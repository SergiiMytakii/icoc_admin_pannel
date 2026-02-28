import 'package:icoc_admin_pannel/constants.dart';

enum VideoContentType { playlist, video }

class Playlist {
  final int id;
  final String title;
  final String lang;
  final String description;
  final String? playlistId;
  final String? videoId;
  final VideoContentType contentType;

  Playlist({
    required this.title,
    required this.id,
    required this.lang,
    required this.description,
    this.playlistId,
    this.videoId,
    this.contentType = VideoContentType.playlist,
  });

  bool get isPlaylist => contentType == VideoContentType.playlist;
  bool get isVideo => contentType == VideoContentType.video;

  String get sourceId => isPlaylist ? (playlistId ?? '') : (videoId ?? '');
  String get sourceLabel => isPlaylist ? 'Playlist ID' : 'Video ID';
  String get typeLabel => isPlaylist ? 'Playlist' : 'Video';
  String get appDeepLink => '$ICOC_WEB_PAGE/video/listvideos/$id?lang=$lang';
  String get externalUrl => isPlaylist
      ? 'https://www.youtube.com/playlist?list=$sourceId'
      : 'https://www.youtube.com/watch?v=$sourceId';

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'lang': lang,
      'description': description,
      'playlistId': playlistId,
      'videoId': videoId,
      'contentType': contentType.name,
    };
  }

  factory Playlist.fromJson(Map<String, dynamic> json) {
    final rawType = json['contentType'] as String?;
    final contentType = rawType == VideoContentType.video.name ||
            (rawType == null &&
                json['videoId'] != null &&
                (json['videoId'] as String).isNotEmpty)
        ? VideoContentType.video
        : VideoContentType.playlist;
    return Playlist(
      id: json['id'] as int,
      title: json['title'] as String,
      lang: json['lang'] as String,
      description: json['description'] as String,
      playlistId: json['playlistId'] as String?,
      videoId: json['videoId'] as String?,
      contentType: contentType,
    );
  }

  Playlist copyWith({
    int? id,
    String? title,
    String? lang,
    String? description,
    String? playlistId,
    String? videoId,
    VideoContentType? contentType,
  }) {
    return Playlist(
      id: id ?? this.id,
      title: title ?? this.title,
      lang: lang ?? this.lang,
      description: description ?? this.description,
      playlistId: playlistId ?? this.playlistId,
      videoId: videoId ?? this.videoId,
      contentType: contentType ?? this.contentType,
    );
  }
}
