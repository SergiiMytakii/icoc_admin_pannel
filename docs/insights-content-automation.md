# Insights Content Automation

This document is the working playbook for the `insights` content pipeline in the ICOC admin panel.

Companion end-to-end runbook:

- [insights-posting-automation-runbook.md](/Users/serhiimytakii/Projects/icoc/icoc_admin_pannel/docs/insights-posting-automation-runbook.md)

It explains:

- what content sources we use
- how NotebookLM fits into the workflow
- how sources are ingested
- how content is mixed across shorts, videos, and images
- how Q&A text posts are injected
- how languages are determined and saved
- which parts are already automated
- which parts still require review

## Goal

The goal is to build a repeatable pipeline that fills the `insights` section with strong draft-ready content by combining:

- YouTube shorts
- long-form YouTube videos
- image assets from Firebase Storage `VerseOfTheDay`
- Firestore `QandA`
- NotebookLM synthesis

The desired result is not random posting. The system should:

- prefer shorts as the main stream
- mix in image posts and long videos
- periodically add text-based Q&A posts
- rotate content sources instead of repeating the same type constantly
- assign the correct post language
- keep output compatible with the real `insights` Firestore schema

## Current Product Model

The admin panel stores insight posts as `Post`:

- model: [post.dart](/Users/serhiimytakii/Projects/icoc/icoc_admin_pannel/lib/domain/model/insights/post.dart)
- editor: [insight_editor_screen.dart](/Users/serhiimytakii/Projects/icoc/icoc_admin_pannel/lib/ui/screens/insights/widgets/insight_editor_screen.dart)
- repository: [insights_repository_impl.dart](/Users/serhiimytakii/Projects/icoc/icoc_admin_pannel/lib/data/repository_impl/insights_repository_impl.dart)

Important fields:

- `type`: `image`, `video`, or `text`
- `language`: string language code
- `title`
- `content`
- `mediaUrls`
- `thumbnailUrl`
- `youtubeId`
- `articleUrl`
- `author`
- `status`
- `allowComments`

The admin UI already supports filtering by language and showing the type and status of each post.

## Supported Insight Languages

For the content automation flow, the preferred languages are:

- `uk`
- `ru`
- `en`
- `es`

Language normalization is implemented in:

- [insights_language.dart](/Users/serhiimytakii/Projects/icoc/icoc_admin_pannel/lib/domain/helpers/insights_language.dart)

What it does:

- canonicalizes user input like `ua` into `uk`
- accepts aliases such as `ukrainian`, `russian`, `english`, `spanish`
- rejects unsupported language values on write
- safely normalizes bad historical values on read with fallback to `en`

Important rule:

- `insights.language` must always represent the language of the final post saved in the database
- this is not always the same as the language of the source asset

Example:

- a Russian YouTube source can still produce a Ukrainian post later
- in that case the source language is `ru`, but the saved post language is `uk`

## Content Sources

### 1. Odesa Church videos

Channel:

- [Odesa Church of Christ videos](https://www.youtube.com/@OdesaChurch/videos)

This feed is used as the main long-form video stream.

### 2. Google Sheets YouTube registry

The operational source-of-truth for YouTube shorts and long videos is now a Google Sheet tab.

The sheet stores one source per row and is used for:

- KCOC shorts
- Odesa long videos
- BibleProject English shorts
- BibleProject Ukrainian shorts
- any additional curated YouTube source family

Recommended columns:

- `enabled`
- `priority_rank`
- `source_origin`
- `source_type`
- `source_ref`
- `source_title`
- `source_language`
- `author_name`
- `channel_url`
- `description`
- `keywords`
- `published`
- `published_at`
- `published_post_ids`

The automation reads the sheet through CSV export, not through NotebookLM.
If a row is marked published, it is excluded from future YouTube queue builds.

### 3. Verse of the Day images

Firebase Storage folder:

- `gs://icoc-8f075.appspot.com/VerseOfTheDay`

This folder is used as the image-post stream.

Inventory export already exists via:

- [export_verse_of_day_inventory.py](/Users/serhiimytakii/Projects/icoc/icoc_admin_pannel/scripts/export_verse_of_day_inventory.py)
- [build_verse_of_day_notebook_source.py](/Users/serhiimytakii/Projects/icoc/icoc_admin_pannel/scripts/build_verse_of_day_notebook_source.py)

The VerseOfTheDay export now uses Firebase Storage REST listing as the primary path, not browser scraping, so automation does not depend on Playwright for the default inventory build.
It also keeps an OCR cache in `build/insights/verse_of_day_ocr_cache.json`, detects the language of cached verse images through macOS Vision OCR, and reuses the same-day inventory instead of re-running Verse export on every retry.
If a new Verse export fails while an older inventory already exists, refresh keeps the last good inventory instead of clobbering it with an empty fallback.

Generated artifacts:

- [verse_of_day_inventory.json](/Users/serhiimytakii/Projects/icoc/icoc_admin_pannel/build/insights/verse_of_day_inventory.json)
- [verse_of_day_notebook_source.md](/Users/serhiimytakii/Projects/icoc/icoc_admin_pannel/build/insights/verse_of_day_notebook_source.md)

### 4. Firestore Q&A

Collection:

- `QandA`

This is the text-post stream for `insights`.

It is exported through Firestore REST with:

- [export_qanda_source_catalog.py](/Users/serhiimytakii/Projects/icoc/icoc_admin_pannel/scripts/export_qanda_source_catalog.py)

Generated artifact:

- [qanda_source_catalog.json](/Users/serhiimytakii/Projects/icoc/icoc_admin_pannel/build/insights/qanda_source_catalog.json)

The catalog groups documents by Q&A article id and tracks available language versions.

## NotebookLM Role

NotebookLM is now optional and should be treated only as the research and synthesis layer, not as the source registry or scheduler.

NotebookLM should help with:

- clustering themes
- extracting post ideas from multiple sources
- turning raw sources into post drafts
- producing weekly content briefs
- mixing videos and image concepts around one theme

NotebookLM should not be trusted to decide the final publication order by itself.

That part should remain deterministic and local.

## Current NotebookLM Workspace

The insights workflow should use multiple NotebookLM notebooks when source limits become a problem.

### Known notebook map

- `74765d5a-4b7c-4dc5-8a10-8c24c886c3c9` — `ICOC Insights Content Engine`
  - main multilingual planning notebook
  - use for schema notes, weekly prompts, queue logic, VerseOfTheDay planning, mixed-source synthesis, and cross-stream content planning
- `b019a235-3477-4ca5-8213-555654a247e5` — `BibleProject Shorts English`
  - overflow / specialized English notebook
  - use when the main insights notebook is near source limits
  - use for English-heavy shorts sources that would otherwise crowd the planning notebook
- `31fdfc03-78da-41c5-8a54-64b701512a8e` — `BibleProject Shorts Ukrainian`
  - specialized Ukrainian shorts notebook
  - use for Ukrainian BibleProject shorts so they stay isolated from the English overflow notebook

### Main notebook contents

`ICOC Insights Content Engine` already contains:

- the insights schema and publishing notes
- the weekly prompt note
- VerseOfTheDay inventory notes
- multiple YouTube sources

NotebookLM on this machine is driven through:

- local CLI: `~/.codex-tools/notebooklm-py/bin/notebooklm`
- auth state: `~/.notebooklm/storage_state.json`
- helper skill outside the repo: `~/.codex/skills/notebooklm-orchestrator`

### Multi-notebook rule

Do not assume one notebook should store all sources forever.

For `insights`, prefer this strategy:

- keep the main notebook focused on planning and mixed-source synthesis
- place overflow or specialized domains into secondary notebooks
- when a notebook approaches source limits, route new sources into the best matching secondary notebook instead of overloading the primary one
- explicitly document which notebook was used for which source family
- keep BibleProject English shorts and BibleProject Ukrainian shorts in separate notebooks

## Source Ingestion

### YouTube source catalog

The YouTube source catalog is built with:

- [export_google_sheets_youtube_catalog.py](/Users/serhiimytakii/Projects/icoc/icoc_admin_pannel/scripts/export_google_sheets_youtube_catalog.py)
- [build_google_sheets_youtube_seed.py](/Users/serhiimytakii/Projects/icoc/icoc_admin_pannel/scripts/build_google_sheets_youtube_seed.py)

It reads a Google Sheets CSV export and writes a structured JSON catalog:

- [youtube_source_catalog.json](/Users/serhiimytakii/Projects/icoc/icoc_admin_pannel/build/insights/youtube_source_catalog.json)

For each source it stores:

- `source_id`
- `source_origin`
- `source_type`
- `source_ref`
- `source_title`
- `channel_position`
- `source_language`
- `language_confidence`
- `language_reason`
- `eligible_for_auto_post`

### Google Sheets bootstrap

To bootstrap the sheet from the current local catalog:

```bash
python3 scripts/build_google_sheets_youtube_seed.py
```

Import the resulting CSV into the Google Sheet tab used by the exporter.

To append `odesa_shorts` rows into the registry and also generate an import CSV:

```bash
python3 scripts/import_youtube_channel_to_google_sheet.py
```

If the live Google Sheets API is unavailable, the script still writes:

- [google_sheets_channel_import.csv](/Users/serhiimytakii/Projects/icoc/icoc_admin_pannel/output/spreadsheet/google_sheets_channel_import.csv)

so the rows can be imported manually later.

### NotebookLM batch import

When a user sends a YouTube channel tab URL and wants everything from that tab added into NotebookLM, the preferred path is the batch helper:

- [.codex/skills/notebooklm-orchestrator/scripts/bulk_add_youtube_channel.py](/Users/serhiimytakii/Projects/icoc/icoc_admin_pannel/.codex/skills/notebooklm-orchestrator/scripts/bulk_add_youtube_channel.py)

It should be used for both:

- `/videos` channel tabs
- `/shorts` channel tabs

Operational rules:

- choose the target notebook before importing
- prefer a dry run for new source families
- skip duplicates already present in the target notebook
- use canonical YouTube URL matching first and title matching as a fallback
- route overflow or English-heavy shorts into the secondary notebook when the main notebook is near source limits

Typical command pattern:

```bash
"$HOME/.codex-tools/notebooklm-py/bin/python" \
  .codex/skills/notebooklm-orchestrator/scripts/bulk_add_youtube_channel.py \
  --notebook 74765d5a-4b7c-4dc5-8a10-8c24c886c3c9 \
  --channel-url "https://www.youtube.com/@OdesaChurch/videos" \
  --dry-run \
  --limit 10
```

## Publishing API (Cloud Function)

- Endpoint: `https://europe-central2-icoc-8f075.cloudfunctions.net/upsertInsightsBatch`
- Auth: Firebase ID token (`Authorization: Bearer <ID_TOKEN>`)
- Batch: up to 50 items
- Types: `image`, `video`, `text`
- Languages: `uk|ru|en|es` (aliases accepted; stored canonical)
- Validation:
  - `video` requires `youtubeId` or `articleUrl` (shorts allowed)
  - `image` requires `mediaUrls`
  - `status` defaults to `published`
  - `thumbnail`/`aspectRatio` auto for video
- Skill: [.codex/skills/insights-publisher/SKILL.md](/Users/serhiimytakii/Projects/icoc/icoc_admin_pannel/.codex/skills/insights-publisher/SKILL.md)

Example call:

```bash
ID_TOKEN="$(firebase auth:print-access-token)"
curl -X POST \
  -H "Authorization: Bearer $ID_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "items": [{
      "id": "codex_uk_video_t6ldczgdd8s",
      "type": "video",
      "language": "uk",
      "title": "Очікування від Бога",
      "content": "Ми часто приходимо до Бога зі своїм таймінгом...",
      "articleUrl": "https://youtube.com/shorts/T6LdCZgDD8s?feature=share",
      "status": "published"
    }]
  }' \
  https://europe-central2-icoc-8f075.cloudfunctions.net/upsertInsightsBatch
```

### Q&A source catalog

The Q&A source catalog is built with:

- [export_qanda_source_catalog.py](/Users/serhiimytakii/Projects/icoc/icoc_admin_pannel/scripts/export_qanda_source_catalog.py)

For each grouped Q&A item it stores:

- `qa_id`
- `source_id`
- `source_origin`
- `source_type = text`
- `source_title`
- `available_languages`
- `is_complete_trilingual`
- per-language versions for `ru`, `en`, and `es`

### Language detection for YouTube titles

At the moment, language is inferred from the title using lightweight heuristics:

- Ukrainian character markers such as `ї`, `є`, `і`, `ґ`
- Russian markers such as `ё`, `ы`, `э`, `ъ`
- keyword sets for `uk`, `ru`, `en`
- script fallback when signals are weak

This is good enough for a first-pass queue, but not a final replacement for transcripts or manual review.

### Verse image inventory

The VerseOfTheDay image inventory is already exported separately.

At the moment, image language is not auto-detected reliably.

That means Verse image items should still be treated as:

- valid content assets
- not fully language-ready
- subject to OCR or manual review before direct publishing

## Content Queue

The main planning layer is:

- [build_insights_content_queue.py](/Users/serhiimytakii/Projects/icoc/icoc_admin_pannel/scripts/build_insights_content_queue.py)

Generated outputs:

- [insights_content_queue.json](/Users/serhiimytakii/Projects/icoc/icoc_admin_pannel/build/insights/insights_content_queue.json)
- [insights_content_queue.md](/Users/serhiimytakii/Projects/icoc/icoc_admin_pannel/build/insights/insights_content_queue.md)

This queue is the real local planner for what should be drafted next.

### Current queue mix

The queue is built with these target weights:

- type weights:
  - `short`: `0.60`
  - `image`: `0.25`
  - `video`: `0.15`
- language weights:
  - `uk`: `0.35`
  - `ru`: `0.25`
  - `en`: `0.20`
  - `es`: `0.20`

This means:

- shorts are the dominant content stream
- images are mixed in regularly
- long videos appear less often but still stay in the rotation

### Queue scoring logic

Each candidate source is scored using:

- whether its type is currently under target
- whether its target post language is currently under target
- shorts bonus
- image bonus
- freshness bonus
- recent channel/origin repetition penalty
- penalty for repeating the same type back to back
- penalty for repeating the same origin back to back
- penalty for repeating the same language back to back

The queue also enforces an origin cooldown:

- when alternatives exist, it avoids long runs from the same `source_origin`
- the current target is to break the stream before it turns into many consecutive items from one channel
- in practice this means shorts from one channel get interrupted by other origins such as long-form videos or image posts
- queue items are treated as multilingual source clusters and currently carry `publish_languages = [uk, ru, en, es]`

Important limitation:

- true cross-channel shorts mixing requires more than one shorts source origin
- if only one shorts channel exists, the queue can still break streaks with videos and images, but it cannot invent a second shorts channel

This keeps the queue from turning into:

- only one language
- only one source stream
- only old content
- only long-form videos
- only one channel

### Review-required items

Some queue items are marked `review_required`.

This usually means:

- image language is not known yet
- a source language could not be confidently determined
- the source should not be auto-published until checked

Current examples:

- VerseOfTheDay images without OCR
- weakly classified YouTube titles

## How NotebookLM Fits Into The Queue

The recommended pipeline is:

1. Build source catalogs.
2. Build the weighted content queue.
3. Build the multilingual daily plan.
4. Take the next scheduled source clusters.
5. Add those sources or summaries to NotebookLM.
6. Ask NotebookLM to generate draft-ready `insights` posts.
7. Save drafts into Firestore with the correct `language`, `type`, and source fields.

This separation matters:

- local queue decides order
- NotebookLM decides wording, angles, summaries, and draft packaging

## Recommended Draft Workflow

For each queue item:

1. Read the queue item.
2. Determine target `post_language`.
3. Send the source into NotebookLM if it is not already available there.
4. Ask NotebookLM for:
   - title
   - body content
   - notification text
   - topic angle
   - why it matters
5. Convert the output into a `Post` compatible with the admin app.

For `short` and `video` sources:

- `type = video`
- `youtubeId` should be extracted from the URL
- `articleUrl` should store the normalized YouTube URL
- `thumbnailUrl` should use the YouTube thumbnail

For `image` sources:

- `type = image`
- `mediaUrls` should contain the Firebase image URL
- if the language is not confirmed, keep the draft in review mode

For `text` Q&A sources:

- `type = text`
- `title` should come from the selected Q&A language version
- `content` should include the question and answer or a refined NotebookLM rewrite
- `articleUrl` can store the original Q&A link
- there is no required image or video field

## Daily Multilingual Plan

The daily planner is:

- [build_insights_daily_plan.py](/Users/serhiimytakii/Projects/icoc/icoc_admin_pannel/scripts/build_insights_daily_plan.py)

Generated outputs:

- [insights_daily_plan.json](/Users/serhiimytakii/Projects/icoc/icoc_admin_pannel/build/insights/insights_daily_plan.json)
- [insights_daily_plan.md](/Users/serhiimytakii/Projects/icoc/icoc_admin_pannel/build/insights/insights_daily_plan.md)

This planner guarantees that each day contains:

- `uk`
- `ru`
- `en`
- `es`

Current behavior:

- the core media source of the day is expanded into all four languages
- every few days, an additional Q&A text cluster is added
- Q&A selection prefers groups that have all of `ru`, `en`, and `es`
- Q&A questions are tracked in state and are not repeated until the pool is exhausted

State file:

- `build/insights/insights_schedule_state.json`

## Current Automation Boundaries

### Already automated

- YouTube catalog export
- Q&A catalog export
- VerseOfTheDay inventory export
- weighted queue generation
- multilingual daily planning
- language normalization for saved `insights` posts
- text-post support in `insights`
- source mixing across shorts, images, and videos
- language-aware planning
- content-language verification step: before publishing, confirm that the media audio/title/channel language matches the target locale (do **not** reuse one clip across multiple locales unless it has true multilingual audio or separate dubbed versions).
- duplicate guard: the Cloud Function now rejects publishing a youtubeId that already exists for the same language; keep ids stable (`codex_<lang>_<type>_<ytid>`) to avoid collisions and make updates explicit.

### Partially automated

- language detection from title-only heuristics
- NotebookLM ingestion of source material
- draft generation from queue items

### Not yet automated

- OCR for VerseOfTheDay images
- transcript-based language detection for YouTube
- automatic draft creation in Firestore
- publish scheduling with cooldown history
- tracking `used_count`, `last_used_at`, and `published_at` in a dedicated queue store beyond the current Q&A state file

## Operational Commands

Rebuild YouTube source catalog:

```bash
python3 scripts/export_youtube_source_catalog.py
```

Rebuild Verse image inventory:

```bash
python3 scripts/export_verse_of_day_inventory.py
python3 scripts/build_verse_of_day_notebook_source.py
```

Rebuild the queue:

```bash
python3 scripts/build_insights_content_queue.py
```

Rebuild Q&A source catalog:

```bash
python3 scripts/export_qanda_source_catalog.py
```

Rebuild the multilingual daily plan:

```bash
python3 scripts/build_insights_daily_plan.py
```

Rebuild the full daily-plan input chain in one command:

```bash
python3 scripts/refresh_insights_daily_plan.py --days 1 --start-date "$(date +%F)"
```

Validate language-related Dart code:

```bash
dart analyze \
  lib/domain/helpers/insights_language.dart \
  lib/ui/screens/insights/widgets/insight_editor_screen.dart \
  lib/data/repository_impl/insights_repository_impl.dart
```

## Publishing Rules

The automation should follow these rules:

- do not save `insights.language` as `ua`; use `uk`
- include `es` in the daily publishing plan
- do not auto-publish image content unless the image language is known
- do not let one source origin dominate the queue
- prefer shorts, but do not eliminate images or videos
- periodically add text-based Q&A posts
- use NotebookLM for content synthesis, not for scheduling
- store the final post language, not only the source language
- prefer trilingual `Q&A` groups for text post clusters
- regenerate `build/insights/*.json` inside automations before publishing; clean Codex worktrees do not contain these generated files
- prefer the one-shot bootstrap script `scripts/refresh_insights_daily_plan.py` for automation runs

## Best Next Steps

The next strongest improvements are:

1. Add OCR for VerseOfTheDay images.
2. Add transcript extraction for YouTube items.
3. Save a real queue state store with:
   - `used_count`
   - `last_used_at`
   - `last_published_at`
   - `draft_status`
4. Generate Firestore-ready multilingual drafts directly from the daily plan.
5. Add a weekly batch job that prepares the next set of drafts automatically.

## Summary

The current automation model is:

- sources are collected locally
- a deterministic queue chooses what source cluster should come next
- a daily planner expands that into `uk / ru / en / es`
- periodic Q&A text clusters are injected from Firestore
- NotebookLM transforms shortlisted sources into content
- the admin panel stores the final post with a canonical language code

This gives us a controllable system instead of a fragile fully-random AI content loop.
