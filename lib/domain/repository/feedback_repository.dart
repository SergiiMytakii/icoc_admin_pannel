import 'package:icoc_admin_pannel/domain/model/feedback/feedback_model.dart';
import 'package:icoc_admin_pannel/domain/model/user.dart';

abstract class FeedbackRepository {
  Future<List<FeedbackModel>> getFeedbackList();
  Future<List<FeedbackModel>> editFeedback(
      IcocUser? user, FeedbackModel feedback);
  Future<List<FeedbackModel>> deleteFeedback(IcocUser? user, String feedbackId);
}
