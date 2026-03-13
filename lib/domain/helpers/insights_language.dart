import 'package:icoc_admin_pannel/constants.dart';

const Set<String> _preferredInsightsLanguages = <String>{
  'uk',
  'ru',
  'en',
  'es',
};

const Map<String, String> _insightsLanguageAliases = <String, String>{
  'ua': 'uk',
  'ukr': 'uk',
  'ukrainian': 'uk',
  'українська': 'uk',
  'украинский': 'uk',
  'укр': 'uk',
  'eng': 'en',
  'english': 'en',
  'английский': 'en',
  'англійська': 'en',
  'spa': 'es',
  'spanish': 'es',
  'español': 'es',
  'испанский': 'es',
  'іспанська': 'es',
  'rus': 'ru',
  'russian': 'ru',
  'русский': 'ru',
  'російська': 'ru',
};

String? tryCanonicalizeInsightLanguage(String raw) {
  final String normalized = raw.trim().toLowerCase();
  if (normalized.isEmpty) {
    return null;
  }

  final String canonical = _insightsLanguageAliases[normalized] ?? normalized;
  if (!languagesCodes.containsKey(canonical)) {
    return null;
  }
  return canonical;
}

String requireSupportedInsightLanguage(String raw) {
  final String? canonical = tryCanonicalizeInsightLanguage(raw);
  if (canonical != null) {
    return canonical;
  }

  final String allowed = supportedInsightLanguageCodes.join(', ').toUpperCase();
  throw FormatException(
    'Unsupported insight language "$raw". Use one of: $allowed.',
  );
}

bool isPreferredInsightLanguage(String raw) {
  final String? canonical = tryCanonicalizeInsightLanguage(raw);
  return canonical != null && _preferredInsightsLanguages.contains(canonical);
}

List<String> get supportedInsightLanguageCodes =>
    languagesCodes.keys.toList(growable: false)..sort();
