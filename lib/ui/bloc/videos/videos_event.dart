part of 'videos_bloc.dart';

@freezed
class VideosEvent with _$VideosEvent {
  const factory VideosEvent.get() = VideosGet;
  const factory VideosEvent.addPlaylist({
    required IcocUser? user,
    required Playlist playlist,
  }) = VideosAddPlaylist;
  const factory VideosEvent.editPlaylist({
    required IcocUser? user,
    required Playlist playlist,
  }) = VideosEditPlaylist;
  const factory VideosEvent.deletePlaylist({
    required IcocUser? user,
    required int playlistId,
  }) = VideosDeletePlaylist;
  const factory VideosEvent.fetchFromPlaylist(String playlistId) =
      VideosFetchFromPlaylist;
  const factory VideosEvent.fetchDetails(String videoId) = VideosFetchDetails;
}
