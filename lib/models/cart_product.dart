import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:loja_virtual/models/item_size.dart';
import 'package:loja_virtual/models/product.dart';

class CartProduct {
  String productId;
  int quantity;
  String size;

  Product product;

  CartProduct.fromProduct(this.product) {
    productId = product.id;
    quantity = 1;
    size = product.selectedSize.name;
  }


  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  CartProduct.fromDocument(DocumentSnapshot document) {
    productId = document.data()['pid'] as String;
    quantity = document.data()['quantity'] as int;
    size = document.data()['size'] as String;

    firestore
        .doc('products/$productId')
        .get()
        .then((doc) => product = Product.fromDocument(doc));
  }


  ItemSize get itemSize {
    if (product == null) return null;
    return product.findSize(size);
  }

  num get unitPrice {
    if (product == null) return 0;
    return itemSize?.price ?? 0;
    /*if(itemSize?.price==null)return 0*/
    /*itemSize?.price = (itemSize==null ? null : itemSize.price)*/
  }

  //firebaseに情報渡すときにマップ型必要
  Map<String,dynamic> toCartItemMap(){
    return {
      'pid' :productId,
      'quantity':quantity,
      'size':size,
    };
  }

  bool stackable(Product product){/*ある商品がカートに入っているかどうか*/
    return product.id == productId && product.selectedSize.name==size;
  }


}
