import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:icoc_admin_pannel/constants.dart';
import 'package:icoc_admin_pannel/domain/model/song_detail.dart';
import 'package:icoc_admin_pannel/injection.dart';
import 'package:icoc_admin_pannel/ui/bloc/auth/auth_bloc.dart';
import 'package:icoc_admin_pannel/ui/bloc/songs/songs_bloc.dart';
import 'package:icoc_admin_pannel/ui/widget/alert_dialog.dart';
import 'package:icoc_admin_pannel/ui/widget/my_text_button.dart';
import 'package:icoc_admin_pannel/ui/widget/my_text_field.dart';
import 'package:icoc_admin_pannel/ui/widget/select_lang.dart';

class AddVersionTab extends StatefulWidget {
  final SongDetail song;
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
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    children: [
                      SelectLanguageWidget(langController: langController),
                      const Spacer(),
                      const Text(
                        'Add a new song version',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 20),
                      ),
                      const Spacer(),
                    ],
                  ),
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
                  maxLength: 50,
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
        getIt<SongsBloc>().add(SongsEvent.update(
            user: context.read<AuthBloc>().icocUser,
            song: widget.song,
            lang: langController.text.toLowerCase(),
            title: titleController.text,
            description: descriptionController.text,
            text: textController.text,
            link: urlController.text));
      }
    }
  }
}
