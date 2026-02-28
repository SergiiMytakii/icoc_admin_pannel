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

class AddVideoPlaylistScreen extends StatefulWidget {
  const AddVideoPlaylistScreen({super.key});

  @override
  State<AddVideoPlaylistScreen> createState() => _AddVideoPlaylistScreenState();
}

class _AddVideoPlaylistScreenState extends State<AddVideoPlaylistScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController langController = TextEditingController()
    ..text = 'en';
  final TextEditingController playlistIdController = TextEditingController();
  VideoContentType contentType = VideoContentType.playlist;
  bool sendNotifications = false;

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
                    'Add video content',
                    style: TextStyle(fontSize: 20),
                  ),
                  const Spacer(),
                  _buttonsBlock(),
                ],
              ),
              DropdownButton<VideoContentType>(
                value: contentType,
                items: VideoContentType.values
                    .map(
                      (type) => DropdownMenuItem(
                        value: type,
                        child: Text(
                          type == VideoContentType.playlist
                              ? 'Playlist'
                              : 'Single video',
                        ),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    contentType = value ?? VideoContentType.playlist;
                  });
                },
              ),
              MyTextField(
                controller: titleController,
                hint: contentType == VideoContentType.playlist
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
                hint: contentType == VideoContentType.playlist
                    ? 'YouTube playlist ID or URL'
                    : 'YouTube video ID or URL',
                validator: (value) {
                  final sourceId = _sourceIdFromInput(value ?? '');
                  if (sourceId.isEmpty) {
                    return contentType == VideoContentType.playlist
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
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final playlist = Playlist(
      id: DateTime.now().millisecondsSinceEpoch,
      title: titleController.text.trim(),
      lang: langController.text.trim(),
      description: descriptionController.text.trim(),
      playlistId: contentType == VideoContentType.playlist
          ? _sourceIdFromInput(playlistIdController.text)
          : null,
      videoId: contentType == VideoContentType.video
          ? _sourceIdFromInput(playlistIdController.text)
          : null,
      contentType: contentType,
    );

    context.read<VideosBloc>().add(
          VideosEvent.addPlaylist(
            user: context.read<AuthBloc>().icocUser,
            playlist: playlist,
          ),
        );

    if (sendNotifications) {
      final notification = NotificationsModel(
        id: DateTime.now().toIso8601String(),
        notifications: [
          NotificationVersion(
            id: '0',
            title: playlist.title,
            text: _notificationText(playlist.description),
            lang: playlist.lang,
            link: playlist.externalUrl,
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
      return 'New playlist is available';
    }
    if (trimmed.length <= 80) {
      return trimmed;
    }
    return '${trimmed.substring(0, 80)}...';
  }

  String _sourceIdFromInput(String input) {
    return contentType == VideoContentType.playlist
        ? getPlaylistId(input)
        : getVideoId(input.trim());
  }
}
