import 'package:flutter/material.dart';
import 'package:icoc_admin_pannel/domain/model/q&a/q&a_model.dart';

class QandACard extends StatelessWidget {
  final QandAModel article;
  final int currentQandAId;

  const QandACard({
    super.key,
    required this.article,
    required this.currentQandAId,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = currentQandAId == article.id;
    return Column(
      children: [
        ListTile(
          selectedColor: Theme.of(context).primaryColor,
          selected: isSelected,
          leading: Text(article.id.toString()),
          contentPadding: const EdgeInsets.symmetric(horizontal: 20),
          title: Text(
            article.title,
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                fontWeight: FontWeight.bold,
                color: isSelected ? Theme.of(context).primaryColor : null),
          ),
          subtitle: Text(article.author ?? ''),
        ),
        const Divider(),
      ],
    );
  }
}
