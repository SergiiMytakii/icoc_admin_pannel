class Resources {
  final String lang;
  final String? title;
  final String link;
  final String? thumbnail;
  final String? artist;
  final String? publishedAt;
  final String? description;
  final String? playlistId;

  Resources(
      {required this.lang,
      required this.title,
      required this.link,
      this.thumbnail,
      this.playlistId,
      this.publishedAt,
      this.description,
      this.artist});

  factory Resources.fromJson(Map json) {
    return Resources(
        lang: json['lang'] ?? '',
        title: json['title'],
        playlistId: json['playlistId'],
        link: json['link'] ?? '',
        thumbnail: json['thumbnail'],
        artist: json['artist']);
  }
  static Resources defaultResource() {
    return Resources(lang: '', title: '', link: '', thumbnail: '', artist: '');
  }

  factory Resources.fromJsonYoutobePlaylists(Map json) {
    //log.w(json);
    return Resources(
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
  factory Resources.fromJsonYoutobeLink(Map json) {
    final items = json['items'] as List<dynamic>;
    if (items.isNotEmpty) {
      final videoData = items[0]['snippet'] as Map<String, dynamic>;
      final title = videoData['title'] as String;
      final thumbnailUrl = (videoData['thumbnails']
          as Map<String, dynamic>)['high']['url'] as String;
      final channelTitle = videoData['channelTitle'] as String;

      return Resources(
        title: title,
        lang: '',
        link: '',
        thumbnail: thumbnailUrl,
      );
    } else {
      return Resources.defaultResource();
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'lang': lang,
      'title': title,
      'link': link,
      'thumbnail': thumbnail,
      'artist': artist,
      'publishedAt': publishedAt,
      'description': description,
      'playlistId': playlistId,
    };
  }

  Resources copyWith({
    String? lang,
    String? title,
    String? link,
    String? thumbnail,
    String? artist,
    String? publishedAt,
    String? description,
    String? playlistId,
  }) {
    return Resources(
      lang: lang ?? this.lang,
      title: title ?? this.title,
      link: link ?? this.link,
      thumbnail: thumbnail ?? this.thumbnail,
      artist: artist ?? this.artist,
      publishedAt: publishedAt ?? this.publishedAt,
      description: description ?? this.description,
      playlistId: playlistId ?? this.playlistId,
    );
  }
}
