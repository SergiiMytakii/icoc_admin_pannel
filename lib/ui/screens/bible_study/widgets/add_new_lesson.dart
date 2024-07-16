import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:icoc_admin_pannel/domain/helpers/calculate_song_number.dart';
import 'package:icoc_admin_pannel/domain/model/bible_study.dart';
import 'package:icoc_admin_pannel/injection.dart';
import 'package:icoc_admin_pannel/ui/bloc/bible_study/bible_study_bloc.dart';
import 'package:icoc_admin_pannel/ui/widget/my_text_button.dart';
import 'package:icoc_admin_pannel/ui/widget/my_text_field.dart';

class AddNewLessonScreen extends StatefulWidget {
  const AddNewLessonScreen({
    super.key,
  });

  @override
  State<AddNewLessonScreen> createState() => _AddNewLessonScreenState();
}

class _AddNewLessonScreenState extends State<AddNewLessonScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController textController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    Future.delayed(Duration.zero).then((_) {
      final state = context.read<BibleStudyBloc>().state;
      state.whenOrNull(
        initial: () {
          context.go('/bible-study');
        },
      );
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final currentBibleStudy = context.read<BibleStudyBloc>().currentBibleStudy;

    final int lessonNumber =
        calculateLastNumber(currentBibleStudy.value.lessons) + 1;
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Builder(builder: (context) {
        return Form(
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
                  _buttonsBlock(currentBibleStudy.value, lessonNumber)
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
                maxLines: 20,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the text in HTML format';
                  }
                  return null;
                },
              ),
            ],
          ),
        );
      }),
    ));
  }

  Row _buttonsBlock(BibleStudy currentBibleStudy, int lessonNumber) {
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
            if (_formKey.currentState!.validate()) {
              currentBibleStudy.lessons.add(Lesson(
                  title: titleController.text,
                  text: textController.text,
                  id: lessonNumber));
              getIt<BibleStudyBloc>()
                  .add(BibleStudyEvent.addLesson(currentBibleStudy));
              Future.delayed(const Duration(seconds: 1)).then((_) {
                context.read<BibleStudyBloc>().currentLesson.value =
                    currentBibleStudy.lessons[lessonNumber - 1];
                context.pop();
              });
            }
          },
          label: 'Save',
        ),
      ],
    );
  }
}
