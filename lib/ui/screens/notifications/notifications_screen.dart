import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:icoc_admin_pannel/domain/model/notifications/notifications_model.dart';
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
            final currentNotification =
                context.read<NotificationsBloc>().currentNotification;
            if (currentNotification.value ==
                    NotificationsModel.defaultNotification() &&
                notifications.isNotEmpty) {
              currentNotification.value = notifications[0];
            }
            return Row(
              children: [
                Flexible(
                  child: ListView.builder(
                      itemCount: notifications.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                            onTap: () => currentNotification.value =
                                notifications[index],
                            child: NotificationCard(
                              notificationsModel: notifications[index],
                            ));
                      }),
                ),
                const VerticalDivider(thickness: 1, width: 1),
                Flexible(
                    flex: 2,
                    child: ValueListenableBuilder(
                        valueListenable: currentNotification,
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
