import 'dart:convert';

import 'package:firebase_cloud_firestore/firebase_cloud_firestore.dart';
import 'package:icoc_admin_pannel/constants.dart';
import 'package:icoc_admin_pannel/domain/data_sources/ai_data_source.dart';
import 'package:icoc_admin_pannel/domain/data_sources/firebase_data_source.dart';
import 'package:icoc_admin_pannel/domain/helpers/json_parsing.dart';
import 'package:icoc_admin_pannel/domain/model/notifications/notifications_model.dart';
import 'package:icoc_admin_pannel/domain/model/user.dart';
import 'package:icoc_admin_pannel/domain/repository/notifications_repository.dart';
import 'package:injectable/injectable.dart';
import 'package:langchain/langchain.dart';

@dev
@prod
@Injectable(as: NotificationsRepository)
class NotificationsRepositoryImpl extends NotificationsRepository {
  final FirebaseDataSource firebaseDataSource;
  final AiDataSource aiDataSource;

  NotificationsRepositoryImpl(this.firebaseDataSource, this.aiDataSource);
  @override
  Future<List<NotificationsModel>> getNotifications() async {
    final QuerySnapshot snapshot = await firebaseDataSource
        .getFromFirebase(FirebaseCollections.Notifications.name);
    final List<NotificationsModel> notifications = snapshot.docs.map(
      (doc) {
        final Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return NotificationsModel.fromJson(
          data,
        );
      },
    ).toList();

    return notifications;
  }

  @override
  Future<List<NotificationsModel>> addNotifications(
      IcocUser? user, NotificationsModel notification) async {
    final QuerySnapshot snapshot = await firebaseDataSource.postToFirebase(
        user, FirebaseCollections.Notifications.name, notification.toJson());
    final List<NotificationsModel> notifications = snapshot.docs.map(
      (doc) {
        final Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return NotificationsModel.fromJson(
          data,
        );
      },
    ).toList();

    return notifications;
  }

  @override
  Future<List<NotificationsModel>> addNotificationVersion(
      IcocUser? user, NotificationsModel notification) async {
    final QuerySnapshot snapshot = await firebaseDataSource.updateToFirebase(
        user,
        FirebaseCollections.Notifications.name,
        notification.id,
        notification.toJson());
    final List<NotificationsModel> notifications = snapshot.docs.map(
      (doc) {
        final Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return NotificationsModel.fromJson(
          data,
        );
      },
    ).toList();

    return notifications;
  }

  @override
  Future<List<NotificationsModel>> deleteNotifications(
      IcocUser? user, String id) async {
    final QuerySnapshot snapshot = await firebaseDataSource.deleteToFirebase(
        user, FirebaseCollections.Notifications.name, id);
    final List<NotificationsModel> notifications = snapshot.docs.map(
      (doc) {
        final Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return NotificationsModel.fromJson(
          data,
        );
      },
    ).toList();

    return notifications;
  }

  @override
  Future<List<NotificationVersion>> getTranslations(
      List<String> languages, NotificationVersion notification) async {
    final outputTemplate = {
      'translations': languages
          .asMap()
          .entries
          .map(
            (entry) => {
              'id': '${(entry.key + 1).toString()} in  String format',
              'lang': entry.value,
              'title': 'Translated title',
              'text': 'Translated text',
              'isRead': false
            },
          )
          .toList()
    };

    final promptTemplate = PromptTemplate.fromTemplate(r'''
          translate the following message to the given languages:
          {languages}, \n
          The message contains the following title and text:
          title: {title}
          text: {text}
          \n
          return translated messages as valid JSON using the following structure:
          
            {outputTemplate}
        
          ''');

    final query = {
      'title': notification.title,
      'text': notification.text,
      'languages': languages,
      'outputTemplate': outputTemplate
    };

    final json = await aiDataSource.getAiResponse(promptTemplate, query);
    final List<NotificationVersion> notifications =
        (json['translations'] as List<dynamic>).map((translation) {
      return NotificationVersion.fromJson(translation);
    }).toList();
    return notifications;
  }
}
