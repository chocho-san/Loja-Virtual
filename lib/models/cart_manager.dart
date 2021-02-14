import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:loja_virtual/models/cart_product.dart';
import 'package:loja_virtual/models/product.dart';
import 'package:loja_virtual/models/user.dart';
import 'package:loja_virtual/models/user_manager.dart';

class CartManager extends ChangeNotifier {
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
        .map((d) => CartProduct.fromDocument(d)..addListener(_onItemUpdated))
        .toList();
  }

  void addToCart(Product product) {
    try {
      /*既にカートに入っている場合*/
      final item = items.firstWhere((p) => p.stackable(product));
      item.increment();
    } catch (e) {
      /*カートに入っていない場合*/
      final cartProduct = CartProduct.fromProduct(product);
      cartProduct.addListener(_onItemUpdated);
      items.add(cartProduct);
      users.cartRef.add(cartProduct.toCartItemMap()).then(
          (doc) => cartProduct.id = doc.id); /*ユーザーのFirebase上のカートに追加*/
    }
    notifyListeners();
  }

  void removeOfCart(CartProduct cartProduct){
    items.removeWhere((p) => p.id == cartProduct.id);
    users.cartRef.doc(cartProduct.id).delete();
    cartProduct.removeListener(_onItemUpdated);
    notifyListeners();
  }

  void _onItemUpdated() {
    print('update');
  }
}
