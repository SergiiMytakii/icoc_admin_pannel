part of 'bible_study_bloc.dart';

@freezed
class BibleStudyEvent with _$BibleStudyEvent {
  const factory BibleStudyEvent.get() = BibleStudyGet;
  const factory BibleStudyEvent.delete(
      {required IcocUser? user, required String id}) = BibleStudyDelete;
  const factory BibleStudyEvent.editLesson({
    required IcocUser? user,
    required BibleStudy bibleStudy,
  }) = LessonEdit;
  const factory BibleStudyEvent.addBibleStudy({
    required IcocUser? user,
    required BibleStudy bibleStudy,
  }) = BibleStudyAdd;
  const factory BibleStudyEvent.addLesson({
    required IcocUser? user,
    required BibleStudy bibleStudy,
  }) = LessonAdd;
}
