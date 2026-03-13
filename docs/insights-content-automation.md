# Insights Content Automation

This document is the working playbook for the `insights` content pipeline in the ICOC admin panel.

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

### 2. KCOC shorts

Channel:

- [KCOC shorts](https://www.youtube.com/@KCOC/shorts)

This feed is used as the main shorts stream.

### 3. Verse of the Day images

Firebase Storage folder:

- `gs://icoc-8f075.appspot.com/VerseOfTheDay`

This folder is used as the image-post stream.

Inventory export already exists via:

- [export_verse_of_day_inventory.py](/Users/serhiimytakii/Projects/icoc/icoc_admin_pannel/scripts/export_verse_of_day_inventory.py)
- [build_verse_of_day_notebook_source.py](/Users/serhiimytakii/Projects/icoc/icoc_admin_pannel/scripts/build_verse_of_day_notebook_source.py)

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

NotebookLM is used as the research and synthesis layer, not as the scheduler.

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
- `BibleProject Shorts Ukrainian` — pending creation after NotebookLM auth refresh
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

- [export_youtube_source_catalog.py](/Users/serhiimytakii/Projects/icoc/icoc_admin_pannel/scripts/export_youtube_source_catalog.py)

It currently reads:

- `@OdesaChurch/videos`
- `@KCOC/shorts`

It uses `yt-dlp` and writes a structured JSON catalog:

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

### Batch import into NotebookLM notebooks

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
