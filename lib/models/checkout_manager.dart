import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:loja_virtual/models/cart_manager.dart';
import 'package:loja_virtual/models/order.dart';
import 'package:loja_virtual/models/product.dart';

class CheckoutManager extends ChangeNotifier {
  CartManager cartManager;

  bool _loading = false;
  bool get loading => _loading;
  set loading(bool value) {
    _loading = value;
    notifyListeners();
  }

  void updateCart(CartManager cartManager) {
    this.cartManager = cartManager;
  }

  Future<void> checkout({Function onStockFail,Function onSuccess}) async {
    loading=true;
    try {
      await _decrementStock();
    } catch (e) {
      onStockFail(e);
      loading=false;
      return;
    }
    final orderId = await _getOrderId();
    final order =Order.fromCartManager(cartManager);

    order.orderId=orderId.toString();

    await order.save();

    cartManager.clear();

    onSuccess(order);
    loading=false;


  }

  Future<int> _getOrderId() async {
    final ref = FirebaseFirestore.instance.doc('aux/ordercounter');

    try {
      final result =
          await FirebaseFirestore.instance.runTransaction((tx) async {
        final doc = await tx.get(ref);
        final orderId = doc.data()['current'] as int;
        await tx.update(
            ref, {'current': orderId + 1}); //取引カウント更新。注文確定ボタン押されるたび増えていく
        return {'orderId': orderId};
      });
      return result['orderId'];
    } catch (e) {
      debugPrint(e.toString());
      return Future.error('注文番号の生成に失敗しました');
    }
  }

  Future<void> _decrementStock() async {
    // 1. 全ての在庫を読み込む
    // 2. 減らす
    // 3. firebaseに保存する

    return FirebaseFirestore.instance.runTransaction((tx) async {
      final List<Product> productsToUpdate = [];
      final List<Product> productsWithoutStock = []; /*在庫がないすべての商品を追加するためのリスト*/

      for (final cartProduct in cartManager.items) { /*カート内のすべてのアイテムを調べる*/
        Product product;

        //条件を満たす要素が少なくとも１つあるか
        if(productsToUpdate.any((p) => p.id == cartProduct.productId)){
          //条件を満たす最初の要素
          product = productsToUpdate.firstWhere(
                  (p) => p.id == cartProduct.productId);
        } else {
          final doc = await tx.get(/*最新の在庫を参照して取得する*/
              FirebaseFirestore.instance
                  .doc('products/${cartProduct.productId}'));
          product = Product.fromDocument(doc); /*最新の各製品*/
        }

        cartProduct.product=product;

        /*在庫があるかの確認*/
        final size = product.findSize(cartProduct.size);
        if (size.stock - cartProduct.quantity < 0) {
          /*在庫足りない*/
          productsWithoutStock.add(product);
        } else {
          /*在庫余ってる*/
          size.stock -= cartProduct.quantity;
          productsToUpdate.add(product);
        }
      }

      if (productsWithoutStock.isNotEmpty) {
        /*在庫切れの商品あり*/
        return Future.error('${productsWithoutStock.length}個の商品が在庫切れ');
      }

      for (final product in productsToUpdate) {/*各製品の在庫を更新*/
        tx.update(
          FirebaseFirestore.instance.doc('products/${product.id}'),
          {'sizes': product.exportSizeList()},
        );
      }
    });
  }
}
