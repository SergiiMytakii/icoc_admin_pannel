import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:icoc_admin_pannel/constants.dart';
import 'package:icoc_admin_pannel/domain/helpers/convert_languages_enum.dart';
import 'package:icoc_admin_pannel/domain/helpers/notification_tranlator.dart';
import 'package:icoc_admin_pannel/domain/model/notifications/notifications_model.dart';
import 'package:icoc_admin_pannel/domain/model/songs/song_model.dart';
import 'package:icoc_admin_pannel/domain/model/youtube_video/youtube_video.dart';
import 'package:icoc_admin_pannel/injection.dart';
import 'package:icoc_admin_pannel/ui/bloc/auth/auth_bloc.dart';
import 'package:icoc_admin_pannel/ui/bloc/notifications/notifications_bloc.dart';
import 'package:icoc_admin_pannel/ui/bloc/songs/songs_bloc.dart';
import 'package:icoc_admin_pannel/ui/widget/alert_dialog.dart';
import 'package:icoc_admin_pannel/ui/widget/my_text_button.dart';
import 'package:icoc_admin_pannel/ui/widget/my_text_field.dart';
import 'package:icoc_admin_pannel/ui/widget/select_lang.dart';
import 'package:icoc_admin_pannel/ui/widget/send_notification_checkbox.dart';

class AddVersionTab extends StatefulWidget {
  final SongModel song;
  const AddVersionTab(
    this.song, {
    super.key,
  });

  @override
  State<AddVersionTab> createState() => _AddVersionTabState();
}

class _AddVersionTabState extends State<AddVersionTab> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController langController = TextEditingController()..text = 'ru';
  TextEditingController textController = TextEditingController();
  TextEditingController urlController = TextEditingController();
  bool sendNotifications = false;
  bool isChords = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Stack(
        children: [
          Form(
            key: _formKey,
            child: ListView(
              children: [
                const Text(
                  'Add a new song version',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    children: [
                      SelectLanguageWidget(
                        langController: langController,
                        label: 'Languages',
                      ),
                      const Spacer(),
                      SizedBox(
                        width: 150,
                        child: CheckboxListTile(
                            controlAffinity: ListTileControlAffinity.leading,
                            title: const Text('Chords'),
                            value: isChords,
                            onChanged: (val) => setState(() {
                                  isChords = !isChords;
                                })),
                      ),
                      const Spacer(),
                      SendNotificationCheckBox(
                        onChanged: (value) => sendNotifications = value,
                      ),
                    ],
                  ),
                ),
                MyTextField(
                  controller: titleController,
                  hint: 'Title',
                  maxLength: 50,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a title';
                    }
                    return null;
                  },
                ),
                MyTextField(
                  controller: descriptionController,
                  hint: 'Desctiption',
                  maxLength: 50,
                ),
                MyTextField(
                  controller: textController,
                  hint: 'Text',
                  maxLines: 15,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the text';
                    }
                    return null;
                  },
                ),
                MyTextField(
                  controller: urlController,
                  hint: 'Youtube link',
                ),
                const SizedBox(
                  height: 250,
                )
              ],
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: MyTextButton(
              onPressed: _save,
              label: 'Save',
            ),
          )
        ],
      ),
    );
  }

  void _save() async {
    if (_formKey.currentState!.validate()) {
      if (await showAlertDialog(context,
          'The language of the song is ${languagesCodes[langController.text]}?',
          showCancelButton: true)) {
        final List<YoutubeVideo> youtubeVideos = [];
        if (urlController.text.isNotEmpty) {
          youtubeVideos.add(YoutubeVideo(
              lang: langController.text,
              title: titleController.text,
              link: urlController.text));
        }
        final songVersion = SongVersion(
            id: widget.song.id,
            lang: convertLanguagesEnum(langController.text),
            text: textController.text,
            isChords: isChords,
            title: titleController.text,
            description: descriptionController.text,
            youtubeVideos: youtubeVideos);

        widget.song.songVersions.add(songVersion);

        getIt<SongsBloc>().add(SongsEvent.edit(
          user: context.read<AuthBloc>().icocUser,
          song: widget.song,
        ));

        if (sendNotifications) {
          _sendNotifications();
        }
      }
    }
  }

  void _sendNotifications() {
    final user = context.read<AuthBloc>().icocUser;

    final translatedNotification =
        getTranslatedNotification(langController.text, titleController.text);

    final notification =
        NotificationsModel(id: DateTime.now().toString(), notifications: [
      NotificationVersion(
        id: '0',
        title: translatedNotification['title']!,
        text: translatedNotification['text']!,
        lang: langController.text,
        link:
            '$ICOC_WEB_PAGE/songbook/songs/${widget.song.id}?lang=${langController.text}',
      )
    ]);
    getIt<NotificationsBloc>().add(NotificationsEvent.add(
        user: user, notification: notification, aditionalLanguages: []));
  }
}
