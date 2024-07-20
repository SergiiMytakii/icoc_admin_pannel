import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:icoc_admin_pannel/domain/model/notifications_model.dart';
import 'package:icoc_admin_pannel/ui/bloc/auth/auth_bloc.dart';
import 'package:icoc_admin_pannel/ui/bloc/notifications/notifications_bloc.dart';
import 'package:icoc_admin_pannel/ui/widget/my_text_button.dart';
import 'package:icoc_admin_pannel/ui/widget/my_text_field.dart';
import 'package:icoc_admin_pannel/ui/widget/select_lang.dart';

class AddNewNotificationScreen extends StatefulWidget {
  const AddNewNotificationScreen({
    super.key,
  });

  @override
  State<AddNewNotificationScreen> createState() =>
      _AddNewNotificationScreenState();
}

class _AddNewNotificationScreenState extends State<AddNewNotificationScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController textController = TextEditingController();
  TextEditingController langController = TextEditingController()..text = 'ru';
  TextEditingController urlController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    Future.delayed(Duration.zero).then((_) {
      final state = context.read<NotificationsBloc>().state;

      state.maybeWhen(
        success: (_) {},
        orElse: () => context.go('/notifications'),
      );
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
        child: ListView(
          children: [
            Row(
              children: [
                SelectLanguageWidget(langController: langController),
                const Spacer(),
                const Text(
                  'Add a new notification',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20),
                ),
                const Spacer(),
                _buttonsBlock()
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
              maxLines: 10,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the text in text or  HTML format';
                }
                return null;
              },
            ),
            MyTexField(
              controller: urlController,
              hint: 'Link (optional)',
            ),
          ],
        ),
      ),
    ));
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
              context.read<NotificationsBloc>().add(
                    NotificationsEvent.add(
                      user: context.read<AuthBloc>().icocUser,
                      notification: NotificationsModel(
                        id: DateTime.now().toString(),
                        notifications: [
                          NotificationVersion(
                            id: DateTime.now().toString(),
                            title: titleController.text,
                            text: textController.text,
                            lang: langController.text,
                            link: urlController.text,
                          ),
                        ],
                      ),
                    ),
                  );
              context.pop();
            }
          },
          label: 'Save',
        ),
      ],
    );
  }
}
