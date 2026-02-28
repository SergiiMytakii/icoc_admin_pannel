import 'dart:convert';

import 'package:firebase_cloud_firestore/firebase_cloud_firestore.dart';
import 'package:icoc_admin_pannel/constants.dart';
import 'package:icoc_admin_pannel/domain/data_sources/firebase_data_source.dart';
import 'package:icoc_admin_pannel/domain/helpers/error_logger.dart';
import 'package:icoc_admin_pannel/domain/model/playlist.dart';
import 'package:icoc_admin_pannel/domain/model/user.dart';
import 'package:icoc_admin_pannel/domain/model/youtube_video/youtube_video.dart';
import 'package:icoc_admin_pannel/domain/repository/video_repository.dart';
import 'package:injectable/injectable.dart';
import 'package:icoc_admin_pannel/domain/data_sources/http_client.dart';

@dev
@prod
@Injectable(as: VideoRepository)
class VideoRepositoryImpl extends VideoRepository {
  final FirebaseDataSource firebaseDataSource;
  final HttpClient httpClient;
  VideoRepositoryImpl(this.firebaseDataSource, this.httpClient);

  static const String _videoCollectionName = 'Video';
  static const String _rssToJsonBase =
      'https://api.rss2json.com/v1/api.json?rss_url=';

  @override
  Future<List<Playlist>> getVideoList() async {
    final snapshot = await firebaseDataSource.getFromFirebase(
      _videoCollectionName,
    );
    return _listFromSnapshot(snapshot);
  }

  @override
  Future<List<YoutubeVideo>?> fetchVideosFromPlaylist(String playlistId) async {
    try {
      final feedUrl =
          'https://www.youtube.com/feeds/videos.xml?playlist_id=$playlistId';
      final url = Uri.parse('$_rssToJsonBase${Uri.encodeComponent(feedUrl)}');
      final response = await httpClient.get(url);

      if (response.statusCode == 200) {
        final videos = _parsePlaylistFeed(
          jsonDecode(response.body) as Map<String, dynamic>,
          playlistId,
        );
        if (videos.isNotEmpty) {
          return videos;
        }
      }

      logError(
        'YouTube playlist scraping failed: ${response.statusCode}',
        null,
      );
      return [];
    } on Exception catch (e, stackTrace) {
      logError(e, stackTrace);
    }
    return null;
  }

  @override
  Future<YoutubeVideo?> fetchVideoDetails(String videoId) async {
    try {
      final videoUrl = Uri.encodeComponent(
        'https://www.youtube.com/watch?v=$videoId',
      );
      final url = Uri.parse(
        'https://noembed.com/embed?url=$videoUrl',
      );
      final response = await httpClient.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        return YoutubeVideo(
          title: data['title'] as String?,
          lang: Languages.defaultLang.name,
          link: videoId,
          thumbnail: data['thumbnail_url'] as String?,
          artist: data['author_name'] as String?,
        );
      } else {
        logError('Video details request failed: ${response.statusCode}', null);
        return null;
      }
    } on Exception catch (e, stackTrace) {
      logError(e, stackTrace);
    }
    return null;
  }

  @override
  Future<List<Playlist>> addPlayList(IcocUser? user, Playlist playlist) async {
    final snapshot = await firebaseDataSource.postToFirebase(
      user,
      _videoCollectionName,
      playlist.toJson(),
    );
    return _listFromSnapshot(snapshot);
  }

  @override
  Future<List<Playlist>> editPlayList(
    IcocUser? user,
    Playlist playlist,
  ) async {
    final docReference = await _resolveDocumentReference(playlist.id);
    final snapshot = await firebaseDataSource.updateToFirebase(
      user,
      _videoCollectionName,
      docReference,
      playlist.toJson(),
    );
    return _listFromSnapshot(snapshot);
  }

  @override
  Future<List<Playlist>> deletePlayList(IcocUser? user, int playlistId) async {
    final docReference = await _resolveDocumentReference(playlistId);
    final snapshot = await firebaseDataSource.deleteToFirebase(
      user,
      _videoCollectionName,
      docReference,
    );
    return _listFromSnapshot(snapshot);
  }

  Future<String> _resolveDocumentReference(int playlistId) async {
    final collection =
        FirebaseFirestore.instance.collection(_videoCollectionName);
    final targetId = playlistId.toString();

    final byField =
        await collection.where('id', isEqualTo: playlistId).limit(1).get();
    if (byField.docs.isNotEmpty) {
      return byField.docs.first.id;
    }

    final directDoc = await collection.doc(targetId).get();
    if (directDoc.exists) {
      return directDoc.id;
    }

    throw FirebaseException(
      plugin: 'cloud_firestore',
      code: 'not-found',
      message:
          'No document found in $_videoCollectionName for playlist id $playlistId',
    );
  }

  List<YoutubeVideo> _parsePlaylistFeed(
    Map<String, dynamic> json,
    String playlistId,
  ) {
    final videos = <YoutubeVideo>[];
    final items = json['items'] as List<dynamic>? ?? const [];

    for (final item in items) {
      final data = item as Map<String, dynamic>;
      final videoUrl = data['link'] as String? ?? '';
      final videoId = Uri.tryParse(videoUrl)?.queryParameters['v'];
      if (videoId == null || videoId.isEmpty) {
        continue;
      }

      videos.add(
        YoutubeVideo(
          lang: Languages.defaultLang.name,
          title: data['title'] as String?,
          link: videoId,
          thumbnail: data['thumbnail'] as String? ??
              'https://i.ytimg.com/vi/$videoId/hqdefault.jpg',
          artist: data['author'] as String?,
          publishedAt: data['pubDate'] as String?,
          playlistId: playlistId,
        ),
      );
    }

    return videos;
  }
}

List<Playlist> _listFromSnapshot(QuerySnapshot snapshot) {
  final List<Playlist> playlists = snapshot.docs.map((doc) {
    return Playlist.fromJson(doc.data() as Map<String, dynamic>);
  }).toList();
  playlists.sort((a, b) => a.id.compareTo(b.id));
  return playlists;
}
