part of 'songs_bloc.dart';

@freezed
class SongsEvent with _$SongsEvent {
  const factory SongsEvent.get({String? query}) = SongsGet;
  const factory SongsEvent.edit(
      {required SongDetail song,
      required String textVersion,
      required String title,
      required String description,
      required String link,
      required String text}) = SongsEdit;

  const factory SongsEvent.add(SongDetail song) = SongsAdd;
  const factory SongsEvent.update(
      {required SongDetail song,
      required String lang,
      required String title,
      String? description,
      String? link,
      required String text}) = SongsUpdate;
}
