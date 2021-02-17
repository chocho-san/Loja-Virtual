import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:loja_virtual/models/section.dart';

class HomeManager {
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
        for (final DocumentSnapshot document in snapshot.docs) {
          sections.add(Section.fromDocument(document));
        }
        print(sections);
      },
    );

    // notifyListeners();
  }
}
