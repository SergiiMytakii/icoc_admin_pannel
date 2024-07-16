import 'package:firebase_cloud_firestore/firebase_cloud_firestore.dart';
import 'package:icoc_admin_pannel/constants.dart';
import 'package:icoc_admin_pannel/domain/data_sources/firebase_data_source.dart';
import 'package:icoc_admin_pannel/domain/model/notifications_model.dart';
import 'package:icoc_admin_pannel/domain/repository/notifications_repository.dart';
import 'package:injectable/injectable.dart';

@dev
@prod
@Injectable(as: NotificationsRepository)
class NotificationsRepositoryImpl extends NotificationsRepository {
  final FirebaseDataSource firebaseDataSource;

  NotificationsRepositoryImpl(this.firebaseDataSource);
  @override
  Future<List<Map<String, NotificationsModel>>> getNotifications() async {
    final List<Map<String, NotificationsModel>> notifications = [];

    final QuerySnapshot snapshot = await firebaseDataSource
        .getFromFirebase(FirebaseCollections.Notifications.name);
    for (final doc in snapshot.docs) {
      final Map data = doc.data() as Map;
      final keys = data.keys;
      keys.forEach((key) {
        for (int i = 0; i < data[key].length; i++) {
          notifications.add({
            key: NotificationsModel(
                id: i,
                topic: doc.id,
                title: data[key][i]['title'],
                text: data[key][i]['text'],
                link: data[key][i]['link'])
          });
        }
      });
    }

    return notifications.reversed.toList();
  }

  @override
  Future<List<Map<String, NotificationsModel>>> addNotifications(
      String lang, NotificationsModel notification) {
    // TODO: implement addNotifications
    throw UnimplementedError();
  }

  @override
  Future<List<Map<String, NotificationsModel>>> deleteNotifications(
      String lang, String id) {
    // TODO: implement deleteNotifications
    throw UnimplementedError();
  }
}
