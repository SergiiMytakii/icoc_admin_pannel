import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:icoc_admin_pannel/constants.dart';
import 'package:icoc_admin_pannel/domain/helpers/error_logger.dart';
import 'package:icoc_admin_pannel/domain/model/q&a/q&a_model.dart';
import 'package:icoc_admin_pannel/domain/repository/q&a_repository.dart';

import 'package:injectable/injectable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'q&a_event.dart';
part 'q&a_state.dart';
part 'q&a_bloc.freezed.dart';

@singleton
class QandABloc extends Bloc<QandAEvent, QandAState> {
  final QandARepository qandARepository;

  QandABloc(this.qandARepository) : super(const QandAState.initial()) {
    on<QandAEvent>((event, emit) async {
      await event.when(
        requested: (query) => _onQandARequested(query, emit),
      );
    });
  }

  Future<void> _onQandARequested(
    String? query,
    Emitter<QandAState> emit,
  ) async {
    try {
      if (query != null) emit(const QandAState.loading());
      final List<QandAModel> articles = await qandARepository.getArticles();
      if (articles.isNotEmpty) {
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

  Future<List<Languages>> _getAllLangs() async {
    return await qandARepository.getAllLangs();
  }
}
