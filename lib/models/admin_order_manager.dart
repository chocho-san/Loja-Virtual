import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:loja_virtual/models/order.dart';
import 'package:loja_virtual/models/users.dart';

class AdminOrderManager extends ChangeNotifier {
  final List<Order> _orders = [];

  Users userFilter;

  List<Status> statusFilter = [Status.preparing];/*[canceled, preparing, transporting, delivered]*/

  //デバイスがいつ呼び出されるかを把握する必要がある
  StreamSubscription _subscription;

  void updateAdmin({bool adminEnabled}) {
    _orders.clear(); /*ユーザー変更されるごとにクリア*/
    _subscription?.cancel();
    if (adminEnabled) {
      /*管理者なら*/
      _listenToOrders(); /*すべてのオーダー取得*/

    }
  }

  List<Order> get filteredOrders {
    List<Order> output = _orders.reversed.toList();
    if(userFilter != null){/*ある一人の管理者のオーダーリスト*/
      output = output.where((o) => o.userId == userFilter.id).toList();
    }
    return output.where((o) =>statusFilter.contains(o.status) ).toList();
    /*nullならみんなのオーダーリスト。フィルターされてるのだけ表示*/
  }

  void _listenToOrders() {
    _subscription = FirebaseFirestore.instance
        .collection('orders') /*すべてのオーダー取得*/
        .snapshots()
        .listen((event) {
      for (final change in event.docChanges) {
        switch (change.type) {
          case DocumentChangeType.added:/*追加なら*/
            _orders.add(Order.fromDocument(change.doc));
            break;
          case DocumentChangeType.modified:/*変更なら*/
            final modOrder =
            _orders.firstWhere((o) => o.orderId == change.doc.id);
            modOrder.updateFromDocument(change.doc);
            break;
          case DocumentChangeType.removed:/*削除なら*/
            debugPrint('問題発生!!!');
            break;
        }
      }
      notifyListeners();
    });
  }

  void setUserFilter(Users users){
    userFilter = users;
    notifyListeners();
  }

  void setStatusFilter({Status status, bool enabled}){
    if(enabled){
      statusFilter.add(status);
    }else{
      statusFilter.remove(status);
    }
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
    _subscription?.cancel();
  }
}
