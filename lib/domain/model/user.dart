import 'package:firebase_auth/firebase_auth.dart';

class IcocUser {
  final String uid;
  final String email;
  final bool isAdmin;

  factory IcocUser.fromFirebaseUser(User user) {
    return IcocUser(
        email: user.email ?? '',
        uid: user.uid,
        isAdmin: user.email == 'serjmitaki@gmail.com');
  }
  factory IcocUser.defaultUser() {
    return IcocUser(email: '', uid: '');
  }

  IcocUser({required this.email, this.isAdmin = false, required this.uid});
}
