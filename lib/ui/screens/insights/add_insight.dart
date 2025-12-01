import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:icoc_admin_pannel/constants.dart';
import 'package:icoc_admin_pannel/domain/model/insights/post.dart';
import 'package:icoc_admin_pannel/injection.dart';
import 'package:icoc_admin_pannel/ui/bloc/auth/auth_bloc.dart';
import 'package:icoc_admin_pannel/ui/bloc/insights/insights_bloc.dart';
import 'package:icoc_admin_pannel/ui/bloc/notifications/notifications_bloc.dart';
import 'package:icoc_admin_pannel/domain/model/notifications/notifications_model.dart';
import 'package:icoc_admin_pannel/ui/widget/my_text_button.dart';
import 'package:icoc_admin_pannel/ui/widget/my_text_field.dart';
import 'package:icoc_admin_pannel/ui/widget/select_lang.dart';
import 'package:icoc_admin_pannel/ui/widget/send_notification_checkbox.dart';

class AddInsightScreen extends StatefulWidget {
  const AddInsightScreen({super.key});

  @override
  State<AddInsightScreen> createState() => _AddInsightScreenState();
}

class _AddInsightScreenState extends State<AddInsightScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();
  final TextEditingController langController = TextEditingController()..text = 'en';
  final TextEditingController mediaUrlController = TextEditingController();
  final TextEditingController thumbUrlController = TextEditingController();
  final TextEditingController articleUrlController = TextEditingController();
  PostType type = PostType.text;
  bool sendNotifications = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Row(
                children: [
                  SelectLanguageWidget(langController: langController, label: 'Language'),
                  const Spacer(),
                  const Text('Add Insight', style: TextStyle(fontSize: 20)),
                  const Spacer(),
                  _buttonsBlock(),
                ],
              ),
              DropdownButton<PostType>(
                value: type,
                items: PostType.values
                    .map((t) => DropdownMenuItem(value: t, child: Text(t.name)))
                    .toList(),
                onChanged: (v) => setState(() => type = v ?? PostType.text),
              ),
              MyTextField(
                controller: titleController,
                hint: 'Title',
                validator: (v) => (v == null || v.isEmpty) ? 'Please enter a title' : null,
              ),
              MyTextField(
                controller: contentController,
                hint: 'Content',
                maxLines: 8,
              ),
              MyTextField(controller: mediaUrlController, hint: 'Media URL'),
              MyTextField(controller: thumbUrlController, hint: 'Thumbnail URL'),
              MyTextField(controller: articleUrlController, hint: 'Article URL'),
              Row(children: [const Spacer(), SendNotificationCheckBox(onChanged: (v) => sendNotifications = v)]),
            ],
          ),
        ),
      ),
    );
  }

  Row _buttonsBlock() {
    return Row(
      children: [
        MyTextButton(onPressed: () => context.pop(), label: 'Cancel'),
        const SizedBox(width: 12),
        MyTextButton(onPressed: _onSubmit, label: 'Save'),
      ],
    );
  }

  void _onSubmit() {
    if (_formKey.currentState!.validate()) {
      final author = PostAuthor(
        name: context.read<AuthBloc>().icocUser?.email ?? 'Admin',
        avatarUrl: '',
      );
      final id = DateTime.now().millisecondsSinceEpoch.toString();
      final post = Post(
        id: id,
        type: type,
        language: langController.text,
        title: titleController.text,
        content: contentController.text,
        mediaUrl: mediaUrlController.text,
        thumbnailUrl: thumbUrlController.text,
        articleUrl: articleUrlController.text,
        author: author,
        createdAt: DateTime.now(),
      );
      context.read<InsightsBloc>().add(InsightsEvent.add(user: context.read<AuthBloc>().icocUser, post: post));
      if (sendNotifications) {
        final link = '$ICOC_WEB_PAGE/insights/post/$id?lang=${langController.text}';
        final notification = NotificationsModel(
          id: DateTime.now().toString(),
          notifications: [
            NotificationVersion(
              id: '0',
              title: titleController.text,
              text: contentController.text,
              lang: langController.text,
              link: link,
            ),
          ],
        );
        context.read<NotificationsBloc>().add(NotificationsEvent.add(
              aditionalLanguages: const [],
              user: context.read<AuthBloc>().icocUser,
              notification: notification,
              baseTopic: 'insights',
            ));
      }
      context.pop();
    }
  }
}
