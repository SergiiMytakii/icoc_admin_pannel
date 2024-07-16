part of 'feedback_bloc.dart';

@freezed
class FeedbackEvent with _$FeedbackEvent {
  const factory FeedbackEvent.get() = FeedbackGet;
  const factory FeedbackEvent.edit(String feedbackId) = FeedbackEdit;
  const factory FeedbackEvent.delete(String feedbackId) = FeedbackDelete;
}
