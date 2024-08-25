import 'package:flutter/services.dart';
import 'package:html/parser.dart';
import 'package:icoc_admin_pannel/constants.dart';
import 'package:icoc_admin_pannel/domain/data_sources/firebase_data_source.dart';
import 'package:icoc_admin_pannel/domain/model/q&a/q&a_model.dart';
import 'package:icoc_admin_pannel/domain/model/user.dart';

Future insertEngQandA(FirebaseDataSource firebaseDataSource) async {
  final String htmlContent =
      await rootBundle.loadString('assets/db/q_and_a.html');
  final List<QandAModel> engQandA = parseHtmlToQandAModel(htmlContent);

  // Insert the parsed data into the database
  for (final qa in engQandA) {
    await firebaseDataSource.postToFirebase(
        IcocUser.defaultUser(), 'QandAEng', qa.toJson());
  }
}

List<QandAModel> parseHtmlToQandAModel(String htmlContent) {
  final document = parse(htmlContent);
  final postDivs = document.querySelectorAll('.post-single');

  return postDivs.map((div) {
    final titleElement = div.querySelector('.post-title a');
    final dateElement = div.querySelector('.posted');
    // final excerptElement = div.querySelector('.post-excerpt p');
    final categoriesElement = div.querySelector('.post-meta p');

    final titleText = titleElement?.text ?? '';
    String title = titleText.contains('A')
        ? titleText.substring(titleText.indexOf('A') + 1).trim()
        : titleText.trim();

    print('title: $title');
    final idMatch = RegExp(r'(\d+)').firstMatch(title);

    final id = idMatch != null ? idMatch.group(1)! : '';
    print(id);

    title = title.contains('—')
        ? title.substring(title.indexOf('—') + 1).trim()
        : title.trim();
    title = title.contains('–')
        ? title.substring(title.indexOf('–') + 1).trim()
        : title.trim();
    print('final title: $title');
    final date = dateElement?.text.replaceAll('Posted:', '').trim() ?? '';
    final categories = categoriesElement?.text ?? '';
    final tagsMatch =
        RegExp(r'Tags:\s*([\s\S]+)', multiLine: true).firstMatch(categories);
    final tags = tagsMatch
        ?.group(1)!
        .split(RegExp(r'[,|]')) // Split by both commas and pipe characters.
        .map((tag) => tag.trim()) // Trim each tag.
        .where((tag) => tag.isNotEmpty) // Remove empty tags.
        .toList();

    return QandAModel(
        id: id.isNotEmpty ? int.parse(id) : 0,
        title: title,
        documentRef: '',
        question: '',
        answer: '',
        date: date,
        lang: Languages.en,
        author: 'Douglas Jacoby', // Assuming all posts are by Douglas Jacoby
        link: titleElement?.attributes['href'],
        source: 'https://www.douglasjacoby.com',
        tags: tags);
  }).toList();
}

String? parseAuthor(String text) {
  final authorMatch = RegExp(r'Автор:\s*(.+?)(?=\n|$)').firstMatch(text);
  return authorMatch?.group(1)?.trim();
}

String? parseTranslator(String text) {
  final translatorMatch = RegExp(r'Перевод:\s*(.+?)(?=\n|$)').firstMatch(text);
  return translatorMatch?.group(1)?.trim();
}

String? parseSource(String text) {
  final sourceMatch = RegExp(r'Источник:\s*(.+?)(?=\n|$)').firstMatch(text);
  return sourceMatch?.group(1)?.trim();
}
