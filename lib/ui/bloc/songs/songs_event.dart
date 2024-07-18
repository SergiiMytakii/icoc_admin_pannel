part of 'songs_bloc.dart';

@freezed
class SongsEvent with _$SongsEvent {
  const factory SongsEvent.get({String? query}) = SongsGet;
  const factory SongsEvent.edit(
      {required SongDetail song,
      required String textVersion,
      required String title,
      required IcocUser? user,
      required String description,
      required String link,
      required String text}) = SongsEdit;

  const factory SongsEvent.add(
      {required IcocUser? user, required SongDetail song}) = SongsAdd;
  const factory SongsEvent.update(
      {required IcocUser? user,
      required SongDetail song,
      required String lang,
      required String title,
      String? description,
      String? link,
      required String text}) = SongsUpdate;
}
