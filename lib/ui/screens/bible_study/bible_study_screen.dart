import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:icoc_admin_pannel/domain/helpers/calculate_song_number.dart';
import 'package:icoc_admin_pannel/domain/helpers/convert_languages_enum.dart';
import 'package:icoc_admin_pannel/domain/helpers/show_menu.dart';
import 'package:icoc_admin_pannel/domain/model/bible_study/bible_study.dart';
import 'package:icoc_admin_pannel/injection.dart';
import 'package:icoc_admin_pannel/ui/bloc/auth/auth_bloc.dart';
import 'package:icoc_admin_pannel/ui/bloc/bible_study/bible_study_bloc.dart';
import 'package:icoc_admin_pannel/ui/screens/bible_study/widgets/bible_study_card.dart';
import 'package:icoc_admin_pannel/ui/screens/bible_study/widgets/one_lesson.dart';
import 'package:icoc_admin_pannel/ui/widget/alert_dialog.dart';
import 'package:icoc_admin_pannel/ui/widget/my_text_button.dart';
import 'package:icoc_admin_pannel/ui/widget/my_text_field.dart';
import 'package:icoc_admin_pannel/ui/widget/select_lang.dart';

class BibleStudyScreen extends StatefulWidget {
  BibleStudyScreen({super.key});

  @override
  State<BibleStudyScreen> createState() => _BibleStudyScreenState();
}

class _BibleStudyScreenState extends State<BibleStudyScreen> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToCurrentTopic(BibleStudy currentBibleStudy) {
    final index = currentBibleStudy.id;
    Future.delayed(Durations.extralong4, () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          index * 55.0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });
  }

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

              _scrollToCurrentTopic(currentBibleStudy.value);

              return Row(
                children: [
                  _buildListTopics(
                      context, bibleStudies, currentBibleStudy, currentLesson),
                  const VerticalDivider(thickness: 1, width: 1),
                  _buildListLessons(context, currentBibleStudy, currentLesson),
                  const VerticalDivider(thickness: 1, width: 1),
                  _buildLessonContent(context, currentLesson)
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

  Flexible _buildLessonContent(
      BuildContext context, ValueNotifier<Lesson> currentLesson) {
    return Flexible(
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
              builder: (context, lesson, _) {
                return OneLesson(lesson: currentLesson.value);
              },
            ),
          ),
        ],
      ),
    );
  }

  Flexible _buildListLessons(
      BuildContext context,
      ValueNotifier<BibleStudy> currentBibleStudy,
      ValueNotifier<Lesson> currentLesson) {
    return Flexible(
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
            builder: (context, lesson, _) {
              return Expanded(
                child: ListView(
                  children: [
                    ...currentBibleStudy.value.lessons.map((lesson) =>
                        _buildLessonCard(
                            currentBibleStudy, currentLesson, lesson))
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Flexible _buildListTopics(
      BuildContext context,
      List<BibleStudy> bibleStudies,
      ValueNotifier<BibleStudy> currentBibleStudy,
      ValueNotifier<Lesson> currentLesson) {
    return Flexible(
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
                controller: _scrollController,
                children: bibleStudies
                    .map((bibleStudy) => GestureDetector(
                        onTap: () {
                          currentBibleStudy.value = bibleStudy;
                          if (bibleStudy.lessons.isNotEmpty) {
                            currentLesson.value = bibleStudy.lessons[0];
                          } else {
                            currentLesson.value = Lesson.defaultLesson;
                          }
                        },
                        onSecondaryTapDown: (TapDownDetails details) {
                          showContextMenu(context, details.globalPosition,
                              () => _deleteBibleStudy(context, bibleStudy));
                        },
                        child: ValueListenableBuilder(
                            valueListenable: currentBibleStudy,
                            builder: (context, lesson, _) {
                              return BibleStudyCard(
                                bibleStudy: bibleStudy,
                                currentBibleStudyId: currentBibleStudy.value.id,
                              );
                            })))
                    .toList()),
          ),
        ],
      ),
    );
  }

  Widget _buildLessonCard(ValueNotifier<BibleStudy> currentBibleStudy,
      ValueNotifier<Lesson> currentLesson, Lesson lesson) {
    return ValueListenableBuilder(
        valueListenable: currentLesson,
        builder: (context, song, _) {
          return GestureDetector(
            onSecondaryTapDown: (TapDownDetails details) {
              showContextMenu(context, details.globalPosition,
                  () => _deleteLesson(context, currentBibleStudy, lesson));
            },
            child: ListTile(
              selected: lesson.id == currentLesson.value.id,
              selectedColor: Theme.of(context).primaryColor,
              onTap: () => currentLesson.value = lesson,
              title: Text(lesson.title),
              leading: Text((lesson.id + 1).toString()),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
            ),
          );
        });
  }

  Future _deleteBibleStudy(BuildContext context, BibleStudy bibleStudy) async {
    final result = await showAlertDialog(context,
        'Do you really want to delete ${bibleStudy.topic}? Be carefull! ',
        showCancelButton: true);
    if (result) {
      context.read<BibleStudyBloc>().add(BibleStudyEvent.delete(
          user: context.read<AuthBloc>().icocUser,
          id: bibleStudy.id.toString()));
    }
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
                    MyTextField(
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
                    MyTextField(
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
                        lang: convertLanguagesEnum(langController.text));
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

  Future _deleteLesson(BuildContext context,
      ValueNotifier<BibleStudy> currentBibleStudy, Lesson lesson) async {
    final result = await showAlertDialog(
        context, 'Do you really want to delete ${lesson.title}? Be carefull! ',
        showCancelButton: true);
    if (result) {
      final updatedBibleStudy = currentBibleStudy.value.copyWith(
          lessons: currentBibleStudy.value.lessons
              .where((element) => element.id != lesson.id)
              .toList());

      context.read<BibleStudyBloc>().add(BibleStudyEvent.editLesson(
          user: context.read<AuthBloc>().icocUser,
          bibleStudy: updatedBibleStudy));
      currentBibleStudy.value = updatedBibleStudy;
      getIt<BibleStudyBloc>().currentLesson.value =
          updatedBibleStudy.lessons.firstOrNull ?? Lesson.defaultLesson;
    }
  }
}
