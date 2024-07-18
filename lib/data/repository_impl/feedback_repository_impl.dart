import 'package:firebase_cloud_firestore/firebase_cloud_firestore.dart';
import 'package:icoc_admin_pannel/constants.dart';
import 'package:icoc_admin_pannel/domain/data_sources/firebase_data_source.dart';
import 'package:icoc_admin_pannel/domain/model/feedback.dart';
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
  Future<List<Feedback>> getFeedbackList() async {
    final QuerySnapshot snapshot = await firebaseDataSource
        .getFromFirebase(FirebaseCollections.Feedback.name);
    final List<Feedback> feedbacks = _listFromSnapshot(snapshot);
    return feedbacks.reversed.toList();
  }

  @override
  Future<List<Feedback>> deleteFeedback(String feedbackId) {
    // TODO: implement deleteFeedback
    throw UnimplementedError();
  }

  @override
  Future<List<Feedback>> editFeedback(String feedbackId) {
    // TODO: implement editFeedback
    throw UnimplementedError();
  }
}

List<Feedback> _listFromSnapshot(QuerySnapshot snapshot) {
  final List<Feedback> feedbacks = snapshot.docs.map((doc) {
    final DateTime parsedDateTime = DateTime.parse(doc.id);
    final String formattedDate =
        DateFormat('dd.MM\nyyyy').format(parsedDateTime);
    return Feedback(
      date: formattedDate,
      text: doc.get('text') ?? '',
      name: doc.get('name') ?? '',
    );
  }).toList();
  return feedbacks;
}
