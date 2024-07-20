import 'package:icoc_admin_pannel/domain/model/notifications_model.dart';
import 'package:icoc_admin_pannel/domain/model/user.dart';

abstract class NotificationsRepository {
  Future<List<NotificationsModel>> getNotifications();
  Future<List<NotificationsModel>> addNotifications(
      IcocUser? user, NotificationsModel notification);
  Future<List<NotificationsModel>> deleteNotifications(
      IcocUser? user, String id);
}
