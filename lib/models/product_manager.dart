import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/models/product.dart';

class ProductManager extends ChangeNotifier {
  ProductManager() {
    _loadAllProducts();
  }

  List<Product> allProducts = [];

  String _search = '';

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
    final QuerySnapshot snapProducts = await FirebaseFirestore.instance
        .collection('products')
        .where('deleted', isEqualTo: false) //deletedがtrueの時は呼び出さない。
        .get();

    allProducts =
        snapProducts.docs.map((d) => Product.fromDocument(d)).toList();

    notifyListeners();
  }

  Product findProductById(String id) {
    try {
      return allProducts.firstWhere((p) => p.id == id);
    } catch (e) {
      return null;
    }
  }

  void update(Product product) {
    allProducts.removeWhere((p) => p.id == product.id);
    allProducts.add(product);
    notifyListeners();
  }

  void delete(Product product) {
    product.delete();
    allProducts.removeWhere((p) => p.id == product.id);
    notifyListeners();
  }
}
