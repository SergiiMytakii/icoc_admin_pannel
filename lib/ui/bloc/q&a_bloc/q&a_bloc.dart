import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:icoc_admin_pannel/constants.dart';
import 'package:icoc_admin_pannel/domain/helpers/error_logger.dart';
import 'package:icoc_admin_pannel/domain/model/q&a/q&a_model.dart';
import 'package:icoc_admin_pannel/domain/model/user.dart';
import 'package:icoc_admin_pannel/domain/repository/q&a_repository.dart';

import 'package:injectable/injectable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'q&a_event.dart';
part 'q&a_state.dart';
part 'q&a_bloc.freezed.dart';

@singleton
class QandABloc extends Bloc<QandAEvent, QandAState> {
  final QandARepository qandARepository;

  final ValueNotifier<QandAModel> currentQandA =
      ValueNotifier<QandAModel>(QandAModel.defaultQandA);
  final List<Languages> langs = [];

  QandABloc(this.qandARepository) : super(const QandAState.initial()) {
    on<QandAEvent>((event, emit) async {
      await event.when(
        delete: (user, docReference) => _onDelete(user, docReference, emit),
        getLangs: () => _onGetLangs(emit),
        requested: (query, lang) => _onQandARequested(query, lang, emit),
        edit: (user, article) => _onEditRequested(user, article, emit),
      );
    });
  }

  Future<void> _onQandARequested(
    String? query,
    Languages lang,
    Emitter<QandAState> emit,
  ) async {
    try {
      if (query != null) emit(const QandAState.loading());
      final List<QandAModel> articles =
          await qandARepository.getArticles(lang: lang);
      if (articles.isNotEmpty) {
        currentQandA.value = articles.first;
        if (query != null) {
          final filteredArticles = articles
              .where((element) => element.title.contains(query))
              .toList();
          emit(QandAState.success(filteredArticles));
        } else {
          emit(QandAState.success(articles));
        }
      } else {
        emit(const QandAState.error(''));
      }
    } catch (error, stackTrace) {
      logError(error, stackTrace);
      emit(QandAState.error(error.toString()));
    }
  }

  Future<void> _onGetLangs(Emitter<QandAState> emit) async {
    langs.addAll(await qandARepository.getAllLangs());
  }

  Future _onDelete(
      IcocUser? user, String docReference, Emitter<QandAState> emit) async {
    try {
      emit(const QandAState.loading());
      final List<QandAModel> articles =
          await qandARepository.deleteQandA(user, docReference);
      emit(QandAState.success(articles));
    } catch (error, stackTrace) {
      logError(error, stackTrace);
      emit(QandAState.error(error.toString()));
    }
  }

  Future _onEditRequested(
      IcocUser? user, QandAModel article, Emitter<QandAState> emit) async {
    emit(const QandAState.loading());
    try {
      final List<QandAModel> articles = await qandARepository.edit(
        user,
        article,
      );

      emit(QandAState.success(articles));
    } catch (error, stackTrace) {
      logError(error, stackTrace);
      emit(QandAState.error(error.toString()));
    }
  }
}
