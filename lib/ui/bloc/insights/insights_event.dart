part of 'insights_bloc.dart';

@freezed
class InsightsEvent with _$InsightsEvent {
  const factory InsightsEvent.get({String? query, String? language}) = InsightsGet;
  const factory InsightsEvent.add({required IcocUser? user, required Post post}) = InsightsAdd;
  const factory InsightsEvent.edit({required IcocUser? user, required Post post}) = InsightsEdit;
  const factory InsightsEvent.delete({required IcocUser? user, required String id}) = InsightsDelete;
}

