import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/cupertino.dart';
import 'package:loja_virtual/models/section_item.dart';
import 'package:uuid/uuid.dart';

class Section with ChangeNotifier {
  String id;
  String name;
  String type;
  List<SectionItem> items;
  List<SectionItem> originalItems;

  Section({this.id, this.name, this.type, this.items}) {
    items = items ?? []; /*length求められるエラー回避*/
    originalItems = List.from(items);
  }

  String _error;

  String get error => _error;

  set error(String value) {
    _error = value;
    notifyListeners();
  }

  Section.fromDocument(DocumentSnapshot document) {
    id = document.id;
    name = document.data()['name'] as String;
    type = document.data()['type'] as String;
    items = (document.data()['items'] as List)
        .map((i) => SectionItem.fromMap(i as Map<String, dynamic>))
        .toList();
  }

  DocumentReference get firestoreRef =>
      FirebaseFirestore.instance.doc('home/$id');

  // Reference get storageRef => FirebaseStorage.instance.ref().child('home/$id');

  void addItem(SectionItem item) {
    items.add(item);
    notifyListeners();
  }

  void removeItem(SectionItem item) {
    items.remove(item);
    notifyListeners();
  }

  /*home画面の保存。Firebaseに伝達*/
  Future<void> save(int pos) async {
    final Map<String, dynamic> data = {
      'name': name,
      'type': type,
      'pos': pos,
    };

    if (id == null) {
      final doc = await FirebaseFirestore.instance.collection('home').add(data);
      id = doc.id;
    } else {
      await firestoreRef.update(data);
    }

    for (final item in items) {
      if (item.image is File) {
        final snapshot = await firebase_storage.FirebaseStorage.instance
            .ref()
            .child('home/$id')
            .child(Uuid().v1())
            .putFile(item.image as File); /*StorageにFile型で追加*/

        final String url = await snapshot.ref.getDownloadURL();
        item.image = url;
      }
    }

    for (final original in originalItems) {
      if (!items.contains(original) &&
          (original.image as String).contains('firebase')) {
        //画像urlに'firebase'が含まれているならstorageから削除
        //もしgoogleからの画像とかなら以下の操作はせず、デバイス上だけで削除
        try {
          final ref = await firebase_storage.FirebaseStorage.instance
              .refFromURL(original.image as String);
          await ref.delete();
        } catch (e) {}
      }
    }

    final Map<String, dynamic> itemsData = {
      'items': items.map((e) => e.toMap()).toList()
    };

    await firestoreRef.update(itemsData); /*画像リストの更新*/
  }

  Future<void> delete() async {
    await firestoreRef.delete();
    for (final item in items) {
      if((item.image as String).contains('firebase')){
        //画像urlに'firebase'が含まれているならstorageから削除
        //もしgoogleからの画像とかなら以下の操作はせず、デバイス上だけで削除
        try {
          final ref = await firebase_storage.FirebaseStorage.instance
              .refFromURL(item.image as String);
          await ref.delete();
          // ignore: empty_catches
        } catch (e) {}
      }

    }
  }

  bool valid() {
    /*TextFieldの有効性でvalidator使わない方法*/
    if (name == null || name.isEmpty) {
      error = 'タイトルが未入力です';
    } else if (items.isEmpty) {
      error = '少なくとも1つの画像を挿入してください';
    } else {
      error = null;
    }
    return error == null;
  }

  Section clone() {
    return Section(
      id: id,
      name: name,
      type: type,
      items: items.map((e) => e.clone()).toList(),
    );
  }

  @override
  String toString() {
    return 'Section{name: $name, type: $type, items: $items}';
  }
}
