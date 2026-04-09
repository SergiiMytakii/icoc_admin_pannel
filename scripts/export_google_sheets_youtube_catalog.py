#!/usr/bin/env python3
from __future__ import annotations

import argparse
import csv
import io
import json
import os
import urllib.parse
import urllib.request
from collections import Counter
from datetime import datetime, timezone
from pathlib import Path
from typing import Any

from export_youtube_source_catalog import detect_language, fetch_video_metadata, hash_source_ref


DEFAULT_OUTPUT = "build/insights/youtube_source_catalog.json"
DEFAULT_PUBLISH_STATE = "build/insights/google_sheets_publish_state.json"
DEFAULT_ALLOWED_LANGUAGES = ("uk", "ru", "en", "es")
DEFAULT_SOURCE_TYPES = ("short", "video")
DEFAULT_SHEET_ID = "1M9Pxs34R8R_OfZaXQTWF1Gup1kLO_nbW0ewVutKTSI4"
DEFAULT_SHEET_GID = "0"
ENV_SHEET_CSV_URL = "INSIGHTS_GOOGLE_SHEET_CSV_URL"
ENV_SHEET_ID = "INSIGHTS_GOOGLE_SHEET_ID"
ENV_SHEET_GID = "INSIGHTS_GOOGLE_SHEET_GID"
ENV_INPUT_CSV = "INSIGHTS_GOOGLE_SHEET_INPUT_CSV"


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Export Insights YouTube source catalog from Google Sheets CSV.",
    )
    parser.add_argument(
        "--sheet-csv-url",
        default=os.environ.get(ENV_SHEET_CSV_URL, ""),
        help="Published Google Sheets CSV URL for the sources tab.",
    )
    parser.add_argument(
        "--sheet-id",
        default=os.environ.get(ENV_SHEET_ID, DEFAULT_SHEET_ID),
        help="Google Sheet ID. Used with --gid to build a CSV export URL.",
    )
    parser.add_argument(
        "--gid",
        default=os.environ.get(ENV_SHEET_GID, DEFAULT_SHEET_GID),
        help="Worksheet gid used with --sheet-id.",
    )
    parser.add_argument(
        "--input-csv",
        default=os.environ.get(ENV_INPUT_CSV, ""),
        help="Local CSV file path. Useful for bootstrapping and testing.",
    )
    parser.add_argument(
        "--output",
        default=DEFAULT_OUTPUT,
        help="Output JSON path.",
    )
    parser.add_argument(
        "--publish-state",
        default=DEFAULT_PUBLISH_STATE,
        help="Local publish-state JSON used as a fallback anti-repost registry.",
    )
    return parser.parse_args()


def build_google_sheets_csv_url(sheet_id: str, gid: str) -> str:
    params = urllib.parse.urlencode(
        {
            "format": "csv",
            "gid": gid,
        }
    )
    return f"https://docs.google.com/spreadsheets/d/{sheet_id}/export?{params}"


def normalize_bool(value: str) -> bool:
    return value.strip().lower() not in {"", "0", "false", "no", "off"}


def normalize_source_type(value: str, source_ref: str) -> str:
    normalized = value.strip().lower()
    if normalized in DEFAULT_SOURCE_TYPES:
        return normalized
    if "/shorts/" in source_ref:
        return "short"
    return "video"


def normalize_language(value: str) -> str:
    normalized = value.strip().lower()
    if normalized == "ua":
        return "uk"
    return normalized


def load_publish_state(path_str: str) -> dict[str, dict[str, Any]]:
    path = Path(path_str)
    if not path.exists():
        return {}
    payload = json.loads(path.read_text(encoding="utf-8"))
    entries = payload.get("published_sources", {})
    return entries if isinstance(entries, dict) else {}


def row_is_published(row: dict[str, str], publish_state: dict[str, dict[str, Any]]) -> tuple[bool, str]:
    source_ref = row.get("source_ref", "")
    if source_ref and source_ref in publish_state:
        return True, "local_publish_state"
    if normalize_bool(row.get("published", "")):
        return True, "google_sheets_published_flag"
    if row.get("published_at", "").strip():
        return True, "google_sheets_published_at"
    if row.get("published_post_ids", "").strip():
        return True, "google_sheets_published_post_ids"
    return False, ""


def load_csv_rows(args: argparse.Namespace) -> tuple[list[dict[str, str]], str]:
    if args.input_csv:
        payload = Path(args.input_csv).read_text(encoding="utf-8")
        return list(csv.DictReader(io.StringIO(payload))), args.input_csv

    csv_url = args.sheet_csv_url.strip()
    if not csv_url:
        sheet_id = args.sheet_id.strip()
        gid = args.gid.strip()
        if sheet_id and gid:
            csv_url = build_google_sheets_csv_url(sheet_id, gid)
    if not csv_url:
        raise SystemExit(
            "Missing Google Sheets source. Provide --input-csv or configure "
            "--sheet-csv-url / INSIGHTS_GOOGLE_SHEET_CSV_URL or --sheet-id + --gid "
            "or INSIGHTS_GOOGLE_SHEET_INPUT_CSV.",
        )

    request = urllib.request.Request(
        csv_url,
        headers={
            "User-Agent": (
                "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) "
                "AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36"
            ),
        },
    )
    with urllib.request.urlopen(request, timeout=30) as response:
        payload = response.read().decode("utf-8-sig")
    return list(csv.DictReader(io.StringIO(payload))), csv_url


def build_catalog(
    rows: list[dict[str, str]],
    source_label: str,
    publish_state: dict[str, dict[str, Any]],
) -> dict[str, Any]:
    items: list[dict[str, Any]] = []
    seen_refs: set[str] = set()
    skipped_published: list[dict[str, str]] = []

    for row_index, raw_row in enumerate(rows, start=2):
        row = {str(key).strip(): str(value or "").strip() for key, value in raw_row.items()}
        source_ref = row.get("source_ref", "")
        if not source_ref or source_ref in seen_refs:
            continue
        if not normalize_bool(row.get("enabled", "true")):
            continue
        is_published, publish_reason = row_is_published(row, publish_state)
        if is_published:
            skipped_published.append(
                {
                    "row_index": str(row_index),
                    "source_ref": source_ref,
                    "reason": publish_reason,
                }
            )
            continue

        source_type = normalize_source_type(row.get("source_type", ""), source_ref)
        source_origin = row.get("source_origin", "") or "google_sheets"
        priority_rank_raw = row.get("priority_rank", "")
        try:
            priority_rank = int(priority_rank_raw) if priority_rank_raw else len(items) + 1
        except ValueError:
            priority_rank = len(items) + 1

        source_title = row.get("source_title", "")
        description = row.get("description", "")
        keywords = row.get("keywords", "")
        source_language = normalize_language(row.get("source_language", ""))
        needs_video_metadata = not source_title or source_language not in DEFAULT_ALLOWED_LANGUAGES
        video_metadata = fetch_video_metadata(source_ref) if needs_video_metadata else {}
        source_title = source_title or video_metadata.get("title", "")
        if not source_title:
            continue

        if source_language not in DEFAULT_ALLOWED_LANGUAGES:
            language_probe = "\n".join(
                part
                for part in (
                    source_title,
                    description,
                    video_metadata.get("description", ""),
                    keywords,
                    video_metadata.get("keywords", ""),
                )
                if part
            )
            language_info = detect_language(language_probe or source_title)
            source_language = language_info["source_language"]
            language_confidence = language_info["language_confidence"]
            language_reason = language_info["language_reason"]
        else:
            language_confidence = 1.0
            language_reason = "google_sheets_explicit"

        author_name = row.get("author_name", "").strip()
        seen_refs.add(source_ref)
        items.append(
            {
                "source_id": hash_source_ref(source_ref),
                "source_origin": source_origin,
                "source_type": source_type,
                "source_ref": source_ref,
                "source_title": source_title,
                "channel_url": row.get("channel_url", "") or source_label,
                "channel_position": priority_rank,
                "source_language": source_language,
                "language_confidence": language_confidence,
                "language_reason": language_reason,
                "eligible_for_auto_post": source_language in {"uk", "ru", "en"},
                "author_name": author_name,
                "published": False,
            }
        )

    items.sort(key=lambda item: (item["source_origin"], item["channel_position"], item["source_ref"]))
    per_origin = sorted({item["source_origin"] for item in items})
    return {
        "generated_at": datetime.now(timezone.utc).isoformat(),
        "source": {
            "type": "google_sheets",
            "label": source_label,
        },
        "total_sources": len(items),
        "origins": per_origin,
        "languages": dict(sorted(Counter(item["source_language"] for item in items).items())),
        "published_source_refs_skipped": skipped_published,
        "items": items,
    }


def main() -> int:
    args = parse_args()
    rows, source_label = load_csv_rows(args)
    payload = build_catalog(rows, source_label, load_publish_state(args.publish_state))

    output_path = Path(args.output)
    output_path.parent.mkdir(parents=True, exist_ok=True)
    output_path.write_text(
        json.dumps(payload, ensure_ascii=False, indent=2) + "\n",
        encoding="utf-8",
    )
    print(f"Wrote {payload['total_sources']} Google Sheets YouTube sources to {output_path}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
