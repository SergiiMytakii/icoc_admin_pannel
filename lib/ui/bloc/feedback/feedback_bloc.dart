import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:icoc_admin_pannel/domain/helpers/error_logger.dart';
import 'package:icoc_admin_pannel/domain/model/feedback.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:icoc_admin_pannel/domain/repository/feedback_repository.dart';
import 'package:injectable/injectable.dart';

part 'feedback_event.dart';
part 'feedback_state.dart';
part 'feedback_bloc.freezed.dart';

@singleton
class FeedbackBloc extends Bloc<FeedbackEvent, FeedbackState> {
  FeedbackBloc(this.feedbackRepository) : super(const FeedbackState.initial()) {
    on<FeedbackGet>(_onFeedbackRequested);
    on<FeedbackEdit>(_onFeedbackEditRequested);
    on<FeedbackDelete>(_onFeedbackDeleteRequested);
  }
  final FeedbackRepository feedbackRepository;

  Future<void> _onFeedbackRequested(
    FeedbackGet event,
    Emitter<FeedbackState> emit,
  ) async {
    emit(const FeedbackState.loading());
    try {
      final List<Feedback> feedbacks =
          await feedbackRepository.getFeedbackList();
      emit(FeedbackState.success(feedbacks));
    } catch (error, stackTrace) {
      logError(error, stackTrace);
      emit(FeedbackState.error(error.toString()));
    }
  }

  Future<void> _onFeedbackEditRequested(
    FeedbackEdit event,
    Emitter<FeedbackState> emit,
  ) async {
    emit(const FeedbackState.loading());
    try {
      final List<Feedback> feedbacks =
          await feedbackRepository.editFeedback(event.feedbackId);
      emit(FeedbackState.success(feedbacks));
    } catch (error, stackTrace) {
      logError(error, stackTrace);
      emit(FeedbackState.error(error.toString()));
    }
  }

  Future<void> _onFeedbackDeleteRequested(
    FeedbackDelete event,
    Emitter<FeedbackState> emit,
  ) async {
    emit(const FeedbackState.loading());
    try {
      final List<Feedback> feedbacks =
          await feedbackRepository.deleteFeedback(event.feedbackId);
      emit(FeedbackState.success(feedbacks));
    } catch (error, stackTrace) {
      logError(error, stackTrace);
      emit(FeedbackState.error(error.toString()));
    }
  }
}
