import 'package:flutter/cupertino.dart';
import 'package:loja_virtual/models/item_size.dart';

class EditListController with ChangeNotifier {
  List<ItemSize> itemList ;

  void newList(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final ItemSize itemSize = itemList.removeAt(oldIndex);
    itemList.insert(newIndex, itemSize);
    notifyListeners();
  }
}