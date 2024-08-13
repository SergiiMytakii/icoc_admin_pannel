import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:icoc_admin_pannel/domain/model/user.dart';
import 'package:injectable/injectable.dart';

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
  IcocUser? icocUser;
  Future<void> _onLogIn(AuthEventLogIn event, Emitter<AuthState> emit) async {
    emit(const AuthState.loading());
    try {
      final user = await _auth.signInWithEmailAndPassword(
        email: event.email,
        password: event.password,
      );
      icocUser = IcocUser.fromFirebaseUser(user.user!);
      emit(AuthState.authenticated(user: icocUser!));
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
          icocUser = IcocUser.fromFirebaseUser(user);
          emit(AuthState.authenticated(user: icocUser!));
        } else {
          emit(const AuthState.initial());
        }
      });
    } catch (e) {
      emit(AuthState.error('Error signing in with custom token: $e'));
    }
  }
}
