part of 'notifications_bloc.dart';

@freezed
class NotificationsEvent with _$NotificationsEvent {
  const factory NotificationsEvent.get() = NotificationsGet;

  const factory NotificationsEvent.add(
      String lang, NotificationsModel notification) = NotificationsAdd;
  const factory NotificationsEvent.delete(SongDetail song) =
      NotificationsDelete;
}
