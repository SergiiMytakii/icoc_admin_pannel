import 'package:firebase_cloud_firestore/firebase_cloud_firestore.dart';
import 'package:icoc_admin_pannel/constants.dart';
import 'package:icoc_admin_pannel/domain/data_sources/firebase_data_source.dart';
import 'package:icoc_admin_pannel/domain/model/user.dart';
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
  Future<QuerySnapshot> updateToFirebase(IcocUser? user, String collectionName,
      String id, Map<String, dynamic> data) async {
    final CollectionReference collection = db.collection(collectionName);
    final DocumentReference documentRef = collection.doc(id);
    await documentRef.update(data);
    logToFirebase(user, 'Update', collectionName, data);
    final QuerySnapshot snapshot = await collection.get();
    return snapshot;
  }

  @override
  Future<QuerySnapshot> postToFirebase(
      IcocUser? user, String collectionName, Map<String, dynamic> data) async {
    final CollectionReference collection = db.collection(collectionName);
    final DocumentReference documentRef = collection.doc(data['id'].toString());
    await documentRef.set(data, SetOptions(merge: true));
    logToFirebase(user, 'Post', collectionName, data);
    final QuerySnapshot snapshot = await collection.get();
    return snapshot;
  }

  @override
  Future<QuerySnapshot> deleteToFirebase(
      IcocUser? user, String collectionName, String id) async {
    final CollectionReference collection = db.collection(collectionName);
    final DocumentReference documentRef = collection.doc(id.toString());
    await documentRef.delete();
    logToFirebase(user, 'Delete', collectionName, {'id': id});
    final QuerySnapshot snapshot = await collection.get();
    return snapshot;
  }

  @override
  Future<void> logToFirebase(IcocUser? user, String eventName,
      String collectionName, Map<String, dynamic> data) async {
    final CollectionReference collection =
        db.collection(FirebaseCollections.UsersLogs.name);
    final DocumentReference documentRef =
        collection.doc('${DateTime.now()}_${user?.email}');
    final map = {
      'user': user?.email ?? 'Unauthenticated',
      'eventName': eventName,
      'collection': collectionName,
      'data': data,
      'timestamp': DateTime.now()
    };
    // Logger().f(map);
    await documentRef.set(map);
  }
}
