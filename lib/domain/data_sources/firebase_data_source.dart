import 'package:firebase_cloud_firestore/firebase_cloud_firestore.dart';

abstract class FirebaseDataSource {
  Future<QuerySnapshot> getFromFirebase(String collection,
      {dynamic orderBy, bool? descending});
  Future<QuerySnapshot> postToFirebase(
      String collection, Map<String, String> data);
}
