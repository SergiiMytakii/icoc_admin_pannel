#!/usr/bin/env python3
from __future__ import annotations

import argparse
import json
from collections import Counter
from pathlib import Path


DEFAULT_INPUT = "build/insights/verse_of_day_inventory.json"
DEFAULT_OUTPUT = "build/insights/verse_of_day_notebook_source.md"


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Build a NotebookLM-friendly markdown source from VerseOfTheDay inventory JSON.",
    )
    parser.add_argument("--input", default=DEFAULT_INPUT, help="Inventory JSON path")
    parser.add_argument("--output", default=DEFAULT_OUTPUT, help="Markdown output path")
    return parser.parse_args()


def main() -> int:
    args = parse_args()
    input_path = Path(args.input)
    if not input_path.exists():
        raise SystemExit(f"Missing inventory JSON: {input_path}")

    payload = json.loads(input_path.read_text(encoding="utf-8"))
    items = payload.get("items", [])
    ext_counter = Counter(item.get("extension", "").lower() for item in items)
    type_counter = Counter(item.get("content_type", "").lower() for item in items)

    lines: list[str] = []
    lines.append("# VerseOfTheDay Inventory")
    lines.append("")
    lines.append(f"- Generated at: {payload.get('generated_at', 'unknown')}")
    lines.append(f"- Project: {payload.get('project', 'unknown')}")
    lines.append(f"- Bucket: {payload.get('bucket', 'unknown')}")
    lines.append(f"- Folder: {payload.get('folder', 'unknown')}")
    lines.append(f"- Total assets: {payload.get('item_count', len(items))}")
    lines.append("")
    lines.append("## Operational Notes")
    lines.append("")
    lines.append("- These assets are suitable for image-based insight posts.")
    lines.append("- Mix them with YouTube-based video posts in weekly draft planning.")
    lines.append("- Use this inventory to avoid reusing the same image too often.")
    lines.append("- Future enrichment should add OCR-derived verse text, scripture reference, theme, language, and tone.")
    lines.append("")
    lines.append("## Extension Breakdown")
    lines.append("")
    for extension, count in sorted(ext_counter.items()):
        label = extension or "(none)"
        lines.append(f"- {label}: {count}")
    lines.append("")
    lines.append("## Content-Type Breakdown")
    lines.append("")
    for content_type, count in sorted(type_counter.items()):
        label = content_type or "(unknown)"
        lines.append(f"- {label}: {count}")
    lines.append("")
    lines.append("## Asset List")
    lines.append("")
    for item in items:
        lines.append(
            f"- {item['name']} | {item['content_type']} | {item['size']} | "
            f"{item['last_modified']} | {item['gs_uri']}"
        )

    output_path = Path(args.output)
    output_path.parent.mkdir(parents=True, exist_ok=True)
    output_path.write_text("\n".join(lines) + "\n", encoding="utf-8")
    print(f"Wrote NotebookLM source markdown to {output_path}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
