import 'package:flutter/material.dart';
import 'package:icoc_admin_pannel/domain/model/notifications/notifications_model.dart';
import 'package:icoc_admin_pannel/injection.dart';
import 'package:icoc_admin_pannel/ui/bloc/auth/auth_bloc.dart';
import 'package:icoc_admin_pannel/ui/bloc/notifications/notifications_bloc.dart';
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
          title: Text(
            notificationsModel.notifications.first.title,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          subtitle: Text(
            DateFormat('MMM d, yyyy HH:mm')
                .format(DateTime.parse(notificationsModel.id)),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          trailing: IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              getIt<NotificationsBloc>().add(NotificationsEvent.delete(
                  notification: notificationsModel,
                  user: getIt<AuthBloc>().icocUser));
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
