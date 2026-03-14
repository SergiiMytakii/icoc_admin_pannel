# Insights Operations Checklist

This is the short operational checklist for the `Insights` posting system.

Use this file when you do not want the full runbook and only need the practical sequence.

Full reference:

- [insights-posting-automation-runbook.md](/Users/serhiimytakii/Projects/icoc/icoc_admin_pannel/docs/insights-posting-automation-runbook.md)

## Daily Manual Check

1. Confirm the main repo is available:
   - `/Users/serhiimytakii/Projects/icoc/icoc_admin_pannel`
2. Regenerate the daily inputs:
   - `python3 scripts/refresh_insights_daily_plan.py --days 1 --start-date "$(date +%F)"`
3. Open the generated plan:
   - [insights_daily_plan.json](/Users/serhiimytakii/Projects/icoc/icoc_admin_pannel/build/insights/insights_daily_plan.json)
4. Verify that today has tasks for `uk`, `ru`, `en`, and `es`.
5. Check whether any media tasks are unsafe because source language does not match target locale.
6. Prefer publishing tasks that already have a correct language match.
7. For Q&A posts, use the matching language variant from:
   - [qanda_source_catalog.json](/Users/serhiimytakii/Projects/icoc/icoc_admin_pannel/build/insights/qanda_source_catalog.json)
8. Publish through `upsertInsightsBatch`, not by ad-hoc Firestore writes.
9. After publish, verify the created records inside `Insights`.
10. If something was skipped, log why it was skipped.

## Publishing Rules

1. Never save `ua`; always save `uk`.
2. Never repost the same YouTube asset into another locale unless it is a real language-specific source.
3. For `video` posts, confirm that audio/title/channel match the locale.
4. For `image` posts, do not auto-publish if the image language is unknown.
5. For `text` posts, use the source author when known.
6. If author cannot be identified, fallback to `ICOC Insights`.
7. If source is BibleProject, use `BibleProject`.
8. If source is KCOC, use `KCOC`.
9. If source is Odesa Church, use `Odesa Church`.
10. Keep ids stable:
   - `codex_<lang>_<type>_<source>`

## Duplicate Prevention

1. The publish API blocks duplicate `youtubeId + language`.
2. If the API returns `already-exists`, do not force publish.
3. Pick another source or another legitimate locale version.
4. Reuse the same id only when updating an existing post intentionally.

## Automation Check

1. Daily automation file:
   - [automation.toml](/Users/serhiimytakii/.codex/automations/daily-insights-publish/automation.toml)
2. Automation memory:
   - [memory.md](/Users/serhiimytakii/.codex/automations/daily-insights-publish/memory.md)
3. The automation must regenerate `build/insights/*.json` before reading the plan.
4. Clean Codex worktrees do not contain generated build artifacts by default.
5. If automation fails, first check whether `refresh_insights_daily_plan.py` completed successfully.
6. If YouTube export fails through `yt-dlp`, the fallback parser should still generate the catalog.
7. If VerseOfTheDay export fails, the system should continue with an empty fallback inventory instead of aborting the whole run.

## Commands

Rebuild all inputs:

```bash
python3 scripts/refresh_insights_daily_plan.py --days 1 --start-date "$(date +%F)"
```

Run the real daily publish:

```bash
python3 scripts/run_daily_insights_publish.py --date "$(date +%F)"
```

Rebuild only YouTube catalog:

```bash
python3 scripts/export_youtube_source_catalog.py
```

Rebuild only Q&A catalog:

```bash
python3 scripts/export_qanda_source_catalog.py
```

Rebuild only queue:

```bash
python3 scripts/build_insights_content_queue.py
```

Rebuild only daily plan:

```bash
python3 scripts/build_insights_daily_plan.py
```

Deploy updated publish function:

```bash
cd functions
npm run build
firebase deploy --only functions:upsertInsightsBatch --project icoc-8f075
```

## If Something Breaks

1. Check whether the plan file exists:
   - [insights_daily_plan.json](/Users/serhiimytakii/Projects/icoc/icoc_admin_pannel/build/insights/insights_daily_plan.json)
2. Check whether the queue exists:
   - [insights_content_queue.json](/Users/serhiimytakii/Projects/icoc/icoc_admin_pannel/build/insights/insights_content_queue.json)
3. Check whether Q&A export exists:
   - [qanda_source_catalog.json](/Users/serhiimytakii/Projects/icoc/icoc_admin_pannel/build/insights/qanda_source_catalog.json)
4. Check automation memory for the exact stop reason.
5. Check whether Firebase ID token acquisition failed.
6. Check whether the source language actually matched the target locale.
7. Check whether the post was blocked by duplicate protection.
8. Check whether the Cloud Function was updated and deployed.

## Default Decision Order

1. Shorts first.
2. Then long videos.
3. Then images when language is safe.
4. Inject Q&A periodically.
5. Preserve source author.
6. Skip unsafe locale mismatches.
7. Prefer correctness over filling every slot blindly.
