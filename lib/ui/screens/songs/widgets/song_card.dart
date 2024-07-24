import 'package:flutter/material.dart';
import 'package:icoc_admin_pannel/constants.dart';
import 'package:icoc_admin_pannel/domain/helpers/extract_text_from_html.dart';
import 'package:icoc_admin_pannel/domain/model/song_detail.dart';

class SongCard extends StatelessWidget {
  final SongDetail song;

  SongCard({
    super.key,
    required this.song,
  });

  @override
  Widget build(BuildContext context) {
    String text = song.text.entries.first.value;
    //если получаем html, то удаляем все теги
    if (text.startsWith('<')) {
      text = FormatTextHelper.extractFormattedText(text);
    }

    return Column(
      children: [
        ListTile(
          horizontalTitleGap: 12,
          leading: Text(song.id.toString(),
              style: Theme.of(context).textTheme.titleSmall),
          title: Text(
            song.title.entries.first.value,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          subtitle: Text(
            text,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          trailing: song.youtubeVideos != null && song.youtubeVideos!.isNotEmpty
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
