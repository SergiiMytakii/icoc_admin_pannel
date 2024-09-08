import 'package:flutter/material.dart';
import 'package:icoc_admin_pannel/domain/model/bible_study/bible_study.dart';

class BibleStudyCard extends StatelessWidget {
  final BibleStudy bibleStudy;
  final int currentBibleStudyId;
  const BibleStudyCard(
      {super.key, required this.bibleStudy, required this.currentBibleStudyId});

  @override
  Widget build(BuildContext context) {
    final isSelected = currentBibleStudyId == bibleStudy.id;
    return Column(
      children: [
        ListTile(
          selectedColor: Theme.of(context).primaryColor,
          selected: isSelected,
          leading: Text((bibleStudy.id + 1).toString()),
          title: Text(
            bibleStudy.topic,
            overflow: TextOverflow.ellipsis,
            maxLines: 3,
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                fontWeight: FontWeight.w600,
                color: isSelected ? Theme.of(context).primaryColor : null),
          ),
          subtitle: Text(
            bibleStudy.subtopic,
            overflow: TextOverflow.ellipsis,
            maxLines: 3,
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: isSelected ? Theme.of(context).primaryColor : null),
          ),
          trailing: Text(bibleStudy.lang.name),
        ),
        const Divider(),
      ],
    );
  }
}
