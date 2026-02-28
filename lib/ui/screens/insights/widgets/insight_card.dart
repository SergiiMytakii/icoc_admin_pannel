import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:icoc_admin_pannel/domain/model/insights/post.dart';

class InsightCard extends StatelessWidget {
  const InsightCard({
    super.key,
    required this.post,
    required this.currentPostId,
  });

  final Post post;
  final String currentPostId;

  @override
  Widget build(BuildContext context) {
    final bool isSelected = currentPostId == post.id;
    final ThemeData theme = Theme.of(context);
    final String? previewImage =
        post.type == PostType.video ? post.thumbnailUrl : post.primaryMediaUrl;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: isSelected
            ? theme.colorScheme.primaryContainer.withValues(alpha: 0.72)
            : theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isSelected
              ? theme.colorScheme.primary
              : theme.dividerColor.withValues(alpha: 0.15),
          width: isSelected ? 2 : 1,
        ),
        boxShadow: isSelected
            ? <BoxShadow>[
                BoxShadow(
                  color: theme.colorScheme.primary.withValues(alpha: 0.18),
                  blurRadius: 14,
                  offset: const Offset(0, 6),
                ),
              ]
            : null,
      ),
      child: ListTile(
        selected: isSelected,
        contentPadding: const EdgeInsets.all(12),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: SizedBox(
            width: 64,
            height: 64,
            child: previewImage == null || previewImage.trim().isEmpty
                ? ColoredBox(
                    color: theme.colorScheme.surfaceContainerHighest,
                    child: Icon(
                      post.type == PostType.video
                          ? Icons.play_circle_outline
                          : Icons.photo_outlined,
                    ),
                  )
                : Image.network(
                    previewImage,
                    fit: BoxFit.cover,
                    webHtmlElementStrategy: WebHtmlElementStrategy.prefer,
                    errorBuilder: (_, __, ___) => ColoredBox(
                      color: theme.colorScheme.surfaceContainerHighest,
                      child: Icon(
                        post.type == PostType.video
                            ? Icons.play_circle_outline
                            : Icons.photo_outlined,
                      ),
                    ),
                  ),
          ),
        ),
        title: Text(
          post.title ?? 'Untitled post',
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text('${post.type.name} • ${post.language.toUpperCase()}'),
              Text(post.author.name),
              Text(
                DateFormat('yyyy-MM-dd HH:mm').format(post.createdAt.toLocal()),
              ),
            ],
          ),
        ),
        trailing: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 120),
          child: IntrinsicWidth(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(post.status),
                const SizedBox(height: 4),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.thumb_up, size: 16),
                    const SizedBox(width: 4),
                    Text('${post.likes}'),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
