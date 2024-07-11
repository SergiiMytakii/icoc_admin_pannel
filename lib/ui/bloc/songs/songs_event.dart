part of 'songs_bloc.dart';

@freezed
class SongsEvent with _$SongsEvent {
  const factory SongsEvent.get() = SongsGet;
  const factory SongsEvent.search() = SongsSearch;
  const factory SongsEvent.add() = SongsAdd;
  const factory SongsEvent.update(
      {required SongDetail song,
      required String lang,
      required String title,
      String? description,
      String? link,
      required String text}) = SongsUpdate;
}
