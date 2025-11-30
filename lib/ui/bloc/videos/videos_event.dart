part of 'videos_bloc.dart';

@freezed
class VideosEvent with _$VideosEvent {
  const factory VideosEvent.get() = VideosGet;
  const factory VideosEvent.addPlaylist(Playlist playlist) = VideosAddPlaylist;
  const factory VideosEvent.fetchFromPlaylist(String playlistId) =
      VideosFetchFromPlaylist;
  const factory VideosEvent.fetchDetails(String videoId) = VideosFetchDetails;
}
