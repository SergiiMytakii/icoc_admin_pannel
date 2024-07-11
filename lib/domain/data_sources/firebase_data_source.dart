import 'package:firebase_cloud_firestore/firebase_cloud_firestore.dart';

abstract class FirebaseDataSource {
  Future<QuerySnapshot> getFromFirebase(String collection,
      {dynamic orderBy, bool? descending});
  Future<QuerySnapshot> updateToFirebase(
      String collection, int id, Map<String, dynamic> data);

  Future<QuerySnapshot> postToFirebase(
      String collection, Map<String, String> data);
}
