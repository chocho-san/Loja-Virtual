import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/cupertino.dart';
import 'package:loja_virtual/models/item_size.dart';
import 'package:uuid/uuid.dart';

class Product extends ChangeNotifier {
  String id;
  String name;
  String description;
  List<String> images;
  List<ItemSize> sizes;

  List<dynamic> newImages;

  bool _loading = false;

  bool get loading => _loading;

  set loading(bool value) {
    _loading = value;
    notifyListeners();
  }

//products_screenから製品追加するときnullを避けるため初期値設定する
  Product({this.id, this.name, this.description, this.images, this.sizes}) {
    images = images ?? [];
    sizes = sizes ?? [];
  }

  Product.fromDocument(DocumentSnapshot document) {
    id = document.id;
    name = document.data()['name'] as String;
    description = document.data()['description'] as String;
    images = List<String>.from(document.data()['images']);
    sizes = (document.data()['sizes'] as List<dynamic> ?? [])
        .map((s) => ItemSize.fromMap(s as Map<String, dynamic>))
        .toList();
  }

  DocumentReference get firestoreRef =>
      FirebaseFirestore.instance.doc('products/$id');

  // Reference get storageRef =>
  //     FirebaseStorage.instance.ref().child('home/$id') ;

  ItemSize _selectedSize;

  ItemSize get selectedSize => _selectedSize;

  set selectedSize(ItemSize value) {
    _selectedSize = value;
    notifyListeners();
  }

  int get totalStock {
    int stock = 0;
    for (final size in sizes) {
      stock += size.stock;
    }
    return stock;
  }

  bool get hasStock {
    return totalStock > 0;
  }

  num get basePrice {
    num lowest = double.infinity; //初期値は∞
    for (final size in sizes) {
      if (size.price < lowest && size.hasStock) {
        lowest = size.price;
      }
    }
    return lowest;
  }

  ItemSize findSize(String name) {
    try {
      return sizes.firstWhere((s) => s.name == name);
    } catch (e) {
      return null;
    }
  }

  //Firebese用
  List<Map<String, dynamic>> exportSizeList() {
    return sizes.map((size) => size.toMap()).toList();
  }

  /*製品の保存*/
  Future<void> save() async {
    loading = true;
    final Map<String, dynamic> data = {
      'name': name,
      'description': description,
      'sizes': exportSizeList(),
    };

    if (id == null) {
      //新規作成なら
      final doc =
          await FirebaseFirestore.instance.collection('products').add(data);
      id = doc.id;
    } else {
      //既存製品なら
      await firestoreRef.update(data);
    }
/*画像リストの保存*/
    final List<String> updateImages = []; /*新規作成、編集した後の画像リスト*/

    for (final newImage in newImages) {
      if (images.contains(newImage)) {
        /*編集前にあった削除されてない画像追加*/
        updateImages.add(newImage as String);
      } else {
        /*新たに足す画像を追加*/
        final snapshot = await firebase_storage.FirebaseStorage.instance
            .ref()
            .child('products/$id')
            .child(Uuid().v1())
            .putFile(newImage as File); /*StorageにFile型で追加*/

        final String url = await snapshot.ref.getDownloadURL();
        updateImages.add(url);
      }
    }
/*Firebaseから削除*/
    for (final image in images) {
      if (!newImages.contains(image)) {
        try {
          final ref =
              await firebase_storage.FirebaseStorage.instance.refFromURL(image);
          await ref.delete();
        } catch (e) {
          debugPrint('削除失敗：$image');
        }
      }
    }

    await firestoreRef.update({'images': updateImages}); /*画像リストの更新*/
    images = updateImages;
    loading = false;

    print(images);
  }

  Product clone() {
    //Productオブジェクトの複製
    return Product(
      id: id,
      name: name,
      description: description,
      images: List.from(images),
      sizes: sizes.map((size) => size.clone()).toList(),
    );
  }

  @override
  String toString() {
    return 'Product{id: $id, name: $name, description: $description, images: $images, sizes: $sizes, newImages: $newImages}';
  }
}
