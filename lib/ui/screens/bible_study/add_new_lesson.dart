import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:icoc_admin_pannel/domain/helpers/calculate_song_number.dart';
import 'package:icoc_admin_pannel/domain/model/bible_study/bible_study.dart';
import 'package:icoc_admin_pannel/injection.dart';
import 'package:icoc_admin_pannel/ui/bloc/auth/auth_bloc.dart';
import 'package:icoc_admin_pannel/ui/bloc/bible_study/bible_study_bloc.dart';
import 'package:icoc_admin_pannel/ui/widget/my_text_button.dart';
import 'package:icoc_admin_pannel/ui/widget/send_notification_checkbox.dart';
import 'package:icoc_admin_pannel/ui/bloc/notifications/notifications_bloc.dart';
import 'package:icoc_admin_pannel/domain/model/notifications/notifications_model.dart';
import 'package:icoc_admin_pannel/constants.dart';
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
  bool sendNotifications = false;

  @override
  void initState() {
    Future.delayed(Duration.zero).then((_) {
      final state = context.read<BibleStudyBloc>().state;

      state.maybeWhen(
        success: (bibleStudies) {},
        orElse: () => context.go('/bible-study'),
      );
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final currentBibleStudy = context.read<BibleStudyBloc>().currentBibleStudy;

    final int lastLessonNumber =
        calculateLastNumber(currentBibleStudy.value.lessons);
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: ListView(
          children: [
            Row(
              children: [
                Text('Lesson number: ${lastLessonNumber + 1}'),
                const Spacer(),
                const Text(
                  'Add a new lesson',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20),
                ),
                const Spacer(),
                _buttonsBlock(currentBibleStudy.value, lastLessonNumber)
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                children: [
                  const Spacer(),
                  SendNotificationCheckBox(
                    onChanged: (value) => sendNotifications = value,
                  ),
                ],
              ),
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
      ),
    ));
  }

  Row _buttonsBlock(BibleStudy currentBibleStudy, int lastLessonNumber) {
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
              //lessons is unmodifible list
              final updatedLessons =
                  List<Lesson>.from(currentBibleStudy.lessons)
                    ..add(Lesson(
                        title: titleController.text,
                        text: textController.text,
                        id: lastLessonNumber + 1));
              final updatedBibleStudy =
                  currentBibleStudy.copyWith(lessons: updatedLessons);
              context.read<BibleStudyBloc>().add(BibleStudyEvent.addLesson(
                    bibleStudy: updatedBibleStudy,
                    user: context.read<AuthBloc>().icocUser,
                  ));
              if (sendNotifications) {
                final link =
                    '$ICOC_WEB_PAGE/biblestudy/lessons/${updatedBibleStudy.id}/${lastLessonNumber + 1}?lang=${updatedBibleStudy.lang.name}';
                final notification = NotificationsModel(
                  id: DateTime.now().toString(),
                  notifications: [
                    NotificationVersion(
                      id: '0',
                      title: 'New Bible Study lesson added',
                      text: titleController.text,
                      lang: updatedBibleStudy.lang.name,
                      link: link,
                    ),
                  ],
                );
                context.read<NotificationsBloc>().add(NotificationsEvent.add(
                    user: context.read<AuthBloc>().icocUser,
                    notification: notification,
                    aditionalLanguages: [],
                    baseTopic: 'biblestudy'));
              }
              Future.delayed(const Duration(seconds: 2)).then((_) {
                context.read<BibleStudyBloc>().currentBibleStudy.value =
                    updatedBibleStudy;
                context.read<BibleStudyBloc>().currentLesson.value =
                    updatedBibleStudy.lessons.last;
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
