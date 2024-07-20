part of 'notifications_bloc.dart';

@freezed
class NotificationsEvent with _$NotificationsEvent {
  const factory NotificationsEvent.get() = NotificationsGet;

  const factory NotificationsEvent.add(
      {required IcocUser? user,
      required NotificationsModel notification}) = NotificationsAdd;
  const factory NotificationsEvent.delete(IcocUser user, SongDetail song) =
      NotificationsDelete;
}
