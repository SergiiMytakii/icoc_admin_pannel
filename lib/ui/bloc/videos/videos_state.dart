part of 'videos_bloc.dart';

@freezed
class VideosState with _$VideosState {
  const factory VideosState.initial() = _VideosInitialState;
  const factory VideosState.loading() = _VideosLoadingState;
  const factory VideosState.error(String errorMessage) = _VideosErrorState;
  const factory VideosState.success(List<Playlist> playlists) =
      _VideosSuccessState;
  const factory VideosState.playlistVideos(List<Resources>? resources) =
      _VideosPlaylistVideosState;
  const factory VideosState.videoDetails(Resources? videoDetails) =
      _VideosDetailsState;
}
