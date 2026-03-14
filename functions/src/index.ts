import { initializeApp } from "firebase-admin/app";
import { getAuth } from "firebase-admin/auth";
import {
  FieldValue,
  Firestore,
  getFirestore,
  Timestamp,
} from "firebase-admin/firestore";
import { HttpsError, onRequest } from "firebase-functions/v2/https";

initializeApp();

const db = getFirestore();
const insightsCollection = db.collection("Insights");
const insightsMetaCollection = db.collection("InsightsMeta");

const PREFERRED_LANGUAGES = new Set(["uk", "ru", "en", "es"]);
const LANGUAGE_ALIASES: Record<string, string> = {
  ua: "uk",
  ukr: "uk",
  ukrainian: "uk",
  "українська": "uk",
  "украинский": "uk",
  "укр": "uk",
  eng: "en",
  english: "en",
  "английский": "en",
  "англійська": "en",
  spa: "es",
  spanish: "es",
  "español": "es",
  "испанский": "es",
  "іспанська": "es",
  rus: "ru",
  russian: "ru",
  "русский": "ru",
  "російська": "ru",
};

type InsightType = "image" | "video" | "text";
type InsightStatus = "draft" | "published";

interface InsightAuthorInput {
  name?: unknown;
  avatarUrl?: unknown;
}

interface InsightPostInput {
  id?: unknown;
  type?: unknown;
  language?: unknown;
  title?: unknown;
  content?: unknown;
  mediaUrls?: unknown;
  thumbnailUrl?: unknown;
  youtubeId?: unknown;
  articleUrl?: unknown;
  mediaAspectRatios?: unknown;
  author?: InsightAuthorInput | null;
  createdAt?: unknown;
  status?: unknown;
  allowComments?: unknown;
  likes?: unknown;
  commentsCount?: unknown;
  shares?: unknown;
}

interface UpsertInsightsBatchBody {
  items?: unknown;
}

interface SanitizedInsightPost {
  id: string;
  type: InsightType;
  language: string;
  title: string | null;
  content: string | null;
  mediaUrls: string[];
  thumbnailUrl: string | null;
  youtubeId: string | null;
  articleUrl: string | null;
  mediaAspectRatios: number[];
  author: {
    name: string;
    avatarUrl: string;
  };
  createdAt: Timestamp;
  status: InsightStatus;
  allowComments: boolean;
  likes: number;
  commentsCount: number;
  shares: number;
}

function normalizeText(value: unknown): string | null {
  if (typeof value !== "string") {
    return null;
  }
  const trimmed = value.trim();
  return trimmed.length > 0 ? trimmed : null;
}

function normalizeStringArray(value: unknown): string[] {
  if (!Array.isArray(value)) {
    return [];
  }
  return value
    .map((item) => (typeof item === "string" ? item.trim() : ""))
    .filter((item) => item.length > 0);
}

function normalizeAspectRatios(value: unknown): number[] {
  if (!Array.isArray(value)) {
    return [];
  }
  return value
    .map((item) => (typeof item === "number" ? item : Number(item)))
    .filter((item) => Number.isFinite(item) && item > 0.1 && item < 10);
}

function normalizeBoolean(value: unknown, fallback: boolean): boolean {
  if (typeof value === "boolean") {
    return value;
  }
  return fallback;
}

function normalizeInteger(value: unknown, fallback = 0): number {
  const numeric = typeof value === "number" ? value : Number(value);
  if (!Number.isFinite(numeric)) {
    return fallback;
  }
  return Math.max(0, Math.trunc(numeric));
}

function canonicalizeLanguage(raw: unknown): string {
  if (typeof raw !== "string") {
    throw new HttpsError("invalid-argument", "Insight language is required.");
  }
  const normalized = raw.trim().toLowerCase();
  if (!normalized) {
    throw new HttpsError("invalid-argument", "Insight language is required.");
  }
  const canonical = LANGUAGE_ALIASES[normalized] ?? normalized;
  if (!PREFERRED_LANGUAGES.has(canonical)) {
    throw new HttpsError(
      "invalid-argument",
      `Unsupported insight language "${raw}".`,
    );
  }
  return canonical;
}

function resolveInsightType(raw: unknown): InsightType {
  if (raw === "image" || raw === "video" || raw === "text") {
    return raw;
  }
  throw new HttpsError("invalid-argument", `Unsupported insight type "${raw}".`);
}

function resolveStatus(raw: unknown): InsightStatus {
  if (raw === "draft" || raw === "published") {
    return raw;
  }
  return "published";
}

function extractYoutubeId(value: string | null): string | null {
  if (!value) {
    return null;
  }

  const trimmed = value.trim();
  const rawIdMatch = trimmed.match(/^[A-Za-z0-9_-]{11}$/);
  if (rawIdMatch) {
    return trimmed;
  }

  try {
    const url = new URL(trimmed);
    if (url.hostname.includes("youtu.be")) {
      const candidate = url.pathname.replace(/^\/+/, "").split("/")[0];
      return candidate || null;
    }

    if (url.pathname === "/watch") {
      return url.searchParams.get("v");
    }

    const shortsMatch = url.pathname.match(/\/shorts\/([A-Za-z0-9_-]{11})/);
    if (shortsMatch) {
      return shortsMatch[1];
    }
  } catch {
    return null;
  }

  return null;
}

function parseCreatedAt(value: unknown): Timestamp | null {
  if (typeof value !== "string") {
    return null;
  }
  const date = new Date(value);
  if (Number.isNaN(date.getTime())) {
    return null;
  }
  return Timestamp.fromDate(date);
}

function ensureBearerToken(headerValue: string | undefined): string {
  if (!headerValue) {
    throw new HttpsError("unauthenticated", "Missing Authorization header.");
  }
  const match = headerValue.match(/^Bearer\s+(.+)$/i);
  if (!match) {
    throw new HttpsError("unauthenticated", "Invalid Authorization header.");
  }
  return match[1];
}

function deriveSourceAuthor(articleUrl: string | null): string | null {
  if (!articleUrl) return null;
  const urlLower = articleUrl.toLowerCase();
  if (urlLower.includes("bibleproject")) return "BibleProject";
  if (urlLower.includes("kcoc")) return "KCOC";
  if (urlLower.includes("odesa") || urlLower.includes("odessa")) return "Odesa Church";
  return null;
}

function fallbackAuthor(
  input: InsightAuthorInput | null | undefined,
  email: string | undefined,
  articleUrl: string | null,
) {
  // Prefer provided author, else infer from known source, else brand default.
  const inferred = deriveSourceAuthor(articleUrl);
  const name = normalizeText(input?.name) ?? inferred ?? "ICOC Insights";
  const avatarUrl = normalizeText(input?.avatarUrl) ?? "";
  return { name, avatarUrl };
}

function buildDefaultId(language: string, type: InsightType, index: number): string {
  return `insight_${language}_${type}_${Date.now()}_${index}`;
}

function sanitizedPayloadForFirestore(post: SanitizedInsightPost, now: Timestamp) {
  return {
    id: post.id,
    type: post.type,
    language: post.language,
    title: post.title,
    content: post.content,
    mediaUrls: post.mediaUrls,
    thumbnailUrl: post.thumbnailUrl,
    youtubeId: post.youtubeId,
    articleUrl: post.articleUrl,
    mediaAspectRatios: post.mediaAspectRatios,
    author: post.author,
    createdAt: post.createdAt,
    updatedAt: now,
    status: post.status,
    allowComments: post.allowComments,
    likes: post.likes,
    commentsCount: post.commentsCount,
    shares: post.shares,
  };
}

async function sanitizeInsightPost(
  raw: InsightPostInput,
  index: number,
  firestore: Firestore,
  actorEmail: string | undefined,
): Promise<SanitizedInsightPost> {
  const type = resolveInsightType(raw.type);
  const language = canonicalizeLanguage(raw.language);
  const articleUrl = normalizeText(raw.articleUrl);
  const youtubeIdFromInput = normalizeText(raw.youtubeId);
  const youtubeId = youtubeIdFromInput ?? extractYoutubeId(articleUrl);

  const mediaUrls = normalizeStringArray(raw.mediaUrls);
  const mediaAspectRatios = normalizeAspectRatios(raw.mediaAspectRatios);
  const thumbnailUrl =
    normalizeText(raw.thumbnailUrl) ??
    (youtubeId ? `https://img.youtube.com/vi/${youtubeId}/hqdefault.jpg` : null);

  if (type === "video" && !youtubeId && !articleUrl) {
    throw new HttpsError(
      "invalid-argument",
      "Video insights require youtubeId or articleUrl.",
    );
  }

  if (type === "image" && mediaUrls.length === 0) {
    throw new HttpsError(
      "invalid-argument",
      "Image insights require at least one media URL.",
    );
  }

  const id = normalizeText(raw.id) ?? buildDefaultId(language, type, index);
  const requestedCreatedAt = parseCreatedAt(raw.createdAt);
  const existingDoc = await firestore.collection("Insights").doc(id).get();
  // Block duplicates: if another post with same youtubeId and language already exists, reject.
  if (youtubeId) {
    const dupSnap = await firestore
      .collection("Insights")
      .where("youtubeId", "==", youtubeId)
      .where("language", "==", language)
      .limit(1)
      .get();
    const duplicate = dupSnap.docs.find((doc) => doc.id !== id);
    if (duplicate) {
      throw new HttpsError(
        "already-exists",
        `Video ${youtubeId} is already published for language ${language} (id=${duplicate.id}).`,
      );
    }
  }
  const existingCreatedAt = existingDoc.exists
    ? (existingDoc.get("createdAt") as Timestamp | undefined)
    : undefined;

  return {
    id,
    type,
    language,
    title: normalizeText(raw.title),
    content: normalizeText(raw.content),
    mediaUrls,
    thumbnailUrl,
    youtubeId,
    articleUrl,
    mediaAspectRatios:
      mediaAspectRatios.length > 0
        ? mediaAspectRatios
        : type === "video"
          ? [articleUrl?.includes("/shorts/") === true ? 9 / 16 : 16 / 9]
          : [],
    author: fallbackAuthor(raw.author, actorEmail, articleUrl),
    createdAt: requestedCreatedAt ?? existingCreatedAt ?? Timestamp.now(),
    status: resolveStatus(raw.status),
    allowComments: normalizeBoolean(raw.allowComments, true),
    likes: normalizeInteger(raw.likes),
    commentsCount: normalizeInteger(raw.commentsCount),
    shares: normalizeInteger(raw.shares),
  };
}

export const upsertInsightsBatch = onRequest(
  {
    region: "europe-central2",
    cors: true,
  },
  async (request, response) => {
    try {
      if (request.method !== "POST") {
        response.status(405).json({ error: true, message: "Method not allowed." });
        return;
      }

      const token = ensureBearerToken(request.header("Authorization"));
      const decoded = await getAuth().verifyIdToken(token);
      const actorEmail = typeof decoded.email === "string" ? decoded.email : undefined;

      const body = (request.body ?? {}) as UpsertInsightsBatchBody;
      const rawItems = Array.isArray(body.items) ? body.items : [];
      if (rawItems.length === 0) {
        throw new HttpsError("invalid-argument", "Request must include items[].");
      }
      if (rawItems.length > 50) {
        throw new HttpsError(
          "invalid-argument",
          "Batch size is limited to 50 insight posts.",
        );
      }

      const now = Timestamp.now();
      const sanitizedItems = await Promise.all(
        rawItems.map((item, index) =>
          sanitizeInsightPost(item as InsightPostInput, index, db, actorEmail),
        ),
      );

      const batch = db.batch();
      for (const item of sanitizedItems) {
        batch.set(
          insightsCollection.doc(item.id),
          sanitizedPayloadForFirestore(item, now),
          { merge: true },
        );
      }
      batch.set(
        insightsMetaCollection.doc("languages"),
        {
          availableLanguages: FieldValue.arrayUnion(
            ...Array.from(new Set(sanitizedItems.map((item) => item.language))),
          ),
        },
        { merge: true },
      );
      await batch.commit();

      response.status(200).json({
        ok: true,
        count: sanitizedItems.length,
        items: sanitizedItems.map((item) => ({
          id: item.id,
          language: item.language,
          type: item.type,
          status: item.status,
        })),
      });
    } catch (error) {
      if (error instanceof HttpsError) {
        response.status(error.httpErrorCode.status).json({
          error: true,
          code: error.code,
          message: error.message,
        });
        return;
      }

      console.error("upsertInsightsBatch failed", error);
      response.status(500).json({
        error: true,
        code: "internal",
        message: "Unexpected insights publish error.",
      });
    }
  },
);
