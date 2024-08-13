import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:icoc_admin_pannel/constants.dart';

part 'bible_study.freezed.dart';
part 'bible_study.g.dart';

@freezed
class BibleStudyV2 with _$BibleStudyV2 {
  @JsonSerializable(explicitToJson: true)
  const factory BibleStudyV2({
    required String topic,
    required String subtopic,
    required Languages lang,
    required int id,
    required List<Lesson> lessons,
  }) = _BibleStudy;

  factory BibleStudyV2.fromJson(Map<String, dynamic> json) =>
      _$BibleStudyV2FromJson(json);

  static const BibleStudyV2 defaultBibleStudy = BibleStudyV2(
    lessons: [],
    topic: '',
    id: 0,
    subtopic: '',
    lang: Languages.defaultLang,
  );
}

@freezed
class Lesson with _$Lesson {
  const factory Lesson({
    required int id,
    required String title,
    required String text,
  }) = _Lesson;

  factory Lesson.fromJson(Map<String, dynamic> json) => _$LessonFromJson(json);

  static const Lesson defaultLesson = Lesson(title: '', text: '', id: 0);
}
