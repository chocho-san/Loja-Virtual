import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/models/cart_product.dart';
import 'package:loja_virtual/models/product.dart';
import 'package:loja_virtual/models/user.dart';
import 'package:loja_virtual/models/user_manager.dart';

class CartManager extends ChangeNotifier {
  CartManager() {
    _loadCartItems();
  }

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  List<CartProduct> items = [];

  Users users;

  void updateUser(UserManager userManager) {
    users = userManager.users;
    items.clear();

    if (users != null) {
      _loadCartItems();
    }
  }

  //ユーザー別のカート内情報を取得する
  Future<void> _loadCartItems() async {
    final QuerySnapshot cartSnap = await users.cartRef.get();

    items = cartSnap.docs
        .map((d) => CartProduct.fromDocument(d))
        .toList();

    notifyListeners();
  }

  void addToCart(Product product) {
    final cartProduct = CartProduct.fromProduct(product);
    items.add(cartProduct);
    users.cartRef.add(cartProduct.toCartItemMap());/*ユーザーのFirebase上のカートに追加*/




  }
}
