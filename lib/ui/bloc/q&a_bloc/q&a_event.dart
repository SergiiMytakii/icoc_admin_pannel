part of 'q&a_bloc.dart';

@freezed
sealed class QandAEvent with _$QandAEvent {
  const factory QandAEvent.requested({String? query, required Languages lang}) =
      QandARequested;
  const factory QandAEvent.getLangs() = QandAGetLangs;
  const factory QandAEvent.edit(
      {required IcocUser? user, required QandAModel article}) = QandAEdit;
  const factory QandAEvent.delete(
      {required IcocUser? user, required String docReference}) = QandADelete;
}
