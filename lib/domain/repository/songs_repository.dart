import 'package:icoc_admin_pannel/domain/model/songs/song_model.dart';
import 'package:icoc_admin_pannel/domain/model/user.dart';

abstract class SongsRepository {
  Future<List<SongModel>> getSongs();
  Future<List<SongModel>> updateSong(IcocUser? user, SongModel song);
  Future<List<SongModel>> addSong(IcocUser? user, SongModel song);
}
