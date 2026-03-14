# AGENTS.md

## Insights Automation

When the task touches `insights` content generation, NotebookLM ingestion, source mixing, or draft planning, use:

- [insights-content-automation.md](/Users/serhiimytakii/Projects/icoc/icoc_admin_pannel/docs/insights-content-automation.md)

Treat that document as the repo playbook for:

- NotebookLM workflow
- multi-notebook routing
- YouTube and Firebase source ingestion
- Firestore Q&A ingestion
- language normalization
- content queue generation
- daily multilingual planning
- shorts / images / videos mixing
- text Q&A posts
- draft generation expectations

## Required Rules For Insights Work

- Canonical insight languages are `uk`, `ru`, `en`, and `es`.
- Never save `ua` to Firestore; normalize it to `uk`.
- `insights.language` must represent the final post language, not only the source language.
- Prefer a deterministic local queue for scheduling and ordering.
- Use NotebookLM for synthesis, summarization, and draft creation, not for final scheduling decisions.
- For `insights`, assume multiple NotebookLM notebooks may be required because of source limits.
- Do not overload one notebook when a source-domain notebook already exists.
- When the user sends a YouTube channel `/videos` or `/shorts` URL, prefer the NotebookLM batch-ingest helper over manual per-video adds.
- Prefer shorts as the main stream, but keep images and long videos in rotation.
- Support `text` insight posts for Q&A content.
- Mix by channel/origin as well as by type. Avoid long runs from the same source origin when alternatives exist.
- Build daily plans so each day includes `uk`, `ru`, `en`, and `es`.
- Prefer Q&A groups that have all of `ru`, `en`, and `es`, and avoid repeating the same question until the pool is exhausted.
- VerseOfTheDay images require OCR or manual review before language-safe auto-publishing.
- Use the publish API instead of ad-hoc Firestore writes: `upsertInsightsBatch` (Cloud Function).

## Relevant Files

- [insights_language.dart](/Users/serhiimytakii/Projects/icoc/icoc_admin_pannel/lib/domain/helpers/insights_language.dart)
- [insights_repository_impl.dart](/Users/serhiimytakii/Projects/icoc/icoc_admin_pannel/lib/data/repository_impl/insights_repository_impl.dart)
- [insight_editor_screen.dart](/Users/serhiimytakii/Projects/icoc/icoc_admin_pannel/lib/ui/screens/insights/widgets/insight_editor_screen.dart)
- [export_youtube_source_catalog.py](/Users/serhiimytakii/Projects/icoc/icoc_admin_pannel/scripts/export_youtube_source_catalog.py)
- [export_qanda_source_catalog.py](/Users/serhiimytakii/Projects/icoc/icoc_admin_pannel/scripts/export_qanda_source_catalog.py)
- [export_verse_of_day_inventory.py](/Users/serhiimytakii/Projects/icoc/icoc_admin_pannel/scripts/export_verse_of_day_inventory.py)
- [build_insights_content_queue.py](/Users/serhiimytakii/Projects/icoc/icoc_admin_pannel/scripts/build_insights_content_queue.py)
- [build_insights_daily_plan.py](/Users/serhiimytakii/Projects/icoc/icoc_admin_pannel/scripts/build_insights_daily_plan.py)
- [.codex/skills/notebooklm-orchestrator/scripts/bulk_add_youtube_channel.py](/Users/serhiimytakii/Projects/icoc/icoc_admin_pannel/.codex/skills/notebooklm-orchestrator/scripts/bulk_add_youtube_channel.py)
- [.codex/skills/insights-publisher/SKILL.md](/Users/serhiimytakii/Projects/icoc/icoc_admin_pannel/.codex/skills/insights-publisher/SKILL.md)
- Cloud Function publish entrypoint: `functions/src/index.ts` → `upsertInsightsBatch`

## Known NotebookLM Notebooks For Insights

- `74765d5a-4b7c-4dc5-8a10-8c24c886c3c9` — `ICOC Insights Content Engine`
  - main multilingual planning notebook
  - use for queue logic, weekly prompts, mixed-source synthesis, and content engine work
- `b019a235-3477-4ca5-8213-555654a247e5` — `BibleProject Shorts English`
  - overflow / specialized English notebook
  - use when the main notebook is near source limits or when English shorts sources should stay isolated
- `31fdfc03-78da-41c5-8a54-64b701512a8e` — `BibleProject Shorts Ukrainian`
  - specialized Ukrainian shorts notebook
  - use for Ukrainian BibleProject shorts so they do not get mixed into the English shorts notebook

## Typical Commands

```bash
python3 scripts/export_youtube_source_catalog.py
python3 scripts/export_qanda_source_catalog.py
python3 scripts/export_verse_of_day_inventory.py
python3 scripts/build_verse_of_day_notebook_source.py
python3 scripts/build_insights_content_queue.py
python3 scripts/build_insights_daily_plan.py
"$HOME/.codex-tools/notebooklm-py/bin/python" .codex/skills/notebooklm-orchestrator/scripts/bulk_add_youtube_channel.py --help
```
