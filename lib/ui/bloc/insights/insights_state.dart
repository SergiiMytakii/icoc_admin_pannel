part of 'insights_bloc.dart';

@freezed
class InsightsState with _$InsightsState {
  const factory InsightsState.initial() = InsightsInitial;
  const factory InsightsState.loading() = InsightsLoading;
  const factory InsightsState.success(List<Post> posts) = InsightsSuccess;
  const factory InsightsState.error(String message) = InsightsError;
}

