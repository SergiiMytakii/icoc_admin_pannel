import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:icoc_admin_pannel/domain/model/insights/post.dart';
import 'package:icoc_admin_pannel/domain/model/user.dart';
import 'package:icoc_admin_pannel/domain/repository/insights_repository.dart';
import 'package:icoc_admin_pannel/domain/helpers/error_logger.dart';
import 'package:injectable/injectable.dart';

part 'insights_event.dart';
part 'insights_state.dart';
part 'insights_bloc.freezed.dart';

@Singleton()
class InsightsBloc extends Bloc<InsightsEvent, InsightsState> {
  final InsightsRepository repository;
  final ValueNotifier<Post?> currentPost = ValueNotifier(null);

  InsightsBloc({required this.repository})
      : super(const InsightsState.initial()) {
    on<InsightsGet>(_onGet);
    on<InsightsAdd>(_onAdd);
    on<InsightsEdit>(_onEdit);
    on<InsightsDelete>(_onDelete);
  }

  Future<void> _onGet(InsightsGet event, Emitter<InsightsState> emit) async {
    emit(const InsightsState.loading());
    try {
      final posts = await repository.getPosts(
          query: event.query, language: event.language);
      emit(InsightsState.success(_newestFirst(posts)));
    } catch (e, st) {
      logError(e, st);
      emit(InsightsState.error(e.toString()));
    }
  }

  Future<void> _onAdd(InsightsAdd event, Emitter<InsightsState> emit) async {
    emit(const InsightsState.loading());
    try {
      final posts = await repository.addPost(event.user, event.post);
      emit(InsightsState.success(_newestFirst(posts)));
    } catch (e, st) {
      logError(e, st);
      emit(InsightsState.error(e.toString()));
    }
  }

  Future<void> _onEdit(InsightsEdit event, Emitter<InsightsState> emit) async {
    emit(const InsightsState.loading());
    try {
      final posts = await repository.editPost(event.user, event.post);
      emit(InsightsState.success(_newestFirst(posts)));
    } catch (e, st) {
      logError(e, st);
      emit(InsightsState.error(e.toString()));
    }
  }

  Future<void> _onDelete(
      InsightsDelete event, Emitter<InsightsState> emit) async {
    emit(const InsightsState.loading());
    try {
      final posts = await repository.deletePost(event.user, event.id);
      emit(InsightsState.success(_newestFirst(posts)));
    } catch (e, st) {
      logError(e, st);
      emit(InsightsState.error(e.toString()));
    }
  }

  List<Post> _newestFirst(List<Post> posts) {
    return List<Post>.of(posts)
      ..sort((Post first, Post second) =>
          second.createdAt.compareTo(first.createdAt));
  }
}
