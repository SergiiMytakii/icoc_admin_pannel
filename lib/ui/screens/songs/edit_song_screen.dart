import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:icoc_admin_pannel/domain/helpers/convert_languages_enum.dart';
import 'package:icoc_admin_pannel/domain/helpers/extract_text_from_html.dart';
import 'package:icoc_admin_pannel/domain/model/songs/song_model.dart';
import 'package:icoc_admin_pannel/domain/model/youtube_video/youtube_video.dart';
import 'package:icoc_admin_pannel/injection.dart';
import 'package:icoc_admin_pannel/ui/bloc/auth/auth_bloc.dart';
import 'package:icoc_admin_pannel/ui/bloc/songs/songs_bloc.dart';
import 'package:icoc_admin_pannel/ui/widget/my_text_button.dart';
import 'package:icoc_admin_pannel/ui/widget/my_text_field.dart';
import 'package:icoc_admin_pannel/ui/widget/select_lang.dart';

class EditSongScreen extends StatefulWidget {
  final SongModel song;
  final int index;
  const EditSongScreen({
    super.key,
    required this.song,
    required this.index,
  });

  @override
  State<EditSongScreen> createState() => _EditSongScreenState();
}

class _EditSongScreenState extends State<EditSongScreen> {
  late final TextEditingController titleController;
  late final TextEditingController descriptionController;
  late final TextEditingController langController;
  late final TextEditingController textController;
  late final TextEditingController urlController;
  final _formKey = GlobalKey<FormState>();
  late bool isChords;
  final List<TextEditingController> youtubeControllers = [];

  @override
  void initState() {
    isChords = widget.song.songVersions[widget.index].isChords;
    titleController = TextEditingController(
        text: widget.song.songVersions[widget.index].title);
    langController = TextEditingController(
        text: widget.song.songVersions[widget.index].lang.name);
    descriptionController = TextEditingController(
        text: widget.song.songVersions[widget.index].description);

    String text = widget.song.songVersions[widget.index].text;
    if (text.startsWith('<')) {
      text = FormatTextHelper.extractFormattedText(text);
    }
    textController = TextEditingController(text: text);
    final videos = widget.song.songVersions[widget.index].youtubeVideos;
    videos?.forEach((video) =>
        youtubeControllers.add(TextEditingController(text: video.link)));

    super.initState();
  }

  void addYoutubeController() {
    setState(() {
      youtubeControllers.add(TextEditingController());
    });
  }

  List<YoutubeVideo> getYoutubeVideos() {
    return youtubeControllers
        .where((controller) => controller.text.isNotEmpty)
        .map((controller) => YoutubeVideo(
            link: controller.text,
            lang: widget.song.songVersions[widget.index].lang.name,
            title: null))
        .toList();
  }

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
                Row(
                  children: [
                    SelectLanguageWidget(
                      langController: langController,
                    ),
                    SizedBox(
                      width: 150,
                      child: CheckboxListTile(
                          title: const Text('Chords'),
                          value: isChords,
                          onChanged: (val) => setState(() {
                                isChords = !isChords;
                              })),
                    ),
                    const Spacer(),
                    const Text(
                      'Edit song version',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 20),
                    ),
                    const Spacer(),
                    const SizedBox(
                      width: 150,
                    ),
                  ],
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
                  maxLength: 60,
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
                SizedBox(
                  height: youtubeControllers.length * 100,
                  child: ListView.builder(
                    itemCount: youtubeControllers.length,
                    itemBuilder: (context, index) {
                      return MyTextField(
                        controller: youtubeControllers[index],
                        hint: 'YouTube Link ${index + 1}',
                      );
                    },
                  ),
                ),
                const SizedBox(
                  height: 200,
                )
              ],
            ),
          ),
          Positioned(
              top: 0,
              right: 0,
              child: Row(
                children: [
                  MyTextButton(
                    label: 'Cancel',
                    onPressed: () => context.pop(),
                  ),
                  MyTextButton(
                    label: 'Save',
                    onPressed: _save,
                  ),
                ],
              ))
        ],
      ),
    );
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      widget.song.songVersions[widget.index] = SongVersion(
          id: widget.song.id,
          text: textController.text,
          isChords: isChords,
          title: titleController.text,
          description: descriptionController.text,
          lang: languagesToEnumMap[langController.text]!,
          youtubeVideos: getYoutubeVideos());
      getIt<SongsBloc>().add(SongsEvent.edit(
        user: context.read<AuthBloc>().icocUser,
        song: widget.song,
      ));
      context.read<SongsBloc>().currentSong.value = widget.song;
      context.pop();
    }
  }
}
