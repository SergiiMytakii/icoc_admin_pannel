import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:icoc_admin_pannel/constants.dart';
import 'package:icoc_admin_pannel/domain/model/notifications/notifications_model.dart';
import 'package:icoc_admin_pannel/injection.dart';
import 'package:icoc_admin_pannel/ui/bloc/auth/auth_bloc.dart';
import 'package:icoc_admin_pannel/ui/bloc/notifications/notifications_bloc.dart';
import 'package:icoc_admin_pannel/ui/widget/alert_dialog.dart';
import 'package:icoc_admin_pannel/ui/widget/my_text_button.dart';
import 'package:icoc_admin_pannel/ui/widget/my_text_field.dart';
import 'package:icoc_admin_pannel/ui/widget/select_lang.dart';

class AddLangTab extends StatefulWidget {
  final NotificationsModel notificationsModel;
  const AddLangTab(
    this.notificationsModel, {
    super.key,
  });

  @override
  State<AddLangTab> createState() => _AddLangTabState();
}

class _AddLangTabState extends State<AddLangTab> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController langController = TextEditingController()..text = 'ru';
  TextEditingController textController = TextEditingController();
  TextEditingController urlController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Stack(
        children: [
          Form(
            key: _formKey,
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    children: [
                      SelectLanguageWidget(
                        langController: langController,
                        label: 'Languages',
                      ),
                      const Spacer(),
                      const Text(
                        'Add a new notification version',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 20),
                      ),
                      const Spacer(),
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
                  controller: descriptionController,
                  hint: 'Desctiption',
                  maxLength: 50,
                ),
                MyTextField(
                  controller: textController,
                  hint: 'Text',
                  maxLines: 15,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the text';
                    }
                    return null;
                  },
                ),
                MyTextField(
                  controller: urlController,
                  hint: 'Youtube link',
                ),
                const SizedBox(
                  height: 250,
                )
              ],
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: MyTextButton(
              onPressed: _save,
              label: 'Save',
            ),
          )
        ],
      ),
    );
  }

  void _save() async {
    if (_formKey.currentState!.validate()) {
      if (widget.notificationsModel
          .getLanguages()
          .contains(langController.text)) {
        showAlertDialog(context,
            'The notification in language ${languagesCodes[langController.text]} already exists',
            showCancelButton: true);
      } else if (await showAlertDialog(context,
          'The language of the notificationsModel is ${languagesCodes[langController.text]}?',
          showCancelButton: true)) {
        final notification = widget.notificationsModel.addVersion(
          title: titleController.text,
          description: descriptionController.text,
          text: textController.text,
          url: urlController.text,
          lang: langController.text,
        );
        getIt<NotificationsBloc>().add(NotificationsEvent.addVersion(
            user: getIt<AuthBloc>().icocUser, notification: notification));
        context.read<NotificationsBloc>().currentNotification.value =
            notification;
      }
    }
  }
}
