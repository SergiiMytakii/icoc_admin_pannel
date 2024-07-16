part of 'feedback_bloc.dart';

@freezed
class FeedbackState with _$FeedbackState {
  const factory FeedbackState.initial() = _FeedbackInitialState;
  const factory FeedbackState.loading() = _FeedbackLoadingState;
  const factory FeedbackState.error(String errorMessage) = _FeedbackErrorState;
  const factory FeedbackState.success(List<Feedback> feedbacks) =
      _FeedbackSuccessState;
}
