import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:icoc_admin_pannel/domain/model/q&a/q&a_model.dart';
import 'package:icoc_admin_pannel/injection.dart';
import 'package:icoc_admin_pannel/ui/bloc/auth/auth_bloc.dart';
import 'package:icoc_admin_pannel/ui/bloc/q&a_bloc/q&a_bloc.dart';
import 'package:icoc_admin_pannel/ui/widget/my_text_button.dart';
import 'package:icoc_admin_pannel/ui/widget/my_text_field.dart';

class EditQandAScreen extends StatefulWidget {
  const EditQandAScreen({
    super.key,
  });

  @override
  State<EditQandAScreen> createState() => _EditQandAScreenState();
}

class _EditQandAScreenState extends State<EditQandAScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController questionController = TextEditingController();

  TextEditingController answerController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  QandAModel currentQandA = QandAModel.defaultQandA;

  @override
  void initState() {
    Future.delayed(Duration.zero).then((_) {
      final state = context.read<QandABloc>().state;
      state.maybeWhen(
        success: (_) {},
        orElse: () => context.go('/q&a'),
      );

      currentQandA = context.read<QandABloc>().currentQandA.value;
      titleController.text = currentQandA.title;
      questionController.text = currentQandA.question;
      answerController.text = currentQandA.answer;
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Row(
                children: [
                  Text('Article ID: ${currentQandA.id}'),
                  const Spacer(),
                  const Text(
                    'Edit article',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20),
                  ),
                  const Spacer(),
                  _buttonsBlock()
                ],
              ),
              MyTextField(
                controller: titleController,
                hint: 'Title',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter title';
                  }
                  return null;
                },
              ),
              MyTextField(
                controller: questionController,
                hint: 'Question',
                maxLines: 6,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter question text';
                  }
                  return null;
                },
              ),
              MyTextField(
                controller: answerController,
                hint: 'Answer',
                maxLines: 6,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter answer text';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Row _buttonsBlock() {
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
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              final updatedArticle = currentQandA.copyWith(
                title: titleController.text,
                question: questionController.text,
                answer: answerController.text,
              );
              getIt<QandABloc>().add(QandAEvent.edit(
                user: context.read<AuthBloc>().icocUser,
                article: updatedArticle,
              ));
              await Future.delayed(Durations.extralong4);
              getIt<QandABloc>().add(QandAEvent.requested(
                lang: updatedArticle.lang,
              ));
              await Future.delayed(Durations.extralong4);
              getIt<QandABloc>().currentQandA.value = updatedArticle;

              context.pop();
            }
          },
          label: 'Save',
        ),
      ],
    );
  }
}
