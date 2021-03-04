import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:loja_virtual/models/item_size.dart';
import 'package:loja_virtual/models/product.dart';

class CartProduct extends ChangeNotifier {
  String productId;

  /*引き継がれたやつ*/
  int quantity;
  String size;

  String id;

  Product _product;

  num fixedPrice;

   Product get product => _product;
  set product(Product value){
    _product = value;
    notifyListeners();
  }

/*上記のようにget、set追加したらここのproductだけプライベートに変更*/
  CartProduct.fromProduct(this._product) {
    productId = product.id;
    quantity = 1;
    size = product.selectedSize.name;
  }

  CartProduct.fromDocument(DocumentSnapshot document) {
    id = document.id;
    productId = document.data()['pid'] as String;
    quantity = document.data()['quantity'] as int;
    size = document.data()['size'] as String;

    FirebaseFirestore.instance.doc('products/$productId').get().then((doc) {
      product = Product.fromDocument(doc);
      notifyListeners();/*firebaseで価格更新した時にカートの商品に伝える*/
    }
    );
  }

  CartProduct.fromMap(Map<String, dynamic> map){/*注文履歴呼び出し用*/
    productId = map['pid'] as String;
    quantity = map['quantity'] as int;
    size = map['size'] as String;
    fixedPrice = map['fixedPrice'] as int;

    FirebaseFirestore.instance.doc('products/$productId').get().then(
            (doc) {
          product = Product.fromDocument(doc);
        }
    );
  }

  ItemSize get itemSize {
    if (product == null) return null;
    /*製品情報取得してから*/
    return product.findSize(size);
  }

  num get unitPrice {
    if (product == null) return 0;
    /*製品情報取得してから*/
    return itemSize?.price ?? 0;
    /*上式の意味はif(itemSize?.price==null)return 0
    itemSize?.price = (itemSize==null ? null : itemSize.price)*/
  }

  num get totalPrice => unitPrice * quantity;

  //firebaseに情報渡すときにマップ型必要
  Map<String, dynamic> toCartItemMap() {
    return {
      'pid': productId,
      'quantity': quantity,
      'size': size,
    };
  }

  Map<String, dynamic> toOrderItemMap() {
    return {
      'pid': productId,
      'quantity': quantity,
      'size': size,
      'fixedPrice':fixedPrice?? unitPrice,/*製品価格変更されてもオーダー時点の価格変更されない*/
    };
  }

  bool stackable(Product product) {
    /*ある商品がカートに入っているかどうか*/
    return product.id == productId && product.selectedSize.name == size;
  }

  void increment() {
    quantity++;
    notifyListeners();
  }

  void decrement() {
    quantity--;
    notifyListeners();
  }

  bool get hasStock {
    if(product != null && product.deleted)return false;
    final size = itemSize;
    if (size == null) return false;
    return size.stock >= quantity;
  }
}
