#!/usr/bin/env python3
from __future__ import annotations

import argparse
import base64
import json
import os
import subprocess
import tempfile
import time
import urllib.error
import urllib.parse
import urllib.request
from dataclasses import dataclass
from pathlib import Path
from typing import Any


DEFAULT_SHEET_ID = "1M9Pxs34R8R_OfZaXQTWF1Gup1kLO_nbW0ewVutKTSI4"
DEFAULT_SHEET_GID = "0"
ENV_SHEET_ID = "INSIGHTS_GOOGLE_SHEET_ID"
ENV_SHEET_GID = "INSIGHTS_GOOGLE_SHEET_GID"
ENV_GOOGLE_APPLICATION_CREDENTIALS = "GOOGLE_APPLICATION_CREDENTIALS"
BASE_HEADERS = (
    "enabled",
    "priority_rank",
    "source_origin",
    "source_type",
    "source_ref",
    "source_title",
    "source_language",
    "author_name",
    "channel_url",
    "description",
    "keywords",
)
PUBLISH_HEADERS = (
    "published",
    "published_at",
    "published_post_ids",
)
ALL_HEADERS = BASE_HEADERS + PUBLISH_HEADERS
SHEETS_SCOPE = "https://www.googleapis.com/auth/spreadsheets"


class GoogleSheetsRegistryError(RuntimeError):
    pass


@dataclass(frozen=True)
class SheetTab:
    title: str
    gid: str


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description="Low-level Google Sheets registry helper.")
    parser.add_argument("--sheet-id", default=os.environ.get(ENV_SHEET_ID, DEFAULT_SHEET_ID))
    parser.add_argument("--gid", default=os.environ.get(ENV_SHEET_GID, DEFAULT_SHEET_GID))
    parser.add_argument("--print-metadata", action="store_true")
    return parser.parse_args()


def _b64url(data: bytes) -> bytes:
    return base64.urlsafe_b64encode(data).rstrip(b"=")


def _load_service_account() -> dict[str, Any]:
    path = os.environ.get(ENV_GOOGLE_APPLICATION_CREDENTIALS, "").strip()
    if not path:
        raise GoogleSheetsRegistryError("GOOGLE_APPLICATION_CREDENTIALS is not set.")
    creds_path = Path(path)
    if not creds_path.exists():
        raise GoogleSheetsRegistryError(f"Service account file does not exist: {creds_path}")
    return json.loads(creds_path.read_text(encoding="utf-8"))


def create_access_token(scope: str = SHEETS_SCOPE) -> str:
    creds = _load_service_account()
    header = _b64url(json.dumps({"alg": "RS256", "typ": "JWT"}, separators=(",", ":")).encode())
    now = int(time.time())
    claim = _b64url(
        json.dumps(
            {
                "iss": creds["client_email"],
                "scope": scope,
                "aud": "https://oauth2.googleapis.com/token",
                "iat": now,
                "exp": now + 3600,
            },
            separators=(",", ":"),
        ).encode()
    )
    unsigned = header + b"." + claim

    with tempfile.NamedTemporaryFile("w", delete=False, encoding="utf-8") as key_file:
        key_file.write(creds["private_key"])
        key_path = key_file.name
    with tempfile.NamedTemporaryFile("wb", delete=False) as input_file:
        input_file.write(unsigned)
        input_path = input_file.name

    try:
        signature = subprocess.check_output(
            ["openssl", "dgst", "-sha256", "-sign", key_path, input_path]
        )
    finally:
        Path(key_path).unlink(missing_ok=True)
        Path(input_path).unlink(missing_ok=True)

    assertion = unsigned + b"." + _b64url(signature)
    body = urllib.parse.urlencode(
        {
            "grant_type": "urn:ietf:params:oauth:grant-type:jwt-bearer",
            "assertion": assertion.decode(),
        }
    ).encode()
    request = urllib.request.Request(
        "https://oauth2.googleapis.com/token",
        data=body,
        headers={"Content-Type": "application/x-www-form-urlencoded"},
        method="POST",
    )
    with urllib.request.urlopen(request, timeout=30) as response:
        payload = json.loads(response.read().decode("utf-8"))
    token = str(payload.get("access_token") or "").strip()
    if not token:
        raise GoogleSheetsRegistryError("Could not obtain Google OAuth access token.")
    return token


def _decode_http_error(error: urllib.error.HTTPError) -> str:
    try:
        payload = json.loads(error.read().decode("utf-8"))
        message = str(payload.get("error", {}).get("message") or "").strip()
        return message or f"HTTP {error.code}"
    except Exception:
        return f"HTTP {error.code}"


def google_api_request_json(
    url: str,
    *,
    method: str = "GET",
    token: str,
    body: dict[str, Any] | None = None,
) -> dict[str, Any]:
    payload = None
    headers = {"Authorization": f"Bearer {token}"}
    if body is not None:
        payload = json.dumps(body).encode("utf-8")
        headers["Content-Type"] = "application/json"
    request = urllib.request.Request(url, data=payload, headers=headers, method=method)
    try:
        with urllib.request.urlopen(request, timeout=30) as response:
            raw = response.read().decode("utf-8")
        return json.loads(raw) if raw else {}
    except urllib.error.HTTPError as error:
        raise GoogleSheetsRegistryError(_decode_http_error(error)) from error


def column_letter(index: int) -> str:
    if index < 1:
        raise ValueError("Column index must be >= 1")
    value = ""
    current = index
    while current:
        current, remainder = divmod(current - 1, 26)
        value = chr(65 + remainder) + value
    return value


def normalize_header(value: str) -> str:
    return value.strip().lower()


def get_sheet_tab(sheet_id: str, gid: str) -> SheetTab:
    token = create_access_token()
    payload = google_api_request_json(
        f"https://sheets.googleapis.com/v4/spreadsheets/{sheet_id}?includeGridData=false",
        token=token,
    )
    for sheet in payload.get("sheets", []):
        properties = sheet.get("properties", {})
        if str(properties.get("sheetId")) == str(gid):
            return SheetTab(title=str(properties.get("title") or "Sheet1"), gid=str(gid))
    raise GoogleSheetsRegistryError(f"Could not resolve gid={gid} in spreadsheet {sheet_id}.")


def get_sheet_values(sheet_id: str, sheet_title: str) -> list[list[str]]:
    token = create_access_token()
    range_name = urllib.parse.quote(f"{sheet_title}!A:ZZ", safe="!:$")
    payload = google_api_request_json(
        f"https://sheets.googleapis.com/v4/spreadsheets/{sheet_id}/values/{range_name}",
        token=token,
    )
    raw_values = payload.get("values", [])
    return [[str(cell) for cell in row] for row in raw_values if isinstance(row, list)]


def update_values(sheet_id: str, updates: list[dict[str, Any]]) -> dict[str, Any]:
    token = create_access_token()
    return google_api_request_json(
        f"https://sheets.googleapis.com/v4/spreadsheets/{sheet_id}/values:batchUpdate",
        method="POST",
        token=token,
        body={
            "valueInputOption": "USER_ENTERED",
            "data": updates,
        },
    )


def append_values(sheet_id: str, range_name: str, values: list[list[str]]) -> dict[str, Any]:
    token = create_access_token()
    encoded_range = urllib.parse.quote(range_name, safe="!:$")
    return google_api_request_json(
        f"https://sheets.googleapis.com/v4/spreadsheets/{sheet_id}/values/{encoded_range}:append?valueInputOption=USER_ENTERED&insertDataOption=INSERT_ROWS",
        method="POST",
        token=token,
        body={"values": values},
    )


def ensure_headers(sheet_id: str, sheet_title: str, existing_rows: list[list[str]]) -> tuple[list[str], dict[str, int]]:
    headers = list(existing_rows[0]) if existing_rows else []
    normalized_existing = [normalize_header(value) for value in headers]
    missing = [header for header in ALL_HEADERS if header not in normalized_existing]
    if missing:
        headers.extend(missing)
        end_column = column_letter(len(headers))
        update_values(
            sheet_id,
            [
                {
                    "range": f"{sheet_title}!A1:{end_column}1",
                    "values": [headers],
                }
            ],
        )
        existing_rows = [headers] + existing_rows[1:]
    header_map = {normalize_header(value): index for index, value in enumerate(headers, start=1)}
    return headers, header_map


def rows_to_dicts(rows: list[list[str]]) -> list[dict[str, str]]:
    if not rows:
        return []
    headers = [normalize_header(value) for value in rows[0]]
    dict_rows: list[dict[str, str]] = []
    for row in rows[1:]:
        dict_rows.append(
            {
                headers[index]: row[index] if index < len(row) else ""
                for index in range(len(headers))
            }
        )
    return dict_rows


def mark_published_entries(
    sheet_id: str,
    gid: str,
    publications: list[dict[str, Any]],
) -> dict[str, Any]:
    tab = get_sheet_tab(sheet_id, gid)
    rows = get_sheet_values(sheet_id, tab.title)
    headers, header_map = ensure_headers(sheet_id, tab.title, rows)
    existing_rows = rows_to_dicts([headers] + rows[1:] if rows else [headers])

    updates: list[dict[str, Any]] = []
    updated_refs: list[str] = []
    missing_refs: list[str] = []
    for publication in publications:
        source_ref = str(publication.get("source_ref") or "").strip()
        if not source_ref:
            continue
        matching_indices = [
            index for index, row in enumerate(existing_rows, start=2)
            if str(row.get("source_ref") or "").strip() == source_ref
        ]
        if not matching_indices:
            missing_refs.append(source_ref)
            continue
        published_at = str(publication.get("published_at") or "").strip()
        post_ids = str(publication.get("published_post_ids") or "").strip()
        start = header_map["published"]
        end = header_map["published_post_ids"]
        row_values = ["TRUE", published_at, post_ids]
        for row_index in matching_indices:
            updates.append(
                {
                    "range": f"{tab.title}!{column_letter(start)}{row_index}:{column_letter(end)}{row_index}",
                    "values": [row_values],
                }
            )
            updated_refs.append(source_ref)
    response = {}
    if updates:
        response = update_values(sheet_id, updates)
    return {
        "updated_refs": sorted(set(updated_refs)),
        "missing_refs": sorted(set(missing_refs)),
        "update_response": response,
    }


def append_source_rows(
    sheet_id: str,
    gid: str,
    rows_to_append: list[dict[str, str]],
) -> dict[str, Any]:
    tab = get_sheet_tab(sheet_id, gid)
    rows = get_sheet_values(sheet_id, tab.title)
    headers, _ = ensure_headers(sheet_id, tab.title, rows)
    existing_rows = rows_to_dicts([headers] + rows[1:] if rows else [headers])
    existing_refs = {
        str(row.get("source_ref") or "").strip()
        for row in existing_rows
        if str(row.get("source_ref") or "").strip()
    }

    append_payload: list[list[str]] = []
    appended_refs: list[str] = []
    skipped_refs: list[str] = []
    for row in rows_to_append:
        source_ref = str(row.get("source_ref") or "").strip()
        if not source_ref:
            continue
        if source_ref in existing_refs:
            skipped_refs.append(source_ref)
            continue
        append_payload.append([str(row.get(header, "")) for header in headers])
        appended_refs.append(source_ref)
        existing_refs.add(source_ref)

    response = {}
    if append_payload:
        response = append_values(sheet_id, f"{tab.title}!A:ZZ", append_payload)
    return {
        "appended_refs": appended_refs,
        "skipped_refs": skipped_refs,
        "append_response": response,
    }


def main() -> int:
    args = parse_args()
    if args.print_metadata:
        tab = get_sheet_tab(args.sheet_id, args.gid)
        rows = get_sheet_values(args.sheet_id, tab.title)
        print(
            json.dumps(
                {
                    "sheet_id": args.sheet_id,
                    "gid": args.gid,
                    "title": tab.title,
                    "row_count": max(len(rows) - 1, 0),
                    "headers": rows[0] if rows else [],
                },
                ensure_ascii=False,
                indent=2,
            )
        )
        return 0
    raise SystemExit("No action requested. Use --print-metadata.")


if __name__ == "__main__":
    raise SystemExit(main())
