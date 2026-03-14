# Insights Posting Automation Runbook

This document describes the full `Insights` posting system for the ICOC admin panel.

It is the operational reference for:

- how sources are collected
- how posts are chosen
- how languages are handled
- how authors are assigned
- how duplicate prevention works
- how daily publishing automation works
- what NotebookLM does in the flow
- what is automated today and what still needs manual review

## Purpose

The purpose of this system is to publish a steady stream of `Insights` posts into the app without turning the feed into random AI spam.

The system is designed to:

- publish across `uk`, `ru`, `en`, and `es`
- prefer shorts, but still mix in videos, images, and Q&A text posts
- avoid repetitive runs from the same source
- avoid publishing the wrong language into the wrong locale
- preserve a real source author when possible
- use NotebookLM for synthesis and planning support, not for blind scheduling

## Main Components

### Product storage

Published posts are stored in Firestore collection `Insights`.

Relevant product code:

- post model: [post.dart](/Users/serhiimytakii/Projects/icoc/icoc_admin_pannel/lib/domain/model/insights/post.dart)
- screen/editor: [insight_editor_screen.dart](/Users/serhiimytakii/Projects/icoc/icoc_admin_pannel/lib/ui/screens/insights/widgets/insight_editor_screen.dart)
- repository: [insights_repository_impl.dart](/Users/serhiimytakii/Projects/icoc/icoc_admin_pannel/lib/data/repository_impl/insights_repository_impl.dart)

### Publish API

Publishing is done through Cloud Function:

- implementation: [index.ts](/Users/serhiimytakii/Projects/icoc/icoc_admin_pannel/functions/src/index.ts)
- endpoint: `https://europe-central2-icoc-8f075.cloudfunctions.net/upsertInsightsBatch`

This function is the canonical write path for automated post creation.

### Local build pipeline

Generated planning artifacts are created under:

- [build/insights](/Users/serhiimytakii/Projects/icoc/icoc_admin_pannel/build/insights)

Important note:

- these files are generated, not committed
- any clean Codex worktree may start without them
- automation must regenerate them before publishing

## Content Sources

### YouTube long videos

Current primary long-form stream:

- Odesa Church videos: [@OdesaChurch/videos](https://www.youtube.com/@OdesaChurch/videos)

### YouTube shorts

Current primary short-form stream:

- KCOC shorts: [@KCOC/shorts](https://www.youtube.com/@KCOC/shorts)

Additional NotebookLM overflow notebooks already exist for BibleProject shorts, but the deterministic queue currently builds from the local exported source catalogs.

### Verse of the Day images

Storage source:

- `gs://icoc-8f075.appspot.com/VerseOfTheDay`

Used as the image stream.

### Q&A text posts

Firestore source:

- collection `QandA`

Used for text-based insight posts.

Q&A is grouped by article id and language variants.

### NotebookLM notebooks

NotebookLM is part of the research layer, not the final scheduler.

Current notebook map:

- `74765d5a-4b7c-4dc5-8a10-8c24c886c3c9` — `ICOC Insights Content Engine`
- `b019a235-3477-4ca5-8213-555654a247e5` — `BibleProject Shorts English`
- `31fdfc03-78da-41c5-8a54-64b701512a8e` — `BibleProject Shorts Ukrainian`

NotebookLM is used to:

- summarize source material
- cluster related ideas
- draft post directions
- build weekly or thematic content thinking

NotebookLM is not trusted to decide final post order by itself.

## Core Rules

### Supported insight languages

The supported publishing locales are:

- `uk`
- `ru`
- `en`
- `es`

Language normalization logic lives in:

- [insights_language.dart](/Users/serhiimytakii/Projects/icoc/icoc_admin_pannel/lib/domain/helpers/insights_language.dart)

Rules:

- save `uk`, never `ua`
- `insights.language` must represent the language of the final saved post
- source language and final post language are not automatically the same, but automation should not relabel media into another locale unless there is a real language-specific source

### Language matching rule

For `video` and `image` tasks:

- the target locale must match the real source language
- one video must not be reposted into multiple languages unless there are separate language versions or dubbed tracks
- if source language does not match the target locale, the automation must skip the task rather than force it into another locale

For `Q&A` text tasks:

- each locale version comes from the matching language version in Firestore `QandA`

### Duplicate prevention

The publish API rejects a duplicate video for the same locale when:

- `youtubeId` already exists in `Insights`
- and `language` matches
- and the post id is different

This prevents accidental repeated publishing of the same YouTube asset inside one locale.

### Author rule

Author assignment priority is:

1. explicitly provided `author.name`
2. inferred source author from known URL patterns
3. fallback author `ICOC Insights`

Current built-in source inference includes:

- `bibleproject` -> `BibleProject`
- `kcoc` -> `KCOC`
- `odesa` or `odessa` -> `Odesa Church`

For Q&A text posts, automation should explicitly send the source author instead of relying on fallback.

## End-to-End Pipeline

### Step 1. Export YouTube source catalog

Script:

- [export_youtube_source_catalog.py](/Users/serhiimytakii/Projects/icoc/icoc_admin_pannel/scripts/export_youtube_source_catalog.py)

Output:

- [youtube_source_catalog.json](/Users/serhiimytakii/Projects/icoc/icoc_admin_pannel/build/insights/youtube_source_catalog.json)

What it does:

- reads configured YouTube channel tabs
- extracts candidate entries
- detects likely source language from title heuristics
- marks whether the source is eligible for auto-post
- stores source origin, type, title, ref, language, and freshness position

Important implementation detail:

- it first tries `yt-dlp`
- if `yt-dlp` fails, it can fall back to lightweight page parsing for reliability
- this was added because automation runs in isolated Codex worktrees where heavier tools can fail

### Step 2. Export Q&A catalog

Script:

- [export_qanda_source_catalog.py](/Users/serhiimytakii/Projects/icoc/icoc_admin_pannel/scripts/export_qanda_source_catalog.py)

Output:

- [qanda_source_catalog.json](/Users/serhiimytakii/Projects/icoc/icoc_admin_pannel/build/insights/qanda_source_catalog.json)

What it does:

- loads Firestore `QandA`
- groups entries by logical Q&A article id
- stores available language versions
- marks whether a Q&A group is complete across `ru`, `en`, and `es`

### Step 3. Export VerseOfTheDay inventory

Script:

- [export_verse_of_day_inventory.py](/Users/serhiimytakii/Projects/icoc/icoc_admin_pannel/scripts/export_verse_of_day_inventory.py)

Output:

- [verse_of_day_inventory.json](/Users/serhiimytakii/Projects/icoc/icoc_admin_pannel/build/insights/verse_of_day_inventory.json)

What it does:

- lists VerseOfTheDay assets through Firebase Storage REST API
- records image references
- stores OCR results in `build/insights/verse_of_day_ocr_cache.json`
- detects source language for cached Verse images via macOS Vision OCR
- limits new OCR work per run so the daily automation stays responsive

Operational note:

- browser-based scraping is no longer the primary dependency
- same-day refresh runs reuse the current Verse inventory instead of re-warming OCR immediately
- if a new Verse export fails while an older inventory already exists, refresh keeps the last good inventory instead of clobbering it with an empty fallback

### Step 4. Build content queue

Script:

- [build_insights_content_queue.py](/Users/serhiimytakii/Projects/icoc/icoc_admin_pannel/scripts/build_insights_content_queue.py)

Output:

- [insights_content_queue.json](/Users/serhiimytakii/Projects/icoc/icoc_admin_pannel/build/insights/insights_content_queue.json)

What it does:

- combines YouTube and VerseOfTheDay source pools
- applies weighting and mixing rules
- assigns a likely publishing language target per queue item
- tries to prevent origin clustering

Current type weights:

- `short` -> `0.6`
- `image` -> `0.25`
- `video` -> `0.15`

Current language weights:

- `uk` -> `0.35`
- `ru` -> `0.25`
- `en` -> `0.20`
- `es` -> `0.20`

Current queue constraints:

- recent-origin window: `4`
- max consecutive items from same origin: `2`

These rules exist to avoid feeds like “five straight shorts from the same channel”.

### Step 5. Build daily multilingual plan

Script:

- [build_insights_daily_plan.py](/Users/serhiimytakii/Projects/icoc/icoc_admin_pannel/scripts/build_insights_daily_plan.py)

Output:

- [insights_daily_plan.json](/Users/serhiimytakii/Projects/icoc/icoc_admin_pannel/build/insights/insights_daily_plan.json)
- [insights_daily_plan.md](/Users/serhiimytakii/Projects/icoc/icoc_admin_pannel/build/insights/insights_daily_plan.md)

What it does:

- takes the queue
- expands each day into required locales `uk / ru / en / es`
- injects a Q&A block every few days
- rotates used Q&A article ids with state

Current defaults:

- plan length: `7` days
- Q&A frequency: every `3` days

Planner state:

- [insights_schedule_state.json](/Users/serhiimytakii/Projects/icoc/icoc_admin_pannel/build/insights/insights_schedule_state.json)

### Step 6. Publish into Insights

Publishing should use:

- [insights-publisher skill](/Users/serhiimytakii/Projects/icoc/icoc_admin_pannel/.codex/skills/insights-publisher/SKILL.md)
- [upsertInsightsBatch](/Users/serhiimytakii/Projects/icoc/icoc_admin_pannel/functions/src/index.ts)

The publish payload contains one or more `items`.

Supported item types:

- `video`
- `image`
- `text`

Key item rules:

- `image` requires `mediaUrls`
- `video` requires `youtubeId` or `articleUrl`
- `text` is used for Q&A and similar direct text posts

## How Posts Are Chosen

### Feed-shape rules

The queue should produce a feed that feels intentionally mixed.

Current intended behavior:

- shorts are the dominant stream
- long videos appear less often
- image posts still appear, but only when usable
- Q&A text posts appear periodically instead of every day

### Source mixing rules

The queue tries to prevent overconcentration from one source origin.

Current logic:

- penalize same origin in the recent window
- penalize repeated same type immediately after the last item
- prefer alternation across source types and origins

### Language distribution rules

Daily planning expects coverage for:

- `uk`
- `ru`
- `en`
- `es`

But there is an important distinction:

- the plan can contain target tasks for all four locales
- the publish stage must still verify that each media source truly matches its locale

This means:

- Q&A can reliably fill text locale variants
- videos and images may still require per-locale availability or skipping

### Q&A selection rules

Q&A insertion prefers:

- items not used recently
- complete trilingual groups
- deterministic selection based on date seed

This gives predictable variety without constantly repeating the same question.

## How Posts Are Created

### Video posts

Video posts are created from a language-matching YouTube source.

Expected fields:

- `type=video`
- `language`
- `title`
- `content`
- `articleUrl` or `youtubeId`
- optional explicit `author`

Author behavior:

- if explicit author is sent, use it
- else infer known source author
- else fallback to `ICOC Insights`

### Image posts

Image posts are created from VerseOfTheDay or another image source.

Expected fields:

- `type=image`
- `language`
- `mediaUrls`
- optional `title`
- optional `content`

Current rule:

- auto-publish image content only when OCR identifies a supported language with high confidence
- if image language is unknown, keep the asset in inventory but skip blind cross-locale publishing

### Text posts

Text posts are primarily Q&A-derived.

Expected fields:

- `type=text`
- `language`
- `title`
- `content`
- explicit source author when available

Recommended Q&A post shape:

- brief title
- question block
- shortened answer block
- no giant unedited wall of text unless intentionally desired

## Author Logic

Author should reflect the real source whenever possible.

Examples:

- BibleProject video -> `BibleProject`
- KCOC content -> `KCOC`
- Odesa Church content -> `Odesa Church`
- Q&A by Douglas Jacoby -> `Douglas Jacoby`
- unknown source -> `ICOC Insights`

This is important because the feed should feel sourced and trustworthy, not anonymous.

## Current Automation

### Daily publish automation

External automation file:

- [automation.toml](/Users/serhiimytakii/.codex/automations/daily-insights-publish/automation.toml)

Deterministic publish runner:

- [run_daily_insights_publish.py](/Users/serhiimytakii/Projects/icoc/icoc_admin_pannel/scripts/run_daily_insights_publish.py)

Important behavior:

- runs in `worktree` environment
- therefore cannot rely on generated `build/` files already existing
- now regenerates the planning artifacts first through:
  - [refresh_insights_daily_plan.py](/Users/serhiimytakii/Projects/icoc/icoc_admin_pannel/scripts/refresh_insights_daily_plan.py)

Bootstrap command:

```bash
python3 /Users/serhiimytakii/Projects/icoc/icoc_admin_pannel/scripts/refresh_insights_daily_plan.py --days 1 --start-date "$(date +%F)"
```

### Why automation originally failed

Root cause:

- the automation expected `build/insights/insights_daily_plan.json` to already exist
- but `build/` is generated and not committed
- Codex automation used a clean worktree
- therefore the file was missing and the publish run stopped before doing anything

Fix:

- added [refresh_insights_daily_plan.py](/Users/serhiimytakii/Projects/icoc/icoc_admin_pannel/scripts/refresh_insights_daily_plan.py)
- updated automation prompt to rebuild inputs before publish
- improved YouTube export resilience so automation is less fragile
- added [run_daily_insights_publish.py](/Users/serhiimytakii/Projects/icoc/icoc_admin_pannel/scripts/run_daily_insights_publish.py) so automation calls one deterministic script instead of reconstructing the publish logic from prompt text

## Automation Bootstrap Script

Bootstrap script:

- [refresh_insights_daily_plan.py](/Users/serhiimytakii/Projects/icoc/icoc_admin_pannel/scripts/refresh_insights_daily_plan.py)

What it does:

1. rebuilds YouTube catalog
2. rebuilds Q&A catalog
3. tries to rebuild VerseOfTheDay inventory
4. if Verse scrape fails, writes an empty fallback inventory
5. rebuilds content queue
6. rebuilds daily plan

This makes automation self-healing enough to proceed even if some optional source export fails.

## Current Constraints And Known Gaps

### VerseOfTheDay scraping

Current status:

- can fail in automation depending on browser/tool environment
- the system now falls back to an empty image inventory instead of aborting the run

Impact:

- the automation can still publish videos and Q&A
- image coverage may be temporarily absent in that run

### Language detection

Current YouTube language detection is heuristic.

It is based mostly on title patterns and script markers.

This is acceptable for early filtering, but not perfect.

Safer future improvement:

- transcript-based language detection

### NotebookLM role

NotebookLM is very useful for synthesis, but it is still intentionally outside the deterministic scheduler.

That separation is deliberate.

### Weekly push notification digest

The desired product behavior is:

- do not send push per every new post
- instead send a weekly “new insights available” digest
- only if real insights were published during that week
- open the insights screen via deep link

If this is implemented later, it should be documented as a separate automation layer on top of publish history.

## Operational Commands

Rebuild YouTube source catalog:

```bash
python3 scripts/export_youtube_source_catalog.py
```

Rebuild Q&A catalog:

```bash
python3 scripts/export_qanda_source_catalog.py
```

Rebuild Verse inventory:

```bash
python3 scripts/export_verse_of_day_inventory.py
```

Rebuild queue:

```bash
python3 scripts/build_insights_content_queue.py
```

Rebuild daily plan:

```bash
python3 scripts/build_insights_daily_plan.py
```

Rebuild the whole daily publish input chain:

```bash
python3 scripts/refresh_insights_daily_plan.py --days 1 --start-date "$(date +%F)"
```

Run the full daily publish flow:

```bash
python3 scripts/run_daily_insights_publish.py --date "$(date +%F)"
```

Build and deploy functions after changing publish logic:

```bash
cd functions
npm run build
firebase deploy --only functions:upsertInsightsBatch --project icoc-8f075
```

## What Is Automated Today

Already automated:

- YouTube source export
- Q&A export
- queue generation
- daily plan generation
- safe batch publish API
- duplicate prevention for same video inside same locale
- author fallback logic
- automation bootstrap for clean worktrees

Partially automated:

- VerseOfTheDay inventory export
- language verification for every media item
- content drafting quality
- source-to-author inference beyond known source families

Not fully automated yet:

- robust transcript-based language detection
- reliable OCR for image language
- push digest layer for weekly insights summary
- fully automatic NotebookLM-to-publish drafting loop with quality control

## Practical Guidance

When publishing manually or through automation:

- regenerate the plan first
- trust the plan for structure, not blindly for language correctness
- verify video locale before publishing
- prefer real source authors
- use Q&A to fill locale coverage without faking media localization
- never repost the same YouTube asset into another locale unless it is a real language-specific source

## Related Files

- main architecture doc: [insights-content-automation.md](/Users/serhiimytakii/Projects/icoc/icoc_admin_pannel/docs/insights-content-automation.md)
- bootstrap script: [refresh_insights_daily_plan.py](/Users/serhiimytakii/Projects/icoc/icoc_admin_pannel/scripts/refresh_insights_daily_plan.py)
- queue builder: [build_insights_content_queue.py](/Users/serhiimytakii/Projects/icoc/icoc_admin_pannel/scripts/build_insights_content_queue.py)
- plan builder: [build_insights_daily_plan.py](/Users/serhiimytakii/Projects/icoc/icoc_admin_pannel/scripts/build_insights_daily_plan.py)
- publish function: [index.ts](/Users/serhiimytakii/Projects/icoc/icoc_admin_pannel/functions/src/index.ts)
- publisher skill: [.codex/skills/insights-publisher/SKILL.md](/Users/serhiimytakii/Projects/icoc/icoc_admin_pannel/.codex/skills/insights-publisher/SKILL.md)
