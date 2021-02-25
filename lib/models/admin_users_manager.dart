import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:loja_virtual/models/users.dart';
import 'package:loja_virtual/models/user_manager.dart';

class AdminUsersManager extends ChangeNotifier {
  List<Users> users = [];

  StreamSubscription _subscription;

  void updateUser(UserManager userManager) {
    _subscription?.cancel();
    if (userManager.adminEnabled) {
      _listenToUsers();
    } else {
      users.clear();
      notifyListeners();
    }
  }

  void _listenToUsers() {
    // final faker = Faker(); /*ダミーデータを生成*/

    _subscription =
        FirebaseFirestore.instance.collection('users').snapshots().listen(
      /*.get().then( とは違いリアルタイム更新できる*/
      (snapshot) {
        users = snapshot.docs.map((d) => Users.fromDocument(d)).toList();
        users.sort(
            (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
        notifyListeners();
      },
    );
  }

  List<String> get names => users.map((e) => e.name).toList();

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
