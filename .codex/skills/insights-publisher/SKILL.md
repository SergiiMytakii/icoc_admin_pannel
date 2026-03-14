name: insights-publisher
description: Safe way to publish or update Insight posts via the Cloud Function upsertInsightsBatch. Use when you need to push one or more posts (image/video/text) to Firestore, including multi-language batches.
---

# Insights Publisher

## API

- Endpoint: `https://europe-central2-icoc-8f075.cloudfunctions.net/upsertInsightsBatch`
- Method: `POST`
- Auth: Firebase ID token in header `Authorization: Bearer <ID_TOKEN>`
- Batch size: up to 50 items

### Item fields
- `id` (string, optional): if missing, API auto-generates; use stable ids when updating.
- `type`: `image` | `video` | `text` (required)
- `language`: `uk|ru|en|es` (aliases: `ua/ukr/ukrainian`, `eng/english`, `spa/spanish/español`, `rus/russian`)
- `title`, `content`: optional strings
- `mediaUrls`: array (required for `image`)
- `youtubeId` or `articleUrl`: required for `video`; shorts URLs allowed
- `thumbnailUrl`: optional; for video auto-falls back to YouTube thumbnail
- `mediaAspectRatios`: optional; for video defaults to `9/16` if shorts URL else `16/9`
- `status`: `draft` or `published` (defaults to `published`)
- `allowComments`: boolean (default true)
- `likes`, `commentsCount`, `shares`: integers (default 0)

### Curl template
```bash
# get ID token from firebase CLI or your app; example with firebase login:ci + auth:print-access-token
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

## Usage Playbook
- Choose target languages up front; one request can include multiple `items` with different `language`.
- Reuse stable ids when re-publishing the same asset in another language: e.g. `codex_ru_video_<ytid>`.
- Keep `mediaAspectRatios` blank unless you need custom ratios; video defaults are set automatically.
- For image posts, populate `mediaUrls` and optionally `mediaAspectRatios`.
- For text/Q&A posts, set `type=text`, `content`, `title`, and optional `articleUrl`.
- Validate the media language before posting. Only push an item to `language=X` if the source audio/title/channel is actually in that language or has a dubbed track. Do **not** reuse one short across several locales without a language-specific version.
- Dedup rule: the API will reject if a youtubeId is already present for the same `language`; use stable ids (`codex_<lang>_<type>_<ytid>`) and pick a new source when you see `already-exists`.
- In automations, regenerate the plan first with `scripts/refresh_insights_daily_plan.py` because `build/insights/*.json` is not committed and may be missing in clean worktrees.

## Safety Checks
- Language is canonicalized and validated.
- Image requires `mediaUrls`.
- Video requires `youtubeId` or `articleUrl`.
- Batch limited to 50 to avoid accidental floods.
