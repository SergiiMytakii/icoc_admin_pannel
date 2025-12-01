part of 'notifications_bloc.dart';

@freezed
class NotificationsEvent with _$NotificationsEvent {
  const factory NotificationsEvent.get() = NotificationsGet;

  const factory NotificationsEvent.add(
      {required IcocUser? user,
      required NotificationsModel notification,
      required List<String> aditionalLanguages,
      String? baseTopic}) = NotificationsAdd;
  const factory NotificationsEvent.addVersion(
      {required IcocUser? user,
      required NotificationsModel notification}) = NotificationsAddVersion;
  const factory NotificationsEvent.delete(
      {required IcocUser? user,
      required NotificationsModel notification}) = NotificationsDelete;
}
