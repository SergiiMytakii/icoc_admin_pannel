import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart' as html;

import 'package:logger/logger.dart';

class SongTextOnSongScreen extends StatelessWidget {
  SongTextOnSongScreen({
    super.key,
    required this.title,
    required this.textVersion,
    required this.description,
    this.resources,
  });

  final String textVersion;
  final String description;
  final String title;
  final Map? resources;
  final log = Logger();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        child: SelectionArea(
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
              textVersion.startsWith('<')
                  ? html.Html(
                      data: textVersion,
                      style: {
                        'body': html.Style(
                            alignment: Alignment.center,
                            fontSize: html.FontSize(14)),
                      },
                    )
                  : Text(
                      textVersion,
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
        ));
  }
}
