import 'package:icoc_admin_pannel/domain/model/feedback.dart';

abstract class FeedbackRepository {
  Future<List<Feedback>> getFeedbackList();
  Future<List<Feedback>> editFeedback(String feedbackId);
  Future<List<Feedback>> deleteFeedback(String feedbackId);
}
