import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:loja_virtual/models/order.dart';
import 'package:loja_virtual/models/users.dart';

class OrdersManager extends ChangeNotifier {
  Users users;

  List<Order> orders = [];

  //デバイスがいつ呼び出されるかを把握する必要がある
  StreamSubscription _subscription;


  void updateUser(Users users) {
    this.users = users;
    orders.clear();/*ユーザー変更されるごとにクリア*/
    _subscription?.cancel();
    if (users != null) {
      /*ログインしてるなら*/
      _listenToOrders(); /*ユーザーのリクエストを検索*/

    }
  }

  void _listenToOrders() {
    _subscription =  FirebaseFirestore.instance
        .collection('orders')
        .where(
            /*コレクションから複数の特定のドキュメントを取得する*/
            'userId',
            /*ordersリスト内のuserId*/
            isEqualTo: users.id)
        .snapshots().listen((event) {
          orders.clear();/*ordersリストに変更があるたびにクリア*/
          for(final doc in event.docs){
            orders.add(Order.fromDocument(doc));
          }
          notifyListeners();

    });
  }

  @override
  void dispose() {
    super.dispose();
    _subscription?.cancel();
  }
//?を付ける理由は初めて利用の場合、最初はnullの為。
//_listenToOrders()はsnapshotsで常にデータリンクしている為、userが変更した場合、
//以前行っていたデータリンクを即停止する必要がある。subscriptionで管理し、user変更時にクリアする。
}
