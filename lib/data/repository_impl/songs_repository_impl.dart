import 'package:firebase_cloud_firestore/firebase_cloud_firestore.dart';
import 'package:icoc_admin_pannel/constants.dart';
import 'package:icoc_admin_pannel/domain/data_sources/firebase_data_source.dart';
import 'package:icoc_admin_pannel/domain/helpers/error_logger.dart';
import 'package:icoc_admin_pannel/domain/model/resources.dart';
import 'package:icoc_admin_pannel/domain/model/song_detail.dart';
import 'package:icoc_admin_pannel/domain/repository/songs_repository.dart';
import 'package:injectable/injectable.dart';

@dev
@prod
@Injectable(as: SongsRepository)
class SongsRepositoryImpl implements SongsRepository {
  final FirebaseDataSource firebaseDataSource;

  SongsRepositoryImpl({
    required this.firebaseDataSource,
  });
  @override
  Future<List<SongDetail>> getSongs() async {
    final QuerySnapshot snapshot = await firebaseDataSource.getFromFirebase(
      FirebaseCollections.Songs.name,
    );
    final List<SongDetail> songList = _songListFromSnapshot(snapshot);
    return songList;
  }

  @override
  Future<List<SongDetail>> addSong(Map<String, dynamic> data) async {
    final QuerySnapshot snapshot = await firebaseDataSource.postToFirebase(
        FirebaseCollections.Songs.name, data);
    final List<SongDetail> songList = _songListFromSnapshot(snapshot);
    return songList;
  }

  @override
  Future<List<SongDetail>> updateSong(
      int songId, Map<String, dynamic> data) async {
    final QuerySnapshot snapshot = await firebaseDataSource.updateToFirebase(
        FirebaseCollections.Songs.name, songId, data);
    final List<SongDetail> songList = _songListFromSnapshot(snapshot);
    return songList;
  }

  @override
  Future<List<SongDetail>> getSearchResult(
      String query, List<String> orderLang) async {
    return [];
  }

//converting  snapshot to song list
  List<SongDetail> _songListFromSnapshot(QuerySnapshot snapshot) {
    final List<SongDetail> songs = snapshot.docs.map(
      (doc) {
        Map data = doc.data() as Map;
        final song = SongDetail.fromJson(data, int.parse(doc.id));
        return song;
      },
    ).toList();
    songs.removeWhere((song) => song.text.isEmpty);
    songs.removeWhere((song) => song.title.isEmpty);
    return songs;
  }
}
