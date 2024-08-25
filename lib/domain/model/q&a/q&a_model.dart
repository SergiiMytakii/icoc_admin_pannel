// ignore_for_file: non_constant_identifier_names

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:icoc_admin_pannel/constants.dart';

part 'q&a_model.freezed.dart';
part 'q&a_model.g.dart';

@freezed
class QandAModel with _$QandAModel {
  const factory QandAModel(
      {required int id,
      @JsonKey(includeToJson: false) required String documentRef,
      required String title,
      required String question,
      required String answer,
      required Languages lang,
      String? date,
      String? author,
      String? link,
      String? image,
      String? source,
      String? translatedBy,
      String? youtubeLink,
      List<String>? tags}) = _QandAModel;

  factory QandAModel.fromJson(Map<String, dynamic> json, String documentRef) =>
      _$QandAModelFromJson(json..addAll({'documentRef': documentRef}));

  static const QandAModel defaultQandA = QandAModel(
      id: 0,
      documentRef: '',
      title: '',
      question: '',
      answer: '',
      lang: Languages.defaultLang);

  const QandAModel._();
}
