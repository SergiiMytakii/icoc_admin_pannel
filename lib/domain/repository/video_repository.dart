import 'package:icoc_admin_pannel/domain/model/playlist.dart';
import 'package:icoc_admin_pannel/domain/model/resources.dart';

abstract class VideoRepository {
  Future<List<Playlist>> getVideoList();
  Future<List<Resources>?> fetchVideosFromPlaylist(String playlistId);
  Future<Resources?> fetchVideoDetails(String videoId);
}
