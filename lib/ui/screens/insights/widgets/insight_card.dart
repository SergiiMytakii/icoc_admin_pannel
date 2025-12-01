import 'package:flutter/material.dart';
import 'package:icoc_admin_pannel/domain/model/insights/post.dart';

class InsightCard extends StatelessWidget {
  final Post post;
  final String currentPostId;

  const InsightCard({super.key, required this.post, required this.currentPostId});

  @override
  Widget build(BuildContext context) {
    final isSelected = currentPostId == post.id;
    return Column(
      children: [
        ListTile(
          selectedColor: Theme.of(context).primaryColor,
          selected: isSelected,
          title: Text(
            post.title ?? '',
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                fontWeight: FontWeight.w500,
                color: isSelected ? Theme.of(context).primaryColor : null),
          ),
          subtitle: Text('${post.type.name} • ${post.language}'),
          trailing: Text(post.language),
          contentPadding: const EdgeInsets.symmetric(horizontal: 20),
        ),
        const Divider(),
      ],
    );
  }
}

