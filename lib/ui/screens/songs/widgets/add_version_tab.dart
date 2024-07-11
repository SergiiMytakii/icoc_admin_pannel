import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:icoc_admin_pannel/domain/model/song_detail.dart';
import 'package:icoc_admin_pannel/injection.dart';
import 'package:icoc_admin_pannel/ui/bloc/songs/songs_bloc.dart';

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
            TextButton(
              onPressed: _save,
              child: const Text('Submit'),
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

class MyTexField extends StatelessWidget {
  const MyTexField({
    super.key,
    required this.controller,
    required this.hint,
    this.maxLength = 100000,
    this.maxLines = 1,
    this.validator,
  });

  final TextEditingController controller;
  final String hint;
  final int maxLength;
  final int maxLines;
  final FormFieldValidator<String>? validator;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        maxLength: maxLength,
        maxLines: maxLines,
        validator: validator,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.grey, width: 0.3),
          ),
          helperText: hint,
        ),
      ),
    );
  }
}
