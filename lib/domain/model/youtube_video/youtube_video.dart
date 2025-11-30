import 'package:freezed_annotation/freezed_annotation.dart';

part 'youtube_video.freezed.dart';
part 'youtube_video.g.dart';

@freezed
class YoutubeVideo with _$YoutubeVideo {
  const factory YoutubeVideo({
    required String lang,
    required String? title,
    required String link,
    String? thumbnail,
    String? artist,
    String? publishedAt,
    String? description,
    String? playlistId,
  }) = _YoutubeVideo;

  factory YoutubeVideo.fromJson(Map<String, dynamic> json) =>
      _$YoutubeVideoFromJson(json);

  const YoutubeVideo._();

  static YoutubeVideo defaultVideo() {
    return const YoutubeVideo(
        lang: '', title: '', link: '', thumbnail: '', artist: '');
  }

  factory YoutubeVideo.fromJsonYoutubePlaylists(Map json) {
    return YoutubeVideo(
        lang: '',
        title: json['title'],
        link: json['resourceId']['videoId'],
        thumbnail: json['thumbnails'] != null
            ? json['thumbnails']['high'] != null
                ? json['thumbnails']['high']['url']
                : null
            : null,
        publishedAt: json['publishedAt'],
        description: json['description'],
        playlistId: json['playlistId'],
        artist: json['artist']);
  }
  factory YoutubeVideo.fromJsonYoutubeLink(Map json) {
    final items = json['items'] as List<dynamic>;
    if (items.isNotEmpty) {
      final videoData = items[0]['snippet'] as Map<String, dynamic>;
      final title = videoData['title'] as String;
      final thumbnailUrl = (videoData['thumbnails']
          as Map<String, dynamic>)['high']['url'] as String;

      return YoutubeVideo(
        title: title,
        lang: '',
        link: '',
        thumbnail: thumbnailUrl,
      );
    } else {
      return YoutubeVideo.defaultVideo();
    }
  }
}
