part of 'auth_bloc.dart';

@freezed
class AuthEvent with _$AuthEvent {
  const factory AuthEvent.logIn({
    required String email,
    required String password,
  }) = AuthEventLogIn;
  const factory AuthEvent.logOut() = AuthEventLogOut;
  const factory AuthEvent.checkStatus() = AuthEventCheckStatus;
}
