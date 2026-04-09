#!/usr/bin/env python3
from __future__ import annotations

import argparse
import csv
from pathlib import Path
from typing import Any

from export_youtube_source_catalog import (
    DEFAULT_YT_DLP,
    detect_language,
    load_channel_entries,
    normalize_video_url,
)
from google_sheets_registry import (
    DEFAULT_SHEET_GID,
    DEFAULT_SHEET_ID,
    GoogleSheetsRegistryError,
    append_source_rows,
)
from run_daily_insights_publish import SOURCE_AUTHORS


DEFAULT_OUTPUT = "output/spreadsheet/google_sheets_channel_import.csv"
DEFAULT_CHANNELS = (
    "odesa_shorts|short|https://www.youtube.com/@OdesaChurch/shorts",
)
FIELDNAMES = (
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
    "published",
    "published_at",
    "published_post_ids",
)


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Import YouTube channel rows into the Insights Google Sheet registry.",
    )
    parser.add_argument(
        "--channel",
        action="append",
        default=[],
        help="Channel spec in the form source_origin|source_type|url.",
    )
    parser.add_argument("--sheet-id", default=DEFAULT_SHEET_ID)
    parser.add_argument("--sheet-gid", default=DEFAULT_SHEET_GID)
    parser.add_argument("--yt-dlp", default=str(DEFAULT_YT_DLP))
    parser.add_argument("--output-csv", default=DEFAULT_OUTPUT)
    return parser.parse_args()


def parse_channel_specs(values: list[str]) -> list[tuple[str, str, str]]:
    specs: list[tuple[str, str, str]] = []
    seen: set[tuple[str, str, str]] = set()
    for raw in values:
        parts = tuple(part.strip() for part in raw.split("|", 2))
        if len(parts) != 3 or not all(parts):
            raise SystemExit(f'Invalid channel spec "{raw}"')
        if parts in seen:
            continue
        seen.add(parts)
        specs.append(parts)
    return specs


def build_rows(specs: list[tuple[str, str, str]], yt_dlp: str) -> list[dict[str, str]]:
    rows: list[dict[str, str]] = []
    seen_refs: set[str] = set()
    for source_origin, source_type, channel_url in specs:
        entries = load_channel_entries(Path(yt_dlp), channel_url, source_type)
        rank = 1
        for entry in entries:
            source_ref = normalize_video_url(entry, source_type)
            if not source_ref or source_ref in seen_refs:
                continue
            source_title = str(entry.get("title") or "").strip()
            if not source_title:
                continue
            language_info = detect_language(source_title)
            rows.append(
                {
                    "enabled": "true",
                    "priority_rank": str(rank),
                    "source_origin": source_origin,
                    "source_type": source_type,
                    "source_ref": source_ref,
                    "source_title": source_title,
                    "source_language": str(language_info["source_language"]),
                    "author_name": SOURCE_AUTHORS.get(source_origin, "ICOC Insights"),
                    "channel_url": channel_url,
                    "description": "",
                    "keywords": "",
                    "published": "",
                    "published_at": "",
                    "published_post_ids": "",
                }
            )
            seen_refs.add(source_ref)
            rank += 1
    return rows


def write_csv(path: str, rows: list[dict[str, str]]) -> None:
    output_path = Path(path)
    output_path.parent.mkdir(parents=True, exist_ok=True)
    with output_path.open("w", encoding="utf-8", newline="") as handle:
        writer = csv.DictWriter(handle, fieldnames=FIELDNAMES)
        writer.writeheader()
        writer.writerows(rows)


def main() -> int:
    args = parse_args()
    channel_specs = args.channel or list(DEFAULT_CHANNELS)
    rows = build_rows(parse_channel_specs(channel_specs), args.yt_dlp)
    write_csv(args.output_csv, rows)
    result: dict[str, Any] = {
        "csv_output": args.output_csv,
        "row_count": len(rows),
        "source_refs": [row["source_ref"] for row in rows[:10]],
    }
    try:
        result["google_sheets_append"] = append_source_rows(args.sheet_id, args.sheet_gid, rows)
    except GoogleSheetsRegistryError as error:
        result["google_sheets_append_error"] = str(error)
    print(json_dumps(result))
    return 0


def json_dumps(payload: dict[str, Any]) -> str:
    import json

    return json.dumps(payload, ensure_ascii=False, indent=2)


if __name__ == "__main__":
    raise SystemExit(main())
