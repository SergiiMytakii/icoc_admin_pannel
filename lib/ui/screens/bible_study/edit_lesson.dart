import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:icoc_admin_pannel/domain/model/bible_study.dart';
import 'package:icoc_admin_pannel/injection.dart';
import 'package:icoc_admin_pannel/ui/bloc/bible_study/bible_study_bloc.dart';
import 'package:icoc_admin_pannel/ui/widget/my_text_button.dart';
import 'package:icoc_admin_pannel/ui/widget/my_text_field.dart';

class EditLessonScreen extends StatefulWidget {
  const EditLessonScreen({
    super.key,
  });

  @override
  State<EditLessonScreen> createState() => _EditLessonScreenState();
}

class _EditLessonScreenState extends State<EditLessonScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController textController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  BibleStudy currentBibleStudy = BibleStudy.defaultBibleStudy;
  Lesson currentLesson = Lesson.defaultLesson;

  @override
  void initState() {
    Future.delayed(Duration.zero).then((_) {
      final state = context.read<BibleStudyBloc>().state;
      state.maybeWhen(
        success: (bibleStudies) {},
        orElse: () => context.go('/bible-study'),
      );

      titleController.text = currentLesson.title;
      textController.text = currentLesson.text;
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    currentBibleStudy = context.read<BibleStudyBloc>().currentBibleStudy.value;
    currentLesson = context.read<BibleStudyBloc>().currentLesson.value;
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
                  Text('Lesson number: ${currentLesson.id}'),
                  const Spacer(),
                  const Text(
                    'Edit lesson',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20),
                  ),
                  const Spacer(),
                  _buttonsBlock(currentBibleStudy)
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

  Row _buttonsBlock(
    BibleStudy currentBibleStudy,
  ) {
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
              currentBibleStudy.lessons
                  .removeWhere((lesson) => lesson.id == currentLesson.id);

              currentBibleStudy.lessons.add(Lesson(
                  title: titleController.text,
                  text: textController.text,
                  id: currentLesson.id));
              getIt<BibleStudyBloc>()
                  .add(BibleStudyEvent.editLesson(currentBibleStudy));

              context.pop();
            }
          },
          label: 'Save',
        ),
      ],
    );
  }
}
