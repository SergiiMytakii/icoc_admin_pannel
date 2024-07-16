import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:icoc_admin_pannel/domain/helpers/calculate_song_number.dart';
import 'package:icoc_admin_pannel/domain/model/bible_study.dart';
import 'package:icoc_admin_pannel/injection.dart';
import 'package:icoc_admin_pannel/ui/bloc/bible_study/bible_study_bloc.dart';
import 'package:icoc_admin_pannel/ui/bloc/songs/songs_bloc.dart';
import 'package:icoc_admin_pannel/ui/widget/my_text_button.dart';
import 'package:icoc_admin_pannel/ui/widget/my_text_field.dart';

class AddNewLessonScreen extends StatefulWidget {
  final BibleStudy bibleStudy;
  const AddNewLessonScreen({super.key, required this.bibleStudy});

  @override
  State<AddNewLessonScreen> createState() => _AddNewLessonScreenState();
}

class _AddNewLessonScreenState extends State<AddNewLessonScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController textController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final int lessonNumber = calculateLastNumber(widget.bibleStudy.lessons) + 1;
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            Row(
              children: [
                Text('Lesson number: $lessonNumber'),
                const Spacer(),
                const Text(
                  'Add a new lesson',
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
              controller: textController,
              hint: 'Text',
              maxLines: 15,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the text in HTML format';
                }
                return null;
              },
            ),
          ],
        ),
      ),
    ));
  }

  Row _buttonsBlock(BuildContext context) {
    return Row(
      children: [
        MyTextButton(
          onPressed: () {
            context.pop();
          },
          label: 'Cancel',
        ),
        const SizedBox(
          width: 16,
        ),
        MyTextButton(
          onPressed: () {
            getIt<BibleStudyBloc>()
                .add(BibleStudyEvent.addLesson(widget.bibleStudy));
            context.read<BibleStudyBloc>().currentLesson.value =
                widget.bibleStudy.lessons[0];
            context.pop();
          },
          label: 'Save',
        ),
      ],
    );
  }
}
