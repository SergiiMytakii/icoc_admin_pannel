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
        You are a professional translator. Your task is to translate the following message into the specified languages:
          {languages}

          Message to translate:
          Title: {title}
          Text: {text}

          Translation guidelines:
          1. Maintain the original structure and style of the text.
          2. Ensure the translation is culturally appropriate for each target language.
          3. Preserve any formatting or special characters present in the original text.

          Provide the translated messages as valid JSON using this structure:
          {outputTemplate}

          Remember to translate both the title and text for each language.
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
