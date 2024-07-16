import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:icoc_admin_pannel/domain/helpers/extract_text_from_html.dart';
import 'package:icoc_admin_pannel/domain/model/resources.dart';
import 'package:icoc_admin_pannel/domain/model/song_detail.dart';
import 'package:icoc_admin_pannel/injection.dart';
import 'package:icoc_admin_pannel/ui/bloc/songs/songs_bloc.dart';
import 'package:icoc_admin_pannel/ui/widget/my_text_button.dart';
import 'package:icoc_admin_pannel/ui/widget/my_text_field.dart';

class EditSongScreen extends StatefulWidget {
  final String textVersion;
  final SongDetail? song;
  const EditSongScreen(
      {super.key, required this.textVersion, required this.song});

  @override
  State<EditSongScreen> createState() => _EditSongScreenState();
}

class _EditSongScreenState extends State<EditSongScreen> {
  late final TextEditingController titleController;
  late final TextEditingController descriptionController;
  late final TextEditingController textVersionController;
  late final TextEditingController textController;
  late final TextEditingController urlController;
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    titleController = TextEditingController(
        text: widget.song?.title[widget.textVersion.substring(0, 2)]);
    final descr = widget.song?.description != null
        ? widget.song?.description![widget.textVersion.substring(0, 2)]
        : null;
    descriptionController = TextEditingController(text: descr);
    textVersionController = TextEditingController(text: widget.textVersion);

    String text = widget.song?.text[widget.textVersion] ?? '';
    if (text.startsWith('<')) {
      text = FormatTextHelper.extractFormattedText(text);
    }
    textController = TextEditingController(text: text);
    final res = widget.song?.resources?.firstWhere(
      (res) => res.lang == widget.textVersion.substring(0, 2),
      orElse: () => Resources.defaultResource(),
    );
    urlController = TextEditingController(text: res?.link);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Stack(
        children: [
          Form(
            key: _formKey,
            child: ListView(
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: 150,
                      child: MyTexField(
                        controller: textVersionController,
                        hint: 'Text version',
                        readOnly: true,
                        maxLength: 3,
                      ),
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
                MyTexField(
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
                MyTexField(
                  controller: descriptionController,
                  hint: 'Desctiption',
                  maxLength: 60,
                ),
                MyTexField(
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
                MyTexField(
                  controller: urlController,
                  hint: 'Youtube link',
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
      if (widget.song != null) {
        getIt<SongsBloc>().add(SongsEvent.edit(
            song: widget.song!,
            textVersion: textVersionController.text.toLowerCase(),
            title: titleController.text,
            description: descriptionController.text,
            text: textController.text,
            link: urlController.text));
        context.read<SongsBloc>().currentSong.value = widget.song!;
        context.pop();
      }
    }
  }
}
