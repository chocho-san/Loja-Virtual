import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/helpers/firebase_errors.dart';
import 'package:loja_virtual/models/user.dart';

class UserManager extends ChangeNotifier {
  UserManager() {
    _loadCurrentUser();
  }

  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore fireStore = FirebaseFirestore.instance;
  Users users;

/*ロード中かどうか*/
  bool _loading = false;

  //getterとsetter
  bool get loading => _loading;

  /*プライベート変数_loadingを参照のみ可能とする*/
  set loading(bool value) {
    /*プライベート変数_loadingを変更可能とする*/
    _loading = value;
    notifyListeners();
  }
  /*ログインしてるかどうか*/
  bool get isLoggedIn => users != null;

  /*ログインする*/
  Future<void> signIn({Users user, Function onFail, Function onSuccess}) async {
    loading = true;
    try {
      final result = await auth.signInWithEmailAndPassword(
        email: user.email,
        password: user.password,
      );

      await _loadCurrentUser(firebaseUser: result.user);


      onSuccess();
    } on FirebaseAuthException catch (error) {
      onFail(getErrorString(error.code));
    }
    loading = false;
  }

  /*アカウント登録。authにはemail、pass、idのみ。nameはuser.dart参照*/
  Future<void> signUp({Users user, Function onFail, Function onSuccess}) async {
    loading = true;
    try {
      final result = await auth.createUserWithEmailAndPassword(/*FireAuthに登録*/
        email: user.email,
        password: user.password,
      );

      user.id = result.user.uid;
      this.users = user;

      await user.saveData();/*Firestoreに保存*/
      onSuccess();
    } on FirebaseAuthException catch (error) {
      onFail(getErrorString(error.code));
    }
    loading = false;
  }

  void signOut(){
    auth.signOut();
    users =null;
    notifyListeners();
  }

  /*Firestoreからユーザーの情報を取得*/
  Future<void> _loadCurrentUser({User firebaseUser}) async {
    final User currentUser = firebaseUser ?? await auth.currentUser;/*authでログイン中のアカウント*/
    if (currentUser != null) {
      final DocumentSnapshot docUser =
          await fireStore.collection('users').doc(currentUser.uid).get();
      users = Users.fromDocument(docUser);
      print(users.name);
      notifyListeners();
    }
  }
}
