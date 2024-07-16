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
  AddSongBlock(
      {super.key,
      required this.titleController,
      required this.descriptionController,
      required this.langController,
      required this.textController,
      required this.urlController,
      required this.formKey});

  @override
  State<AddSongBlock> createState() => _AddSongBlockState();
}

class _AddSongBlockState extends State<AddSongBlock> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: widget.formKey,
        child: Column(
          children: [
            Row(
              children: [
                SelectLanguageWidget(langController: widget.langController),
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
            MyTexField(
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
            MyTexField(
              controller: widget.descriptionController,
              hint: 'Desctiption',
              maxLength: 60,
            ),
            MyTexField(
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
            MyTexField(
              controller: widget.urlController,
              hint: 'Youtube link',
            ),
          ],
        ),
      ),
    );
  }
}
