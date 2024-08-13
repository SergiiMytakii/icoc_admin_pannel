import 'package:flutter/material.dart';
import 'package:icoc_admin_pannel/domain/model/bible_study/bible_study.dart';

class BibleStudyCard extends StatelessWidget {
  final BibleStudy bibleStudy;
  const BibleStudyCard({super.key, required this.bibleStudy});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        children: [
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Text((bibleStudy.id + 1).toString()),
            title: Text(
              bibleStudy.topic,
              overflow: TextOverflow.ellipsis,
              maxLines: 3,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              bibleStudy.subtopic,
              overflow: TextOverflow.ellipsis,
              maxLines: 3,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            trailing: Text(bibleStudy.lang.name),
          ),
          const Divider(),
        ],
      ),
    );
  }
}
