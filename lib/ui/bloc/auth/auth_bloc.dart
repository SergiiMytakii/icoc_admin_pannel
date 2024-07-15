import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:icoc_admin_pannel/domain/helpers/error_logger.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:universal_html/html.dart';

part 'auth_event.dart';
part 'auth_state.dart';
part 'auth_bloc.freezed.dart';

@singleton
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(const AuthState.initial()) {
    on<AuthEventLogIn>(_onLogIn);
    on<AuthEventLogOut>(_onLogOut);
    on<AuthEventCheckStatus>(_onCheckAuthStatus);
  }
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Future<void> _onLogIn(AuthEventLogIn event, Emitter<AuthState> emit) async {
    emit(const AuthState.loading());
    try {
      final user = await _auth.signInWithEmailAndPassword(
        email: event.email,
        password: event.password,
      );
      emit(AuthState.authenticated(user: user.user!));
    } catch (e) {
      emit(AuthState.error(e.toString()));
    }
  }

  Future<void> _onLogOut(AuthEventLogOut event, Emitter<AuthState> emit) async {
    await _auth.signOut();
    emit(const AuthState.initial());
  }

  Future<void> _onCheckAuthStatus(
      AuthEventCheckStatus event, Emitter<AuthState> emit) async {
    try {
      await _auth.authStateChanges().first.then((User? user) async {
        if (user != null) {
          print('authenticated');
          emit(AuthState.authenticated(user: user));
        } else {
          print('UNauthenticated');

          emit(const AuthState.initial());
        }
      });
    } catch (e) {
      emit(AuthState.error('Error signing in with custom token: $e'));
    }
  }

  // Future<void> _onCheckAuthStatus(
  //     AuthEventCheckStatus event, Emitter<AuthState> emit) async {
  //   final authToken = _getAuthCookie();
  //   if (authToken != null) {
  //     try {
  //       final user = await _auth.signInWithCustomToken(authToken);
  //       emit(AuthState.authenticated(user: user.user!));
  //     } catch (e) {
  //       _clearAuthCookie();
  //       emit(AuthState.error('Error signing in with custom token: $e'));
  //     }
  //   } else {
  //     emit(const AuthInitial());
  //   }
  // }

  // void _setAuthCookie(String token) {
  //   document.cookie =
  //       'auth_token=$token; path=/; max-age=2592000; SameSite=Strict; Secure';
  // }

  // String? _getAuthCookie() {
  //   final cookies = document.cookie?.split('; ') ?? [];
  //   Logger().f(cookies);
  //   for (var cookie in cookies) {
  //     final parts = cookie.split('=');
  //     if (parts[0] == 'auth_token') {
  //       return parts[1];
  //     }
  //   }
  //   return null;
  // }

  // void _clearAuthCookie() {
  //   document.cookie =
  //       'auth_token=; path=/; expires=Thu, 01 Jan 1970 00:00:00 GMT';
  // }
}
