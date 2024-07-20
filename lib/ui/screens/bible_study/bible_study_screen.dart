import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:icoc_admin_pannel/constants.dart';
import 'package:icoc_admin_pannel/domain/helpers/calculate_song_number.dart';
import 'package:icoc_admin_pannel/domain/model/bible_study.dart';
import 'package:icoc_admin_pannel/injection.dart';
import 'package:icoc_admin_pannel/ui/bloc/auth/auth_bloc.dart';
import 'package:icoc_admin_pannel/ui/bloc/bible_study/bible_study_bloc.dart';
import 'package:icoc_admin_pannel/ui/screens/bible_study/widgets/bible_study_card.dart';
import 'package:icoc_admin_pannel/ui/screens/bible_study/widgets/one_lesson.dart';
import 'package:icoc_admin_pannel/ui/widget/alert_dialog.dart';
import 'package:icoc_admin_pannel/ui/widget/my_text_button.dart';
import 'package:icoc_admin_pannel/ui/widget/my_text_field.dart';
import 'package:icoc_admin_pannel/ui/widget/select_lang.dart';
import 'package:logger/logger.dart';

class BibleStudyScreen extends StatelessWidget {
  const BibleStudyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Builder(builder: (context) {
      final state = context.watch<BibleStudyBloc>().state;
      return state.when(
          initial: () {
            getIt<BibleStudyBloc>().add(const BibleStudyEvent.get());
            return const SizedBox.shrink();
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (message) => Center(child: Text(message)),
          success: (bibleStudies) {
            if (bibleStudies.isNotEmpty) {
              final currentBibleStudy =
                  context.read<BibleStudyBloc>().currentBibleStudy;
              final currentLesson =
                  context.read<BibleStudyBloc>().currentLesson;
              if (currentBibleStudy.value is BibleStudyInitial) {
                currentBibleStudy.value = bibleStudies[0];
              }
              if (currentLesson.value is LessonInitial) {
                currentLesson.value = currentBibleStudy.value.lessons[0];
              }

              return Row(
                children: [
                  Flexible(
                    flex: 1,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            MyTextButton(
                              label: 'Add topic',
                              onPressed: () {
                                _showAddTopicDialog(context, bibleStudies);
                              },
                            ),
                          ],
                        ),
                        Expanded(
                          child: ListView(
                            children: bibleStudies
                                .map((bibleStudy) => GestureDetector(
                                    onTap: () {
                                      currentBibleStudy.value = bibleStudy;
                                      if (bibleStudy.lessons.isNotEmpty) {
                                        currentLesson.value =
                                            bibleStudy.lessons[0];
                                      } else {
                                        currentLesson.value =
                                            Lesson.defaultLesson;
                                      }
                                    },
                                    onSecondaryTapDown:
                                        (TapDownDetails details) {
                                      _showContextMenu(context,
                                          details.globalPosition, bibleStudy);
                                    },
                                    child: BibleStudyCard(
                                      bibleStudy: bibleStudy,
                                    )))
                                .toList(),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const VerticalDivider(thickness: 1, width: 1),
                  Flexible(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            MyTextButton(
                              label: 'Add lesson',
                              onPressed: () => context.go(
                                '/bible-study/addlesson',
                              ),
                            ),
                          ],
                        ),
                        ValueListenableBuilder(
                          valueListenable: currentBibleStudy,
                          builder: (context, song, _) {
                            return Expanded(
                              child: ListView(
                                children: [
                                  ...currentBibleStudy.value.lessons
                                      .map((lesson) => ListTile(
                                            onTap: () =>
                                                currentLesson.value = lesson,
                                            title: Text(lesson.title),
                                            leading: Text(lesson.id.toString()),
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                    horizontal: 16),
                                          ))
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  const VerticalDivider(thickness: 1, width: 1),
                  Flexible(
                    flex: 2,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            MyTextButton(
                              label: 'Edit lesson',
                              onPressed: () => context.go(
                                '/bible-study/editlesson',
                              ),
                            ),
                          ],
                        ),
                        Expanded(
                          child: ValueListenableBuilder(
                            valueListenable: currentLesson,
                            builder: (context, song, _) {
                              return OneLesson(lesson: currentLesson.value);
                            },
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              );
            } else {
              getIt<BibleStudyBloc>().add(const BibleStudyEvent.get());
              Future.delayed(Durations.long4)
                  .then((_) => showAlertDialog(context, 'Ooooops... no songs'));
              return const SizedBox.shrink();
            }
          });
    }));
  }

  void _showContextMenu(
      BuildContext context, Offset tapPosition, BibleStudy bibleStudy) {
    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;

    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromPoints(
        tapPosition,
        tapPosition,
      ),
      Offset.zero & overlay.size,
    );
    showMenu(
      context: context,
      position: position,
      items: [
        PopupMenuItem(
          child: const Text(
            'Delete',
            style: TextStyle(color: ScreenColors.songBook),
          ),
          onTap: () async {
            final result = await showAlertDialog(context,
                'Do you really want to delete ${bibleStudy.topic}? Be carefull! ',
                showCancelButton: true);
            if (result) {
              context.read<BibleStudyBloc>().add(BibleStudyEvent.delete(
                  user: context.read<AuthBloc>().icocUser,
                  id: bibleStudy.id.toString()));
            }
          },
        ),
      ],
    );
  }

  Future<dynamic> _showAddTopicDialog(
      BuildContext context, List<BibleStudy> bibleStudies) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        final TextEditingController topicController = TextEditingController();
        final TextEditingController subTopicController =
            TextEditingController();
        final TextEditingController langController = TextEditingController()
          ..text = 'en';
        final formKey = GlobalKey<FormState>();
        return Center(
          child: AlertDialog(
            title: const Text('Add a New Topic'),
            content: SizedBox(
              width: MediaQuery.of(context).size.width / 2,
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    MyTexField(
                      controller: topicController,
                      hint: 'Topic',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a topic';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    MyTexField(
                      controller: subTopicController,
                      hint: 'Description',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a description';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    SelectLanguageWidget(langController: langController),
                  ],
                ),
              ),
            ),
            actions: [
              MyTextButton(
                onPressed: () => context.pop(),
                label: 'Cancel',
              ),
              MyTextButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    final bibleStudy = BibleStudy(
                        lessons: [],
                        topic: topicController.text,
                        id: calculateLastNumber(bibleStudies) + 1,
                        subtopic: subTopicController.text,
                        lang: langController.text);
                    getIt<BibleStudyBloc>().add(BibleStudyEvent.addBibleStudy(
                      bibleStudy: bibleStudy,
                      user: context.read<AuthBloc>().icocUser,
                    ));
                    context.pop();
                  }
                },
                label: 'Add',
              ),
            ],
          ),
        );
      },
    );
  }
}
