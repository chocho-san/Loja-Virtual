import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:loja_virtual/models/store.dart';

class StoresManager extends ChangeNotifier {
  StoresManager() {
    _loadStoreList();
    _startTimer(); /*常に更新*/
  }

  List<Store> stores = [];
  Timer _timer;

  Future<void> _loadStoreList() async {
    final snapshot = /*ストア情報取得*/
        await FirebaseFirestore.instance.collection('stores').get();

    stores = snapshot.docs.map((e) => Store.fromDocument(e)).toList();
    notifyListeners();
  }

  void _startTimer() { /*営業してるか１分おきに確認*/
    _timer = Timer.periodic(Duration(minutes: 1), (timer) {
      for (final store in stores)
        store.updateStatus();
      notifyListeners();
    });
  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
  }
}
