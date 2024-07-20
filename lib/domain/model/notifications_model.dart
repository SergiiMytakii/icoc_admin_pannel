import 'package:icoc_admin_pannel/domain/helpers/error_logger.dart';

class NotificationsModel {
  final String id;
  final List<NotificationVersion> notifications;

  NotificationsModel({
    required this.id,
    required this.notifications,
  });

  factory NotificationsModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return NotificationsModel(
      id: json['id'],
      notifications: (json['notifications'] as List<dynamic>)
          .map((notification) => NotificationVersion.fromJson(
              notification as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'notifications':
          notifications.map((notification) => notification.toJson()).toList(),
    };
  }
}

class NotificationsModelInitial extends NotificationsModel {
  NotificationsModelInitial({
    required super.id,
    required super.notifications,
  });
  static NotificationsModelInitial defaultNotification() {
    return NotificationsModelInitial(id: 'initial', notifications: [
      NotificationVersion(title: '', text: '', id: 'initial', lang: 'en')
    ]);
  }
}

class NotificationVersion {
  final String id;
  final String title;
  final String text;
  final String? link;
  final String lang;
  bool isRead;

  NotificationVersion({
    required this.title,
    required this.text,
    required this.id,
    required this.lang,
    this.link,
    this.isRead = false,
  });

  factory NotificationVersion.fromJson(
    Map json,
  ) {
    return NotificationVersion(
      id: json['id'],
      title: json['title'],
      text: json['text'],
      lang: json['lang'],
      link: json['link'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'text': text,
      'lang': lang,
      'link': link,
    };
  }
}
