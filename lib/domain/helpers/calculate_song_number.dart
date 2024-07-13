import 'dart:math';

import 'package:icoc_admin_pannel/domain/model/song_detail.dart';

int calculateSongLastNumber(List<SongDetail> songs) {
  final ids = songs.map((song) => song.id).toList();
  final maximum = ids.reduce(max);
  return maximum;
}
