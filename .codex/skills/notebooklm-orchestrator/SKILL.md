---
name: notebooklm-orchestrator
description: Git-safe snapshot of the NotebookLM orchestration rules used for the ICOC insights content pipeline in this repository.
---

# NotebookLM Orchestrator

This is the repo-scoped snapshot of the NotebookLM operating pattern for `insights`.

Use this together with:

- [AGENTS.md](/Users/serhiimytakii/Projects/icoc/icoc_admin_pannel/AGENTS.md)
- [insights-content-automation.md](/Users/serhiimytakii/Projects/icoc/icoc_admin_pannel/docs/insights-content-automation.md)

## Core Principle

Treat NotebookLM as the synthesis layer and local code/scripts as the scheduling layer.

- local scripts decide source ingestion, queue order, daily language coverage, and anti-repeat logic
- NotebookLM turns selected sources into drafts, summaries, and content briefs

## Multi-Notebook Rule

Do not assume one NotebookLM notebook should store all sources forever.

For this project, use multiple notebooks when source limits or source sprawl make one notebook less useful.

### Known Notebook Map

- `74765d5a-4b7c-4dc5-8a10-8c24c886c3c9` — `ICOC Insights Content Engine`
  - main multilingual planning notebook
  - use for mixed-source planning, weekly prompts, queue logic, VerseOfTheDay planning, and cross-stream synthesis

- `b019a235-3477-4ca5-8213-555654a247e5` — `BibleProject Shorts English`
  - overflow / specialized English notebook
  - use when the main notebook is near source limits
  - use for English-heavy shorts and other sources that would otherwise crowd the main planning notebook

- `BibleProject Shorts Ukrainian` — pending creation on next NotebookLM login refresh
  - specialized Ukrainian shorts notebook
  - use for Ukrainian BibleProject shorts so they do not mix into the English-only overflow notebook

## Notebook Routing Rules

- keep the main notebook focused on planning and mixed-source synthesis
- move overflow or specialized domains into secondary notebooks
- when a notebook approaches source limits, route new sources into the best matching secondary notebook
- explicitly record which notebook holds which source family
- when the user sends a YouTube channel `/videos` or `/shorts` URL, use the batch helper instead of adding one source at a time

## Batch YouTube Ingest

Use the helper script:

- [.codex/skills/notebooklm-orchestrator/scripts/bulk_add_youtube_channel.py](/Users/serhiimytakii/Projects/icoc/icoc_admin_pannel/.codex/skills/notebooklm-orchestrator/scripts/bulk_add_youtube_channel.py)

Workflow:

1. Choose the target notebook before importing.
2. Prefer the exact channel tab URL, such as `/videos` or `/shorts`.
3. Run a dry run first when the source family is new.
4. Run the real import with duplicate skipping enabled.
5. Keep future imports from the same source family in the same notebook unless routing rules change.

The helper:

- enumerates the channel tab through `yt-dlp --flat-playlist`
- adds sources through `notebooklm source add ... --type youtube`
- skips duplicates already present in the notebook by canonical URL, then by title fallback
- is the preferred path for quickly loading a full channel tab into NotebookLM

ICOC routing reminder:

- `ICOC Insights Content Engine` for multilingual planning and mixed-source synthesis
- `BibleProject Shorts English` for overflow or English-heavy shorts
- `BibleProject Shorts Ukrainian` for Ukrainian BibleProject shorts

## Content Workflow Context

The `insights` system currently combines:

- YouTube shorts
- long-form YouTube videos
- VerseOfTheDay image assets
- Firestore `QandA`

The language plan is:

- `uk`
- `ru`
- `en`
- `es`

The scheduler should ensure daily coverage for all four languages.

## Repo Artifacts To Trust First

Prefer these local artifacts before improvising:

- [youtube_source_catalog.json](/Users/serhiimytakii/Projects/icoc/icoc_admin_pannel/build/insights/youtube_source_catalog.json)
- [qanda_source_catalog.json](/Users/serhiimytakii/Projects/icoc/icoc_admin_pannel/build/insights/qanda_source_catalog.json)
- [verse_of_day_inventory.json](/Users/serhiimytakii/Projects/icoc/icoc_admin_pannel/build/insights/verse_of_day_inventory.json)
- [insights_content_queue.json](/Users/serhiimytakii/Projects/icoc/icoc_admin_pannel/build/insights/insights_content_queue.json)
- [insights_daily_plan.json](/Users/serhiimytakii/Projects/icoc/icoc_admin_pannel/build/insights/insights_daily_plan.json)

## Operational Reminder

Do not commit the global `~/.codex` folder.

Only this repo-scoped `.codex` snapshot is meant for git.
