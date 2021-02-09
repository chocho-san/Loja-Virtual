import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:loja_virtual/helpers/firebase_errors.dart';
import 'package:loja_virtual/models/user.dart';

class UserManager {
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> signIn({Users user, Function onFail, Function onSuccess}) async {
    try {
      final result = await auth.signInWithEmailAndPassword(
          email: user.email, password: user.password);
      onSuccess();
    } on PlatformException catch (e) {
      onFail(getErrorString(e.code));
    }
  }
}
