import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:icoc_admin_pannel/constants.dart';
import 'package:icoc_admin_pannel/domain/helpers/show_menu.dart';
import 'package:icoc_admin_pannel/domain/model/insights/post.dart';
import 'package:icoc_admin_pannel/domain/model/user.dart';
import 'package:icoc_admin_pannel/ui/bloc/auth/auth_bloc.dart';
import 'package:icoc_admin_pannel/ui/bloc/insights/insights_bloc.dart';
import 'package:icoc_admin_pannel/ui/screens/insights/widgets/insight_card.dart';
import 'package:icoc_admin_pannel/ui/widget/my_text_button.dart';
import 'package:url_launcher/url_launcher.dart';

class InsightsScreen extends StatefulWidget {
  const InsightsScreen({super.key});

  @override
  State<InsightsScreen> createState() => _InsightsScreenState();
}

class _InsightsScreenState extends State<InsightsScreen> {
  final TextEditingController _queryController = TextEditingController();
  String _language = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      final bool isAuthed = context.read<AuthBloc>().state.maybeWhen(
            authenticated: (_) => true,
            orElse: () => false,
          );
      if (isAuthed) {
        _loadPosts();
      }
    });
  }

  @override
  void dispose() {
    _queryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: <Widget>[
            _buildToolbar(),
            const SizedBox(height: 12),
            Expanded(
              child: BlocBuilder<InsightsBloc, InsightsState>(
                builder: (BuildContext context, InsightsState state) {
                  return state.maybeWhen(
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    success: (List<Post> posts) {
                      return ValueListenableBuilder<Post?>(
                        valueListenable:
                            context.read<InsightsBloc>().currentPost,
                        builder: (
                          BuildContext context,
                          Post? currentPost,
                          _,
                        ) {
                          final Post? selectedPost =
                              _resolveSelectedPost(posts, currentPost);
                          _syncSelectedPost(currentPost, selectedPost);
                          return Row(
                            children: <Widget>[
                              Expanded(
                                flex: 2,
                                child: posts.isEmpty
                                    ? const Center(
                                        child: Text('No insights found'),
                                      )
                                    : ListView.builder(
                                        itemCount: posts.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          final Post post = posts[index];
                                          return GestureDetector(
                                            onTap: () => context
                                                .read<InsightsBloc>()
                                                .currentPost
                                                .value = post,
                                            onSecondaryTapDown: (details) {
                                              showContextMenu(
                                                context,
                                                details.globalPosition,
                                                () => _deletePost(post),
                                              );
                                            },
                                            child: InsightCard(
                                              post: post,
                                              currentPostId:
                                                  selectedPost?.id ?? '',
                                            ),
                                          );
                                        },
                                      ),
                              ),
                              const VerticalDivider(thickness: 1, width: 1),
                              Expanded(
                                flex: 3,
                                child: selectedPost == null
                                    ? const Center(
                                        child: Text(
                                          'Select a post to preview it',
                                        ),
                                      )
                                    : KeyedSubtree(
                                        key: ValueKey<String>(
                                          'insight-details-${selectedPost.id}',
                                        ),
                                        child: _buildDetails(selectedPost),
                                      ),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    error: (String message) => Center(child: Text(message)),
                    orElse: () => const SizedBox.shrink(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToolbar() {
    return Row(
      children: <Widget>[
        const Text('Insights', style: TextStyle(fontSize: 20)),
        const SizedBox(width: 20),
        Expanded(
          child: TextField(
            controller: _queryController,
            onChanged: (_) => setState(() {}),
            onSubmitted: (_) => _loadPosts(),
            decoration: InputDecoration(
              hintText: 'Search by title, content, author',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _queryController.text.isEmpty
                  ? null
                  : IconButton(
                      onPressed: () {
                        _queryController.clear();
                        _loadPosts();
                        setState(() {});
                      },
                      icon: const Icon(Icons.clear),
                    ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        DropdownButton<String>(
          value: _language,
          underline: const SizedBox.shrink(),
          items: <DropdownMenuItem<String>>[
            const DropdownMenuItem<String>(
              value: '',
              child: Text('All languages'),
            ),
            ...languagesCodes.keys.map(
              (String language) => DropdownMenuItem<String>(
                value: language,
                child: Text(language.toUpperCase()),
              ),
            ),
          ],
          onChanged: (String? value) {
            setState(() {
              _language = value ?? '';
            });
            _loadPosts();
          },
        ),
        const SizedBox(width: 12),
        MyTextButton(onPressed: _loadPosts, label: 'Refresh'),
        const SizedBox(width: 12),
        MyTextButton(
          onPressed: () => context.go('/insights/add'),
          label: 'Add',
        ),
      ],
    );
  }

  Widget _buildDetails(Post post) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  post.title ?? '',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
              const SizedBox(width: 12),
              MyTextButton(
                onPressed: () => context.go('/insights/edit'),
                label: 'Edit',
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: <Widget>[
              _metaChip(post.type.name),
              _metaChip(post.language.toUpperCase()),
              _metaChip(post.status),
              _metaChip(post.allowComments ? 'comments on' : 'comments off'),
              _metaChip('likes ${post.likes}'),
              _metaChip('comments ${post.commentsCount}'),
              _metaChip('shares ${post.shares}'),
            ],
          ),
          const SizedBox(height: 16),
          _buildMediaPreview(post),
          const SizedBox(height: 16),
          Text(
            'Author',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Row(
            children: <Widget>[
              CircleAvatar(
                backgroundImage: (post.author.avatarUrl.trim().isNotEmpty)
                    ? NetworkImage(post.author.avatarUrl.trim())
                    : null,
                child: post.author.avatarUrl.trim().isEmpty
                    ? Text(post.author.name.trim().isEmpty
                        ? '?'
                        : post.author.name
                            .trim()
                            .characters
                            .first
                            .toUpperCase())
                    : null,
              ),
              const SizedBox(width: 12),
              Expanded(child: Text(post.author.name)),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Created ${DateFormat('yyyy-MM-dd HH:mm').format(post.createdAt.toLocal())}',
          ),
          const SizedBox(height: 12),
          Text(
            'Deep link',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          SelectableText(post.appDeepLink),
          if ((post.articleUrl ?? '').trim().isNotEmpty) ...<Widget>[
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                onPressed: () {
                  final uri = Uri.tryParse(post.articleUrl!.trim());
                  if (uri != null) {
                    launchUrl(
                      uri,
                      mode: LaunchMode.externalApplication,
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Invalid URL format'),
                      ),
                    );
                  }
                },
                icon: const Icon(Icons.open_in_new),
                label: const Text('Open source URL'),
              ),
            ),
          ],
          if ((post.content ?? '').trim().isNotEmpty) ...<Widget>[
            const SizedBox(height: 16),
            Text(
              'Content',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            SelectableText(post.content!.trim()),
          ],
        ],
      ),
    );
  }

  Widget _buildMediaPreview(Post post) {
    if (post.type == PostType.video) {
      final String? thumbnailUrl = post.thumbnailUrl;
      if (thumbnailUrl == null || thumbnailUrl.trim().isEmpty) {
        return const SizedBox.shrink();
      }
      return ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Align(
          alignment: Alignment.centerLeft,
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 640,
              maxHeight: 360,
            ),
            child: AspectRatio(
              aspectRatio: post.aspectRatioForIndex(
                0,
                fallback: (post.articleUrl ?? '').contains('/shorts/')
                    ? 9 / 16
                    : 16 / 9,
              ),
              child: Image.network(
                thumbnailUrl,
                key: ValueKey<String>('${post.id}:$thumbnailUrl'),
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const ColoredBox(
                  color: Color(0x11000000),
                  child: Center(child: Icon(Icons.broken_image_outlined)),
                ),
              ),
            ),
          ),
        ),
      );
    }

    if (post.type == PostType.text) {
      return DecoratedBox(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Padding(
          padding: EdgeInsets.all(24),
          child: Row(
            children: <Widget>[
              Icon(Icons.article_outlined),
              SizedBox(width: 12),
              Expanded(
                child: Text('Text-only insight. No media preview is attached.'),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if (post.primaryMediaUrl != null)
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 640,
                  maxHeight: 360,
                ),
                child: AspectRatio(
                  aspectRatio: post.aspectRatioForIndex(0),
                  child: Image.network(
                    post.primaryMediaUrl!,
                    key: ValueKey<String>(
                      '${post.id}:${post.primaryMediaUrl}',
                    ),
                    fit: BoxFit.cover,
                    webHtmlElementStrategy: WebHtmlElementStrategy.prefer,
                    errorBuilder: (_, __, ___) => const ColoredBox(
                      color: Color(0x11000000),
                      child: Center(child: Icon(Icons.broken_image_outlined)),
                    ),
                  ),
                ),
              ),
            ),
          ),
        if (post.mediaUrls.length > 1) ...<Widget>[
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: post.mediaUrls
                .skip(1)
                .map(
                  (String mediaUrl) => ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: SizedBox(
                      width: 96,
                      height: 96,
                      child: Image.network(
                        mediaUrl,
                        fit: BoxFit.cover,
                        webHtmlElementStrategy: WebHtmlElementStrategy.prefer,
                        errorBuilder: (_, __, ___) => const ColoredBox(
                          color: Color(0x11000000),
                          child: Center(
                            child: Icon(Icons.broken_image_outlined),
                          ),
                        ),
                      ),
                    ),
                  ),
                )
                .toList(growable: false),
          ),
        ],
      ],
    );
  }

  Widget _metaChip(String label) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: Text(label),
      ),
    );
  }

  void _loadPosts() {
    context.read<InsightsBloc>().add(
          InsightsEvent.get(
            query: _queryController.text.trim(),
            language: _language.isEmpty ? null : _language,
          ),
        );
  }

  Post? _resolveSelectedPost(List<Post> posts, Post? current) {
    if (current == null) {
      return posts.isEmpty ? null : posts.first;
    }
    for (final Post post in posts) {
      if (post.id == current.id) {
        return post;
      }
    }
    return posts.isEmpty ? null : posts.first;
  }

  void _syncSelectedPost(Post? current, Post? selectedPost) {
    final ValueNotifier<Post?> currentPostNotifier =
        context.read<InsightsBloc>().currentPost;
    if (current != selectedPost) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          currentPostNotifier.value = selectedPost;
        }
      });
    }
  }

  void _deletePost(Post post) {
    final IcocUser? user = context.read<AuthBloc>().icocUser;
    context.read<InsightsBloc>().add(
          InsightsEvent.delete(
            user: user,
            id: post.id,
          ),
        );
    final ValueNotifier<Post?> currentPostNotifier =
        context.read<InsightsBloc>().currentPost;
    if (currentPostNotifier.value?.id == post.id) {
      currentPostNotifier.value = null;
    }
  }
}
