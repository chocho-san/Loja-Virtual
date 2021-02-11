import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:loja_virtual/models/product.dart';

class ProductManager extends ChangeNotifier {
  ProductManager() {
    _loadAllProducts();
  }

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  List<Product> allProducts = [];

  String _search='';

  String get search => _search;

  /*プライベート変数_searchを参照のみ可能とする*/
  set search(String value) {
    /*プライベート変数_searchを変更可能とする*/
    _search = value;
    notifyListeners();
  }

  List<Product> get filteredProducts {
    final List<Product> filteredProducts = [];

    if (search.isEmpty) {
      filteredProducts.addAll(allProducts);
    } else {
      filteredProducts.addAll(
        allProducts
            .where((p) => p.name.toLowerCase().contains(search.toLowerCase())),
      );
    }
    return filteredProducts;
  }

  Future<void> _loadAllProducts() async {
    final QuerySnapshot snapProducts =
        await firestore.collection('products').get();

    allProducts =
        snapProducts.docs.map((d) => Product.fromDocument(d)).toList();

    notifyListeners();

    // for(DocumentSnapshot doc in snapProducts.docs){
    //   print(doc.data());
    // }
  }
}
