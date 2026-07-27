from __future__ import annotations

import sys
import unittest
from collections import Counter
from pathlib import Path
from unittest.mock import patch


SCRIPTS_DIR = Path(__file__).resolve().parents[1] / "scripts"
sys.path.insert(0, str(SCRIPTS_DIR))

import build_insights_content_queue as content_queue  # noqa: E402
import export_google_sheets_youtube_catalog as sheets_catalog  # noqa: E402
import import_youtube_channel_to_google_sheet as channel_import  # noqa: E402


class OdesaLanguagePipelineTest(unittest.TestCase):
    def test_channel_import_uses_canonical_video_title_for_language(self) -> None:
        listing_entry = {
            "id": "P4fllNVl65g",
            "title": "God's Message: Your Personal Recipe for #shorts",
            "url": "https://www.youtube.com/shorts/P4fllNVl65g",
        }

        with (
            patch.object(channel_import, "load_channel_entries", return_value=[listing_entry]),
            patch.object(
                channel_import,
                "fetch_video_metadata",
                create=True,
                return_value={"title": "Божье Послание: Ваш Личный Рецепт #shorts"},
            ),
        ):
            rows = channel_import.build_rows(
                [("odesa_shorts", "short", "https://www.youtube.com/@OdesaChurch/shorts")],
                "/missing/yt-dlp",
            )

        self.assertEqual(rows[0]["source_title"], "Божье Послание: Ваш Личный Рецепт #shorts")
        self.assertEqual(rows[0]["source_language"], "ru")

    def test_existing_odesa_english_row_is_rechecked_against_canonical_title(self) -> None:
        rows = [self._odesa_english_row()]

        with patch.object(
            sheets_catalog,
            "fetch_video_metadata",
            return_value={"title": "Глубина проповедей: больше, чем кажется #shorts"},
        ):
            catalog = sheets_catalog.build_catalog(rows, "test-sheet", {})

        item = catalog["items"][0]
        self.assertEqual(item["source_title"], "Глубина проповедей: больше, чем кажется #shorts")
        self.assertEqual(item["source_language"], "uk")
        self.assertEqual(item["language_confidence"], 0.51)
        self.assertFalse(item["eligible_for_auto_post"])

    def test_low_confidence_canonical_english_title_requires_review(self) -> None:
        with patch.object(
            sheets_catalog,
            "fetch_video_metadata",
            return_value={"title": "Hosanna"},
        ):
            catalog = sheets_catalog.build_catalog(
                [self._odesa_english_row()],
                "test-sheet",
                {},
            )

        item = catalog["items"][0]
        self.assertEqual(item["source_title"], "Hosanna")
        self.assertEqual(item["language_confidence"], 0.75)
        self.assertFalse(item["eligible_for_auto_post"])

    def test_missing_canonical_metadata_requires_review(self) -> None:
        with patch.object(sheets_catalog, "fetch_video_metadata", return_value={}):
            catalog = sheets_catalog.build_catalog(
                [self._odesa_english_row()],
                "test-sheet",
                {},
            )

        item = catalog["items"][0]
        self.assertFalse(item["eligible_for_auto_post"])
        self.assertEqual(item["review_reason"], "canonical_metadata_unavailable")

    def test_non_odesa_import_preserves_listing_title(self) -> None:
        listing_entry = {
            "id": "T6LdCZgDD8s",
            "title": "Очікування від Бога",
            "url": "https://www.youtube.com/shorts/T6LdCZgDD8s",
        }

        with (
            patch.object(channel_import, "load_channel_entries", return_value=[listing_entry]),
            patch.object(
                channel_import,
                "fetch_video_metadata",
                side_effect=AssertionError("non-Odesa metadata should not be fetched"),
            ),
        ):
            rows = channel_import.build_rows(
                [("bibleproject_ukrainian", "short", "https://example.com/shorts")],
                "/missing/yt-dlp",
            )

        self.assertEqual(rows[0]["source_title"], "Очікування від Бога")
        self.assertEqual(rows[0]["source_language"], "uk")

    def test_non_odesa_import_preserves_low_confidence_language(self) -> None:
        listing_entry = {
            "id": "abcdefghijk",
            "title": "Hosanna",
            "url": "https://www.youtube.com/shorts/abcdefghijk",
        }

        with (
            patch.object(channel_import, "load_channel_entries", return_value=[listing_entry]),
            patch.object(
                channel_import,
                "fetch_video_metadata",
                side_effect=AssertionError("non-Odesa metadata should not be fetched"),
            ),
        ):
            rows = channel_import.build_rows(
                [("other_shorts", "short", "https://example.com/shorts")],
                "/missing/yt-dlp",
            )

        self.assertEqual(rows[0]["source_language"], "en")

    def test_ineligible_youtube_language_requires_review_in_queue(self) -> None:
        source = content_queue.QueueSource(
            source_id="odesa-43lpvQf0pE4",
            source_type="short",
            source_origin="odesa_shorts",
            source_ref="https://www.youtube.com/shorts/43lpvQf0pE4",
            source_title="Глубина проповедей: больше, чем кажется #shorts",
            freshness_rank=1,
            source_language="uk",
            language_confidence=0.51,
            eligible_for_auto_post=False,
            review_reason="low_language_confidence",
        )

        post_language, language_ready, review_reason = content_queue.choose_post_language(
            source,
            Counter(),
        )

        self.assertEqual(post_language, "uk")
        self.assertFalse(language_ready)
        self.assertEqual(review_reason, "low_language_confidence")

    @staticmethod
    def _odesa_english_row() -> dict[str, str]:
        return {
            "enabled": "true",
            "priority_rank": "1",
            "source_origin": "odesa_shorts",
            "source_type": "short",
            "source_ref": "https://www.youtube.com/shorts/43lpvQf0pE4",
            "source_title": "Sermons are deeper than they seem #shorts",
            "source_language": "en",
            "author_name": "Odesa Church",
            "channel_url": "https://www.youtube.com/@OdesaChurch/shorts",
            "description": "",
            "keywords": "",
            "published": "",
            "published_at": "",
            "published_post_ids": "",
        }


if __name__ == "__main__":
    unittest.main()
