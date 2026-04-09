#!/usr/bin/env python3
from __future__ import annotations

import argparse
import json
import re
import subprocess
import sys
import time
import urllib.error
import urllib.parse
import urllib.request
from datetime import date
from pathlib import Path
from typing import Any

from google_sheets_registry import (
    DEFAULT_SHEET_GID,
    DEFAULT_SHEET_ID,
    GoogleSheetsRegistryError,
    mark_published_entries,
)


REPO_ROOT = Path(__file__).resolve().parent.parent
PLAN_PATH = REPO_ROOT / "build" / "insights" / "insights_daily_plan.json"
QANDA_PATH = REPO_ROOT / "build" / "insights" / "qanda_source_catalog.json"
YOUTUBE_CATALOG_PATH = REPO_ROOT / "build" / "insights" / "youtube_source_catalog.json"
VERSE_INVENTORY_PATH = REPO_ROOT / "build" / "insights" / "verse_of_day_inventory.json"
RUN_REPORT_PATH = REPO_ROOT / "build" / "insights" / "daily_publish_report.json"
GOOGLE_SHEETS_PUBLISH_STATE_PATH = REPO_ROOT / "build" / "insights" / "google_sheets_publish_state.json"
FUNCTION_ENDPOINTS = (
    "https://europe-central2-icoc-8f075.cloudfunctions.net/upsertInsightsBatch",
    "https://upsertinsightsbatch-5lehxrftgq-lm.a.run.app",
)
SOURCE_AUTHORS = {
    "odesa_videos": "Odesa Church",
    "odesa_shorts": "Odesa Church",
    "kcoc_shorts": "KCOC",
    "insights_content_engine": "ICOC Insights",
    "bibleproject_shorts_en": "BibleProject",
    "bibleproject_shorts_uk": "BibleProject",
    "qanda_firestore": "Douglas Jacoby",
    "verse_of_day": "ICOC Insights",
}
IMAGE_TITLES = {
    "uk": "Вірш дня",
    "ru": "Стих дня",
    "en": "Verse of the Day",
    "es": "Versículo del día",
}


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Refresh and publish today's Insights tasks.",
    )
    parser.add_argument("--date", default=str(date.today()))
    parser.add_argument("--skip-refresh", action="store_true")
    parser.add_argument("--refresh-retries", type=int, default=3)
    parser.add_argument("--http-retries", type=int, default=3)
    parser.add_argument("--sheet-id", default=DEFAULT_SHEET_ID)
    parser.add_argument("--sheet-gid", default=DEFAULT_SHEET_GID)
    return parser.parse_args()


def load_json(path: Path) -> dict[str, Any]:
    return json.loads(path.read_text(encoding="utf-8"))


def save_json(path: Path, payload: dict[str, Any]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(payload, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")


def load_local_publish_state() -> dict[str, Any]:
    if not GOOGLE_SHEETS_PUBLISH_STATE_PATH.exists():
        return {"published_sources": {}}
    return load_json(GOOGLE_SHEETS_PUBLISH_STATE_PATH)


def build_sheet_publication_map(items: list[dict[str, Any]]) -> list[dict[str, Any]]:
    publications_by_ref: dict[str, dict[str, Any]] = {}
    for item in items:
        if item.get("type") != "video":
            continue
        source_ref = str(item.get("_source_ref") or "").strip()
        if not source_ref:
            continue
        entry = publications_by_ref.setdefault(
            source_ref,
            {
                "source_ref": source_ref,
                "published_at": "",
                "published_post_ids": [],
            },
        )
        entry["published_at"] = str(item.get("_published_at") or entry["published_at"]).strip()
        entry["published_post_ids"].append(str(item["id"]))
    result: list[dict[str, Any]] = []
    for value in publications_by_ref.values():
        result.append(
            {
                "source_ref": value["source_ref"],
                "published_at": value["published_at"],
                "published_post_ids": ",".join(sorted(set(value["published_post_ids"]))),
            }
        )
    return result


def persist_local_publish_state(publications: list[dict[str, Any]]) -> dict[str, Any]:
    state = load_local_publish_state()
    published_sources = state.get("published_sources", {})
    if not isinstance(published_sources, dict):
        published_sources = {}
    updated_refs: list[str] = []
    for publication in publications:
        source_ref = str(publication.get("source_ref") or "").strip()
        if not source_ref:
            continue
        published_sources[source_ref] = {
            "published_at": str(publication.get("published_at") or "").strip(),
            "published_post_ids": str(publication.get("published_post_ids") or "").strip(),
        }
        updated_refs.append(source_ref)
    state["published_sources"] = dict(sorted(published_sources.items()))
    save_json(GOOGLE_SHEETS_PUBLISH_STATE_PATH, state)
    return {
        "path": str(GOOGLE_SHEETS_PUBLISH_STATE_PATH),
        "updated_refs": sorted(set(updated_refs)),
        "total_published_sources": len(published_sources),
    }


def run_refresh(target_date: str, retries: int) -> tuple[bool, str]:
    command = [
        sys.executable,
        str(REPO_ROOT / "scripts" / "refresh_insights_daily_plan.py"),
        "--days",
        "1",
        "--start-date",
        target_date,
    ]
    last_error = ""
    for attempt in range(1, retries + 1):
        try:
            completed = subprocess.run(
                command,
                cwd=REPO_ROOT,
                text=True,
                capture_output=True,
                check=True,
            )
            return True, completed.stdout.strip()
        except subprocess.CalledProcessError as error:
            stderr = (error.stderr or "").strip()
            stdout = (error.stdout or "").strip()
            last_error = stderr or stdout or f"refresh_failed_exit_{error.returncode}"
            if attempt < retries:
                time.sleep(min(2 * attempt, 5))
    return False, last_error


def extract_api_key() -> str:
    source = (REPO_ROOT / "lib" / "firebase_options.dart").read_text(encoding="utf-8")
    match = re.search(r"apiKey:\s*'([^']+)'", source)
    if not match:
        raise RuntimeError("Could not extract Firebase Web API key.")
    return match.group(1)


def http_request_json(
    url: str,
    *,
    method: str = "GET",
    headers: dict[str, str] | None = None,
    body: dict[str, Any] | None = None,
    retries: int = 3,
) -> dict[str, Any]:
    payload = None
    request_headers = {"Content-Type": "application/json"}
    if headers:
        request_headers.update(headers)
    if body is not None:
        payload = json.dumps(body).encode("utf-8")

    last_error: Exception | None = None
    for attempt in range(1, retries + 1):
        request = urllib.request.Request(
            url,
            data=payload,
            headers=request_headers,
            method=method,
        )
        try:
            with urllib.request.urlopen(request, timeout=30) as response:
                raw = response.read().decode("utf-8")
                return json.loads(raw) if raw else {}
        except (urllib.error.URLError, urllib.error.HTTPError, TimeoutError, json.JSONDecodeError) as error:
            last_error = error
            if attempt < retries:
                time.sleep(min(2 * attempt, 5))
    raise RuntimeError(f"HTTP request failed for {url}: {last_error}")


def create_temp_firebase_user(api_key: str, retries: int) -> tuple[str, str]:
    nonce = int(time.time() * 1000)
    email = f"codex-insights-{nonce}@icoc.test"
    password = f"CodexAuto!{nonce}"
    response = http_request_json(
        f"https://identitytoolkit.googleapis.com/v1/accounts:signUp?key={api_key}",
        method="POST",
        body={
            "email": email,
            "password": password,
            "returnSecureToken": True,
        },
        retries=retries,
    )
    return response["idToken"], response["refreshToken"]


def delete_temp_firebase_user(api_key: str, id_token: str, retries: int) -> None:
    try:
        http_request_json(
            f"https://identitytoolkit.googleapis.com/v1/accounts:delete?key={api_key}",
            method="POST",
            body={"idToken": id_token},
            retries=retries,
        )
    except Exception:
        pass


def parse_youtube_id(url: str) -> str | None:
    patterns = (
        r"[?&]v=([A-Za-z0-9_-]{11})",
        r"/shorts/([A-Za-z0-9_-]{11})",
        r"youtu\.be/([A-Za-z0-9_-]{11})",
    )
    for pattern in patterns:
        match = re.search(pattern, url)
        if match:
            return match.group(1)
    if re.fullmatch(r"[A-Za-z0-9_-]{11}", url):
        return url
    return None


def slugify(value: str) -> str:
    lowered = value.strip().lower()
    slug = re.sub(r"[^a-z0-9]+", "_", lowered)
    return slug.strip("_") or "item"


def build_image_title(language: str) -> str:
    return IMAGE_TITLES.get(language, "Verse of the Day")


def build_image_content(raw_text: str) -> str:
    lines = [
        line.strip()
        for line in raw_text.splitlines()
        if line.strip()
    ]
    cleaned = [
        line for line in lines
        if not line.startswith("•••")
    ]
    content = "\n".join(cleaned).strip()
    if len(content) > 1200:
        content = content[:1197].rstrip() + "..."
    return content


def qanda_publishable_languages(item: dict[str, Any]) -> list[str]:
    representative_language = str(item.get("representative_language") or "en")
    representative = item.get("versions", {}).get(representative_language, {})
    representative_link = str(representative.get("link") or "").strip()
    publishable: list[str] = []

    for language in ("ru", "en", "es"):
        version = item.get("versions", {}).get(language)
        if not isinstance(version, dict):
            continue
        question = str(version.get("question") or "").strip()
        answer = str(version.get("answer") or "").strip()
        version_link = str(version.get("link") or "").strip()
        if not question or not answer:
            continue
        if representative_link and version_link and version_link != representative_link:
            continue
        publishable.append(language)
    return publishable


def build_text_content(question: str, answer: str) -> str:
    cleaned_question = question.strip()
    cleaned_answer = answer.strip()
    if len(cleaned_answer) > 1600:
        cleaned_answer = cleaned_answer[:1597].rstrip() + "..."
    return f"Question:\n{cleaned_question}\n\nAnswer:\n{cleaned_answer}"


def build_publish_batch(target_date: str) -> tuple[list[dict[str, Any]], list[str]]:
    plan_payload = load_json(PLAN_PATH)
    qanda_payload = load_json(QANDA_PATH)
    youtube_payload = load_json(YOUTUBE_CATALOG_PATH)
    verse_payload = load_json(VERSE_INVENTORY_PATH)
    local_publish_state = load_local_publish_state().get("published_sources", {})
    if not isinstance(local_publish_state, dict):
        local_publish_state = {}

    day = next((item for item in plan_payload.get("days", []) if item.get("date") == target_date), None)
    if day is None:
        raise RuntimeError(f"No plan entry found for {target_date}.")

    youtube_by_ref = {
        str(item.get("source_ref")): item
        for item in youtube_payload.get("items", [])
    }
    verse_by_ref: dict[str, dict[str, Any]] = {}
    for item in verse_payload.get("items", []):
        if not isinstance(item, dict):
            continue
        for key in (
            item.get("gs_uri"),
            item.get("relative_path"),
            item.get("object_name"),
            item.get("download_url"),
            item.get("public_url"),
        ):
            if isinstance(key, str) and key.strip():
                verse_by_ref[key] = item
    qanda_by_id = {
        int(item["qa_id"]): item
        for item in qanda_payload.get("items", [])
        if "qa_id" in item
    }

    items: list[dict[str, Any]] = []
    skips: list[str] = []

    for task in day.get("tasks", []):
        language = str(task.get("language") or "")
        source_origin = str(task.get("source_origin") or "")
        source_ref = str(task.get("source_ref") or "")
        insight_type = str(task.get("insight_type") or "")
        content_mode = str(task.get("content_mode") or "")

        if insight_type == "video" and content_mode == "localized_from_source":
            source = youtube_by_ref.get(source_ref)
            if source is None:
                skips.append(f"{language}:{source_ref}:missing_source_catalog_entry")
                continue
            if source_ref in local_publish_state:
                skips.append(f"{language}:{source_ref}:already_published_local_state")
                continue
            if bool(source.get("published")):
                skips.append(f"{language}:{source_ref}:already_marked_published")
                continue
            source_language = str(source.get("source_language") or "und")
            if source_language != language:
                skips.append(
                    f"{language}:{source_ref}:source_language_{source_language}_does_not_match_target"
                )
                continue
            youtube_id = parse_youtube_id(source_ref)
            if not youtube_id:
                skips.append(f"{language}:{source_ref}:missing_youtube_id")
                continue
            items.append(
                {
                    "id": f"codex_{language}_video_{youtube_id.lower()}",
                    "type": "video",
                    "language": language,
                    "title": str(task.get("source_title") or "").strip(),
                    "content": "",
                    "articleUrl": source_ref,
                    "status": "published",
                    "author": {
                        "name": str(source.get("author_name") or "").strip()
                        or SOURCE_AUTHORS.get(source_origin, "ICOC Insights"),
                    },
                    "_source_ref": source_ref,
                    "_published_at": target_date,
                }
            )
            continue

        if insight_type == "image" and content_mode == "localized_from_source":
            source = verse_by_ref.get(source_ref)
            if source is None:
                skips.append(f"{language}:{source_ref}:missing_verse_inventory_entry")
                continue
            source_language = str(source.get("source_language") or "und")
            if source_language != language:
                skips.append(
                    f"{language}:{source_ref}:source_language_{source_language}_does_not_match_target"
                )
                continue
            media_url = str(source.get("download_url") or source.get("public_url") or "").strip()
            if not media_url:
                skips.append(f"{language}:{source_ref}:missing_media_url")
                continue
            aspect_ratio_raw = source.get("aspect_ratio")
            media_aspect_ratios = []
            if isinstance(aspect_ratio_raw, (int, float)) and aspect_ratio_raw > 0.1:
                media_aspect_ratios = [float(aspect_ratio_raw)]
            numeric_id = source.get("numeric_id")
            object_name = str(source.get("object_name") or source.get("name") or source_ref)
            image_suffix = str(int(numeric_id)) if isinstance(numeric_id, int) else slugify(object_name)
            items.append(
                {
                    "id": f"codex_{language}_image_verse_{image_suffix}",
                    "type": "image",
                    "language": language,
                    "title": build_image_title(language),
                    "content": build_image_content(str(source.get("ocr_text") or "")),
                    "mediaUrls": [media_url],
                    "mediaAspectRatios": media_aspect_ratios,
                    "status": "published",
                    "author": {
                        "name": SOURCE_AUTHORS.get(source_origin, "ICOC Insights"),
                    },
                }
            )
            continue

        if insight_type == "text" and content_mode == "direct_qanda_source":
            qa_id = int(task.get("qa_id") or 0)
            qanda_item = qanda_by_id.get(qa_id)
            if qanda_item is None:
                skips.append(f"{language}:qanda:{qa_id}:missing_qanda_group")
                continue
            valid_languages = qanda_publishable_languages(qanda_item)
            if language not in valid_languages:
                skips.append(f"{language}:qanda:{qa_id}:invalid_or_empty_variant")
                continue
            version = qanda_item["versions"][language]
            items.append(
                {
                    "id": f"codex_{language}_text_qanda_{qa_id}",
                    "type": "text",
                    "language": language,
                    "title": str(version.get("title") or qanda_item.get("source_title") or "").strip(),
                    "content": build_text_content(
                        str(version.get("question") or ""),
                        str(version.get("answer") or ""),
                    ),
                    "articleUrl": version.get("link") or None,
                    "status": "published",
                    "author": {
                        "name": str(qanda_item.get("author") or "ICOC Insights"),
                    },
                }
            )
            continue

        skips.append(f"{language}:{source_ref or insight_type}:unsupported_task")

    return items, skips


def strip_internal_fields(items: list[dict[str, Any]]) -> list[dict[str, Any]]:
    cleaned: list[dict[str, Any]] = []
    for item in items:
        cleaned.append({key: value for key, value in item.items() if not key.startswith("_")})
    return cleaned


def publish_items(items: list[dict[str, Any]], id_token: str, retries: int) -> dict[str, Any]:
    last_error: Exception | None = None
    for endpoint in FUNCTION_ENDPOINTS:
        try:
            return http_request_json(
                endpoint,
                method="POST",
                headers={"Authorization": f"Bearer {id_token}"},
                body={"items": items},
                retries=retries,
            )
        except Exception as error:
            last_error = error
    raise RuntimeError(f"Publish failed on all endpoints: {last_error}")


def main() -> int:
    args = parse_args()
    refresh_ok = True
    refresh_note = "skipped"

    if not args.skip_refresh:
        refresh_ok, refresh_note = run_refresh(args.date, args.refresh_retries)
        if not refresh_ok:
            if not PLAN_PATH.exists():
                raise SystemExit(f"Refresh failed and no plan is available: {refresh_note}")
            refresh_note = f"fallback_to_existing_plan:{refresh_note}"

    items, skips = build_publish_batch(args.date)
    report: dict[str, Any] = {
        "date": args.date,
        "refresh_ok": refresh_ok,
        "refresh_note": refresh_note,
        "candidate_count": len(items),
        "published_ids": [],
        "skips": skips,
    }

    if not items:
        save_json(RUN_REPORT_PATH, report)
        print(json.dumps(report, ensure_ascii=False, indent=2))
        return 0

    api_key = extract_api_key()
    id_token = ""
    exit_code = 0
    try:
        id_token, _ = create_temp_firebase_user(api_key, args.http_retries)
        response = publish_items(strip_internal_fields(items), id_token, args.http_retries)
        report["publish_response"] = response
        report["published_ids"] = [str(item["id"]) for item in items]
        sheet_publications = build_sheet_publication_map(items)
        if sheet_publications:
            report["local_publish_state"] = persist_local_publish_state(sheet_publications)
            try:
                report["google_sheets_sync"] = mark_published_entries(
                    args.sheet_id,
                    args.sheet_gid,
                    sheet_publications,
                )
            except GoogleSheetsRegistryError as error:
                report["google_sheets_sync_error"] = str(error)
    except Exception as error:
        report["publish_error"] = str(error)
        exit_code = 1
    finally:
        if id_token:
            delete_temp_firebase_user(api_key, id_token, args.http_retries)
        save_json(RUN_REPORT_PATH, report)

    print(json.dumps(report, ensure_ascii=False, indent=2))
    return exit_code


if __name__ == "__main__":
    raise SystemExit(main())
