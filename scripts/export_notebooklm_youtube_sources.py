#!/usr/bin/env python3
from __future__ import annotations

import argparse
import json
import subprocess
from dataclasses import dataclass
from datetime import datetime, timezone
from pathlib import Path
from typing import Any
from urllib.parse import parse_qs, urlparse


DEFAULT_NOTEBOOKLM = Path.home() / ".codex-tools" / "notebooklm-py" / "bin" / "notebooklm"
DEFAULT_OUTPUT = "build/insights/notebooklm_youtube_sources.json"


@dataclass(frozen=True)
class NotebookSpec:
    notebook_id: str
    source_origin: str
    notebook_name: str
    default_source_type: str


DEFAULT_NOTEBOOKS = (
    NotebookSpec(
        notebook_id="74765d5a-4b7c-4dc5-8a10-8c24c886c3c9",
        source_origin="insights_content_engine",
        notebook_name="ICOC Insights Content Engine",
        default_source_type="mixed",
    ),
    NotebookSpec(
        notebook_id="b019a235-3477-4ca5-8213-555654a247e5",
        source_origin="bibleproject_shorts_en",
        notebook_name="BibleProject Shorts English",
        default_source_type="short",
    ),
    NotebookSpec(
        notebook_id="31fdfc03-78da-41c5-8a54-64b701512a8e",
        source_origin="bibleproject_shorts_uk",
        notebook_name="BibleProject Shorts Ukrainian",
        default_source_type="short",
    ),
)


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Export NotebookLM YouTube sources for the Insights pipeline.",
    )
    parser.add_argument(
        "--notebooklm-bin",
        default=str(DEFAULT_NOTEBOOKLM),
        help="Path to notebooklm CLI binary",
    )
    parser.add_argument(
        "--output",
        default=DEFAULT_OUTPUT,
        help="Output JSON path",
    )
    return parser.parse_args()


def canonicalize_youtube_url(url: str | None) -> str | None:
    if not url:
        return None
    parsed = urlparse(url)
    host = parsed.netloc.lower()
    path = parsed.path.rstrip("/")

    if "youtu.be" in host:
        video_id = path.lstrip("/")
        return f"https://www.youtube.com/watch?v={video_id}" if video_id else None

    if "youtube.com" not in host:
        return None

    if path == "/watch":
        video_id = parse_qs(parsed.query).get("v", [None])[0]
        return f"https://www.youtube.com/watch?v={video_id}" if video_id else None

    if "/shorts/" in path:
        video_id = path.rsplit("/shorts/", 1)[-1]
        return f"https://www.youtube.com/shorts/{video_id}" if video_id else None

    return url.strip()


def infer_source_type(url: str, default_source_type: str) -> str:
    if default_source_type in {"short", "video"}:
        return default_source_type
    if "/shorts/" in url:
        return "short"
    if "watch?v=" in url or "youtu.be/" in url:
        return "video"
    return "video"


def run_command(command: list[str]) -> subprocess.CompletedProcess[str]:
    return subprocess.run(
        command,
        check=False,
        text=True,
        capture_output=True,
    )


def load_notebook_sources(notebooklm_bin: Path, spec: NotebookSpec) -> list[dict[str, Any]]:
    completed = run_command(
        [
            str(notebooklm_bin),
            "source",
            "list",
            "--json",
            "--notebook",
            spec.notebook_id,
        ]
    )
    if completed.returncode != 0:
        stderr = completed.stderr.strip()
        stdout = completed.stdout.strip()
        message = stderr or stdout or f"source list failed for {spec.notebook_id}"
        raise RuntimeError(message)

    payload = json.loads(completed.stdout)
    items: list[dict[str, Any]] = []
    for index, source in enumerate(payload.get("sources", []), 1):
        if not isinstance(source, dict):
            continue
        url = canonicalize_youtube_url(
            source.get("url")
            or source.get("sourceUrl")
            or source.get("source_url")
            or source.get("href")
        )
        title = str(source.get("title") or "").strip()
        if not url or not title:
            continue
        items.append(
            {
                "notebook_id": spec.notebook_id,
                "notebook_name": spec.notebook_name,
                "source_origin": spec.source_origin,
                "source_type": infer_source_type(url, spec.default_source_type),
                "source_ref": url,
                "source_title": title,
                "notebook_position": index,
            }
        )
    return items


def main() -> int:
    args = parse_args()
    notebooklm_bin = Path(args.notebooklm_bin).expanduser()
    output_path = Path(args.output)

    all_items: list[dict[str, Any]] = []
    notebooks_payload: dict[str, dict[str, Any]] = {}
    warnings: list[str] = []

    for spec in DEFAULT_NOTEBOOKS:
        try:
            items = load_notebook_sources(notebooklm_bin, spec)
        except Exception as error:
            items = []
            warnings.append(f"{spec.source_origin}: {error}")
        notebooks_payload[spec.source_origin] = {
            "notebook_id": spec.notebook_id,
            "notebook_name": spec.notebook_name,
            "default_source_type": spec.default_source_type,
            "count": len(items),
        }
        all_items.extend(items)

    if warnings and not all_items:
        if output_path.exists():
            try:
                existing_payload = json.loads(output_path.read_text(encoding="utf-8"))
                existing_items = existing_payload.get("items", [])
                if isinstance(existing_items, list) and existing_items:
                    print(
                        "NotebookLM export warnings detected; "
                        f"keeping existing {output_path}",
                    )
                    for warning in warnings:
                        print(f"- {warning}")
                    return 0
            except (OSError, ValueError, json.JSONDecodeError):
                pass
        raise SystemExit(
            "Could not export NotebookLM YouTube sources and no valid cached export exists.",
        )

    payload: dict[str, Any] = {
        "generated_at": datetime.now(timezone.utc).isoformat(),
        "total_sources": len(all_items),
        "notebooks": notebooks_payload,
        "items": all_items,
    }
    if warnings:
        payload["warnings"] = warnings

    output_path.parent.mkdir(parents=True, exist_ok=True)
    output_path.write_text(
        json.dumps(payload, ensure_ascii=False, indent=2) + "\n",
        encoding="utf-8",
    )
    print(f"Wrote {payload['total_sources']} NotebookLM YouTube sources to {output_path}")
    if warnings:
        print("Warnings:")
        for warning in warnings:
            print(f"- {warning}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
