#!/usr/bin/env python3
from __future__ import annotations

import argparse
import json
import subprocess
import sys
from datetime import date, datetime, timezone
from pathlib import Path
from typing import Sequence


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Rebuild all inputs required for the daily insights plan.",
    )
    parser.add_argument("--start-date", default=str(date.today()))
    parser.add_argument("--days", type=int, default=7)
    parser.add_argument("--qanda-frequency-days", type=int, default=3)
    return parser.parse_args()


def run_step(name: str, command: Sequence[str], cwd: Path) -> None:
    print(f"[refresh] {name}: {' '.join(command)}")
    subprocess.run(command, cwd=cwd, check=True)


def run_step_with_existing_fallback(
    name: str,
    command: Sequence[str],
    cwd: Path,
    fallback_path: Path,
) -> None:
    try:
        run_step(name, command, cwd)
    except subprocess.CalledProcessError as error:
        if fallback_path.exists():
            print(
                f"[refresh] {name} warning: export failed with exit {error.returncode}; "
                f"keeping existing {fallback_path}"
            )
            return
        raise


def write_empty_verse_inventory(output_path: Path, reason: str) -> None:
    output_path.parent.mkdir(parents=True, exist_ok=True)
    payload = {
        "generated_at": datetime.now(timezone.utc).isoformat(),
        "project": "icoc-8f075",
        "bucket": "icoc-8f075.appspot.com",
        "folder": "VerseOfTheDay",
        "item_count": 0,
        "items": [],
        "fallback_reason": reason,
    }
    output_path.write_text(
        json.dumps(payload, ensure_ascii=False, indent=2) + "\n",
        encoding="utf-8",
    )
    print(f"[refresh] verse inventory fallback written: {reason}")


def inventory_generated_today(path: Path) -> bool:
    if not path.exists():
        return False
    try:
        payload = json.loads(path.read_text(encoding="utf-8"))
        if payload.get("fallback_reason"):
            return False
        generated_at = str(payload.get("generated_at") or "").strip()
        if not generated_at:
            return False
        generated_date = datetime.fromisoformat(generated_at.replace("Z", "+00:00")).date()
        return generated_date == datetime.now(timezone.utc).date()
    except (OSError, ValueError, json.JSONDecodeError):
        return False


def main() -> int:
    args = parse_args()
    repo_root = Path(__file__).resolve().parent.parent
    build_dir = repo_root / "build" / "insights"
    youtube_catalog = build_dir / "youtube_source_catalog.json"
    qanda_catalog = build_dir / "qanda_source_catalog.json"
    verse_inventory = build_dir / "verse_of_day_inventory.json"

    run_step_with_existing_fallback(
        "google sheets youtube catalog",
        [sys.executable, "scripts/export_google_sheets_youtube_catalog.py"],
        repo_root,
        youtube_catalog,
    )
    run_step_with_existing_fallback(
        "qanda catalog",
        [sys.executable, "scripts/export_qanda_source_catalog.py"],
        repo_root,
        qanda_catalog,
    )

    if inventory_generated_today(verse_inventory):
        print(f"[refresh] verse inventory: reuse {verse_inventory}")
    else:
        try:
            command = [sys.executable, "scripts/export_verse_of_day_inventory.py"]
            print(f"[refresh] verse inventory: {' '.join(command)}")
            completed = subprocess.run(
                command,
                cwd=repo_root,
                check=True,
                text=True,
                capture_output=True,
            )
            if completed.stdout.strip():
                print(completed.stdout.strip())
        except subprocess.CalledProcessError as error:
            stderr = (error.stderr or "").strip().splitlines()
            if stderr:
                print(f"[refresh] verse inventory warning: {stderr[-1]}")
            if verse_inventory.exists():
                print(f"[refresh] verse inventory warning: keeping existing {verse_inventory}")
            else:
                write_empty_verse_inventory(
                    verse_inventory,
                    f"export_failed_exit_{error.returncode}",
                )

    run_step(
        "content queue",
        [sys.executable, "scripts/build_insights_content_queue.py"],
        repo_root,
    )
    run_step(
        "daily plan",
        [
            sys.executable,
            "scripts/build_insights_daily_plan.py",
            "--start-date",
            args.start_date,
            "--days",
            str(args.days),
            "--qanda-frequency-days",
            str(args.qanda_frequency_days),
        ],
        repo_root,
    )
    print("[refresh] insights daily plan refreshed successfully")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
