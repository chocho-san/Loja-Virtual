import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:loja_virtual/models/section.dart';
import 'package:flutter/material.dart';

class HomeManager extends ChangeNotifier {
  HomeManager() {
    _loadSections();
  }

  bool editing = false;
  bool loading = false;

  final List<Section> _sections = [];

  List<Section> get sections {
    if (editing) {
      return _editingSections;
    } else {
      return _sections;
    }
  }

  List<Section> _editingSections = [];


  Future<void> _loadSections() async {
    FirebaseFirestore.instance
        .collection('home')
    .orderBy('pos')
        .snapshots() /*.get()とは異なり、リアルタイム更新*/
        .listen(
      (snapshot) {
        _sections.clear(); /*一旦クリアしないと同じものが複製されちゃう*/
        for (final DocumentSnapshot document in snapshot.docs) {
          _sections.add(Section.fromDocument(document));
        }
        notifyListeners();
      },
    );
  }

  void addSection(Section section){
    _editingSections.add(section);
    notifyListeners();
  }

  void removeSection(Section section){
    _editingSections.remove(section);

    notifyListeners();
  }

  void enterEditing() {
    editing = true;
    _editingSections = _sections.map((s) => s.clone()).toList();

    notifyListeners();
  }

  Future<void> saveEditing() async{
    bool valid = true;
    for(final section in _editingSections){
      if(!section.valid()) valid = false;
    }
    if(!valid) return;
    loading = true;
    notifyListeners();

    int pos =0;
    for(final section in _editingSections){
      await section.save(pos);
      pos++;
    }
    for(final section in List.from(_sections)) {
      if (!_editingSections.any((element) => element.id == section.id)) {
        await section.delete();
      }
    }
    loading = false;
    editing = false;
    notifyListeners();
  }

  void discardEditing() {
    editing = false;
    notifyListeners();
  }
}
