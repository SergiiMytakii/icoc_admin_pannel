import 'package:icoc_admin_pannel/domain/model/playlist.dart';
import 'package:icoc_admin_pannel/domain/model/user.dart';
import 'package:icoc_admin_pannel/domain/model/youtube_video/youtube_video.dart';

abstract class VideoRepository {
  Future<List<Playlist>> getVideoList();
  Future<List<Playlist>> addPlayList(IcocUser? user, Playlist playlist);
  Future<List<Playlist>> editPlayList(IcocUser? user, Playlist playlist);
  Future<List<Playlist>> deletePlayList(IcocUser? user, int playlistId);
  Future<List<YoutubeVideo>?> fetchVideosFromPlaylist(String playlistId);
  Future<YoutubeVideo?> fetchVideoDetails(String videoId);
}
