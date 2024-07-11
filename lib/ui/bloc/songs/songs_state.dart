part of 'songs_bloc.dart';

@freezed
class SongsState with _$SongsState {
  const factory SongsState.initial() = _InitialState;
  const factory SongsState.loading() = _SongsLoadingState;
  const factory SongsState.error(String errorMessage) = _SongsErrorState;
  const factory SongsState.success(List<SongDetail> songs) =
      _GetSongsSuccessState;
}
