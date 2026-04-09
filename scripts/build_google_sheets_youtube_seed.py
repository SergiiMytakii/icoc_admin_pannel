#!/usr/bin/env python3
from __future__ import annotations

import argparse
import csv
import json
from pathlib import Path
from typing import Any, Iterable

from run_daily_insights_publish import SOURCE_AUTHORS


DEFAULT_INPUT = "build/insights/youtube_source_catalog.json"
DEFAULT_OUTPUT = "output/spreadsheet/insights_youtube_sources_seed.csv"
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
        description="Build a Google Sheets seed CSV from the current YouTube catalog.",
    )
    parser.add_argument("--input", default=DEFAULT_INPUT)
    parser.add_argument("--output", default=DEFAULT_OUTPUT)
    return parser.parse_args()


def load_json(path: str) -> dict[str, Any]:
    return json.loads(Path(path).read_text(encoding="utf-8"))


def build_rows(items: Iterable[dict[str, Any]]) -> list[dict[str, str]]:
    rows: list[dict[str, str]] = []
    for item in items:
        if not isinstance(item, dict):
            continue
        source_origin = str(item.get("source_origin") or "").strip()
        rows.append(
            {
                "enabled": "true",
                "priority_rank": str(item.get("channel_position") or len(rows) + 1),
                "source_origin": source_origin,
                "source_type": str(item.get("source_type") or ""),
                "source_ref": str(item.get("source_ref") or ""),
                "source_title": str(item.get("source_title") or ""),
                "source_language": str(item.get("source_language") or ""),
                "author_name": str(item.get("author_name") or SOURCE_AUTHORS.get(source_origin, "")),
                "channel_url": str(item.get("channel_url") or ""),
                "description": "",
                "keywords": "",
                "published": "",
                "published_at": "",
                "published_post_ids": "",
            }
        )
    return rows


def write_csv(output_path: Path, rows: list[dict[str, str]]) -> None:
    output_path.parent.mkdir(parents=True, exist_ok=True)
    with output_path.open("w", encoding="utf-8", newline="") as handle:
        writer = csv.DictWriter(handle, fieldnames=FIELDNAMES)
        writer.writeheader()
        writer.writerows(rows)


def main() -> int:
    args = parse_args()
    payload = load_json(args.input)
    rows = build_rows(payload.get("items", []))
    output_path = Path(args.output)
    write_csv(output_path, rows)
    print(f"Wrote {len(rows)} rows to {output_path}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
