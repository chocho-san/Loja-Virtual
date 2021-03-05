import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:loja_virtual/helpers/firebase_errors.dart';
import 'package:loja_virtual/models/users.dart';

class UserManager extends ChangeNotifier {
  UserManager() {
    _loadCurrentUser();
  }

  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore fireStore = FirebaseFirestore.instance;
  Users users;

/*ロード中かどうか*/
  bool _loading = false;
  bool get loading => _loading; //getterとsetter
  /*プライベート変数_loadingを参照のみ可能とする*/
  set loading(bool value) {
    /*プライベート変数_loadingを変更可能とする*/
    _loading = value;
    notifyListeners();
  }

  bool _loadingGoogle = false;
  bool get loadingGoogle => _loadingGoogle;
  set loadingGoogle(bool value) {
    _loadingGoogle = value;
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
      );/*FireAuthにログイン*/

      await _loadCurrentUser(firebaseUser: result.user);
      /*Firestoreからユーザーの情報を取得*/

      onSuccess();
    } on FirebaseAuthException catch (error) {
      onFail(getErrorString(error.code));
    }
    loading = false;
  }


  //Googleでログイン
  Future<void> googleLogin({Function onFail, Function onSuccess}) async {
    loadingGoogle = true;

    final GoogleSignIn googleSignIn  = await GoogleSignIn(
        scopes: [
          'email',
          'https://www.googleapis.com/auth/contacts.readonly',
        ]
    );

    GoogleSignInAccount googleUser = await googleSignIn.signIn();
    if (googleUser == null) return;
      // cancelled login

    final GoogleSignInAuthentication googleAuth = await googleUser
        .authentication;
    // continue google sign-in

// 取得に成功したら、認証情報をFirebaseに伝達

    try {
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

//FirebaseAuthにgoogleアカウントでサインイン
      final  result =
          await auth.signInWithCredential(credential);


      if (result.user != null) {/*既にAuthにそのgoogleアカウント存在するなら*/
        users = Users(
            id: result.user.uid,
            name: result.user.displayName,
            email: result.user.email,
        );

        /*googleアカウント初登録なら*/
        await users.saveData();
        onSuccess();
      }
    } /*on FirebaseAuthException */catch (error) {
      return onFail(getErrorString(error.code));
    }
    loadingGoogle = false;
  }


/*アカウント登録。authにはemail、pass、idのみ。nameはuser.dart参照*/
  Future<void> signUp({Users user, Function onFail, Function onSuccess}) async {
    loading = true;
    try {
      final result = await auth.createUserWithEmailAndPassword(
        email: user.email,
        password: user.password,
      );        /*FireAuthに登録*/

      user.id = result.user.uid; /*Firestoreに保存*/
      this.users = user;
      await user.saveData();
      onSuccess();
    } on FirebaseAuthException catch (error) {
      onFail(getErrorString(error.code));
    }
    loading = false;
  }

  void signOut() {
    auth.signOut();
    users = null;
    notifyListeners();
  }

/*Firestoreからユーザーの情報を取得*/
  Future<void> _loadCurrentUser({User firebaseUser}) async {
    final User currentUser =
        firebaseUser ?? await auth.currentUser; /*authでログイン中のアカウント*/
    if (currentUser != null) {
      final DocumentSnapshot docUser =
          await fireStore.collection('users').doc(currentUser.uid).get();
      users = Users.fromDocument(docUser);

      final docAdmin = await FirebaseFirestore.instance
          .collection('admins')
          .doc(users.id)
          .get();

      if (docAdmin.exists) {
        users.admin = true;
      }

      notifyListeners();
    }
  }

  bool get adminEnabled => users != null && users.admin;
/*ユーザーが管理者かどうか*/

}
