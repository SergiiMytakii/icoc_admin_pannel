#!/usr/bin/env python3
from __future__ import annotations

import argparse
import hashlib
import json
from collections import Counter
from datetime import date, datetime, timedelta, timezone
from pathlib import Path
from typing import Any


DEFAULT_QUEUE = "build/insights/insights_content_queue.json"
DEFAULT_QANDA = "build/insights/qanda_source_catalog.json"
DEFAULT_STATE = "build/insights/insights_schedule_state.json"
DEFAULT_OUTPUT_JSON = "build/insights/insights_daily_plan.json"
DEFAULT_OUTPUT_MD = "build/insights/insights_daily_plan.md"
DEFAULT_DAYS = 7
REQUIRED_DAILY_LANGUAGES = ("uk", "ru", "en", "es")


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Build a multilingual daily insights plan with periodic Q&A text posts.",
    )
    parser.add_argument("--queue", default=DEFAULT_QUEUE)
    parser.add_argument("--qanda", default=DEFAULT_QANDA)
    parser.add_argument("--state", default=DEFAULT_STATE)
    parser.add_argument("--output-json", default=DEFAULT_OUTPUT_JSON)
    parser.add_argument("--output-md", default=DEFAULT_OUTPUT_MD)
    parser.add_argument("--days", type=int, default=DEFAULT_DAYS)
    parser.add_argument("--qanda-frequency-days", type=int, default=3)
    parser.add_argument("--start-date", default=str(date.today()))
    return parser.parse_args()


def load_json(path: str, fallback: dict[str, Any] | None = None) -> dict[str, Any]:
    input_path = Path(path)
    if not input_path.exists():
        if fallback is not None:
            return fallback
        raise SystemExit(f"Missing input file: {input_path}")
    return json.loads(input_path.read_text(encoding="utf-8"))


def stable_hash(value: str) -> int:
    return int(hashlib.sha256(value.encode("utf-8")).hexdigest()[:12], 16)


def sort_qanda_candidates(items: list[dict[str, Any]], seed: str) -> list[dict[str, Any]]:
    return sorted(items, key=lambda item: stable_hash(f"{seed}:{item['qa_id']}"))


def select_qanda_group(
    qanda_items: list[dict[str, Any]],
    used_ids: set[int],
    seed: str,
) -> dict[str, Any] | None:
    candidates = [item for item in qanda_items if item["qa_id"] not in used_ids]
    if not candidates:
        used_ids.clear()
        candidates = list(qanda_items)
    if not candidates:
        return None
    trilingual = [item for item in candidates if item.get("is_complete_trilingual")]
    preferred_pool = trilingual or candidates
    return sort_qanda_candidates(preferred_pool, seed)[0]


def build_daily_tasks_for_source(item: dict[str, Any]) -> list[dict[str, Any]]:
    source_type = item["source_type"]
    insight_type = "video" if source_type in {"short", "video"} else "image"
    return [
        {
            "language": language,
            "insight_type": insight_type,
            "source_origin": item["source_origin"],
            "source_ref": item["source_ref"],
            "source_title": item["source_title"],
            "source_type": source_type,
            "review_required": bool(item.get("review_required", False)),
            "content_mode": "localized_from_source",
        }
        for language in REQUIRED_DAILY_LANGUAGES
    ]


def build_qanda_tasks(item: dict[str, Any]) -> list[dict[str, Any]]:
    tasks = []
    for language in item.get("available_languages", []):
        if language not in {"ru", "en", "es"}:
            continue
        version = item["versions"][language]
        tasks.append(
            {
                "language": language,
                "insight_type": "text",
                "source_origin": "qanda_firestore",
                "source_ref": version.get("documentRef") or item["source_id"],
                "source_title": version.get("title") or item["source_title"],
                "source_type": "text",
                "review_required": False,
                "content_mode": "direct_qanda_source",
                "qa_id": item["qa_id"],
            }
        )
    return tasks


def build_plan(
    queue_payload: dict[str, Any],
    qanda_payload: dict[str, Any],
    state_payload: dict[str, Any],
    start_date: date,
    days: int,
    qanda_frequency_days: int,
) -> tuple[list[dict[str, Any]], dict[str, Any]]:
    queue = queue_payload.get("queue", [])
    if not queue:
        raise SystemExit("Queue is empty. Rebuild insights_content_queue first.")

    qanda_items = qanda_payload.get("items", [])
    used_qanda_ids = {int(value) for value in state_payload.get("used_qanda_ids", [])}
    queue_index = int(state_payload.get("last_queue_index", 0))
    days_payload: list[dict[str, Any]] = []

    for offset in range(days):
        current_date = start_date + timedelta(days=offset)
        core_source = queue[(queue_index + offset) % len(queue)]
        tasks = build_daily_tasks_for_source(core_source)
        qanda_item: dict[str, Any] | None = None
        if qanda_items and offset % max(qanda_frequency_days, 1) == 0:
            seed = current_date.isoformat()
            qanda_item = select_qanda_group(qanda_items, used_qanda_ids, seed)
            if qanda_item is not None:
                used_qanda_ids.add(int(qanda_item["qa_id"]))
                tasks.extend(build_qanda_tasks(qanda_item))

        language_counts = Counter(task["language"] for task in tasks)
        days_payload.append(
            {
                "date": current_date.isoformat(),
                "core_source": {
                    "source_id": core_source["source_id"],
                    "source_title": core_source["source_title"],
                    "source_origin": core_source["source_origin"],
                    "source_type": core_source["source_type"],
                },
                "qanda_source": None
                if qanda_item is None
                else {
                    "qa_id": qanda_item["qa_id"],
                    "source_title": qanda_item["source_title"],
                    "available_languages": qanda_item["available_languages"],
                },
                "language_coverage": {
                    language: language_counts.get(language, 0)
                    for language in REQUIRED_DAILY_LANGUAGES
                },
                "tasks": tasks,
            }
        )

    new_state = {
        "last_generated_at": datetime.now(timezone.utc).isoformat(),
        "last_queue_index": (queue_index + days) % len(queue),
        "used_qanda_ids": sorted(used_qanda_ids),
    }
    return days_payload, new_state


def write_outputs(
    days_payload: list[dict[str, Any]],
    new_state: dict[str, Any],
    output_json: Path,
    output_md: Path,
    state_path: Path,
) -> None:
    output_json.parent.mkdir(parents=True, exist_ok=True)
    output_md.parent.mkdir(parents=True, exist_ok=True)
    state_path.parent.mkdir(parents=True, exist_ok=True)

    payload = {
        "generated_at": datetime.now(timezone.utc).isoformat(),
        "required_daily_languages": list(REQUIRED_DAILY_LANGUAGES),
        "days": days_payload,
    }
    output_json.write_text(
        json.dumps(payload, ensure_ascii=False, indent=2) + "\n",
        encoding="utf-8",
    )
    state_path.write_text(
        json.dumps(new_state, ensure_ascii=False, indent=2) + "\n",
        encoding="utf-8",
    )

    lines = [
        "# Insights Daily Plan",
        "",
        f"- Generated at: {payload['generated_at']}",
        f"- Days: {len(days_payload)}",
        f"- Required languages: {', '.join(REQUIRED_DAILY_LANGUAGES).upper()}",
        "",
    ]
    for day in days_payload:
        lines.append(f"## {day['date']}")
        lines.append("")
        lines.append(
            f"- Core source: {day['core_source']['source_title']} "
            f"({day['core_source']['source_origin']} / {day['core_source']['source_type']})",
        )
        if day["qanda_source"] is not None:
            lines.append(
                f"- Q&A source: {day['qanda_source']['source_title']} "
                f"(langs: {', '.join(day['qanda_source']['available_languages']).upper()})",
            )
        lines.append(
            f"- Language coverage: {day['language_coverage']}",
        )
        lines.append("- Tasks:")
        for task in day["tasks"]:
            lines.append(
                f"  - [{task['language']}] {task['insight_type']} | "
                f"{task['source_origin']} | {task['source_title']}",
            )
        lines.append("")

    output_md.write_text("\n".join(lines), encoding="utf-8")


def main() -> int:
    args = parse_args()
    queue_payload = load_json(args.queue)
    qanda_payload = load_json(args.qanda)
    state_payload = load_json(args.state, fallback={})
    start_date = date.fromisoformat(args.start_date)
    days_payload, new_state = build_plan(
        queue_payload,
        qanda_payload,
        state_payload,
        start_date,
        args.days,
        args.qanda_frequency_days,
    )
    write_outputs(
        days_payload,
        new_state,
        Path(args.output_json),
        Path(args.output_md),
        Path(args.state),
    )
    print(f"Wrote daily plan with {len(days_payload)} days to {args.output_json}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
