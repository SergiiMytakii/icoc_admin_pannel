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
        for (final Map notification in data[key]) {
          notifications.add({
            key: NotificationsModel(
                topic: doc.id,
                title: notification['title'],
                text: notification['text'],
                link: notification['link'])
          });
        }
      });
    }

    return notifications.reversed.toList();
  }
}
