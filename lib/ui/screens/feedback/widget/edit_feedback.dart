import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:icoc_admin_pannel/domain/model/feedback/feedback_model.dart';
import 'package:icoc_admin_pannel/injection.dart';
import 'package:icoc_admin_pannel/ui/bloc/auth/auth_bloc.dart';
import 'package:icoc_admin_pannel/ui/bloc/feedback/feedback_bloc.dart';
import 'package:icoc_admin_pannel/ui/widget/my_text_button.dart';
import 'package:icoc_admin_pannel/ui/widget/my_text_field.dart';

class EditFeedbackScreen extends StatefulWidget {
  const EditFeedbackScreen({
    super.key,
  });

  @override
  State<EditFeedbackScreen> createState() => _EditFeedbackScreenState();
}

class _EditFeedbackScreenState extends State<EditFeedbackScreen> {
  TextEditingController textController = TextEditingController();

  TextEditingController commentController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  FeedbackModel currentFeedback = FeedbackModel.defaultFeedback();

  @override
  void initState() {
    Future.delayed(Duration.zero).then((_) {
      final state = context.read<FeedbackBloc>().state;
      state.maybeWhen(
        success: (feedbacks) {},
        orElse: () => context.go('/feedback'),
      );

      currentFeedback = context.read<FeedbackBloc>().currentFeedback.value;
      textController.text = currentFeedback.text;
      commentController.text = currentFeedback.comment ?? '';
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
                  Text('Feedback ID: ${currentFeedback.id}'),
                  const Spacer(),
                  const Text(
                    'Edit Feedback',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20),
                  ),
                  const Spacer(),
                  _buttonsBlock()
                ],
              ),
              MyTextField(
                controller: textController,
                hint: 'Feedback Text',
                maxLines: 5,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter feedback text';
                  }
                  return null;
                },
              ),
              MyTextField(
                controller: commentController,
                hint: 'Comment (optional)',
                maxLines: 3,
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
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              final updatedFeedback = FeedbackModel(
                id: currentFeedback.id,
                text: textController.text,
                name: currentFeedback.name,
                date: currentFeedback.date,
                comment: commentController.text.isNotEmpty
                    ? commentController.text
                    : null,
              );
              getIt<FeedbackBloc>().add(FeedbackEvent.edit(
                user: context.read<AuthBloc>().icocUser,
                feedback: updatedFeedback,
              ));
              getIt<FeedbackBloc>().currentFeedback.value = updatedFeedback;

              context.pop();
            }
          },
          label: 'Save',
        ),
      ],
    );
  }
}
