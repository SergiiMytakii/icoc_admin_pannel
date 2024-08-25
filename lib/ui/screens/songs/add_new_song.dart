import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:icoc_admin_pannel/constants.dart';
import 'package:icoc_admin_pannel/domain/helpers/calculate_song_number.dart';
import 'package:icoc_admin_pannel/domain/helpers/convert_languages_enum.dart';
import 'package:icoc_admin_pannel/domain/helpers/notification_tranlator.dart';
import 'package:icoc_admin_pannel/domain/model/notifications/notifications_model.dart';
import 'package:icoc_admin_pannel/domain/model/songs/song_model.dart';
import 'package:icoc_admin_pannel/domain/model/youtube_video/youtube_video.dart';
import 'package:icoc_admin_pannel/injection.dart';
import 'package:icoc_admin_pannel/ui/bloc/auth/auth_bloc.dart';
import 'package:icoc_admin_pannel/ui/bloc/notifications/notifications_bloc.dart';
import 'package:icoc_admin_pannel/ui/bloc/songs/songs_bloc.dart';
import 'package:icoc_admin_pannel/ui/screens/songs/widgets/add_song_block.dart';
import 'package:icoc_admin_pannel/ui/widget/alert_dialog.dart';
import 'package:icoc_admin_pannel/ui/widget/my_text_button.dart';
import 'package:icoc_admin_pannel/ui/widget/send_notification_checkbox.dart';
import 'package:logger/logger.dart';

class AddNewSongScreen extends StatefulWidget {
  const AddNewSongScreen({
    super.key,
  });

  @override
  State<AddNewSongScreen> createState() => _AddNewSongScreenState();
}

class _AddNewSongScreenState extends State<AddNewSongScreen> {
  final List<Map<String, dynamic>> _isOpen = [
    {'isOpen': true, 'key': GlobalKey<FormState>()}
  ];
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController langController = TextEditingController()..text = 'en';
  TextEditingController textController = TextEditingController();
  TextEditingController urlController = TextEditingController();
  SongModel song = SongModel.defaultSong();
  bool sendNotifications = false;
  bool isChords = false;

  @override
  void initState() {
    getIt<SongsBloc>().add(const SongsEvent.get());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Builder(builder: (context) {
                      final state = context.watch<SongsBloc>().state;
                      state.whenOrNull(
                        initial: () =>
                            getIt<SongsBloc>().add(const SongsEvent.get()),
                        success: (songs) => song =
                            song.copyWith(id: calculateLastNumber(songs) + 1),
                      );
                      return Text('Song number: ${song.id}');
                    }),
                    SendNotificationCheckBox(
                      onChanged: (value) => sendNotifications = value,
                    ),
                    const Spacer(),
                    _buttonsBlock(context)
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: _isOpen.length,
                    itemBuilder: (context, index) {
                      return ExpansionTile(
                        initiallyExpanded: _isOpen[index]['isOpen'],
                        title: Text('Version ${index + 1}'),
                        children: [
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 1000),
                            height: _isOpen[index]['isOpen'] ? null : 0,
                            child: AddSongBlock(
                              formKey: _isOpen[index]['key'],
                              langController: langController,
                              titleController: titleController,
                              descriptionController: descriptionController,
                              textController: textController,
                              urlController: urlController,
                              callback: (val) => isChords = val,
                            ),
                          ),
                        ],
                        onExpansionChanged: (value) {
                          setState(() {
                            _isOpen[index]['isOpen'] = value;
                            _isOpen[index]['key'] = GlobalKey<FormState>();
                          });
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Row _buttonsBlock(
    BuildContext context,
  ) {
    return Row(
      children: [
        MyTextButton(
          onPressed: () async {
            final currentKey =
                _isOpen.firstWhere((item) => item['isOpen'] == true)['key']
                    as GlobalKey<FormState>;
            if (currentKey.currentState!.validate()) {
              final res = await showAlertDialog(context,
                  'The language of the version is ${languagesCodes[langController.text]}, correct?',
                  showCancelButton: true);
              if (res) {
                _addToSong();
                // log(song.toJson());
                setState(
                  () {
                    _isOpen[_isOpen.length - 1]['isOpen'] = false;
                    _isOpen
                        .add({'isOpen': true, 'key': GlobalKey<FormState>()});
                    titleController.clear();
                    descriptionController.clear();
                    textController.clear();
                    urlController.clear();
                    langController.clear();
                  },
                );
              }
            }
          },
          label: 'Add Version',
        ),
        const SizedBox(
          width: 16,
        ),
        MyTextButton(
          onPressed: () async {
            final currentKey =
                _isOpen.firstWhere((item) => item['isOpen'] == true)['key']
                    as GlobalKey<FormState>;
            if (currentKey.currentState!.validate()) {
              final res = await showAlertDialog(context,
                  'The language of the version is ${languagesCodes[langController.text]}, correct?',
                  showCancelButton: true);
              if (res) {
                _addToSong();
                getIt<SongsBloc>().add(SongsEvent.add(
                    user: context.read<AuthBloc>().icocUser, song: song));
                getIt<SongsBloc>().currentSong.value = song;
                if (sendNotifications) {
                  _sendNotifications();
                }
                context.pop();
              }
            }
          },
          label: 'Save',
        ),
      ],
    );
  }

  void _addToSong() {
    final List<YoutubeVideo> youtubeVideos = [];
    if (urlController.text.isNotEmpty) {
      youtubeVideos.add(YoutubeVideo(
          lang: langController.text,
          title: titleController.text,
          link: urlController.text));
    }
    final songVersion = SongVersion(
        id: song.id,
        isChords: isChords,
        lang: convertLanguagesEnum(langController.text),
        text: textController.text,
        title: titleController.text,
        description: descriptionController.text,
        youtubeVideos: youtubeVideos);

    song.songVersions.add(songVersion);
  }

  void _sendNotifications() {
    final user = context.read<AuthBloc>().icocUser;
    //get languages from song
    final Set<Languages> allLanguages = {};
    allLanguages.addAll(song.getAllLangs());

    final notification = NotificationsModel(
      id: DateTime.now().toString(),
      notifications: allLanguages.toList().asMap().entries.map((entry) {
        final translatedNotification = getTranslatedNotification(
            entry.value.name,
            song.songVersions
                .firstWhere(
                    (songVersion) => songVersion.lang.name == entry.value.name)
                .title);
        return NotificationVersion(
          id: '${entry.key + 1}',
          title: translatedNotification['title']!,
          text: translatedNotification['text']!,
          lang: entry.value.name,
          link:
              '$ICOC_WEB_PAGE/songbook/songs/${song.id}?lang=${entry.value.name}',
        );
      }).toList(),
    );
    getIt<NotificationsBloc>().add(NotificationsEvent.add(
        user: user, notification: notification, aditionalLanguages: []));
  }
}
