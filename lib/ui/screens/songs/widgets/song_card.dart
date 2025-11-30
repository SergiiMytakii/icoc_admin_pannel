import 'package:flutter/material.dart';
import 'package:icoc_admin_pannel/constants.dart';
import 'package:icoc_admin_pannel/domain/helpers/extract_text_from_html.dart';
import 'package:icoc_admin_pannel/domain/model/songs/song_model.dart';

class SongCard extends StatelessWidget {
  final SongModel song;
  final int currentSongId;

  SongCard({
    super.key,
    required this.song,
    required this.currentSongId,
  });

  @override
  Widget build(BuildContext context) {
    String text = song.songVersions.first.text;
    final isSelected = currentSongId == song.id;
    //если получаем html, то удаляем все теги
    if (text.startsWith('<')) {
      text = FormatTextHelper.extractFormattedText(text);
    }

    return Column(
      children: [
        ListTile(
          selectedColor: Theme.of(context).primaryColor,
          selected: isSelected,
          horizontalTitleGap: 12,
          leading: Text(song.id.toString(),
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                  color: isSelected ? Theme.of(context).primaryColor : null)),
          title: Text(
            song.songVersions.first.title,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                fontWeight: FontWeight.w500,
                color: isSelected ? Theme.of(context).primaryColor : null),
          ),
          subtitle: Text(
            text,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: isSelected ? Theme.of(context).primaryColor : null),
          ),
          trailing: song.hasVideos()
              ? const Icon(
                  Icons.play_circle,
                  color: ScreenColors.songBook,
                )
              : Container(
                  height: 1,
                  width: 1,
                ),
        ),
        const Divider(
          indent: 50,
          thickness: 1.2,
        ),
      ],
    );
  }
}
