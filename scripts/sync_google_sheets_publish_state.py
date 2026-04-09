#!/usr/bin/env python3
from __future__ import annotations

import argparse
import json
from pathlib import Path
from typing import Any

from google_sheets_registry import (
    DEFAULT_SHEET_GID,
    DEFAULT_SHEET_ID,
    mark_published_entries,
)


DEFAULT_INPUT = "build/insights/google_sheets_publish_state.json"


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Backfill local Google Sheets publish state into the live sheet.",
    )
    parser.add_argument("--input", default=DEFAULT_INPUT)
    parser.add_argument("--sheet-id", default=DEFAULT_SHEET_ID)
    parser.add_argument("--sheet-gid", default=DEFAULT_SHEET_GID)
    return parser.parse_args()


def main() -> int:
    args = parse_args()
    payload = json.loads(Path(args.input).read_text(encoding="utf-8"))
    published_sources = payload.get("published_sources", {})
    publications: list[dict[str, Any]] = []
    for source_ref, entry in sorted(published_sources.items()):
        if not isinstance(entry, dict):
            continue
        publications.append(
            {
                "source_ref": source_ref,
                "published_at": str(entry.get("published_at") or "").strip(),
                "published_post_ids": str(entry.get("published_post_ids") or "").strip(),
            }
        )
    result = mark_published_entries(args.sheet_id, args.sheet_gid, publications)
    print(json.dumps(result, ensure_ascii=False, indent=2))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
