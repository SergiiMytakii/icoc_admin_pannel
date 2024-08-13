import 'package:firebase_cloud_firestore/firebase_cloud_firestore.dart';
import 'package:icoc_admin_pannel/constants.dart';
import 'package:icoc_admin_pannel/domain/data_sources/firebase_data_source.dart';
import 'package:icoc_admin_pannel/domain/helpers/error_logger.dart';
import 'package:icoc_admin_pannel/domain/model/feedback/feedback_model.dart';
import 'package:icoc_admin_pannel/domain/model/user.dart';
import 'package:icoc_admin_pannel/domain/repository/feedback_repository.dart';
import 'package:injectable/injectable.dart';
import 'package:intl/intl.dart';

@dev
@prod
@Injectable(as: FeedbackRepository)
class FeedbackRepositoryImpl extends FeedbackRepository {
  final FirebaseDataSource firebaseDataSource;

  FeedbackRepositoryImpl(this.firebaseDataSource);
  @override
  Future<List<FeedbackModel>> getFeedbackList() async {
    final QuerySnapshot snapshot = await firebaseDataSource
        .getFromFirebase(FirebaseCollections.Feedback.name);
    final List<FeedbackModel> feedbacks = _listFromSnapshot(snapshot);
    return feedbacks.reversed.toList();
  }

  @override
  Future<List<FeedbackModel>> deleteFeedback(
      IcocUser? user, String feedbackId) async {
    final QuerySnapshot snapshot = await firebaseDataSource.deleteToFirebase(
        user, FirebaseCollections.Feedback.name, feedbackId);
    final List<FeedbackModel> feedbacks = _listFromSnapshot(snapshot);
    return feedbacks.reversed.toList();
  }

  @override
  Future<List<FeedbackModel>> editFeedback(
      IcocUser? user, FeedbackModel feedback) async {
    final QuerySnapshot snapshot = await firebaseDataSource.updateToFirebase(
        user,
        FirebaseCollections.Feedback.name,
        feedback.id,
        feedback.toJson());
    final List<FeedbackModel> feedbacks = _listFromSnapshot(snapshot);
    return feedbacks.reversed.toList();
  }
}

List<FeedbackModel> _listFromSnapshot(QuerySnapshot snapshot) {
  final List<FeedbackModel> feedbacks = snapshot.docs.map((doc) {
    final Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    //temporary while model will be changed in icoc app
    data['date'] ??= doc.id;
    data['id'] = doc.id;
    return FeedbackModel.fromJson(data);
  }).toList();
  return feedbacks;
}
