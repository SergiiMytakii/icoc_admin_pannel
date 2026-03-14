#!/usr/bin/env python3
from __future__ import annotations

import argparse
import hashlib
import json
import re
import subprocess
import urllib.request
import xml.etree.ElementTree as ET
from collections import Counter
from dataclasses import dataclass
from datetime import datetime, timezone
from pathlib import Path
from typing import Any


DEFAULT_OUTPUT = "build/insights/youtube_source_catalog.json"
DEFAULT_YT_DLP = Path.home() / ".codex-tools" / "notebooklm-py" / "bin" / "yt-dlp"
DEFAULT_CHANNELS = (
    "odesa_videos|video|https://www.youtube.com/@OdesaChurch/videos",
    "kcoc_shorts|short|https://www.youtube.com/@KCOC/shorts",
)
UK_WORDS = {
    "бог",
    "бога",
    "боже",
    "україни",
    "україна",
    "церкви",
    "церква",
    "життя",
    "молитва",
    "віра",
    "любити",
    "христос",
    "воскресіння",
    "гріх",
    "дякуємо",
    "благодать",
}
RU_WORDS = {
    "бог",
    "бога",
    "божье",
    "церковь",
    "церкви",
    "жизнь",
    "молитва",
    "вера",
    "любовь",
    "грех",
    "дух",
    "святой",
    "страдаю",
    "гордость",
    "библии",
}
EN_WORDS = {
    "god",
    "church",
    "christ",
    "faith",
    "prayer",
    "life",
    "love",
    "truth",
    "today",
    "heavenly",
    "capital",
    "voice",
    "power",
    "sermons",
}


@dataclass(frozen=True)
class ChannelSpec:
    source_origin: str
    source_type: str
    url: str


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Export a language-aware source catalog from YouTube channel feeds.",
    )
    parser.add_argument(
        "--channel",
        action="append",
        default=list(DEFAULT_CHANNELS),
        help=(
            "Channel spec in the form source_origin|source_type|url. "
            "May be passed multiple times."
        ),
    )
    parser.add_argument(
        "--yt-dlp",
        default=str(DEFAULT_YT_DLP),
        help="Path to yt-dlp binary",
    )
    parser.add_argument(
        "--output",
        default=DEFAULT_OUTPUT,
        help="Output JSON path",
    )
    return parser.parse_args()


def parse_channel_specs(values: list[str]) -> list[ChannelSpec]:
    specs: list[ChannelSpec] = []
    seen: set[tuple[str, str, str]] = set()
    for raw in values:
        parts = [part.strip() for part in raw.split("|", 2)]
        if len(parts) != 3 or not all(parts):
            raise SystemExit(
                f'Invalid --channel value "{raw}". Expected source_origin|source_type|url.',
            )
        spec = ChannelSpec(parts[0], parts[1], parts[2])
        key = (spec.source_origin, spec.source_type, spec.url)
        if key in seen:
            continue
        seen.add(key)
        specs.append(spec)
    return specs


def run_yt_dlp(yt_dlp: Path, url: str) -> list[dict[str, Any]]:
    command = [
        str(yt_dlp),
        "--flat-playlist",
        "--dump-single-json",
        url,
    ]
    completed = subprocess.run(
        command,
        check=True,
        text=True,
        capture_output=True,
    )
    payload = json.loads(completed.stdout)
    return payload.get("entries", [])


def fetch_text(url: str) -> str:
    request = urllib.request.Request(
        url,
        headers={
            "User-Agent": (
                "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) "
                "AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36"
            ),
        },
    )
    with urllib.request.urlopen(request, timeout=30) as response:
        return response.read().decode("utf-8", errors="ignore")


def extract_balanced_json(text: str, marker: str) -> dict[str, Any] | None:
    start = text.find(marker)
    if start < 0:
        return None
    brace_start = text.find("{", start)
    if brace_start < 0:
        return None

    depth = 0
    in_string = False
    escape = False
    for index in range(brace_start, len(text)):
        char = text[index]
        if in_string:
            if escape:
                escape = False
            elif char == "\\":
                escape = True
            elif char == '"':
                in_string = False
            continue

        if char == '"':
            in_string = True
        elif char == "{":
            depth += 1
        elif char == "}":
            depth -= 1
            if depth == 0:
                try:
                    return json.loads(text[brace_start : index + 1])
                except json.JSONDecodeError:
                    return None
    return None


def extract_text_value(value: Any) -> str:
    if isinstance(value, str):
        return value.strip()
    if not isinstance(value, dict):
        return ""
    if isinstance(value.get("simpleText"), str):
        return value["simpleText"].strip()
    runs = value.get("runs")
    if isinstance(runs, list):
        return "".join(
            str(item.get("text", ""))
            for item in runs
            if isinstance(item, dict)
        ).strip()
    if isinstance(value.get("content"), str):
        return value["content"].strip()
    return ""


def extract_renderer_entry(
    renderer: dict[str, Any],
    renderer_type: str,
    source_type: str,
) -> dict[str, Any] | None:
    if renderer_type in {"videoRenderer", "gridVideoRenderer"}:
        video_id = str(renderer.get("videoId") or "").strip()
        title = extract_text_value(renderer.get("title"))
        url = (
            renderer.get("navigationEndpoint", {})
            .get("commandMetadata", {})
            .get("webCommandMetadata", {})
            .get("url")
        )
    elif renderer_type == "reelItemRenderer":
        video_id = str(renderer.get("videoId") or "").strip()
        title = (
            extract_text_value(renderer.get("headline"))
            or extract_text_value(renderer.get("accessibility"))
            or extract_text_value(renderer.get("title"))
        )
        url = (
            renderer.get("navigationEndpoint", {})
            .get("commandMetadata", {})
            .get("webCommandMetadata", {})
            .get("url")
        )
    elif renderer_type == "shortsLockupViewModel":
        video_id = str(renderer.get("entityId") or "").split("|")[-1].strip()
        title = (
            extract_text_value(
                renderer.get("overlayMetadata", {})
                .get("primaryText", {})
            )
            or extract_text_value(renderer.get("title"))
        )
        url = (
            renderer.get("onTap", {})
            .get("innertubeCommand", {})
            .get("commandMetadata", {})
            .get("webCommandMetadata", {})
            .get("url")
        )
    else:
        return None

    if not video_id or not title:
        return None
    if isinstance(url, str) and url.startswith("/"):
        url = f"https://www.youtube.com{url}"
    if not url:
        url = (
            f"https://www.youtube.com/shorts/{video_id}"
            if source_type == "short"
            else f"https://www.youtube.com/watch?v={video_id}"
        )
    return {"id": video_id, "title": title, "url": url}


def walk_renderers(node: Any) -> list[tuple[str, dict[str, Any]]]:
    results: list[tuple[str, dict[str, Any]]] = []
    if isinstance(node, dict):
        for key in (
            "videoRenderer",
            "gridVideoRenderer",
            "reelItemRenderer",
            "shortsLockupViewModel",
        ):
            value = node.get(key)
            if isinstance(value, dict):
                results.append((key, value))
        for value in node.values():
            results.extend(walk_renderers(value))
    elif isinstance(node, list):
        for item in node:
            results.extend(walk_renderers(item))
    return results


def run_page_fallback(url: str, source_type: str) -> list[dict[str, Any]]:
    html = fetch_text(url)
    initial_data = (
        extract_balanced_json(html, "var ytInitialData = ")
        or extract_balanced_json(html, "ytInitialData = ")
    )
    if initial_data is None:
        raise RuntimeError(f"Could not extract ytInitialData from {url}")

    entries: list[dict[str, Any]] = []
    seen_ids: set[str] = set()
    for renderer_type, renderer in walk_renderers(initial_data):
        entry = extract_renderer_entry(renderer, renderer_type, source_type)
        if entry is None:
            continue
        entry_id = str(entry["id"])
        if entry_id in seen_ids:
            continue
        seen_ids.add(entry_id)
        entries.append(entry)
    if entries:
        return entries
    raise RuntimeError(f"No entries found in page fallback for {url}")


def resolve_channel_id(url: str) -> str | None:
    html = fetch_text(url)
    patterns = (
        r'"channelId":"([^"]+)"',
        r'<meta itemprop="channelId" content="([^"]+)">',
    )
    for pattern in patterns:
        match = re.search(pattern, html)
        if match:
            return match.group(1)
    return None


def run_feed_fallback(url: str, source_type: str) -> list[dict[str, Any]]:
    channel_id = resolve_channel_id(url)
    if not channel_id:
        raise RuntimeError(f"Could not resolve channel id for {url}")
    feed = fetch_text(f"https://www.youtube.com/feeds/videos.xml?channel_id={channel_id}")
    root = ET.fromstring(feed)
    ns = {
        "atom": "http://www.w3.org/2005/Atom",
        "yt": "http://www.youtube.com/xml/schemas/2015",
    }
    entries: list[dict[str, Any]] = []
    for entry in root.findall("atom:entry", ns):
        video_id = (entry.findtext("yt:videoId", default="", namespaces=ns) or "").strip()
        title = (entry.findtext("atom:title", default="", namespaces=ns) or "").strip()
        link = ""
        for link_node in entry.findall("atom:link", ns):
            href = link_node.attrib.get("href", "").strip()
            if href:
                link = href
                break
        if not video_id or not title:
            continue
        if source_type == "short" and "/shorts/" not in link:
            link = f"https://www.youtube.com/shorts/{video_id}"
        elif source_type == "video" and "/watch" not in link:
            link = f"https://www.youtube.com/watch?v={video_id}"
        entries.append({"id": video_id, "title": title, "url": link})
    if entries:
        return entries
    raise RuntimeError(f"No entries found in feed fallback for {url}")


def load_channel_entries(yt_dlp: Path, url: str, source_type: str) -> list[dict[str, Any]]:
    if yt_dlp.exists():
        try:
            return run_yt_dlp(yt_dlp, url)
        except (subprocess.CalledProcessError, OSError):
            pass
    try:
        return run_page_fallback(url, source_type)
    except Exception:
        if source_type == "short":
            raise
        return run_feed_fallback(url, source_type)


def hash_source_ref(value: str) -> str:
    return hashlib.sha256(value.encode("utf-8")).hexdigest()[:16]


def tokenize(text: str) -> list[str]:
    token = []
    tokens: list[str] = []
    for char in text.lower():
        if char.isalpha():
            token.append(char)
        elif token:
            tokens.append("".join(token))
            token.clear()
    if token:
        tokens.append("".join(token))
    return tokens


def detect_language(text: str) -> dict[str, Any]:
    tokens = tokenize(text)
    if not tokens:
        return {
            "source_language": "und",
            "language_confidence": 0.0,
            "language_reason": "no_tokens",
        }

    joined = "".join(tokens)
    latin_count = sum("a" <= char <= "z" for char in joined)
    cyrillic_count = sum("\u0400" <= char <= "\u04ff" for char in joined)

    uk_unique = sum(char in "іїєґ" for char in joined)
    ru_unique = sum(char in "ёыэъ" for char in joined)
    uk_hits = sum(token in UK_WORDS for token in tokens)
    ru_hits = sum(token in RU_WORDS for token in tokens)
    en_hits = sum(token in EN_WORDS for token in tokens)

    if latin_count > cyrillic_count * 2:
        confidence = 0.9 if en_hits > 0 else 0.75
        reason = "latin_script"
        if en_hits > 0:
            reason = "english_keywords"
        return {
            "source_language": "en",
            "language_confidence": round(confidence, 2),
            "language_reason": reason,
        }

    if uk_unique > 0 or uk_hits > ru_hits:
        confidence = 0.95 if uk_unique > 0 else 0.8
        return {
            "source_language": "uk",
            "language_confidence": round(confidence, 2),
            "language_reason": "ukrainian_markers",
        }

    if ru_unique > 0 or ru_hits > uk_hits:
        confidence = 0.95 if ru_unique > 0 else 0.78
        return {
            "source_language": "ru",
            "language_confidence": round(confidence, 2),
            "language_reason": "russian_markers",
        }

    if en_hits > 0:
        return {
            "source_language": "en",
            "language_confidence": 0.72,
            "language_reason": "english_keywords",
        }

    if cyrillic_count > 0:
        return {
            "source_language": "uk",
            "language_confidence": 0.51,
            "language_reason": "cyrillic_fallback",
        }

    return {
        "source_language": "en",
        "language_confidence": 0.55,
        "language_reason": "latin_fallback",
    }


def normalize_video_url(entry: dict[str, Any], source_type: str) -> str:
    url = str(entry.get("url") or entry.get("webpage_url") or "").strip()
    entry_id = str(entry.get("id") or "").strip()
    if url.startswith("http://") or url.startswith("https://"):
        return url
    if source_type == "short":
        if entry_id:
            return f"https://www.youtube.com/shorts/{entry_id}"
    if entry_id:
        return f"https://www.youtube.com/watch?v={entry_id}"
    if url.startswith("/"):
        return f"https://www.youtube.com{url}"
    return url


def build_catalog(
    specs: list[ChannelSpec],
    yt_dlp: Path,
) -> dict[str, Any]:
    items: list[dict[str, Any]] = []
    seen_refs: set[str] = set()
    per_channel: dict[str, dict[str, Any]] = {}

    for spec in specs:
        entries = load_channel_entries(yt_dlp, spec.url, spec.source_type)
        channel_items: list[dict[str, Any]] = []
        for entry in entries:
            title = str(entry.get("title") or "").strip()
            source_ref = normalize_video_url(entry, spec.source_type)
            if not title or not source_ref or source_ref in seen_refs:
                continue
            seen_refs.add(source_ref)
            language_info = detect_language(title)
            item = {
                "source_id": hash_source_ref(source_ref),
                "source_origin": spec.source_origin,
                "source_type": spec.source_type,
                "source_ref": source_ref,
                "source_title": title,
                "channel_url": spec.url,
                "channel_position": len(channel_items) + 1,
                "source_language": language_info["source_language"],
                "language_confidence": language_info["language_confidence"],
                "language_reason": language_info["language_reason"],
                "eligible_for_auto_post": language_info["source_language"] in {"uk", "ru", "en"},
            }
            items.append(item)
            channel_items.append(item)

        per_channel[spec.source_origin] = {
            "source_type": spec.source_type,
            "url": spec.url,
            "count": len(channel_items),
            "languages": dict(
                sorted(Counter(item["source_language"] for item in channel_items).items()),
            ),
        }

    items.sort(key=lambda item: (item["source_origin"], item["channel_position"]))
    return {
        "generated_at": datetime.now(timezone.utc).isoformat(),
        "total_sources": len(items),
        "channels": per_channel,
        "items": items,
    }


def main() -> int:
    args = parse_args()
    yt_dlp = Path(args.yt_dlp).expanduser()

    specs = parse_channel_specs(args.channel)
    payload = build_catalog(specs, yt_dlp)

    output_path = Path(args.output)
    output_path.parent.mkdir(parents=True, exist_ok=True)
    output_path.write_text(
        json.dumps(payload, ensure_ascii=False, indent=2) + "\n",
        encoding="utf-8",
    )
    print(f"Wrote {payload['total_sources']} YouTube sources to {output_path}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
