import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:loja_virtual/models/address.dart';
import 'package:loja_virtual/models/cart_manager.dart';
import 'package:loja_virtual/models/cart_product.dart';

enum Status { canceled, preparing, transporting, delivered } /*配送状況*/

class Order {
  String orderId;
  List<CartProduct> items;
  num price;
  String userId;
  Address address;
  Timestamp date;
  Status status;

  Order.fromDocument(DocumentSnapshot doc) {
    orderId = doc.id;
    items = (doc.data()['items'] as List<dynamic>).map((e) {
      return CartProduct.fromMap(e as Map<String, dynamic>);
    }).toList();
    price = doc.data()['price'] as int;
    userId = doc.data()['userId'] as String;
    address = Address.fromMap(doc.data()['address'] as Map<String, dynamic>);
    date = doc.data()['date'] as Timestamp;
    status = Status.values[doc.data()['status'] as int]; /*ステータスの取得*/
  }

  Order.fromCartManager(CartManager cartManager) {
    items = List.from(cartManager.items);
    price = cartManager.totalPrice;
    userId = cartManager.users.id;
    address = cartManager.address;
    status = Status.preparing; /*準備中*/
  }

  DocumentReference get firestoreRef =>
      FirebaseFirestore.instance.collection('orders').doc(orderId);

  void updateFromDocument(DocumentSnapshot doc) {
    status = Status.values[doc.data()['status'] as int];
  }

  Future<void> save() async {
    FirebaseFirestore.instance.collection('orders').doc(orderId).set({
      'items': items.map((e) => e.toOrderItemMap()).toList(),
      'price': price,
      'userId': userId,
      'address': address.toMap(),
      'status': status.index,
      'date': Timestamp.now(),
    });
  }

  Function get back {
    return status.index >= Status.transporting.index
        ? () {
            status = Status.values[status.index - 1];
            firestoreRef.update({'status': status.index});
          }
        : null;
  }

  Function get advance {
    return status.index <= Status.transporting.index
        ? () {
            status = Status.values[status.index + 1];
            firestoreRef.update({'status': status.index});
          }
        : null;
  }

  void cancel() {
    status = Status.canceled;
    firestoreRef.update({'status': status.index});
  }

 void export(){
    status = Status.transporting;
    firestoreRef.update({'status':status.index});
 }

  String get formattedId => '#${orderId.padLeft(6, '0')}';

  String get statusText => getStatusText(status);

  /*order_tileに表示*/

  static String getStatusText(Status status) {
    switch (status) {
      case Status.canceled:
        return 'キャンセル';
      case Status.preparing:
        return '準備中';
      case Status.transporting:
        return '配送中';
      case Status.delivered:
        return '配達済み';
      default:
        return '';
    }
  }

  @override
  String toString() {
    return 'Order{orderId: $orderId, items: $items, price: $price, userId: $userId, address: $address, date: $date}';
  }
}
