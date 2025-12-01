import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:icoc_admin_pannel/firebase_options.dart';
import 'package:icoc_admin_pannel/domain/model/notifications/notifications_model.dart';

class AdminPushSender {
  static const String _region = String.fromEnvironment('functionsRegion',
      defaultValue: 'europe-central2');
  final String _base =
      'https://$_region-${DefaultFirebaseOptions.currentPlatform.projectId}.cloudfunctions.net';

  Future<void> sendTopic({
    required String topic,
    required String title,
    required String body,
    required String id,
    Map<String, String>? data,
  }) async {
    final token = await FirebaseAuth.instance.currentUser?.getIdToken();
    if (token == null) throw Exception('Not authenticated');
    final uri = Uri.parse('$_base/sendTopic');
    final payload = {
      'topic': topic,
      'title': title,
      'body': body,
      'data': {
        'route': 'notifications',
        'id': id,
        ...?data,
      }
    };
    final res = await http.post(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode(payload),
    );
    if (res.statusCode != 200) {
      throw Exception(res.body);
    }
  }

  Future<void> sendByLanguages(NotificationsModel n,
      {String baseTopic = 'notifications',
      List<String>? filterLanguages}) async {
    final versions = n.notifications.where(
        (v) => filterLanguages == null || filterLanguages.contains(v.lang));
    for (final v in versions) {
      final data = {
        'topic': baseTopic,
        'lang': v.lang,
        if (v.link != null && v.link!.isNotEmpty) 'link': v.link!,
      };
      await sendTopic(
        topic: '$baseTopic-lang-${v.lang}',
        title: v.title,
        body: v.text,
        id: n.id,
        data: data,
      );
    }
  }
}
