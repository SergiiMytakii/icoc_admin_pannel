import 'package:icoc_admin_pannel/domain/model/song_detail.dart';

int countTabs(SongDetail song) {
  final tabs =
      song.text.length + (song.chords != null ? song.chords!.length : 0);
  return tabs;
}
