import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:icoc_admin_pannel/domain/helpers/get_playlist_id.dart';
import 'package:icoc_admin_pannel/domain/helpers/get_video_id.dart';
import 'package:icoc_admin_pannel/domain/model/notifications/notifications_model.dart';
import 'package:icoc_admin_pannel/domain/model/playlist.dart';
import 'package:icoc_admin_pannel/ui/bloc/auth/auth_bloc.dart';
import 'package:icoc_admin_pannel/ui/bloc/notifications/notifications_bloc.dart';
import 'package:icoc_admin_pannel/ui/bloc/videos/videos_bloc.dart';
import 'package:icoc_admin_pannel/ui/widget/my_text_button.dart';
import 'package:icoc_admin_pannel/ui/widget/my_text_field.dart';
import 'package:icoc_admin_pannel/ui/widget/select_lang.dart';
import 'package:icoc_admin_pannel/ui/widget/send_notification_checkbox.dart';

class EditVideoPlaylistScreen extends StatefulWidget {
  const EditVideoPlaylistScreen({super.key});

  @override
  State<EditVideoPlaylistScreen> createState() =>
      _EditVideoPlaylistScreenState();
}

class _EditVideoPlaylistScreenState extends State<EditVideoPlaylistScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController titleController;
  late final TextEditingController descriptionController;
  late final TextEditingController langController;
  late final TextEditingController playlistIdController;
  bool sendNotifications = false;
  Playlist? currentPlaylist;

  @override
  void initState() {
    super.initState();
    currentPlaylist = context.read<VideosBloc>().currentPlaylist.value;
    titleController = TextEditingController(text: currentPlaylist?.title ?? '');
    descriptionController =
        TextEditingController(text: currentPlaylist?.description ?? '');
    langController = TextEditingController(text: currentPlaylist?.lang ?? 'en');
    playlistIdController =
        TextEditingController(text: currentPlaylist?.sourceId ?? '');
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    langController.dispose();
    playlistIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (currentPlaylist == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          context.go('/video');
        }
      });
      return const Scaffold(body: SizedBox.shrink());
    }

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Row(
                children: [
                  SelectLanguageWidget(
                    langController: langController,
                    label: 'Language',
                  ),
                  const Spacer(),
                  const Text(
                    'Edit video content',
                    style: TextStyle(fontSize: 20),
                  ),
                  const Spacer(),
                  _buttonsBlock(),
                ],
              ),
              MyTextField(
                controller: titleController,
                hint: currentPlaylist!.isPlaylist
                    ? 'Playlist title'
                    : 'Video title',
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              MyTextField(
                controller: descriptionController,
                hint: 'Description',
                maxLines: 6,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              MyTextField(
                controller: playlistIdController,
                hint: currentPlaylist!.isPlaylist
                    ? 'YouTube playlist ID or URL'
                    : 'YouTube video ID or URL',
                validator: (value) {
                  if (_sourceIdFromInput(value ?? '').isEmpty) {
                    return currentPlaylist!.isPlaylist
                        ? 'Please enter a playlist ID or URL'
                        : 'Please enter a video ID or URL';
                  }
                  return null;
                },
              ),
              Row(
                children: [
                  const Spacer(),
                  SendNotificationCheckBox(
                    onChanged: (value) => sendNotifications = value,
                  ),
                ],
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
        MyTextButton(onPressed: () => context.pop(), label: 'Cancel'),
        const SizedBox(width: 12),
        MyTextButton(onPressed: _onSubmit, label: 'Save'),
      ],
    );
  }

  void _onSubmit() {
    if (!_formKey.currentState!.validate() || currentPlaylist == null) {
      return;
    }

    final updatedPlaylist = currentPlaylist!.copyWith(
      title: titleController.text.trim(),
      lang: langController.text.trim(),
      description: descriptionController.text.trim(),
      playlistId: currentPlaylist!.isPlaylist
          ? _sourceIdFromInput(playlistIdController.text)
          : null,
      videoId: currentPlaylist!.isVideo
          ? _sourceIdFromInput(playlistIdController.text)
          : null,
    );

    context.read<VideosBloc>().add(
          VideosEvent.editPlaylist(
            user: context.read<AuthBloc>().icocUser,
            playlist: updatedPlaylist,
          ),
        );

    if (sendNotifications) {
      final notification = NotificationsModel(
        id: DateTime.now().toIso8601String(),
        notifications: [
          NotificationVersion(
            id: '0',
            title: updatedPlaylist.title,
            text: _notificationText(updatedPlaylist.description),
            lang: updatedPlaylist.lang,
            link: updatedPlaylist.appDeepLink,
          ),
        ],
      );
      context.read<NotificationsBloc>().add(
            NotificationsEvent.add(
              user: context.read<AuthBloc>().icocUser,
              notification: notification,
              aditionalLanguages: const [],
              baseTopic: 'video',
            ),
          );
    }

    context.pop();
  }

  String _notificationText(String description) {
    final trimmed = description.trim();
    if (trimmed.isEmpty) {
      return 'Playlist was updated';
    }
    if (trimmed.length <= 80) {
      return trimmed;
    }
    return '${trimmed.substring(0, 80)}...';
  }

  String _sourceIdFromInput(String input) {
    return currentPlaylist!.isPlaylist
        ? getPlaylistId(input)
        : getVideoId(input.trim());
  }
}
