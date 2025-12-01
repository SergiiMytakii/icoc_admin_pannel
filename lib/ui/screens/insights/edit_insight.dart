import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:icoc_admin_pannel/domain/model/insights/post.dart';
import 'package:icoc_admin_pannel/injection.dart';
import 'package:icoc_admin_pannel/ui/bloc/auth/auth_bloc.dart';
import 'package:icoc_admin_pannel/ui/bloc/insights/insights_bloc.dart';
import 'package:icoc_admin_pannel/ui/widget/my_text_button.dart';
import 'package:icoc_admin_pannel/ui/widget/my_text_field.dart';

class EditInsightScreen extends StatefulWidget {
  const EditInsightScreen({super.key});

  @override
  State<EditInsightScreen> createState() => _EditInsightScreenState();
}

class _EditInsightScreenState extends State<EditInsightScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController titleController;
  late TextEditingController contentController;

  @override
  void initState() {
    final current = context.read<InsightsBloc>().currentPost.value;
    titleController = TextEditingController(text: current?.title ?? '');
    contentController = TextEditingController(text: current?.content ?? '');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final current = context.read<InsightsBloc>().currentPost.value;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Row(children: [
                const Spacer(),
                const Text('Edit Insight', style: TextStyle(fontSize: 20)),
                const Spacer(),
                _buttonsBlock()
              ]),
              MyTextField(
                  controller: titleController,
                  hint: 'Title',
                  validator: (v) =>
                      (v == null || v.isEmpty) ? 'Enter a title' : null),
              MyTextField(
                  controller: contentController, hint: 'Content', maxLines: 8),
            ],
          ),
        ),
      ),
    );
  }

  Row _buttonsBlock() {
    return Row(children: [
      MyTextButton(onPressed: () => context.pop(), label: 'Cancel'),
      const SizedBox(width: 12),
      MyTextButton(onPressed: _onSubmit, label: 'Save'),
    ]);
  }

  void _onSubmit() {
    if (_formKey.currentState!.validate()) {
      final current = context.read<InsightsBloc>().currentPost.value!;
      final edited = current.copyWith(
          title: titleController.text, content: contentController.text);
      context.read<InsightsBloc>().add(InsightsEvent.edit(
          user: context.read<AuthBloc>().icocUser, post: edited));
      context.pop();
    }
  }
}
