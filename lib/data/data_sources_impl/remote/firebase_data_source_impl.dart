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
  Future<QuerySnapshot> getFromFirebase(
    String collectionName, {
    Map<String, dynamic>? filters,
    Map<String, dynamic>? search,
    Map<String, bool>? orderBy,
  }) async {
    Query query = db.collection(collectionName);
    if (filters != null && filters.isNotEmpty) {
      for (var filter in filters.entries) {
        query = query.where(filter.key, isEqualTo: filter.value);
      }
    }
    if (search != null && search.isNotEmpty) {
      for (var search in search.entries) {
        query = query.where(search.key, arrayContains: search.value);
      }
    }

    if (orderBy != null && orderBy.isNotEmpty) {
      return query
          .orderBy(orderBy.entries.first.key,
              descending: orderBy.entries.first.value)
          .get();
    } else {
      return await query.get();
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
      IcocUser? user, String collectionName, Map<String, dynamic> data,
      {String? docReference}) async {
    final CollectionReference collection = db.collection(collectionName);

    final DocumentReference documentRef =
        collection.doc(docReference ?? data['id'].toString());
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
  Future<void> updateQandALangsFirebase() async {
    final CollectionReference collection =
        db.collection(FirebaseCollections.QandA.name);
    final QuerySnapshot snapshot = await collection.get();
    final Set<String> fields = {};
    for (final doc in snapshot.docs) {
      final String res = doc.get('lang');

      fields.add(res);
    }
    final CollectionReference langsCollection =
        db.collection(FirebaseCollections.QandALangs.name);
    langsCollection.doc('languages').set({'QandAlangs': fields});
  }

  @override
  Future<void> logToFirebase(IcocUser? user, String eventName,
      String collectionName, Map<String, dynamic> data) async {
    if (user != null && !user.isAdmin) {
      final CollectionReference collection =
          db.collection(FirebaseCollections.UsersLogs.name);
      final DocumentReference documentRef =
          collection.doc('${DateTime.now()}_${user.email}');
      final map = {
        'user': user.email,
        'eventName': eventName,
        'collection': collectionName,
        'data': data,
        'timestamp': DateTime.now()
      };
      // Logger().f(map);
      await documentRef.set(map);
    }
  }
}
