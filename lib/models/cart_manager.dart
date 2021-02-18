import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:loja_virtual/models/cart_product.dart';
import 'package:loja_virtual/models/product.dart';
import 'package:loja_virtual/models/users.dart';
import 'package:loja_virtual/models/user_manager.dart';

class CartManager extends ChangeNotifier {
  List<CartProduct> items = [];

  Users users;

  num productsPrice = 0;

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
      users.cartRef
          .add(cartProduct.toCartItemMap())
          .then((doc) => cartProduct.id = doc.id); /*ユーザーのFirebase上のカートに追加*/
      _onItemUpdated();
    }
    notifyListeners();
  }

  void removeOfCart(CartProduct cartProduct) {
    items.removeWhere((p) => p.id == cartProduct.id); /*CartTile削除*/
    users.cartRef.doc(cartProduct.id).delete();
    cartProduct.removeListener(_onItemUpdated); /*addListener不要になったらこれが必要*/
    notifyListeners();
  }

  void _onItemUpdated() {
    productsPrice = 0;
    for (int i = 0; i < items.length; i++) {
      final cartProduct = items[i];
      if (cartProduct.quantity == 0) {
        removeOfCart(cartProduct);
        i--; /*一個消されたら次の商品のiが繰り下がる*/
        continue; /*次のcartProductにスキップ*/
      }
      productsPrice += cartProduct.totalPrice;
      _updateCartProduct(cartProduct);
    }

    notifyListeners();
  }

  void _updateCartProduct(CartProduct cartProduct) {
    if (cartProduct.id != null) /*エラー対策？*/
      users.cartRef.doc(cartProduct.id).update(cartProduct.toCartItemMap());
  }

  bool get isCartValid {
    for (final cartProduct in items) {
      if (!cartProduct.hasStock) return false;
    }
    return true;
  }
}
