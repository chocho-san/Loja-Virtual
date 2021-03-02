import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:loja_virtual/models/address.dart';
import 'package:loja_virtual/models/cart_manager.dart';
import 'package:loja_virtual/models/cart_product.dart';

class Order {
  String orderId;
  List<CartProduct> items;
  num price;
  String userId;
  Address address;
  Timestamp date;

  Order.fromDocument(DocumentSnapshot doc) {
    orderId = doc.id;

    items = (doc.data()['items'] as List<dynamic>).map((e){
      return CartProduct.fromMap(e as Map<String, dynamic>);
    }).toList();

    price = doc.data()['price']as int;
    userId = doc.data()['userId']as String;
    address = Address.fromMap(doc.data()['address'] as Map<String, dynamic>);
    date=doc.data()['date'] as Timestamp;
  }

  Order.fromCartManager(CartManager cartManager) {
    items = List.from(cartManager.items);
    price = cartManager.totalPrice;
    userId = cartManager.users.id;
    address = cartManager.address;
  }



  Future<void> save() async {
    FirebaseFirestore.instance.collection('orders').doc(orderId).set({
      'items': items.map((e) => e.toOrderItemMap()).toList(),
      'price': price,
      'userId': userId,
      'address': address.toMap(),
    });
  }

  String get formattedId => '#${orderId.padLeft(6, '0')}';

  @override
  String toString() {
    return 'Order{orderId: $orderId, items: $items, price: $price, userId: $userId, address: $address, date: $date}';
  }
}
