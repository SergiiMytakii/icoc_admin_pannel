import 'package:flutter/material.dart';

import 'package:icoc_admin_pannel/ui/widget/my_text_field.dart';
import 'package:icoc_admin_pannel/ui/widget/select_lang.dart';

class AddSongBlock extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController titleController;
  final TextEditingController descriptionController;
  final TextEditingController langController;
  final TextEditingController textController;
  final TextEditingController urlController;
  final Function callback;
  AddSongBlock(
      {super.key,
      required this.titleController,
      required this.descriptionController,
      required this.langController,
      required this.textController,
      required this.urlController,
      required this.callback,
      required this.formKey});

  @override
  State<AddSongBlock> createState() => _AddSongBlockState();
}

class _AddSongBlockState extends State<AddSongBlock> {
  bool isChords = false;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: widget.formKey,
        child: Column(
          children: [
            Row(
              children: [
                SelectLanguageWidget(langController: widget.langController),
                SizedBox(
                  width: 150,
                  child: CheckboxListTile(
                      title: const Text('Chords'),
                      value: isChords,
                      onChanged: (val) => setState(() {
                            isChords = !isChords;
                            widget.callback(val);
                          })),
                ),
                const Spacer(),
                const Text(
                  'Add a new song version',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20),
                ),
                const Spacer(),
                const SizedBox(
                  width: 50,
                )
              ],
            ),
            MyTextField(
              controller: widget.titleController,
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
              controller: widget.descriptionController,
              hint: 'Desctiption',
              maxLength: 60,
            ),
            MyTextField(
              controller: widget.textController,
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
              controller: widget.urlController,
              hint: 'Youtube link',
            ),
          ],
        ),
      ),
    );
  }
}
