#!/usr/bin/env python3
from __future__ import annotations

import argparse
import json
import re
from datetime import datetime, timezone
from pathlib import Path

from playwright.sync_api import sync_playwright


DEFAULT_PROJECT = "icoc-8f075"
DEFAULT_BUCKET = "icoc-8f075.appspot.com"
DEFAULT_FOLDER = "VerseOfTheDay"
DEFAULT_OUTPUT = "build/insights/verse_of_day_inventory.json"
DEFAULT_STORAGE_STATE = Path.home() / ".notebooklm" / "storage_state.json"


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Export Firebase Storage inventory for VerseOfTheDay via Firebase Console.",
    )
    parser.add_argument("--project", default=DEFAULT_PROJECT, help="Firebase project id")
    parser.add_argument("--bucket", default=DEFAULT_BUCKET, help="Firebase Storage bucket")
    parser.add_argument("--folder", default=DEFAULT_FOLDER, help="Folder inside the bucket")
    parser.add_argument(
        "--storage-state",
        default=str(DEFAULT_STORAGE_STATE),
        help="Path to Playwright/Firebase authenticated storage_state.json",
    )
    parser.add_argument(
        "--output",
        default=DEFAULT_OUTPUT,
        help="Output JSON path",
    )
    parser.add_argument(
        "--wait-ms",
        type=int,
        default=7000,
        help="Milliseconds to wait for Firebase Console to settle before scraping",
    )
    return parser.parse_args()


def build_console_url(project: str, bucket: str, folder: str) -> str:
    folder_path = f"~2F{folder.strip('/').replace('/', '~2F')}"
    return (
        "https://console.firebase.google.com/u/0/project/"
        f"{project}/storage/{bucket}/files/{folder_path}?pli=1"
    )


def normalize_item(bucket: str, folder: str, row: dict[str, str]) -> dict[str, object]:
    name = row["name"]
    suffix = Path(name).suffix.lower()
    numeric_match = re.match(r"^(\d+)", name)
    return {
        "name": name,
        "size": row["size"],
        "content_type": row["content_type"],
        "last_modified": row["last_modified"],
        "extension": suffix,
        "numeric_id": int(numeric_match.group(1)) if numeric_match else None,
        "gs_uri": f"gs://{bucket}/{folder.strip('/')}/{name}",
        "relative_path": f"{folder.strip('/')}/{name}",
        "post_type": "image",
        "content_stream": "verse_of_the_day",
    }


def scrape_inventory(url: str, storage_state: Path, wait_ms: int) -> list[dict[str, object]]:
    with sync_playwright() as playwright:
        browser = playwright.chromium.launch(
            channel="chrome",
            headless=True,
            args=["--disable-blink-features=AutomationControlled"],
            ignore_default_args=["--enable-automation"],
        )
        context = browser.new_context(storage_state=str(storage_state))
        page = context.new_page()
        page.goto(url, wait_until="domcontentloaded", timeout=60000)
        page.wait_for_timeout(wait_ms)
        page.locator("table.fire-table tbody tr").first.wait_for(timeout=15000)

        items = page.evaluate(
            """
            () => [...document.querySelectorAll('table.fire-table tbody tr')].map((row) => {
              const cells = [...row.querySelectorAll('td')].map((cell) => (cell.innerText || '').trim());
              return {
                name: (cells[1] || '').replace(/^photo\\s+/, '').trim(),
                size: cells[2] || '',
                content_type: cells[3] || '',
                last_modified: cells[4] || '',
              };
            }).filter((item) => item.name)
            """
        )
        browser.close()
        return items


def main() -> int:
    args = parse_args()
    storage_state = Path(args.storage_state).expanduser()
    if not storage_state.exists():
        raise SystemExit(f"Missing storage state: {storage_state}")

    url = build_console_url(args.project, args.bucket, args.folder)
    rows = scrape_inventory(url, storage_state, args.wait_ms)
    items = [normalize_item(args.bucket, args.folder, row) for row in rows]
    items.sort(key=lambda item: (item["numeric_id"] is None, item["numeric_id"], item["name"]))

    output_path = Path(args.output)
    output_path.parent.mkdir(parents=True, exist_ok=True)
    payload = {
        "generated_at": datetime.now(timezone.utc).isoformat(),
        "project": args.project,
        "bucket": args.bucket,
        "folder": args.folder,
        "console_url": url,
        "item_count": len(items),
        "items": items,
    }
    output_path.write_text(json.dumps(payload, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    print(f"Exported {len(items)} assets to {output_path}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
