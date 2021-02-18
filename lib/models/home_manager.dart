import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:loja_virtual/models/section.dart';
import 'package:flutter/material.dart';



class HomeManager extends ChangeNotifier{
  HomeManager() {
    _loadSections();
  }

  List<Section> sections = [];

  Future<void> _loadSections() async {
    FirebaseFirestore.instance
        .collection('home')
        .snapshots() /*.get()とは異なり、リアルタイム更新*/
        .listen(
      (snapshot) {
        sections.clear();/*一旦クリアしないと同じものが複製されちゃう*/
        for (final DocumentSnapshot document in snapshot.docs) {
          sections.add(Section.fromDocument(document));
        }
notifyListeners();
      },
    );
  }
}
