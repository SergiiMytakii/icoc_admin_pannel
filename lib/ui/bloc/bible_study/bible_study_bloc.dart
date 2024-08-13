// bible_study_bloc.dart
import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:icoc_admin_pannel/domain/helpers/error_logger.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:icoc_admin_pannel/domain/model/bible_study/bible_study.dart';
import 'package:icoc_admin_pannel/domain/model/user.dart';
import 'package:icoc_admin_pannel/domain/repository/bible_study_repository.dart';
import 'package:injectable/injectable.dart';

part 'bible_study_event.dart';
part 'bible_study_state.dart';
part 'bible_study_bloc.freezed.dart';

@singleton
class BibleStudyBloc extends Bloc<BibleStudyEvent, BibleStudyState> {
  BibleStudyBloc(this.bibleStudyRepository)
      : super(const BibleStudyState.initial()) {
    on<BibleStudyGet>(_onBibleStudyRequested);
    on<LessonEdit>(_onLessonEditRequested);
    on<LessonAdd>(_onLessonAddRequested);
    on<BibleStudyDelete>(_onLessonDeleteRequested);
    on<BibleStudyAdd>(_onBibleStudyAddRequested);
  }
  final BibleStudyRepository bibleStudyRepository;
  final ValueNotifier<BibleStudy> currentBibleStudy =
      ValueNotifier<BibleStudy>(BibleStudy.defaultBibleStudy);
  final ValueNotifier<Lesson> currentLesson =
      ValueNotifier<Lesson>(Lesson.defaultLesson);

  Future<void> _onBibleStudyRequested(
    BibleStudyGet event,
    Emitter<BibleStudyState> emit,
  ) async {
    emit(const BibleStudyState.loading());
    try {
      final List<BibleStudy> bibleStudies =
          await bibleStudyRepository.getBibleStudyList();
      if (bibleStudies.isNotEmpty) {
        bibleStudies.sort((a, b) => a.id.compareTo(b.id));
      }
      emit(BibleStudyState.success(bibleStudies));
    } catch (error, stackTrace) {
      logError(error, stackTrace);
      emit(BibleStudyState.error(error.toString()));
    }
  }

  Future<void> _onLessonEditRequested(
    LessonEdit event,
    Emitter<BibleStudyState> emit,
  ) async {
    emit(const BibleStudyState.loading());
    try {
      final List<BibleStudy> bibleStudies =
          await bibleStudyRepository.editLesson(event.user, event.bibleStudy);

      if (bibleStudies.isNotEmpty) {
        bibleStudies.sort((a, b) => a.id.compareTo(b.id));
      }
      emit(BibleStudyState.success(bibleStudies));
    } catch (error, stackTrace) {
      logError(error, stackTrace);
      emit(BibleStudyState.error(error.toString()));
    }
  }

  Future<void> _onLessonDeleteRequested(
    BibleStudyDelete event,
    Emitter<BibleStudyState> emit,
  ) async {
    emit(const BibleStudyState.loading());
    try {
      final List<BibleStudy> bibleStudies =
          await bibleStudyRepository.deleteBibleStudy(event.user, event.id);

      if (bibleStudies.isNotEmpty) {
        bibleStudies.sort((a, b) => a.id.compareTo(b.id));
      }
      emit(BibleStudyState.success(bibleStudies));
    } catch (error, stackTrace) {
      logError(error, stackTrace);
      emit(BibleStudyState.error(error.toString()));
    }
  }

  Future<void> _onBibleStudyAddRequested(
    BibleStudyAdd event,
    Emitter<BibleStudyState> emit,
  ) async {
    emit(const BibleStudyState.loading());
    try {
      final List<BibleStudy> bibleStudies = await bibleStudyRepository
          .addBibleStudy(event.user, event.bibleStudy);
      if (bibleStudies.isNotEmpty) {
        bibleStudies.sort((a, b) => a.id.compareTo(b.id));
      }

      emit(BibleStudyState.success(bibleStudies));
    } catch (error, stackTrace) {
      logError(error, stackTrace);
      emit(BibleStudyState.error(error.toString()));
    }
  }

  Future<void> _onLessonAddRequested(
    LessonAdd event,
    Emitter<BibleStudyState> emit,
  ) async {
    emit(const BibleStudyState.loading());
    try {
      final List<BibleStudy> bibleStudies = await bibleStudyRepository
          .addBibleStudy(event.user, event.bibleStudy);

      if (bibleStudies.isNotEmpty) {
        bibleStudies.sort((a, b) => a.id.compareTo(b.id));
      }
      emit(BibleStudyState.success(bibleStudies));
    } catch (error, stackTrace) {
      logError(error, stackTrace);
      emit(BibleStudyState.error(error.toString()));
    }
  }
}
