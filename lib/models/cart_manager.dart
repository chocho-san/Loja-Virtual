import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:loja_virtual/models/cart_product.dart';
import 'package:loja_virtual/models/product.dart';
import 'package:loja_virtual/models/user.dart';
import 'package:loja_virtual/models/user_manager.dart';

class CartManager {

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
  }

  void addToCart(Product product) {
    try{
      final item = items.firstWhere((p) => p.stackable(product));
      item.quantity++;
    }catch (e){
      final cartProduct = CartProduct.fromProduct(product);

      items.add(cartProduct);
      users.cartRef.add(cartProduct.toCartItemMap());/*ユーザーのFirebase上のカートに追加*/
    }
  }
}
