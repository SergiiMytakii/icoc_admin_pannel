#!/usr/bin/env python3
from pathlib import Path
import re
import sys


SKILL_PATH = Path(__file__).resolve().parents[1] / "SKILL.md"
REQUIRED_BODY_MARKERS = (
    "## API",
    "### Curl template",
    "## Usage Playbook",
    "## Safety Checks",
    "upsertInsightsBatch",
)


def parse_frontmatter(text: str) -> dict[str, str]:
    match = re.match(r"^---\n(.*?)\n---\n", text, re.S)
    if not match:
        raise ValueError("SKILL.md must start with a closed YAML frontmatter block")

    metadata: dict[str, str] = {}
    for line in match.group(1).splitlines():
        if not line.strip():
            continue
        key, separator, value = line.partition(":")
        if not separator:
            raise ValueError(f"Invalid frontmatter line: {line!r}")
        metadata[key.strip()] = value.strip()
    return metadata


def main() -> int:
    text = SKILL_PATH.read_text()
    metadata = parse_frontmatter(text)

    if metadata.get("name") != "insights-publisher":
        raise ValueError("frontmatter name must be insights-publisher")
    if not metadata.get("description"):
        raise ValueError("frontmatter description is required")

    missing = [marker for marker in REQUIRED_BODY_MARKERS if marker not in text]
    if missing:
        raise ValueError(f"SKILL.md missing required body marker(s): {', '.join(missing)}")

    print("PASS: insights-publisher skill metadata and required publishing sections are valid")
    return 0


if __name__ == "__main__":
    try:
        raise SystemExit(main())
    except ValueError as exc:
        print(f"FAIL: {exc}", file=sys.stderr)
        raise SystemExit(1)
