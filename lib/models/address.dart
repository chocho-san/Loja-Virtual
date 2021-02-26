import 'package:flutter/foundation.dart';

class Address extends ChangeNotifier {
  Address({this.prefecture,this.city,this.town,this.postal, this.latitude,this.longitude});
  String prefecture; //都道府県
  String city; //区
  String town; //町
  String postal; //郵便番号
  String _allStreetAddress; //全ての住所情報。
  String _subStreetAddress;
  double longitude; //経度
  double latitude; //緯度

  String get allStreetAddress => _allStreetAddress;
  set allStreetAddress(String value) {
    _allStreetAddress = value;
    notifyListeners();
  }

  String get subStreetAddress => _subStreetAddress;
  set subStreetAddress(String value) {
    _subStreetAddress = value;
    notifyListeners();
  }
}
