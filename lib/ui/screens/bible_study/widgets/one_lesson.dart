import 'package:flutter/widgets.dart';
import 'package:flutter_html/flutter_html.dart' as html;
import 'package:icoc_admin_pannel/domain/model/bible_study.dart';

class OneLesson extends StatelessWidget {
  final Lesson lesson;
  const OneLesson({super.key, required this.lesson});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: html.Html(
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
    );
  }
}
