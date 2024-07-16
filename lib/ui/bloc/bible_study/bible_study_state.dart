part of 'bible_study_bloc.dart';

@freezed
class BibleStudyState with _$BibleStudyState {
  const factory BibleStudyState.initial() = _BibleStudyInitialState;
  const factory BibleStudyState.loading() = _BibleStudyLoadingState;
  const factory BibleStudyState.error(String errorMessage) =
      _BibleStudyErrorState;
  const factory BibleStudyState.success(List<BibleStudy> bibleStudies) =
      _BibleStudySuccessState;
}
