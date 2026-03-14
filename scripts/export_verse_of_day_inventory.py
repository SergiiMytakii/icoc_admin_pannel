#!/usr/bin/env python3
from __future__ import annotations

import argparse
import json
import re
import subprocess
import tempfile
import time
import urllib.parse
import urllib.error
import urllib.request
from datetime import datetime, timezone
from pathlib import Path
from typing import Any


DEFAULT_PROJECT = "icoc-8f075"
DEFAULT_BUCKET = "icoc-8f075.appspot.com"
DEFAULT_FOLDER = "VerseOfTheDay"
DEFAULT_OUTPUT = "build/insights/verse_of_day_inventory.json"
DEFAULT_OCR_CACHE = "build/insights/verse_of_day_ocr_cache.json"
DEFAULT_PAGE_SIZE = 500
DEFAULT_MAX_NEW_OCR = 8
SUPPORTED_LANGUAGES = {"uk", "ru", "en", "es"}


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Export Firebase Storage inventory for VerseOfTheDay via the public Storage REST API.",
    )
    parser.add_argument("--project", default=DEFAULT_PROJECT, help="Firebase project id")
    parser.add_argument("--bucket", default=DEFAULT_BUCKET, help="Firebase Storage bucket")
    parser.add_argument("--folder", default=DEFAULT_FOLDER, help="Folder inside the bucket")
    parser.add_argument("--output", default=DEFAULT_OUTPUT, help="Output JSON path")
    parser.add_argument("--ocr-cache", default=DEFAULT_OCR_CACHE, help="Path to OCR cache JSON")
    parser.add_argument("--page-size", type=int, default=DEFAULT_PAGE_SIZE)
    parser.add_argument(
        "--max-new-ocr",
        type=int,
        default=DEFAULT_MAX_NEW_OCR,
        help="Maximum number of uncached images to OCR in this run (0 = cache only, -1 = no limit)",
    )
    return parser.parse_args()


def build_console_url(project: str, bucket: str, folder: str) -> str:
    folder_path = f"~2F{folder.strip('/').replace('/', '~2F')}"
    return (
        "https://console.firebase.google.com/u/0/project/"
        f"{project}/storage/{bucket}/files/{folder_path}?pli=1"
    )


def fetch_json(url: str) -> dict[str, Any]:
    last_error: Exception | None = None
    for attempt in range(1, 4):
        request = urllib.request.Request(
            url,
            headers={
                "User-Agent": (
                    "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) "
                    "AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36"
                ),
            },
        )
        try:
            with urllib.request.urlopen(request, timeout=30) as response:
                return json.loads(response.read().decode("utf-8"))
        except (urllib.error.URLError, urllib.error.HTTPError, TimeoutError, json.JSONDecodeError) as error:
            last_error = error
            if attempt < 3:
                time.sleep(attempt)
    raise RuntimeError(f"Failed to fetch JSON from {url}: {last_error}")


def fetch_bytes(url: str) -> bytes:
    last_error: Exception | None = None
    for attempt in range(1, 4):
        request = urllib.request.Request(
            url,
            headers={
                "User-Agent": (
                    "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) "
                    "AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36"
                ),
            },
        )
        try:
            with urllib.request.urlopen(request, timeout=30) as response:
                return response.read()
        except (urllib.error.URLError, urllib.error.HTTPError, TimeoutError) as error:
            last_error = error
            if attempt < 3:
                time.sleep(attempt)
    raise RuntimeError(f"Failed to download bytes from {url}: {last_error}")


def list_object_names(bucket: str, folder: str, page_size: int) -> list[str]:
    prefix = folder.strip("/") + "/"
    names: list[str] = []
    page_token: str | None = None

    while True:
        params = {
            "prefix": prefix,
            "maxResults": str(page_size),
        }
        if page_token:
            params["pageToken"] = page_token
        url = (
            f"https://firebasestorage.googleapis.com/v0/b/{bucket}/o?"
            + urllib.parse.urlencode(params)
        )
        payload = fetch_json(url)
        for item in payload.get("items", []):
            name = str(item.get("name") or "").strip()
            if name:
                names.append(name)
        page_token = payload.get("nextPageToken")
        if not page_token:
            break

    return names


def fetch_object_metadata(bucket: str, object_name: str) -> dict[str, Any]:
    encoded_name = urllib.parse.quote(object_name, safe="")
    url = f"https://firebasestorage.googleapis.com/v0/b/{bucket}/o/{encoded_name}"
    return fetch_json(url)


def build_download_url(bucket: str, object_name: str, token: str | None) -> str:
    encoded_name = urllib.parse.quote(object_name, safe="")
    base = f"https://firebasestorage.googleapis.com/v0/b/{bucket}/o/{encoded_name}?alt=media"
    return f"{base}&token={token}" if token else base


def load_ocr_cache(cache_path: Path) -> dict[str, dict[str, Any]]:
    if not cache_path.exists():
        return {}
    payload = json.loads(cache_path.read_text(encoding="utf-8"))
    items = payload.get("items")
    if not isinstance(items, dict):
        return {}
    return {
        str(key): value
        for key, value in items.items()
        if isinstance(value, dict)
    }


def save_ocr_cache(cache_path: Path, items: dict[str, dict[str, Any]]) -> None:
    cache_path.parent.mkdir(parents=True, exist_ok=True)
    payload = {
        "generated_at": datetime.now(timezone.utc).isoformat(),
        "items": items,
    }
    cache_path.write_text(json.dumps(payload, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")


def canonicalize_language(raw: Any) -> str:
    if not isinstance(raw, str):
        return "und"
    normalized = raw.strip().lower()
    return normalized if normalized in SUPPORTED_LANGUAGES else "und"


def run_ocr_batch(manifest_path: Path, repo_root: Path) -> dict[str, dict[str, Any]]:
    helper_path = repo_root / "scripts" / "ocr_detect_image_language.swift"
    completed = subprocess.run(
        ["swift", str(helper_path), str(manifest_path)],
        cwd=repo_root,
        text=True,
        capture_output=True,
        check=True,
    )
    payload = json.loads(completed.stdout)
    return {
        str(item["key"]): item
        for item in payload
        if isinstance(item, dict) and "key" in item
    }


def collect_ocr_results(
    bucket: str,
    folder: str,
    metadata_items: list[dict[str, Any]],
    cache_path: Path,
    repo_root: Path,
    max_new_ocr: int,
) -> dict[str, dict[str, Any]]:
    cache = load_ocr_cache(cache_path)
    updated_cache = dict(cache)
    ocr_results: dict[str, dict[str, Any]] = {}

    with tempfile.TemporaryDirectory(prefix="verse-ocr-") as temp_dir:
        temp_root = Path(temp_dir)
        manifest_entries: list[dict[str, str]] = []
        pending_metadata: dict[str, dict[str, Any]] = {}

        for metadata in metadata_items:
            object_name = str(metadata.get("name") or "")
            if not object_name:
                continue
            updated = str(metadata.get("updated") or metadata.get("timeCreated") or "")
            cache_entry = cache.get(object_name)
            if cache_entry and str(cache_entry.get("updated") or "") == updated:
                ocr_results[object_name] = cache_entry
                continue
            if max_new_ocr == 0:
                continue
            if max_new_ocr > 0 and len(manifest_entries) >= max_new_ocr:
                continue

            download_tokens = str(metadata.get("downloadTokens") or "").strip()
            primary_token = download_tokens.split(",", 1)[0].strip() or None
            download_url = build_download_url(bucket, object_name, primary_token)
            suffix = Path(object_name).suffix or ".img"
            file_path = temp_root / f"{len(manifest_entries):04d}{suffix}"
            file_path.write_bytes(fetch_bytes(download_url))
            manifest_entries.append({"key": object_name, "path": str(file_path)})
            pending_metadata[object_name] = metadata

        if manifest_entries:
            manifest_path = temp_root / "manifest.json"
            manifest_path.write_text(
                json.dumps(manifest_entries, ensure_ascii=False, indent=2) + "\n",
                encoding="utf-8",
            )
            batch_results = run_ocr_batch(manifest_path, repo_root)
            for object_name, metadata in pending_metadata.items():
                result = batch_results.get(object_name, {})
                cache_entry = {
                    "updated": str(metadata.get("updated") or metadata.get("timeCreated") or ""),
                    "ocr_text": result.get("ocrText"),
                    "detected_language": result.get("detectedLanguage"),
                    "language_confidence": result.get("languageConfidence"),
                    "width": result.get("width"),
                    "height": result.get("height"),
                    "error": result.get("error"),
                }
                updated_cache[object_name] = cache_entry
                ocr_results[object_name] = cache_entry

    save_ocr_cache(cache_path, updated_cache)
    return ocr_results


def normalize_item(
    bucket: str,
    folder: str,
    metadata: dict[str, Any],
    ocr_entry: dict[str, Any] | None,
) -> dict[str, object]:
    object_name = str(metadata.get("name") or "")
    leaf_name = Path(object_name).name
    suffix = Path(leaf_name).suffix.lower()
    numeric_match = re.match(r"^(\d+)", leaf_name)
    download_tokens = str(metadata.get("downloadTokens") or "").strip()
    primary_token = download_tokens.split(",", 1)[0].strip() or None
    content_type = str(metadata.get("contentType") or "")
    updated = str(metadata.get("updated") or metadata.get("timeCreated") or "")
    size_raw = str(metadata.get("size") or "0")
    size = size_raw if size_raw else "0"
    ocr_text = str((ocr_entry or {}).get("ocr_text") or "").strip()
    detected_language = canonicalize_language((ocr_entry or {}).get("detected_language"))
    confidence_raw = (ocr_entry or {}).get("language_confidence")
    confidence = float(confidence_raw) if isinstance(confidence_raw, (int, float)) else 0.0
    width_raw = (ocr_entry or {}).get("width")
    height_raw = (ocr_entry or {}).get("height")
    width = int(width_raw) if isinstance(width_raw, (int, float)) and width_raw > 0 else None
    height = int(height_raw) if isinstance(height_raw, (int, float)) and height_raw > 0 else None
    aspect_ratio = round(width / height, 4) if width and height else None
    eligible_for_auto_post = detected_language in SUPPORTED_LANGUAGES and confidence >= 0.85
    error_text = str((ocr_entry or {}).get("error") or "").strip()
    review_reason = None if eligible_for_auto_post else (error_text or "requires_ocr_or_manual_language_review")

    return {
        "name": leaf_name,
        "object_name": object_name,
        "size": size,
        "content_type": content_type,
        "last_modified": updated,
        "extension": suffix,
        "numeric_id": int(numeric_match.group(1)) if numeric_match else None,
        "download_token": primary_token,
        "download_url": build_download_url(bucket, object_name, primary_token),
        "public_url": build_download_url(bucket, object_name, None),
        "gs_uri": f"gs://{bucket}/{object_name}",
        "relative_path": object_name if object_name.startswith(folder.strip("/") + "/") else f"{folder.strip('/')}/{leaf_name}",
        "source_language": detected_language,
        "language_confidence": confidence,
        "eligible_for_auto_post": eligible_for_auto_post,
        "review_required": not eligible_for_auto_post,
        "review_reason": review_reason,
        "ocr_text": ocr_text or None,
        "width": width,
        "height": height,
        "aspect_ratio": aspect_ratio,
        "post_type": "image",
        "content_stream": "verse_of_the_day",
    }


def main() -> int:
    args = parse_args()
    repo_root = Path(__file__).resolve().parent.parent
    names = list_object_names(args.bucket, args.folder, args.page_size)
    metadata_items = [fetch_object_metadata(args.bucket, name) for name in names]
    metadata_items.sort(
        key=lambda item: (
            not re.match(r"^(\d+)", Path(str(item.get("name") or "")).name),
            int(re.match(r"^(\d+)", Path(str(item.get("name") or "")).name).group(1))
            if re.match(r"^(\d+)", Path(str(item.get("name") or "")).name)
            else 999999,
            str(item.get("name") or ""),
        )
    )
    ocr_results = collect_ocr_results(
        args.bucket,
        args.folder,
        metadata_items,
        Path(args.ocr_cache),
        repo_root,
        args.max_new_ocr,
    )
    items = [
        normalize_item(args.bucket, args.folder, metadata, ocr_results.get(str(metadata.get("name") or "")))
        for metadata in metadata_items
    ]
    items.sort(key=lambda item: (item["numeric_id"] is None, item["numeric_id"], item["name"]))

    output_path = Path(args.output)
    output_path.parent.mkdir(parents=True, exist_ok=True)
    payload = {
        "generated_at": datetime.now(timezone.utc).isoformat(),
        "project": args.project,
        "bucket": args.bucket,
        "folder": args.folder,
        "console_url": build_console_url(args.project, args.bucket, args.folder),
        "source": "firebase_storage_rest_api",
        "ocr_cache_path": str(Path(args.ocr_cache)),
        "item_count": len(items),
        "items": items,
    }
    output_path.write_text(json.dumps(payload, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    print(f"Exported {len(items)} assets to {output_path}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
