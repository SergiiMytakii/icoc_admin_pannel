import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:icoc_admin_pannel/domain/helpers/error_logger.dart';
import 'package:icoc_admin_pannel/domain/model/notifications_model.dart';
import 'package:icoc_admin_pannel/domain/model/song_detail.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:icoc_admin_pannel/domain/repository/notifications_repository.dart';
import 'package:injectable/injectable.dart';
part 'notifications_event.dart';
part 'notifications_state.dart';
part 'notifications_bloc.freezed.dart';

@singleton
class NotificationsBloc extends Bloc<NotificationsEvent, NotificationsState> {
  NotificationsBloc(this.notificationsRepository)
      : super(const NotificationsState.initial()) {
    on<NotificationsGet>(_onNotificationsRequested);
    on<NotificationsAdd>(_onNotificationsAddRequested);
    on<NotificationsDelete>(_onNotificationDeleteRequested);
  }
  final NotificationsRepository notificationsRepository;

  Future<void> _onNotificationsRequested(
    NotificationsGet event,
    Emitter<NotificationsState> emit,
  ) async {
    emit(const NotificationsState.loading());
    try {
      final List<Map<String, NotificationsModel>> notifications =
          await notificationsRepository.getNotifications();

      emit(NotificationsState.success(notifications));
    } catch (error, stackTrace) {
      logError(error, stackTrace);
      emit(NotificationsState.error(error.toString()));
    }
  }

  FutureOr<void> _onNotificationsAddRequested(
      NotificationsAdd event, Emitter<NotificationsState> emit) async {
    try {
      emit(const NotificationsState.loading());
      final List<Map<String, NotificationsModel>> notifications =
          await notificationsRepository.getNotifications();
      emit(NotificationsState.success(notifications));
    } catch (error, stackTrace) {
      logError(error, stackTrace);
      emit(NotificationsState.error(error.toString()));
    }
  }

  FutureOr<void> _onNotificationDeleteRequested(
      NotificationsDelete event, Emitter<NotificationsState> emit) async {
    try {
      emit(const NotificationsState.loading());
      final List<Map<String, NotificationsModel>> notifications =
          await notificationsRepository.getNotifications();
      emit(NotificationsState.success(notifications));
    } catch (error, stackTrace) {
      logError(error, stackTrace);
      emit(NotificationsState.error(error.toString()));
    }
  }
}
