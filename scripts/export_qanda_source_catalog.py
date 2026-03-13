#!/usr/bin/env python3
from __future__ import annotations

import argparse
import json
import urllib.parse
import urllib.request
from collections import Counter
from datetime import datetime, timezone
from pathlib import Path
from typing import Any


DEFAULT_PROJECT = "icoc-8f075"
DEFAULT_COLLECTION = "QandA"
DEFAULT_OUTPUT = "build/insights/qanda_source_catalog.json"
SUPPORTED_QANDA_LANGS = ("ru", "en", "es")


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Export Q&A source catalog from Firestore via REST API.",
    )
    parser.add_argument("--project", default=DEFAULT_PROJECT)
    parser.add_argument("--collection", default=DEFAULT_COLLECTION)
    parser.add_argument("--output", default=DEFAULT_OUTPUT)
    parser.add_argument("--page-size", type=int, default=300)
    return parser.parse_args()


def firestore_url(project: str, collection: str, page_size: int, page_token: str | None) -> str:
    base = (
        f"https://firestore.googleapis.com/v1/projects/{project}"
        f"/databases/(default)/documents/{collection}"
    )
    params = {"pageSize": str(page_size)}
    if page_token:
        params["pageToken"] = page_token
    return f"{base}?{urllib.parse.urlencode(params)}"


def decode_firestore_value(value: dict[str, Any]) -> Any:
    if "stringValue" in value:
        return value["stringValue"]
    if "integerValue" in value:
        return int(value["integerValue"])
    if "doubleValue" in value:
        return float(value["doubleValue"])
    if "booleanValue" in value:
        return bool(value["booleanValue"])
    if "nullValue" in value:
        return None
    if "arrayValue" in value:
        values = value["arrayValue"].get("values", [])
        return [decode_firestore_value(item) for item in values]
    if "mapValue" in value:
        fields = value["mapValue"].get("fields", {})
        return {key: decode_firestore_value(val) for key, val in fields.items()}
    if "timestampValue" in value:
        return value["timestampValue"]
    return None


def decode_document(document: dict[str, Any]) -> dict[str, Any]:
    fields = document.get("fields", {})
    payload = {key: decode_firestore_value(value) for key, value in fields.items()}
    payload["documentRef"] = document["name"].rsplit("/", 1)[-1]
    return payload


def fetch_documents(project: str, collection: str, page_size: int) -> list[dict[str, Any]]:
    documents: list[dict[str, Any]] = []
    page_token: str | None = None
    while True:
        url = firestore_url(project, collection, page_size, page_token)
        with urllib.request.urlopen(url, timeout=30) as response:
            payload = json.loads(response.read().decode("utf-8"))
        documents.extend(decode_document(document) for document in payload.get("documents", []))
        page_token = payload.get("nextPageToken")
        if not page_token:
            break
    return documents


def build_catalog(documents: list[dict[str, Any]]) -> dict[str, Any]:
    grouped: dict[int, dict[str, Any]] = {}
    for document in documents:
        lang = str(document.get("lang") or "").strip().lower()
        article_id = int(document.get("id") or 0)
        if article_id <= 0 or lang not in SUPPORTED_QANDA_LANGS:
            continue

        group = grouped.setdefault(
            article_id,
            {
                "qa_id": article_id,
                "available_languages": [],
                "versions": {},
                "tags": [],
                "author": document.get("author") or "Douglas Jacoby",
            },
        )
        group["versions"][lang] = {
            "documentRef": document.get("documentRef"),
            "title": document.get("title") or "",
            "question": document.get("question") or "",
            "answer": document.get("answer") or "",
            "link": document.get("link"),
            "source": document.get("source"),
            "youtubeLink": document.get("youtubeLink"),
            "date": document.get("date"),
            "translatedBy": document.get("translatedBy"),
        }
        tags = document.get("tags") or []
        for tag in tags:
            if isinstance(tag, str) and tag not in group["tags"]:
                group["tags"].append(tag)

    items: list[dict[str, Any]] = []
    for article_id, group in sorted(grouped.items()):
        available_languages = sorted(group["versions"].keys())
        if not available_languages:
            continue
        representative_lang = "en" if "en" in group["versions"] else available_languages[0]
        representative = group["versions"][representative_lang]
        items.append(
            {
                "qa_id": article_id,
                "source_id": f"qanda-{article_id}",
                "source_origin": "qanda_firestore",
                "source_type": "text",
                "source_title": representative["title"],
                "representative_language": representative_lang,
                "available_languages": available_languages,
                "is_complete_trilingual": all(
                    language in available_languages for language in SUPPORTED_QANDA_LANGS
                ),
                "author": group["author"],
                "tags": group["tags"],
                "versions": group["versions"],
            },
        )

    language_counter = Counter()
    for item in items:
        for language in item["available_languages"]:
            language_counter[language] += 1

    return {
        "generated_at": datetime.now(timezone.utc).isoformat(),
        "total_questions": len(items),
        "languages": dict(sorted(language_counter.items())),
        "items": items,
    }


def main() -> int:
    args = parse_args()
    documents = fetch_documents(args.project, args.collection, args.page_size)
    payload = build_catalog(documents)
    output_path = Path(args.output)
    output_path.parent.mkdir(parents=True, exist_ok=True)
    output_path.write_text(
        json.dumps(payload, ensure_ascii=False, indent=2) + "\n",
        encoding="utf-8",
    )
    print(f"Wrote {payload['total_questions']} Q&A groups to {output_path}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
