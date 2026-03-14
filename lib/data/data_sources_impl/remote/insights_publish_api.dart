import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

class InsightsPublishApi {
  InsightsPublishApi({
    this.endpoint =
        'https://europe-central2-icoc-8f075.cloudfunctions.net/upsertInsightsBatch',
  });

  final String endpoint;

  /// Publish or update up to 50 insight items via Cloud Function.
  Future<http.Response> upsertBatch({
    required List<Map<String, Object?>> items,
    String? bearerToken,
  }) async {
    final token = bearerToken ?? await FirebaseAuth.instance.currentUser?.getIdToken();
    if (token == null) throw Exception('Not authenticated');

    final res = await http.post(
      Uri.parse(endpoint),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({'items': items}),
    );

    if (res.statusCode != 200) {
      throw Exception('Publish failed: ${res.statusCode} ${res.body}');
    }
    return res;
  }
}
