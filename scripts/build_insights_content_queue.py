#!/usr/bin/env python3
from __future__ import annotations

import argparse
import json
from collections import Counter
from dataclasses import dataclass
from datetime import datetime, timezone
from pathlib import Path
from typing import Any


DEFAULT_YOUTUBE_CATALOG = "build/insights/youtube_source_catalog.json"
DEFAULT_VERSE_INVENTORY = "build/insights/verse_of_day_inventory.json"
DEFAULT_OUTPUT_JSON = "build/insights/insights_content_queue.json"
DEFAULT_OUTPUT_MD = "build/insights/insights_content_queue.md"
DEFAULT_QUEUE_LENGTH = 21
TYPE_WEIGHTS = {"short": 0.6, "image": 0.25, "video": 0.15}
LANG_WEIGHTS = {"uk": 0.4, "ru": 0.3, "en": 0.3}
RECENT_ORIGIN_WINDOW = 4
MAX_CONSECUTIVE_ORIGIN_ITEMS = 2


@dataclass(frozen=True)
class QueueSource:
    source_id: str
    source_type: str
    source_origin: str
    source_ref: str
    source_title: str
    freshness_rank: int
    source_language: str
    language_confidence: float
    eligible_for_auto_post: bool
    review_reason: str | None


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Build a weighted, language-aware content queue for Insights.",
    )
    parser.add_argument("--youtube-catalog", default=DEFAULT_YOUTUBE_CATALOG)
    parser.add_argument("--verse-inventory", default=DEFAULT_VERSE_INVENTORY)
    parser.add_argument("--queue-length", type=int, default=DEFAULT_QUEUE_LENGTH)
    parser.add_argument("--output-json", default=DEFAULT_OUTPUT_JSON)
    parser.add_argument("--output-md", default=DEFAULT_OUTPUT_MD)
    return parser.parse_args()


def load_json(path: str) -> dict[str, Any]:
    payload_path = Path(path)
    if not payload_path.exists():
        raise SystemExit(f"Missing input file: {payload_path}")
    return json.loads(payload_path.read_text(encoding="utf-8"))


def build_sources(
    youtube_payload: dict[str, Any],
    verse_payload: dict[str, Any],
) -> list[QueueSource]:
    sources: list[QueueSource] = []

    for item in youtube_payload.get("items", []):
        sources.append(
            QueueSource(
                source_id=str(item["source_id"]),
                source_type=str(item["source_type"]),
                source_origin=str(item["source_origin"]),
                source_ref=str(item["source_ref"]),
                source_title=str(item["source_title"]),
                freshness_rank=int(item.get("channel_position") or 9999),
                source_language=str(item.get("source_language", "und")),
                language_confidence=float(item.get("language_confidence", 0.0)),
                eligible_for_auto_post=bool(item.get("eligible_for_auto_post", False)),
                review_reason=None,
            ),
        )

    for item in verse_payload.get("items", []):
        name = str(item.get("name") or item.get("relative_path") or "Verse image")
        sources.append(
            QueueSource(
                source_id=f"verse-{name}",
                source_type="image",
                source_origin="verse_of_day",
                source_ref=str(item.get("gs_uri") or item.get("relative_path") or name),
                source_title=name,
                freshness_rank=int(item.get("numeric_id") or 9999),
                source_language=str(item.get("source_language") or "und"),
                language_confidence=float(item.get("language_confidence") or 0.0),
                eligible_for_auto_post=bool(item.get("eligible_for_auto_post", False)),
                review_reason=str(item.get("review_reason") or "") or None,
            ),
        )

    return sources


def target_count(weights: dict[str, float], total: int) -> dict[str, int]:
    counts = {
        key: int(total * weight)
        for key, weight in weights.items()
    }
    while sum(counts.values()) < total:
        deficit_key = max(
            weights,
            key=lambda key: (total * weights[key]) - counts[key],
        )
        counts[deficit_key] += 1
    return counts


def choose_post_language(source: QueueSource, current_lang_counts: Counter[str]) -> tuple[str, bool, str | None]:
    if source.source_language in LANG_WEIGHTS:
        return source.source_language, True, None

    target_lang_counts = target_count(LANG_WEIGHTS, max(sum(current_lang_counts.values()) + 1, 1))
    target_language = min(
        LANG_WEIGHTS,
        key=lambda lang: current_lang_counts[lang] - target_lang_counts[lang],
    )
    return target_language, False, source.review_reason


def score_candidate(
    source: QueueSource,
    post_language: str,
    current_type_counts: Counter[str],
    current_lang_counts: Counter[str],
    desired_type_counts: dict[str, int],
    desired_lang_counts: dict[str, int],
    last_item: dict[str, Any] | None,
    recent_queue: list[dict[str, Any]],
) -> float:
    score = 0.0
    score += (desired_type_counts[source.source_type] - current_type_counts[source.source_type]) * 3.0
    score += (desired_lang_counts[post_language] - current_lang_counts[post_language]) * 2.0

    if source.source_type == "short":
        score += 1.5
    if source.source_type == "image":
        score += 0.7

    freshness_bonus = max(0.0, 1.3 - (min(source.freshness_rank, 40) / 40))
    score += freshness_bonus

    if not source.eligible_for_auto_post:
        score -= 0.35

    same_origin_recent = sum(
        1 for item in recent_queue if item["source_origin"] == source.source_origin
    )
    score -= same_origin_recent * 0.9

    if last_item is not None:
        if source.source_type == last_item["source_type"]:
            score -= 1.4
        else:
            score += 0.6

        if source.source_origin == last_item["source_origin"]:
            score -= 0.5
        else:
            score += 0.25

        if post_language == last_item["post_language"]:
            score -= 0.8
        else:
            score += 0.45

    return score


def has_alternative_origin(pool: list[QueueSource], blocked_origin: str) -> bool:
    return any(source.source_origin != blocked_origin for source in pool)


def would_break_origin_cooldown(
    source: QueueSource,
    queue: list[dict[str, Any]],
    pool: list[QueueSource],
) -> bool:
    if len(queue) < MAX_CONSECUTIVE_ORIGIN_ITEMS:
        return False
    recent = queue[-MAX_CONSECUTIVE_ORIGIN_ITEMS:]
    if not all(item["source_origin"] == source.source_origin for item in recent):
        return False
    return has_alternative_origin(pool, source.source_origin)


def build_queue(sources: list[QueueSource], queue_length: int) -> list[dict[str, Any]]:
    pool = list(sources)
    desired_type_counts = target_count(TYPE_WEIGHTS, queue_length)
    desired_lang_counts = target_count(LANG_WEIGHTS, queue_length)
    current_type_counts: Counter[str] = Counter()
    current_lang_counts: Counter[str] = Counter()
    queue: list[dict[str, Any]] = []

    while pool and len(queue) < queue_length:
        ranked: list[tuple[float, QueueSource, str, bool, str | None]] = []
        last_item = queue[-1] if queue else None
        recent_queue = queue[-RECENT_ORIGIN_WINDOW:]
        for source in pool:
            if would_break_origin_cooldown(source, queue, pool):
                continue
            post_language, language_ready, review_reason = choose_post_language(
                source,
                current_lang_counts,
            )
            ranked.append(
                (
                    score_candidate(
                        source,
                        post_language,
                        current_type_counts,
                        current_lang_counts,
                        desired_type_counts,
                        desired_lang_counts,
                        last_item,
                        recent_queue,
                    ),
                    source,
                    post_language,
                    language_ready,
                    review_reason,
                ),
            )

        if not ranked:
            for source in pool:
                post_language, language_ready, review_reason = choose_post_language(
                    source,
                    current_lang_counts,
                )
                ranked.append(
                    (
                        score_candidate(
                            source,
                            post_language,
                            current_type_counts,
                            current_lang_counts,
                            desired_type_counts,
                            desired_lang_counts,
                            last_item,
                            recent_queue,
                        ),
                        source,
                        post_language,
                        language_ready,
                        review_reason,
                    ),
                )

        ranked.sort(
            key=lambda item: (
                item[0],
                item[1].eligible_for_auto_post,
                item[1].language_confidence,
            ),
            reverse=True,
        )
        _, chosen, post_language, language_ready, review_reason = ranked[0]
        pool.remove(chosen)
        current_type_counts[chosen.source_type] += 1
        current_lang_counts[post_language] += 1
        queue.append(
            {
                "position": len(queue) + 1,
                "source_id": chosen.source_id,
                "source_type": chosen.source_type,
                "source_origin": chosen.source_origin,
                "source_ref": chosen.source_ref,
                "source_title": chosen.source_title,
                "source_language": chosen.source_language,
                "language_confidence": chosen.language_confidence,
                "post_language": post_language,
                "publish_languages": ["uk", "ru", "en", "es"],
                "language_ready_for_publish": language_ready,
                "review_required": not language_ready,
                "review_reason": review_reason,
            },
        )

    return queue


def write_outputs(
    queue: list[dict[str, Any]],
    output_json: Path,
    output_md: Path,
    youtube_payload: dict[str, Any],
    verse_payload: dict[str, Any],
) -> None:
    output_json.parent.mkdir(parents=True, exist_ok=True)
    output_md.parent.mkdir(parents=True, exist_ok=True)

    payload = {
        "generated_at": datetime.now(timezone.utc).isoformat(),
        "queue_length": len(queue),
        "type_weights": TYPE_WEIGHTS,
        "language_weights": LANG_WEIGHTS,
        "inputs": {
            "youtube_sources": youtube_payload.get("total_sources", 0),
            "verse_assets": verse_payload.get("item_count", 0),
        },
        "queue": queue,
    }
    output_json.write_text(
        json.dumps(payload, ensure_ascii=False, indent=2) + "\n",
        encoding="utf-8",
    )

    type_counts = Counter(item["source_type"] for item in queue)
    lang_counts = Counter(item["post_language"] for item in queue)
    review_count = sum(1 for item in queue if item["review_required"])
    lines = [
        "# Insights Content Queue",
        "",
        f"- Generated at: {payload['generated_at']}",
        f"- Queue length: {len(queue)}",
        f"- Type mix: {dict(sorted(type_counts.items()))}",
        f"- Language mix: {dict(sorted(lang_counts.items()))}",
        f"- Review-required items: {review_count}",
        "",
        "## Queue",
        "",
    ]
    for item in queue:
        review = "review required" if item["review_required"] else "ready"
        lines.append(
            f"- #{item['position']} [{item['source_type']}] [{item['post_language']}] "
            f"{item['source_title']} | {item['source_origin']} | {review}",
        )
    output_md.write_text("\n".join(lines) + "\n", encoding="utf-8")


def main() -> int:
    args = parse_args()
    youtube_payload = load_json(args.youtube_catalog)
    verse_payload = load_json(args.verse_inventory)
    sources = build_sources(youtube_payload, verse_payload)
    queue = build_queue(sources, args.queue_length)
    write_outputs(
        queue,
        Path(args.output_json),
        Path(args.output_md),
        youtube_payload,
        verse_payload,
    )
    print(f"Wrote queue with {len(queue)} items to {args.output_json}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
