import 'package:firebase_cloud_firestore/firebase_cloud_firestore.dart';
import 'package:icoc_admin_pannel/constants.dart';
import 'package:icoc_admin_pannel/domain/data_sources/firebase_data_source.dart';
import 'package:icoc_admin_pannel/domain/model/songs/song_model.dart';
import 'package:icoc_admin_pannel/domain/model/user.dart';
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
  Future<List<SongModel>> getSongs() async {
    final QuerySnapshot snapshot = await firebaseDataSource.getFromFirebase(
      FirebaseCollections.SongsV2.name,
    );
    final List<SongModel> songs = snapshot.docs.map(
      (doc) {
        return SongModel.fromJson(doc.data() as Map<String, dynamic>);
      },
    ).toList();
    return songs;
  }

  @override
  Future<List<SongModel>> addSong(IcocUser? user, SongModel song) async {
    final QuerySnapshot snapshot = await firebaseDataSource.postToFirebase(
        user, FirebaseCollections.SongsV2.name, song.toJson());
    final List<SongModel> songs = snapshot.docs.map(
      (doc) {
        return SongModel.fromJson(doc.data() as Map<String, dynamic>);
      },
    ).toList();
    return songs;
  }

  @override
  Future<List<SongModel>> updateSong(IcocUser? user, SongModel song) async {
    final QuerySnapshot snapshot = await firebaseDataSource.updateToFirebase(
        user,
        FirebaseCollections.SongsV2.name,
        song.id.toString(),
        song.toJson());
    final List<SongModel> songs = snapshot.docs.map(
      (doc) {
        return SongModel.fromJson(doc.data() as Map<String, dynamic>);
      },
    ).toList();
    return songs;
  }

  @override
  Future<List<SongModel>> delete(IcocUser? user, String songId) async {
    final QuerySnapshot snapshot = await firebaseDataSource.deleteToFirebase(
        user, FirebaseCollections.SongsV2.name, songId);
    final List<SongModel> songs = snapshot.docs.map(
      (doc) {
        return SongModel.fromJson(doc.data() as Map<String, dynamic>);
      },
    ).toList();
    return songs;
  }
}
