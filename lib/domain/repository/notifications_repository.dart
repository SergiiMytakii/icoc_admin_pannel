import 'package:icoc_admin_pannel/domain/model/notifications_model.dart';

abstract class NotificationsRepository {
  Future<List<Map<String, NotificationsModel>>> getNotifications();
}
