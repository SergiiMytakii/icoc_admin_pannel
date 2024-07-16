import 'package:icoc_admin_pannel/domain/model/identifable.dart';

class NotificationsModel implements Identifiable {
  @override
  final int id;
  final String title;
  final String text;
  final String? topic;
  final String? link;
  bool isRead;
  NotificationsModel(
      {required this.title,
      required this.text,
      required this.id,
      this.topic,
      this.link,
      this.isRead = false});
}
