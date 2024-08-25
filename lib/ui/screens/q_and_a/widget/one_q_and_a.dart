import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:icoc_admin_pannel/constants.dart';
import 'package:icoc_admin_pannel/domain/helpers/convert_languages_enum.dart';
import 'package:icoc_admin_pannel/domain/model/q&a/q&a_model.dart';
import 'package:flutter_html/flutter_html.dart' as html;
import 'package:icoc_admin_pannel/injection.dart';
import 'package:icoc_admin_pannel/ui/bloc/auth/auth_bloc.dart';
import 'package:icoc_admin_pannel/ui/bloc/q&a_bloc/q&a_bloc.dart';
import 'package:icoc_admin_pannel/ui/widget/alert_dialog.dart';
import 'package:icoc_admin_pannel/ui/widget/my_text_button.dart';
import 'package:icoc_admin_pannel/ui/widget/select_lang.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class OneQandA extends StatelessWidget {
  final QandAModel article;

  OneQandA({
    super.key,
    required this.article,
  });

  static const fontStyle =
      TextStyle(color: ScreenColors.QandA, fontWeight: FontWeight.bold);

  final TextEditingController langController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: SelectionArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ListView(
            children: [
              Text(
                'Document reference: ${article.documentRef}',
                style: OneQandA.fontStyle,
              ),
              const SizedBox(
                height: 10,
              ),
              if (article.lang == Languages.ru)
                Text(
                  'Original En number: ${article.id - 884}',
                  style: OneQandA.fontStyle,
                ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                'Question:',
                style: OneQandA.fontStyle,
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                article.question,
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                'Answer:',
                style: OneQandA.fontStyle,
              ),
              const SizedBox(
                height: 10,
              ),
              if (article.answer.startsWith('<'))
                html.Html(
                  data: article.answer,
                  onLinkTap: (url, __, ___) {
                    launchUrl(Uri.parse(url ?? ''));
                  },
                  style: {
                    'body': html.Style(fontSize: html.FontSize(14)),
                    'h5': html.Style(fontSize: html.FontSize(14)),
                    'p': html.Style(fontSize: html.FontSize(14)),
                  },
                )
              else
                Text(
                  article.answer,
                ),
              if (article.youtubeLink != null)
                _buildYoutubeLink(
                  article,
                  context,
                ),
              const SizedBox(
                height: 20,
              ),
              if (article.date != null)
                Text(
                  '${'Date:'} ${article.date}',
                  style: OneQandA.fontStyle,
                ),
              if (article.author != null)
                Text(
                  '${'Author:'} ${article.author}',
                  style: OneQandA.fontStyle,
                ),
              if (article.translatedBy != null)
                Text(
                  '${'Translated by:'} ${article.translatedBy}',
                  style: OneQandA.fontStyle,
                ),
              if (article.source != null)
                _buildActiveLink(
                  label: 'Source:',
                  url: article.source!,
                )
            ],
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      toolbarHeight: 45,
      actions: [
        SelectLanguageWidget(
          langController: langController,
          label: 'Translate Eng Q&As to the',
        ),
        MyTextButton(
          label: 'Translate',
          onPressed: () async {
            final result = await showAlertDialog(context,
                'Do you really want to translate all English Q&As to the ${langController.text}? It will take a long time to process 1660 Q&As. ',
                showCancelButton: true);
            if (result) {
              getIt<QandABloc>().add(QandAEvent.translate(
                  user: getIt<AuthBloc>().icocUser,
                  lang: convertLanguagesEnum(langController.text)));
            }
          },
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: MyTextButton(
            label: 'Edit',
            onPressed: () {
              context.go('/q&a/edit');
            },
          ),
        ),
      ],
      elevation: 0,
    );
  }

  GestureDetector _buildYoutubeLink(
    QandAModel article,
    BuildContext context,
  ) {
    return GestureDetector(
        onTap: () {
          final videoId =
              YoutubePlayerController.convertUrlToId(article.youtubeLink!) ??
                  '';
          // context.go('/q&a/$Q_AND_A_VIDEO_PLAYER/$videoId');
        },
        child: Text(
          article.youtubeLink!,
          style: OneQandA.fontStyle.copyWith(
            color: Colors.blue,
            decoration: TextDecoration.underline,
          ),
        ));
  }

  GestureDetector _buildActiveLink({
    required String label,
    required String url,
  }) {
    return GestureDetector(
      onTap: () async {
        final urlString = url.toLowerCase();
        final uri = urlString.startsWith('http')
            ? Uri.parse(urlString)
            : Uri.parse('https://$urlString');

        if (await canLaunchUrl(uri)) {
          launchUrl(
            uri,
          );
        }
      },
      child: Row(
        children: [
          Text(label, style: OneQandA.fontStyle),
          Expanded(
            child: Text(
              url,
              style: OneQandA.fontStyle.copyWith(
                decoration: TextDecoration.underline,
                color: Colors.blue,
              ),
              overflow: TextOverflow.ellipsis,
              softWrap: false,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}
