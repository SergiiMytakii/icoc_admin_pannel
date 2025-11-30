part of 'notifications_bloc.dart';

@freezed
class NotificationsState with _$NotificationsState {
  const factory NotificationsState.initial() = _NotificationsInitialState;
  const factory NotificationsState.loading() = _NotificationsLoadingState;
  const factory NotificationsState.error(String errorMessage) =
      _NotificationsErrorState;
  const factory NotificationsState.success(
          List<NotificationsModel> notifications) =
      _NotificationsSuccessState;
}
