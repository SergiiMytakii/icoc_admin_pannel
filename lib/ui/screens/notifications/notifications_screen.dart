import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:icoc_admin_pannel/injection.dart';
import 'package:icoc_admin_pannel/ui/bloc/notifications/notifications_bloc.dart';
import 'package:icoc_admin_pannel/ui/screens/notifications/widget/notification_card.dart';
import 'package:icoc_admin_pannel/ui/screens/notifications/widget/one_notification.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Builder(builder: (context) {
      final state = context.watch<NotificationsBloc>().state;
      return state.when(
          initial: () {
            getIt<NotificationsBloc>().add(const NotificationsEvent.get());
            return const SizedBox.shrink();
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (message) => Center(child: Text(message)),
          success: (notifications) {
            return Row(
              children: [
                Flexible(
                  child: ListView.builder(
                      itemCount: notifications.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                            onTap: () => context
                                .read<NotificationsBloc>()
                                .currentNotification
                                .value = notifications.reversed.toList()[index],
                            child: ValueListenableBuilder(
                                valueListenable: context
                                    .read<NotificationsBloc>()
                                    .currentNotification,
                                builder: (context, currentNotification, _) {
                                  return NotificationCard(
                                    notificationsModel:
                                        notifications.reversed.toList()[index],
                                    currentNotificationId:
                                        currentNotification.id,
                                  );
                                }));
                      }),
                ),
                const VerticalDivider(thickness: 1, width: 1),
                Flexible(
                    flex: 2,
                    child: ValueListenableBuilder(
                        valueListenable: context
                            .read<NotificationsBloc>()
                            .currentNotification,
                        builder: (context, notification, _) {
                          return OneNotification(
                            notificationsModel: notification,
                          );
                        }))
              ],
            );
          });
    }));
  }
}
