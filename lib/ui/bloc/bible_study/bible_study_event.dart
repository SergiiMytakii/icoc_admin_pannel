part of 'bible_study_bloc.dart';

@freezed
class BibleStudyEvent with _$BibleStudyEvent {
  const factory BibleStudyEvent.get() = BibleStudyGet;
  const factory BibleStudyEvent.editLesson(String id) = LessonEdit;
  const factory BibleStudyEvent.addBibleStudy(BibleStudy bibleStudy) =
      BibleStudyAdd;
  const factory BibleStudyEvent.addLesson(BibleStudy bibleStudy) = LessonAdd;
}
