import 'dart:async';
import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:icoc_admin_pannel/domain/helpers/get_video_id.dart';
import 'package:icoc_admin_pannel/domain/model/insights/post.dart';
import 'package:icoc_admin_pannel/domain/model/notifications/notifications_model.dart';
import 'package:icoc_admin_pannel/ui/bloc/auth/auth_bloc.dart';
import 'package:icoc_admin_pannel/ui/bloc/insights/insights_bloc.dart';
import 'package:icoc_admin_pannel/ui/bloc/notifications/notifications_bloc.dart';
import 'package:icoc_admin_pannel/ui/widget/my_text_button.dart';
import 'package:icoc_admin_pannel/ui/widget/my_text_field.dart';
import 'package:icoc_admin_pannel/ui/widget/select_lang.dart';
import 'package:universal_html/html.dart' as html;

class InsightEditorScreen extends StatefulWidget {
  const InsightEditorScreen({
    super.key,
    this.initialPost,
  });

  final Post? initialPost;

  bool get isEditing => initialPost != null;

  @override
  State<InsightEditorScreen> createState() => _InsightEditorScreenState();
}

class _InsightEditorScreenState extends State<InsightEditorScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _contentController;
  late final TextEditingController _langController;
  late final TextEditingController _authorNameController;
  late final TextEditingController _authorAvatarUrlController;
  late final TextEditingController _youtubeUrlController;
  late final String _postId;

  late PostType _type;
  late String _status;
  late bool _allowComments;
  bool _sendNotifications = false;
  bool _isSaving = false;
  String? _localValidationError;
  NotificationsModel? _pendingNotification;
  final List<_ExistingInsightImage> _existingImages = <_ExistingInsightImage>[];
  final List<_PendingInsightImage> _pendingImages = <_PendingInsightImage>[];

  @override
  void initState() {
    super.initState();
    final Post? post = widget.initialPost;
    _postId = post?.id ?? DateTime.now().millisecondsSinceEpoch.toString();
    final String defaultAuthorName =
        _defaultAuthorName(context.read<AuthBloc>().icocUser?.email);
    _titleController = TextEditingController(text: post?.title ?? '');
    _contentController = TextEditingController(text: post?.content ?? '');
    _langController = TextEditingController(text: post?.language ?? 'en');
    _authorNameController = TextEditingController(
      text: post?.author.name ?? defaultAuthorName,
    );
    _authorAvatarUrlController = TextEditingController(
      text: post?.author.avatarUrl ??
          'https://firebasestorage.googleapis.com/v0/b/icoc-8f075.appspot.com/o/insights%2FICOC%20logo%20small.png?alt=media&token=20824f12-2b58-49ae-9f0f-71e36a13a63e',
    );
    _youtubeUrlController = TextEditingController(
      text: _initialYoutubeValue(post),
    );
    _type = post?.type ?? PostType.image;
    _status = post?.status ?? 'published';
    _allowComments = post?.allowComments ?? true;
    if (post != null) {
      for (int index = 0; index < post.mediaUrls.length; index++) {
        _existingImages.add(
          _ExistingInsightImage(
            url: post.mediaUrls[index],
            aspectRatio: post.aspectRatioForIndex(index),
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _langController.dispose();
    _authorNameController.dispose();
    _authorAvatarUrlController.dispose();
    _youtubeUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<InsightsBloc, InsightsState>(
        listener: (BuildContext context, InsightsState state) {
          if (!_isSaving) {
            return;
          }
          state.whenOrNull(
            success: (List<Post> posts) {
              _isSaving = false;
              Post? savedPost;
              for (final Post post in posts) {
                if (post.id == _postId) {
                  savedPost = post;
                  break;
                }
              }
              if (savedPost != null) {
                context.read<InsightsBloc>().currentPost.value = savedPost;
              }
              if (_pendingNotification != null) {
                context.read<NotificationsBloc>().add(
                      NotificationsEvent.add(
                        user: context.read<AuthBloc>().icocUser,
                        notification: _pendingNotification!,
                        aditionalLanguages: const <String>[],
                        baseTopic: 'insights',
                      ),
                    );
                _pendingNotification = null;
              }
              if (mounted) {
                context.pop();
              }
            },
            error: (String message) {
              setState(() {
                _isSaving = false;
                _localValidationError = message;
                _pendingNotification = null;
              });
            },
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: ListView(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    SelectLanguageWidget(
                      langController: _langController,
                      label: 'Language',
                    ),
                    const Spacer(),
                    Text(
                      widget.isEditing ? 'Edit Insight' : 'Add Insight',
                      style: const TextStyle(fontSize: 20),
                    ),
                    const Spacer(),
                    _buttonsBlock(),
                  ],
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<PostType>(
                  initialValue: _type,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Post type',
                  ),
                  items: PostType.values
                      .map(
                        (PostType type) => DropdownMenuItem<PostType>(
                          value: type,
                          child: Text(type.name),
                        ),
                      )
                      .toList(growable: false),
                  onChanged: _isSaving
                      ? null
                      : (PostType? value) {
                          if (value == null) {
                            return;
                          }
                          setState(() {
                            _type = value;
                            _localValidationError = null;
                          });
                        },
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  initialValue: _status,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Status',
                  ),
                  items: const <DropdownMenuItem<String>>[
                    DropdownMenuItem<String>(
                      value: 'published',
                      child: Text('published'),
                    ),
                    DropdownMenuItem<String>(
                      value: 'draft',
                      child: Text('draft'),
                    ),
                  ],
                  onChanged: _isSaving
                      ? null
                      : (String? value) {
                          if (value == null) {
                            return;
                          }
                          setState(() {
                            _status = value;
                          });
                        },
                ),
                const SizedBox(height: 12),
                MyTextField(
                  controller: _titleController,
                  hint: 'Title',
                  validator: (String? value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a title';
                    }
                    return null;
                  },
                ),
                MyTextField(
                  controller: _contentController,
                  hint: 'Content',
                  maxLines: 8,
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: MyTextField(
                        controller: _authorNameController,
                        hint: 'Author name',
                        validator: (String? value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter an author name';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: MyTextField(
                        controller: _authorAvatarUrlController,
                        hint: 'Author avatar URL',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                if (_type == PostType.video) ...<Widget>[
                  MyTextField(
                    controller: _youtubeUrlController,
                    hint: 'YouTube URL or video ID',
                    validator: (String? value) {
                      if (_resolveVideoId(value ?? '').isEmpty) {
                        return 'Please enter a YouTube URL or video ID';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 8),
                  _buildVideoPreview(),
                ] else ...<Widget>[
                  Row(
                    children: <Widget>[
                      TextButton(
                        onPressed: _isSaving ? null : _pickImages,
                        child: const Text(
                          'Select images',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        '${_existingImages.length + _pendingImages.length} image(s) selected',
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'You can upload one or multiple photos. They will be stored in Firebase Storage and attached to the post.',
                  ),
                  const SizedBox(height: 12),
                  if (_existingImages.isNotEmpty || _pendingImages.isNotEmpty)
                    _buildImagesGrid(),
                ],
                const SizedBox(height: 12),
                CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Allow comments'),
                  value: _allowComments,
                  onChanged: _isSaving
                      ? null
                      : (bool? value) {
                          setState(() {
                            _allowComments = value ?? true;
                          });
                        },
                ),
                CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Send push notification'),
                  subtitle: const Text(
                    'Push uses a deep link and opens this post in the app.',
                  ),
                  value: _sendNotifications,
                  onChanged: _isSaving
                      ? null
                      : (bool? value) {
                          setState(() {
                            _sendNotifications = value ?? false;
                          });
                        },
                ),
                if (_status == 'draft' && _sendNotifications)
                  const Padding(
                    padding: EdgeInsets.only(bottom: 8),
                    child: Text(
                      'Draft posts cannot send notifications. Publish the post first.',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                if (_localValidationError != null &&
                    _localValidationError!.trim().isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      _localValidationError!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Row _buttonsBlock() {
    return Row(
      children: <Widget>[
        MyTextButton(
          onPressed: _isSaving ? () {} : () => context.pop(),
          label: 'Cancel',
        ),
        const SizedBox(width: 12),
        if (_isSaving)
          const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          )
        else
          MyTextButton(onPressed: _onSubmit, label: 'Save'),
      ],
    );
  }

  Widget _buildVideoPreview() {
    final String videoId = _resolveVideoId(_youtubeUrlController.text);
    if (videoId.isEmpty) {
      return const SizedBox.shrink();
    }
    final String thumbnailUrl =
        'https://img.youtube.com/vi/$videoId/hqdefault.jpg';
    final double aspectRatio =
        _isShortsUrl(_normalizedYoutubeUrl(_youtubeUrlController.text))
            ? 9 / 16
            : 16 / 9;
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: AspectRatio(
        aspectRatio: aspectRatio,
        child: Image.network(
          thumbnailUrl,
          fit: BoxFit.cover,
          webHtmlElementStrategy: WebHtmlElementStrategy.prefer,
          errorBuilder: (_, __, ___) => DecoratedBox(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
            ),
            child: const Center(child: Icon(Icons.broken_image_outlined)),
          ),
        ),
      ),
    );
  }

  Widget _buildImagesGrid() {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: <Widget>[
        for (int index = 0; index < _existingImages.length; index++)
          _buildImageTile(
            image: Image.network(
              _existingImages[index].url,
              fit: BoxFit.cover,
              webHtmlElementStrategy: WebHtmlElementStrategy.prefer,
              errorBuilder: (_, __, ___) => const ColoredBox(
                color: Color(0x11000000),
                child: Center(child: Icon(Icons.broken_image_outlined)),
              ),
            ),
            label: 'Uploaded',
            onRemove: _isSaving
                ? null
                : () {
                    setState(() {
                      _existingImages.removeAt(index);
                    });
                  },
          ),
        for (int index = 0; index < _pendingImages.length; index++)
          _buildImageTile(
            image: Image.memory(
              _pendingImages[index].bytes,
              fit: BoxFit.cover,
            ),
            label: 'New',
            onRemove: _isSaving
                ? null
                : () {
                    setState(() {
                      _pendingImages.removeAt(index);
                    });
                  },
          ),
      ],
    );
  }

  Widget _buildImageTile({
    required Widget image,
    required String label,
    required VoidCallback? onRemove,
  }) {
    return Stack(
      children: <Widget>[
        SizedBox(
          width: 170,
          height: 170,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Stack(
              fit: StackFit.expand,
              children: <Widget>[
                image,
                Positioned(
                  left: 8,
                  bottom: 8,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.6),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      child: Text(
                        label,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          top: 8,
          right: 8,
          child: IconButton.filledTonal(
            onPressed: onRemove,
            icon: const Icon(Icons.close),
          ),
        ),
      ],
    );
  }

  Future<void> _pickImages() async {
    try {
      final List<_PendingInsightImage> files =
          await _InsightImagePicker.pickImages();
      if (files.isEmpty) {
        return;
      }
      setState(() {
        _pendingImages.addAll(files);
        _localValidationError = null;
      });
    } catch (error) {
      setState(() {
        _localValidationError = 'Image selection failed: $error';
      });
    }
  }

  Future<void> _onSubmit() async {
    if (_isSaving) {
      return;
    }
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final String title = _titleController.text.trim();
    final String? content = _normalizedOrNull(_contentController.text);
    final String? authorAvatarUrl =
        _normalizedOrNull(_authorAvatarUrlController.text);
    final String authorName = _authorNameController.text.trim();
    final String language = _langController.text.trim();

    if (_type == PostType.image &&
        _existingImages.isEmpty &&
        _pendingImages.isEmpty) {
      setState(() {
        _localValidationError = 'Please select at least one image';
      });
      return;
    }

    if (_sendNotifications && _status == 'draft') {
      setState(() {
        _localValidationError =
            'Draft posts cannot send notifications. Publish the post first.';
      });
      return;
    }

    setState(() {
      _isSaving = true;
      _localValidationError = null;
    });

    try {
      final String postId = _postId;
      final List<_StoredInsightImage> storedImages = <_StoredInsightImage>[
        ..._existingImages.map(
          (_ExistingInsightImage image) => _StoredInsightImage(
            url: image.url,
            aspectRatio: image.aspectRatio,
          ),
        ),
      ];

      if (_type == PostType.image && _pendingImages.isNotEmpty) {
        storedImages.addAll(
          await _uploadPendingImages(postId, _pendingImages),
        );
      }

      final String videoId = _resolveVideoId(_youtubeUrlController.text);
      final String? articleUrl = _type == PostType.video
          ? _normalizedYoutubeUrl(_youtubeUrlController.text)
          : null;
      final bool isShorts = _type == PostType.video && _isShortsUrl(articleUrl);

      final Post post = Post(
        id: postId,
        type: _type,
        language: language,
        title: title,
        content: content,
        mediaUrls: _type == PostType.image
            ? storedImages.map((image) => image.url).toList(growable: false)
            : const <String>[],
        thumbnailUrl: _type == PostType.video && videoId.isNotEmpty
            ? 'https://img.youtube.com/vi/$videoId/hqdefault.jpg'
            : null,
        youtubeId: _type == PostType.video ? videoId : null,
        articleUrl: articleUrl,
        mediaAspectRatios: _type == PostType.image
            ? storedImages
                .map((image) => image.aspectRatio)
                .toList(growable: false)
            : <double>[isShorts ? 9 / 16 : 16 / 9],
        author: PostAuthor(
          name: authorName,
          avatarUrl: authorAvatarUrl ?? '',
        ),
        createdAt: widget.initialPost?.createdAt ?? DateTime.now(),
        status: _status,
        allowComments: _allowComments,
        likes: widget.initialPost?.likes ?? 0,
        commentsCount: widget.initialPost?.commentsCount ?? 0,
        shares: widget.initialPost?.shares ?? 0,
      );

      _pendingNotification = null;
      if (_sendNotifications) {
        _pendingNotification = NotificationsModel(
          id: DateTime.now().toIso8601String(),
          notifications: <NotificationVersion>[
            NotificationVersion(
              id: '0',
              title: post.title?.trim().isNotEmpty == true
                  ? post.title!.trim()
                  : 'New insight',
              text: _notificationText(post),
              lang: post.language,
              link: post.appDeepLink,
            ),
          ],
        );
      }
      context.read<InsightsBloc>().currentPost.value = post;
      final InsightsBloc bloc = context.read<InsightsBloc>();
      bloc.add(
        widget.isEditing
            ? InsightsEvent.edit(
                user: context.read<AuthBloc>().icocUser,
                post: post,
              )
            : InsightsEvent.add(
                user: context.read<AuthBloc>().icocUser,
                post: post,
              ),
      );
    } catch (error) {
      if (!mounted) {
        return;
      }
      setState(() {
        _isSaving = false;
        _localValidationError = error.toString();
        _pendingNotification = null;
      });
    }
  }

  Future<List<_StoredInsightImage>> _uploadPendingImages(
    String postId,
    List<_PendingInsightImage> images,
  ) async {
    final FirebaseStorage storage = FirebaseStorage.instance;
    final List<_StoredInsightImage> uploaded = <_StoredInsightImage>[];

    for (int index = 0; index < images.length; index++) {
      final _PendingInsightImage image = images[index];
      final String sanitizedFileName =
          image.fileName.replaceAll(RegExp(r'[^a-zA-Z0-9._-]'), '_');
      final String path =
          'insights/$postId/${DateTime.now().millisecondsSinceEpoch}_${index}_$sanitizedFileName';
      final Reference reference = storage.ref().child(path);
      final SettableMetadata metadata = SettableMetadata(
        contentType: image.contentType,
        customMetadata: <String, String>{
          'postId': postId,
        },
      );
      try {
        await reference.putData(image.bytes, metadata);
        final String url = await reference.getDownloadURL();
        uploaded.add(
          _StoredInsightImage(
            url: url,
            aspectRatio: image.aspectRatio,
          ),
        );
      } catch (e) {
        throw Exception('Failed to upload image $sanitizedFileName: $e');
      }
    }

    return uploaded;
  }

  String _resolveVideoId(String input) => getVideoId(input.trim());

  String _normalizedYoutubeUrl(String input) {
    final String trimmed = input.trim();
    final String resolvedId = _resolveVideoId(trimmed);
    if (resolvedId.isEmpty) {
      return trimmed;
    }
    if (trimmed.startsWith('http://') || trimmed.startsWith('https://')) {
      return trimmed;
    }
    return 'https://www.youtube.com/watch?v=$resolvedId';
  }

  bool _isShortsUrl(String? url) =>
      url != null && url.trim().contains('/shorts/');

  String _notificationText(Post post) {
    final String source = (post.content ?? post.title ?? '').trim();
    if (source.isEmpty) {
      return widget.isEditing ? 'Insight updated' : 'New insight is available';
    }
    if (source.length <= 120) {
      return source;
    }
    return '${source.substring(0, 120)}...';
  }

  String? _normalizedOrNull(String value) {
    final String trimmed = value.trim();
    if (trimmed.isEmpty) {
      return null;
    }
    return trimmed;
  }

  String _defaultAuthorName(String? email) {
    final String trimmed = (email ?? '').trim();
    if (trimmed.isEmpty) {
      return 'ICOC Admin';
    }
    final int delimiterIndex = trimmed.indexOf('@');
    if (delimiterIndex > 0) {
      return trimmed.substring(0, delimiterIndex);
    }
    return trimmed;
  }

  String _initialYoutubeValue(Post? post) {
    if (post == null || post.type != PostType.video) {
      return '';
    }
    if ((post.articleUrl ?? '').trim().isNotEmpty) {
      return post.articleUrl!.trim();
    }
    if ((post.youtubeId ?? '').trim().isNotEmpty) {
      return 'https://www.youtube.com/watch?v=${post.youtubeId!.trim()}';
    }
    return '';
  }
}

class _ExistingInsightImage {
  const _ExistingInsightImage({
    required this.url,
    required this.aspectRatio,
  });

  final String url;
  final double aspectRatio;
}

class _PendingInsightImage {
  const _PendingInsightImage({
    required this.bytes,
    required this.fileName,
    required this.contentType,
    required this.aspectRatio,
  });

  final Uint8List bytes;
  final String fileName;
  final String contentType;
  final double aspectRatio;
}

class _StoredInsightImage {
  const _StoredInsightImage({
    required this.url,
    required this.aspectRatio,
  });

  final String url;
  final double aspectRatio;
}

class _InsightImagePicker {
  static Future<List<_PendingInsightImage>> pickImages() async {
    final html.FileUploadInputElement input = html.FileUploadInputElement()
      ..accept = 'image/*'
      ..multiple = true;
    input.click();

    await input.onChange.first;
    final List<html.File> files = input.files ?? <html.File>[];
    final List<_PendingInsightImage> images = <_PendingInsightImage>[];

    for (final html.File file in files) {
      final Uint8List bytes = await _readFileAsBytes(file);
      final String contentType =
          file.type.trim().isNotEmpty ? file.type.trim() : 'image/jpeg';
      final double aspectRatio =
          await _resolveAspectRatio(bytes, contentType: contentType);
      images.add(
        _PendingInsightImage(
          bytes: bytes,
          fileName: file.name,
          contentType: contentType,
          aspectRatio: aspectRatio,
        ),
      );
    }

    return images;
  }

  static Future<Uint8List> _readFileAsBytes(html.File file) {
    final Completer<Uint8List> completer = Completer<Uint8List>();
    final html.FileReader reader = html.FileReader();
    reader.onError.listen((_) {
      completer.completeError('Unable to read ${file.name}');
    });
    reader.onLoad.listen((_) {
      final Object? result = reader.result;
      if (result is Uint8List) {
        completer.complete(result);
        return;
      }
      if (result is ByteBuffer) {
        completer.complete(Uint8List.view(result));
        return;
      }
      completer.completeError('Unsupported file format for ${file.name}');
    });
    reader.readAsArrayBuffer(file);
    return completer.future;
  }

  static Future<double> _resolveAspectRatio(
    Uint8List bytes, {
    required String contentType,
  }) async {
    final Completer<double> completer = Completer<double>();
    final html.Blob blob = html.Blob(<Object>[bytes], contentType);
    final String objectUrl = html.Url.createObjectUrlFromBlob(blob);
    final html.ImageElement image = html.ImageElement()..src = objectUrl;

    StreamSubscription<html.Event>? loadSubscription;
    StreamSubscription<html.Event>? errorSubscription;

    void cleanup() {
      loadSubscription?.cancel();
      errorSubscription?.cancel();
      html.Url.revokeObjectUrl(objectUrl);
    }

    loadSubscription = image.onLoad.listen((_) {
      if (!completer.isCompleted) {
        final int width = image.naturalWidth;
        final int height = image.naturalHeight;
        cleanup();
        if (width > 0 && height > 0) {
          completer.complete(width / height);
        } else {
          completer.complete(1);
        }
      }
    });

    errorSubscription = image.onError.listen((_) {
      if (!completer.isCompleted) {
        cleanup();
        completer.complete(1);
      }
    });

    return completer.future.timeout(
      const Duration(seconds: 10),
      onTimeout: () {
        cleanup();
        return 1;
      },
    );
  }
}
