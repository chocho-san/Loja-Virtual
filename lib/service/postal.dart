import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/models/address.dart';
import 'package:loja_virtual/models/postal_address.dart';


class Postal extends ChangeNotifier {

  Address address;

  bool _townSelectValue = false;
  bool get townSelectValue => _townSelectValue;
  set townSelect(bool select) {
    _townSelectValue = select;
    notifyListeners();
  }

  bool _addressGet = false;
  bool get addressGet => _addressGet;

  String _postAddress;
  String get postsAddress => _postAddress;
  set postAddress(String value) {
    _postAddress = value;
  }

  bool _onSave = false;
  bool get onSaved => _onSave;
  set onSave(bool value) {
    _onSave = value;
    notifyListeners();
  }


  Future<void> getAddress(String postalCode) async {
    _addressGet = false;
    //郵便番号情報取得API元　http://geoapi.heartrails.com/

    final url = 'http://geoapi.heartrails.com/api/json?method=searchByPostal&postal=$postalCode';

    final Dio dio = Dio(); //Httpパッケージの上位ver

    try {
      Response response = await dio.get(url);
      final addressData = PostalAddress.fromMap(response.data); //jsonデーターを渡し、データを個別に抽出。
      address = Address( //Addressにデーターを移行。
        prefecture: addressData.prefecture,
        city: addressData.city,
        town: addressData.town,
        postal: addressData.postal,
        latitude: double.parse(addressData.latitude),
        longitude: double.parse(addressData.longitude),
      );
      _addressGet = true;
      notifyListeners();
    }  catch (e) {
      throw Future.error('無効です');
    }
  }


  void postRemove() {
    address = null;
    _townSelectValue = false;
    notifyListeners();
  }


}