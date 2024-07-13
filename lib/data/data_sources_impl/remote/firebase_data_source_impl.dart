import 'package:firebase_cloud_firestore/firebase_cloud_firestore.dart';
import 'package:icoc_admin_pannel/domain/data_sources/firebase_data_source.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';

@dev
@prod
@Injectable(as: FirebaseDataSource)
class DatabaseServiceFirebase implements FirebaseDataSource {
  var log = Logger();
  final db = FirebaseFirestore.instance;

  DatabaseServiceFirebase() {
    db.settings = const Settings(persistenceEnabled: true);
  }

  //get songs
  @override
  Future<QuerySnapshot> getFromFirebase(String collectionName,
      {dynamic orderBy, bool? descending}) async {
    final CollectionReference collection = db.collection(collectionName);
    if (descending != null && orderBy != null) {
      return collection.orderBy(orderBy, descending: descending).get();
    } else {
      return await collection.get();
    }
  }

  @override
  Future<QuerySnapshot> updateToFirebase(
      String collectionName, int id, Map<String, dynamic> data) async {
    final CollectionReference collection = db.collection(collectionName);
    final DocumentReference documentRef = collection.doc(id.toString());
    await documentRef.update(data);
    final QuerySnapshot snapshot = await collection.get();
    return snapshot;
  }

  @override
  Future<QuerySnapshot> postToFirebase(
      String collectionName, Map<String, dynamic> data) async {
    final CollectionReference collection = db.collection(collectionName);
    final DocumentReference documentRef = collection.doc(data['id'].toString());
    await documentRef.set(data, SetOptions(merge: true));
    final QuerySnapshot snapshot = await collection.get();
    return snapshot;
  }
}
