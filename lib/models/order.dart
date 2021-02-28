import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:loja_virtual/models/address.dart';
import 'package:loja_virtual/models/cart_manager.dart';
import 'package:loja_virtual/models/cart_product.dart';

class Order{

  String orderId;
  List<CartProduct> items;
  num price;
  String userId;
  Address address;
  Timestamp date;

  Order.fromCartManager(CartManager cartManager){
    items = List.from(cartManager.items);
    price = cartManager.totalPrice;
    userId = cartManager.users.id;
    address = cartManager.address;
  }

  Future<void> save()async{
    FirebaseFirestore.instance.collection('orders').doc(orderId).set(
      {
      'items' : items.map((e) => e.toOrderItemMap()).toList(),
      'price' : price,
      'userId' : userId,
      'address' : address.toMap(),
      }
    );
  }

}