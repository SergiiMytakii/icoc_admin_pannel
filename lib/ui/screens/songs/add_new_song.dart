import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:icoc_admin_pannel/constants.dart';
import 'package:icoc_admin_pannel/domain/helpers/calculate_song_number.dart';
import 'package:icoc_admin_pannel/domain/model/resources.dart';
import 'package:icoc_admin_pannel/domain/model/song_detail.dart';
import 'package:icoc_admin_pannel/injection.dart';
import 'package:icoc_admin_pannel/ui/bloc/auth/auth_bloc.dart';
import 'package:icoc_admin_pannel/ui/bloc/songs/songs_bloc.dart';
import 'package:icoc_admin_pannel/ui/screens/songs/widgets/add_song_block.dart';
import 'package:icoc_admin_pannel/ui/widget/alert_dialog.dart';
import 'package:icoc_admin_pannel/ui/widget/my_text_button.dart';

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
  SongDetail song = SongDetail.defaultSong();
  final ValueNotifier<bool> _sendNotificationNotifier =
      ValueNotifier<bool>(false);

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
                    _buildSendNotificationCheckBox(),
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
                context.read<SongsBloc>().currentSong.value = song;
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
    List<Resources>? resources;
    final title = song.title..[langController.text] = titleController.text;
    final text = song.text..['${langController.text}1'] = textController.text;
    final description = song.description ?? {};
    description[langController.text] = descriptionController.text;

    if (urlController.text.isNotEmpty) {
      resources = song.resources ?? [];
      resources.add(Resources(
          lang: langController.text,
          title: titleController.text,
          link: urlController.text));
    }
    song = song.copyWith(
        title: title,
        text: text,
        description: description,
        resources: resources);
  }

  Widget _buildSendNotificationCheckBox() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          ValueListenableBuilder<bool>(
            valueListenable: _sendNotificationNotifier,
            builder: (context, value, child) {
              return Checkbox(
                value: value,
                onChanged: (newValue) {
                  _sendNotificationNotifier.value = newValue!;
                },
              );
            },
          ),
          const Text('Send notifications?'),
        ],
      ),
    );
  }
}
