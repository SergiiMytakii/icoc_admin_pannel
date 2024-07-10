import 'package:icoc_admin_pannel/domain/model/song_detail.dart';

abstract class SongsRepository {
  Future<List<SongDetail>> getSongs();

  Future<List<SongDetail>> getSearchResult(
      String query, List<String> orderLang);
}
