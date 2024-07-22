import 'package:firebase_cloud_firestore/firebase_cloud_firestore.dart';
import 'package:icoc_admin_pannel/constants.dart';
import 'package:icoc_admin_pannel/domain/data_sources/firebase_data_source.dart';
import 'package:icoc_admin_pannel/domain/model/notifications/notifications_model.dart';
import 'package:icoc_admin_pannel/domain/model/user.dart';
import 'package:icoc_admin_pannel/domain/repository/notifications_repository.dart';
import 'package:injectable/injectable.dart';

@dev
@prod
@Injectable(as: NotificationsRepository)
class NotificationsRepositoryImpl extends NotificationsRepository {
  final FirebaseDataSource firebaseDataSource;

  NotificationsRepositoryImpl(this.firebaseDataSource);
  @override
  Future<List<NotificationsModel>> getNotifications() async {
    final QuerySnapshot snapshot = await firebaseDataSource
        .getFromFirebase(FirebaseCollections.Notifications.name);
    final List<NotificationsModel> notifications = snapshot.docs.map(
      (doc) {
        final Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return NotificationsModel.fromJson(
          data,
        );
      },
    ).toList();

    return notifications;
  }

  @override
  Future<List<NotificationsModel>> addNotifications(
      IcocUser? user, NotificationsModel notification) async {
    final QuerySnapshot snapshot = await firebaseDataSource.postToFirebase(
        user, FirebaseCollections.Notifications.name, notification.toJson());
    final List<NotificationsModel> notifications = snapshot.docs.map(
      (doc) {
        final Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return NotificationsModel.fromJson(
          data,
        );
      },
    ).toList();

    return notifications;
  }

  @override
  Future<List<NotificationsModel>> addNotificationVersion(
      IcocUser? user, NotificationsModel notification) async {
    final QuerySnapshot snapshot = await firebaseDataSource.updateToFirebase(
        user,
        FirebaseCollections.Notifications.name,
        notification.id,
        notification.toJson());
    final List<NotificationsModel> notifications = snapshot.docs.map(
      (doc) {
        final Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return NotificationsModel.fromJson(
          data,
        );
      },
    ).toList();

    return notifications;
  }

  @override
  Future<List<NotificationsModel>> deleteNotifications(
      IcocUser? user, String id) async {
    final QuerySnapshot snapshot = await firebaseDataSource.deleteToFirebase(
        user, FirebaseCollections.Notifications.name, id);
    final List<NotificationsModel> notifications = snapshot.docs.map(
      (doc) {
        final Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return NotificationsModel.fromJson(
          data,
        );
      },
    ).toList();

    return notifications;
  }
}
