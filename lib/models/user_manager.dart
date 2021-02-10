import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:loja_virtual/helpers/firebase_errors.dart';
import 'package:loja_virtual/models/user.dart';

class UserManager extends ChangeNotifier {
  UserManager(){
    _loadCurrentUser();
  }
  final FirebaseAuth auth = FirebaseAuth.instance;
  User user;

  bool _loading = false;
  //getterとsetter
  bool get loading => _loading;/*プライベート変数_loadingを参照のみ可能とする*/
  set loading(bool value) {/*プライベート変数_loadingを変更可能とする*/
    _loading = value;
    notifyListeners();
  }

  Future<void> signIn({Users user, Function onFail, Function onSuccess}) async {
    loading = true;
    try {
      final result = await auth.signInWithEmailAndPassword(
          email: user.email, password: user.password);

      this.user = result.user;

      onSuccess();
    } on FirebaseAuthException catch (error) {
      onFail(getErrorString(error.code));
    }
    loading = false;
  }

  Future<void> _loadCurrentUser() async {
    final User currentUser = await auth.currentUser;
    if(currentUser != null){
      user = currentUser;
    }
    notifyListeners();
  }
}
