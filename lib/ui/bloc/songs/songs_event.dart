part of 'songs_bloc.dart';

@freezed
class SongsEvent with _$SongsEvent {
  const factory SongsEvent.get({String? query}) = SongsGet;
  const factory SongsEvent.edit({
    required SongModel song,
    required IcocUser? user,
  }) = SongsEdit;

  const factory SongsEvent.add(
      {required IcocUser? user, required SongModel song}) = SongsAdd;
  const factory SongsEvent.delete({
    required IcocUser? user,
    required String songId,
  }) = SongDelete;
}
