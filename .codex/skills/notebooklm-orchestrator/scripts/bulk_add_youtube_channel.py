#!/usr/bin/env python3
from __future__ import annotations

import argparse
import json
import subprocess
import sys
import time
from pathlib import Path
from typing import Any
from urllib.parse import parse_qs, urlparse


DEFAULT_NOTEBOOKLM = Path.home() / ".codex-tools" / "notebooklm-py" / "bin" / "notebooklm"
DEFAULT_YTDLP = Path.home() / ".codex-tools" / "notebooklm-py" / "bin" / "yt-dlp"


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Bulk-add YouTube channel videos or shorts into a NotebookLM notebook."
    )
    parser.add_argument("--notebook", required=True, help="NotebookLM notebook ID")
    parser.add_argument(
        "--channel-url",
        required=True,
        help="YouTube channel tab URL, ideally ending with /videos or /shorts",
    )
    parser.add_argument(
        "--feed-type",
        choices=["auto", "videos", "shorts"],
        default="auto",
        help="Append /videos or /shorts when the provided URL is a bare channel URL",
    )
    parser.add_argument(
        "--limit",
        type=int,
        default=None,
        help="Maximum number of entries to read from the channel tab",
    )
    parser.add_argument(
        "--pause-seconds",
        type=float,
        default=1.0,
        help="Pause between NotebookLM add operations",
    )
    parser.add_argument(
        "--allow-duplicates",
        action="store_true",
        help="Do not compare against existing notebook sources before adding",
    )
    parser.add_argument(
        "--dry-run",
        action="store_true",
        help="Only inspect the channel feed and report what would be added",
    )
    parser.add_argument(
        "--json",
        action="store_true",
        help="Print machine-readable JSON instead of human-readable text",
    )
    parser.add_argument(
        "--notebooklm-bin",
        default=str(DEFAULT_NOTEBOOKLM),
        help="Path to notebooklm CLI binary",
    )
    parser.add_argument(
        "--yt-dlp-bin",
        default=str(DEFAULT_YTDLP),
        help="Path to yt-dlp binary",
    )
    return parser.parse_args()


def ensure_binary(path_str: str, label: str) -> Path:
    path = Path(path_str).expanduser()
    if not path.exists():
        raise SystemExit(f"Missing {label} binary: {path}")
    return path


def run_command(command: list[str], *, allow_failure: bool = False) -> subprocess.CompletedProcess[str]:
    completed = subprocess.run(
        command,
        check=False,
        text=True,
        capture_output=True,
    )
    if completed.returncode != 0 and not allow_failure:
        stderr = completed.stderr.strip()
        stdout = completed.stdout.strip()
        message = stderr or stdout or f"Command failed: {' '.join(command)}"
        raise RuntimeError(message)
    return completed


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
        return url.strip()

    if path == "/watch":
        video_id = parse_qs(parsed.query).get("v", [None])[0]
        return f"https://www.youtube.com/watch?v={video_id}" if video_id else None

    if "/shorts/" in path:
        video_id = path.rsplit("/shorts/", 1)[-1]
        return f"https://www.youtube.com/watch?v={video_id}" if video_id else None

    return url.strip()


def normalize_title(title: str | None) -> str | None:
    if not title:
        return None
    return " ".join(title.split()).casefold()


def normalize_channel_url(channel_url: str, feed_type: str) -> tuple[str, str]:
    normalized = channel_url.strip().rstrip("/")
    if feed_type == "auto":
        if normalized.endswith("/shorts"):
            return normalized, "shorts"
        if normalized.endswith("/videos"):
            return normalized, "videos"
        return normalized, "mixed"

    if normalized.endswith("/shorts") or normalized.endswith("/videos"):
        normalized = normalized.rsplit("/", 1)[0]
    return f"{normalized}/{feed_type}", feed_type


def extract_video_id(entry: dict[str, Any]) -> str | None:
    for key in ("id", "url"):
        value = entry.get(key)
        if isinstance(value, str) and value and "http" not in value and "/" not in value:
            return value
    webpage_url = entry.get("webpage_url") or entry.get("original_url")
    return video_id_from_url(webpage_url)


def video_id_from_url(url: str | None) -> str | None:
    canonical = canonicalize_youtube_url(url)
    if not canonical:
        return None
    parsed = urlparse(canonical)
    return parse_qs(parsed.query).get("v", [None])[0]


def list_channel_entries(yt_dlp_bin: Path, channel_url: str, limit: int | None) -> list[dict[str, Any]]:
    command = [str(yt_dlp_bin), "--flat-playlist", "--dump-single-json", channel_url]
    if limit and limit > 0:
        command[1:1] = ["--playlist-end", str(limit)]

    completed = run_command(command)
    payload = json.loads(completed.stdout)
    entries = payload.get("entries") or []
    normalized_entries: list[dict[str, Any]] = []

    for index, entry in enumerate(entries, start=1):
        if not isinstance(entry, dict):
            continue
        title = entry.get("title")
        video_id = extract_video_id(entry)
        video_url = canonicalize_youtube_url(entry.get("webpage_url"))
        if not video_url and video_id:
            video_url = f"https://www.youtube.com/watch?v={video_id}"
        if not video_url:
            continue
        normalized_entries.append(
            {
                "index": index,
                "title": title,
                "video_id": video_id,
                "video_url": video_url,
                "channel": entry.get("channel") or payload.get("channel"),
            }
        )
    return normalized_entries


def check_auth(notebooklm_bin: Path) -> None:
    completed = run_command(
        [str(notebooklm_bin), "auth", "check", "--test"],
        allow_failure=True,
    )
    if completed.returncode == 0:
        return
    stderr = completed.stderr.strip()
    stdout = completed.stdout.strip()
    message = stderr or stdout or "NotebookLM authentication is invalid."
    raise RuntimeError(f"{message}\nRun 'notebooklm login' before batch import.")


def load_existing_sources(notebooklm_bin: Path, notebook_id: str) -> tuple[set[str], set[str]]:
    completed = run_command(
        [str(notebooklm_bin), "source", "list", "--json", "--notebook", notebook_id]
    )
    payload = json.loads(completed.stdout)
    existing_urls: set[str] = set()
    existing_titles: set[str] = set()

    for source in payload.get("sources", []):
        if not isinstance(source, dict):
            continue
        url_key = canonicalize_youtube_url(source.get("url"))
        title_key = normalize_title(source.get("title"))
        if url_key:
            existing_urls.add(url_key)
        if title_key:
            existing_titles.add(title_key)
    return existing_urls, existing_titles


def add_source(notebooklm_bin: Path, notebook_id: str, video_url: str) -> dict[str, Any]:
    completed = run_command(
        [
            str(notebooklm_bin),
            "source",
            "add",
            video_url,
            "--type",
            "youtube",
            "--json",
            "--notebook",
            notebook_id,
        ]
    )
    return json.loads(completed.stdout)


def render_human(summary: dict[str, Any]) -> str:
    lines = [
        f"Notebook: {summary['notebook']}",
        f"Channel URL: {summary['channel_url']}",
        f"Resolved URL: {summary['resolved_channel_url']}",
        f"Feed type: {summary['feed_type']}",
        f"Scanned entries: {summary['scanned_entries']}",
        f"Added: {summary['added_count']}",
        f"Skipped: {summary['skipped_count']}",
        f"Errors: {summary['error_count']}",
    ]
    if summary["added_titles"]:
        lines.append("Added titles:")
        lines.extend(f"- {title}" for title in summary["added_titles"])
    if summary["skipped_titles"]:
        lines.append("Skipped titles:")
        lines.extend(f"- {title}" for title in summary["skipped_titles"])
    if summary["errors"]:
        lines.append("Errors:")
        lines.extend(f"- {error}" for error in summary["errors"])
    return "\n".join(lines)


def main() -> int:
    args = parse_args()
    notebooklm_bin = ensure_binary(args.notebooklm_bin, "notebooklm")
    yt_dlp_bin = ensure_binary(args.yt_dlp_bin, "yt-dlp")
    resolved_url, feed_type = normalize_channel_url(args.channel_url, args.feed_type)

    entries = list_channel_entries(yt_dlp_bin, resolved_url, args.limit)

    existing_urls: set[str] = set()
    existing_titles: set[str] = set()
    if not args.dry_run or not args.allow_duplicates:
        check_auth(notebooklm_bin)
    if not args.allow_duplicates:
        existing_urls, existing_titles = load_existing_sources(notebooklm_bin, args.notebook)

    added_titles: list[str] = []
    skipped_titles: list[str] = []
    errors: list[str] = []
    processed: list[dict[str, Any]] = []

    for entry in entries:
        title = entry.get("title") or entry["video_url"]
        url_key = canonicalize_youtube_url(entry["video_url"])
        title_key = normalize_title(entry.get("title"))
        skip_reason = None

        if not args.allow_duplicates:
            if url_key and url_key in existing_urls:
                skip_reason = "duplicate_url"
            elif title_key and title_key in existing_titles:
                skip_reason = "duplicate_title"

        if skip_reason:
            skipped_titles.append(title)
            processed.append(
                {
                    "title": title,
                    "video_url": entry["video_url"],
                    "status": "skipped",
                    "reason": skip_reason,
                }
            )
            continue

        if args.dry_run:
            added_titles.append(title)
            processed.append(
                {
                    "title": title,
                    "video_url": entry["video_url"],
                    "status": "would_add",
                }
            )
            continue

        try:
            result = add_source(notebooklm_bin, args.notebook, entry["video_url"])
            added_titles.append(title)
            processed.append(
                {
                    "title": title,
                    "video_url": entry["video_url"],
                    "status": "added",
                    "result": result,
                }
            )
            if url_key:
                existing_urls.add(url_key)
            if title_key:
                existing_titles.add(title_key)
            if args.pause_seconds > 0:
                time.sleep(args.pause_seconds)
        except Exception as exc:  # pragma: no cover - network/runtime dependent
            errors.append(f"{title}: {exc}")
            processed.append(
                {
                    "title": title,
                    "video_url": entry["video_url"],
                    "status": "error",
                    "error": str(exc),
                }
            )

    summary = {
        "notebook": args.notebook,
        "channel_url": args.channel_url,
        "resolved_channel_url": resolved_url,
        "feed_type": feed_type,
        "dry_run": args.dry_run,
        "allow_duplicates": args.allow_duplicates,
        "scanned_entries": len(entries),
        "added_count": len(added_titles),
        "skipped_count": len(skipped_titles),
        "error_count": len(errors),
        "added_titles": added_titles,
        "skipped_titles": skipped_titles,
        "errors": errors,
        "processed": processed,
    }

    if args.json:
        print(json.dumps(summary, ensure_ascii=False, indent=2))
    else:
        print(render_human(summary))
    return 0


if __name__ == "__main__":
    sys.exit(main())
