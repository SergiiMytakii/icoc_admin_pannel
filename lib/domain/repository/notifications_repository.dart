import 'package:icoc_admin_pannel/domain/model/notifications_model.dart';

abstract class NotificationsRepository {
  Future<List<Map<String, NotificationsModel>>> getNotifications();
  Future<List<Map<String, NotificationsModel>>> addNotifications(
      String lang, NotificationsModel notification);
  Future<List<Map<String, NotificationsModel>>> deleteNotifications(
      String lang, String id);
}
