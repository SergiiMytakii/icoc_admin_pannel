String getPlaylistId(String input) {
  final trimmed = input.trim();
  if (trimmed.isEmpty) {
    return '';
  }

  final uri = Uri.tryParse(trimmed);
  if (uri == null) {
    return trimmed;
  }

  final playlistId = uri.queryParameters['list'];
  if (playlistId != null && playlistId.isNotEmpty) {
    return playlistId;
  }

  return trimmed;
}
