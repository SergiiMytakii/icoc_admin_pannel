import 'package:flutter/material.dart';
import 'package:icoc_admin_pannel/domain/model/song_detail.dart';
import 'package:icoc_admin_pannel/injection.dart';
import 'package:icoc_admin_pannel/ui/bloc/songs/songs_bloc.dart';
import 'package:icoc_admin_pannel/ui/widget/my_text_button.dart';
import 'package:icoc_admin_pannel/ui/widget/my_text_field.dart';

class AddVersionTab extends StatefulWidget {
  final SongDetail song;
  AddVersionTab(
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
  TextEditingController langController = TextEditingController();
  TextEditingController textController = TextEditingController();
  TextEditingController urlController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                children: [
                  const SizedBox(
                    width: 30,
                  ),
                  const Spacer(),
                  const Text(
                    'Add a new song version',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20),
                  ),
                  const Spacer(),
                  MyTextButton(
                    onPressed: _save,
                    label: 'Save',
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                ],
              ),
            ),
            MyTexField(
              controller: langController,
              hint: 'Language code',
              maxLength: 2,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a language code';
                }
                return null;
              },
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
    );
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      getIt<SongsBloc>().add(SongsEvent.update(
          song: widget.song,
          lang: langController.text.toLowerCase(),
          title: titleController.text,
          description: descriptionController.text,
          text: textController.text,
          link: urlController.text));
    }
  }
}
