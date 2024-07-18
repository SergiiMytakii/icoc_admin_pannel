import 'package:icoc_admin_pannel/domain/model/song_detail.dart';
import 'package:icoc_admin_pannel/domain/model/user.dart';

abstract class SongsRepository {
  Future<List<SongDetail>> getSongs();
  Future<List<SongDetail>> updateSong(
      IcocUser? user, int songId, Map<String, dynamic> data);
  Future<List<SongDetail>> addSong(IcocUser? user, Map<String, dynamic> data);
}
