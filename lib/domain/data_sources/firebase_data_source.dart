import 'package:firebase_cloud_firestore/firebase_cloud_firestore.dart';
import 'package:icoc_admin_pannel/domain/model/user.dart';

abstract class FirebaseDataSource {
  Future<QuerySnapshot> getFromFirebase(String collection,
      {dynamic orderBy, bool? descending});
  Future<QuerySnapshot> updateToFirebase(
      IcocUser? user, String collection, int id, Map<String, dynamic> data);

  Future<QuerySnapshot> postToFirebase(
      IcocUser? user, String collection, Map<String, dynamic> data);

  Future<QuerySnapshot> deleteToFirebase(
      IcocUser? user, String collection, String id);

  Future<void> logToFirebase(IcocUser? user, String eventName,
      String collectionName, Map<String, dynamic> data);
}
