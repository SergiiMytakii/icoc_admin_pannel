import 'package:flutter/material.dart';
import 'package:icoc_admin_pannel/domain/helpers/extract_text_from_html.dart';
import 'package:icoc_admin_pannel/domain/model/notifications_model.dart';
import 'package:intl/intl.dart';

class NotificationCard extends StatelessWidget {
  final NotificationsModel notificationsModel;

  NotificationCard({
    super.key,
    required this.notificationsModel,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          horizontalTitleGap: 12,
          leading: const SizedBox(
            width: 20,
          ),
          // Text(notificationsModel.id.toString(),
          //     style: Theme.of(context).textTheme.titleSmall),
          title: Text(
            notificationsModel.notifications.first.title,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          subtitle: Text(
            DateFormat('MMM d, yyyy HH:mm').format(
                DateTime.parse(notificationsModel.notifications.first.id)),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          trailing: IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              // delete notification
            },
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 20),
        ),
        const Divider(
          indent: 50,
          thickness: 1.2,
        ),
      ],
    );
  }
}
