import 'dart:convert';

import 'package:firebase_cloud_firestore/firebase_cloud_firestore.dart';
import 'package:icoc_admin_pannel/constants.dart';
import 'package:icoc_admin_pannel/domain/data_sources/firebase_data_source.dart';
import 'package:icoc_admin_pannel/domain/helpers/error_logger.dart';
import 'package:icoc_admin_pannel/domain/model/playlist.dart';
import 'package:icoc_admin_pannel/domain/model/resources.dart';
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
  @override
  Future<List<Playlist>> getVideoList() async {
    final QuerySnapshot snapshot = await firebaseDataSource
        .getFromFirebase(FirebaseCollections.Video.name);
    final List<Playlist> playlists = _listFromSnapshot(snapshot);
    return playlists;
  }

  @override
  Future<List<Resources>?> fetchVideosFromPlaylist(String playlistId) async {
    final Map<String, String> headers = {
      'Content-Type': 'application/json',
    };
    final url = Uri.parse(
        'https://www.googleapis.com/youtube/v3/playlistItems?part=snippet&playlistId=$playlistId&key=$YOUTUBE_API_KEY&maxResults=40');
    // Get Playlist Videos
    try {
      final response = await httpClient.get(
        url,
        headers: headers,
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> videosJson = data['items'];

        // Fetch first eight playlists from uploads playlist
        final List<Resources> playlists = [];
        videosJson.forEach(
          (json) => playlists.add(
            Resources.fromJsonYoutobePlaylists(json['snippet']),
          ),
        );
        return playlists;
      } else {
        logError(
            json.decode(response.body)['error']['message'] ??
                'youtube api error',
            null);
        return [];
      }
    } on Exception catch (e, stackTrace) {
      logError(e, stackTrace);
    }
    return null;
  }

  @override
  Future<Resources?> fetchVideoDetails(String videoId) async {
    final Map<String, String> headers = {
      'Content-Type': 'application/json',
    };
    final url = Uri.parse(
        'https://www.googleapis.com/youtube/v3/videos?id=$videoId&key=$YOUTUBE_API_KEY&part=snippet');

    try {
      final response = await httpClient.get(
        url,
        headers: headers,
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        return Resources.fromJsonYoutobeLink(data);
      } else {
        logError(
            json.decode(response.body)['error']['message'] ??
                'youtube api error',
            null);
        return null;
      }
    } on Exception catch (e, stackTrace) {
      logError(e, stackTrace);
    }
    return null;
  }

  @override
  Future<List<Playlist>> addPlayList(Playlist playlist) {
    // TODO: implement addPlayList
    throw UnimplementedError();
  }
}

List<Playlist> _listFromSnapshot(QuerySnapshot snapshot) {
  final List<Playlist> playlists = snapshot.docs.map((doc) {
    return Playlist(
      name: doc.id,
      description: doc.get('description') ?? '',
      lang: doc.get('lang') ?? '',
      playlistId: doc.get('playlistId') ?? '',
    );
  }).toList();
  return playlists;
}
