import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart' as html;
import 'package:go_router/go_router.dart';
import 'package:icoc_admin_pannel/domain/model/song_detail.dart';
import 'package:icoc_admin_pannel/ui/widget/my_text_button.dart';

import 'package:logger/logger.dart';

class SongTextOnSongScreen extends StatelessWidget {
  SongTextOnSongScreen({
    super.key,
    required this.title,
    required this.text,
    required this.textVersion,
    required this.description,
    required this.song,
    this.resources,
  });

  final String text;
  final String textVersion;
  final String description;
  final String title;
  final SongDetail song;
  final Map? resources;
  final log = Logger();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        child: Stack(
          children: [
            SelectionArea(
              child: Column(
                children: [
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineMedium!,
                  ),
                  Container(
                    alignment: Alignment.topRight,
                    margin: const EdgeInsets.symmetric(vertical: 7),
                    child: Text(
                      description,
                      style: Theme.of(context).textTheme.headlineSmall!,
                    ),
                  ),
                  const SizedBox(height: 10),
                  text.startsWith('<')
                      ? html.Html(
                          data: text,
                          style: {
                            'body': html.Style(
                                alignment: Alignment.center,
                                fontSize: html.FontSize(14)),
                          },
                        )
                      : Text(
                          text,
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(fontSize: 14),
                        ),
                  const SizedBox(
                    height: 300,
                  )
                ],
              ),
            ),
            Positioned(
                top: 0,
                right: 0,
                child: MyTextButton(
                  label: 'Edit',
                  onPressed: () {
                    context.go('/songs/edit/$textVersion', extra: song);
                  },
                )),
          ],
        ));
  }
}
