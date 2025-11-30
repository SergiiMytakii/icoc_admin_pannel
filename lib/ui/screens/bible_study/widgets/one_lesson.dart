import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart' as html;
import 'package:icoc_admin_pannel/domain/model/bible_study/bible_study.dart';

class OneLesson extends StatelessWidget {
  final Lesson lesson;
  const OneLesson({super.key, required this.lesson});

  @override
  Widget build(BuildContext context) {
    return ListView(children: [
      Text(
        lesson.title,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.titleMedium,
      ),
      const SizedBox(
        width: 20,
      ),
      html.Html(
        data: lesson.text,
        style: {
          'body': html.Style(
            fontSize: html.FontSize(14),
          ),
          'h5': html.Style(
            fontSize: html.FontSize(14),
          ),
          'p': html.Style(
            fontSize: html.FontSize(14),
          ),
        },
      ),
    ]);
  }
}
