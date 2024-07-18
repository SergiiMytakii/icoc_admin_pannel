import 'package:firebase_auth/firebase_auth.dart';

class IcocUser {
  final String uid;
  final String email;

  factory IcocUser.fromFirebaseUser(User user) {
    return IcocUser(user.email ?? '', uid: user.uid);
  }
  factory IcocUser.defaultUser() {
    return IcocUser('', uid: '');
  }

  IcocUser(this.email, {required this.uid});
}
