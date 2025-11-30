import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:icoc_admin_pannel/constants.dart';
import 'package:icoc_admin_pannel/domain/model/identifable.dart';

part 'bible_study.freezed.dart';
part 'bible_study.g.dart';

@freezed
class BibleStudy with _$BibleStudy implements Identifiable {
  @JsonSerializable(explicitToJson: true)
  const factory BibleStudy({
    @override required int id,
    required String topic,
    required String subtopic,
    required Languages lang,
    required List<Lesson> lessons,
  }) = _BibleStudy;

  factory BibleStudy.fromJson(Map<String, dynamic> json) =>
      _$BibleStudyFromJson(json);

  static const BibleStudy defaultBibleStudy = BibleStudy(
    lessons: [],
    topic: '',
    id: 0,
    subtopic: '',
    lang: Languages.defaultLang,
  );
  const BibleStudy._();
}

@freezed
class Lesson with _$Lesson implements Identifiable {
  const factory Lesson({
    @override required int id,
    required String title,
    required String text,
  }) = _Lesson;

  factory Lesson.fromJson(Map<String, dynamic> json) => _$LessonFromJson(json);

  static const Lesson defaultLesson = Lesson(title: '', text: '', id: 0);
}
