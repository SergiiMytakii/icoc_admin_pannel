import 'package:icoc_admin_pannel/domain/model/feedback.dart';

abstract class FeedbackRepository {
  Future<List<Feedback>> getFeedbackList();
  Future<List<Feedback>> insertFeedback(String name, String feedback);
}
