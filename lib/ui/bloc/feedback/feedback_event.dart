part of 'feedback_bloc.dart';

@freezed
class FeedbackEvent with _$FeedbackEvent {
  const factory FeedbackEvent.get() = FeedbackGet;
  const factory FeedbackEvent.edit(
      {required IcocUser? user,
      required FeedbackModel feedback}) = FeedbackEdit;
  const factory FeedbackEvent.delete(
      {required IcocUser? user, required String feedbackId}) = FeedbackDelete;
}
