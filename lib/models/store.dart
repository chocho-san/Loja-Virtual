import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/models/address.dart';
import 'package:loja_virtual/helpers/extensions.dart';


enum StoreStatus { closed, open, closing }

class Store {
  String name;
  String image;
  String phone;
  Address address;
  Map<String, Map<String, TimeOfDay>> opening;
  StoreStatus status;


  Store.fromDocument(DocumentSnapshot doc) {
    name = doc.data()['name'] as String;
    image = doc.data()['image'] as String;
    phone = doc.data()['phone'] as String;
    address = Address.fromMap(doc.data()['address'] as Map<String, dynamic>);
    opening = (doc.data()['opening'] as Map<String, dynamic>).map(
          (key, value) {
        final timesString = value as String;

        if (timesString != null && timesString.isNotEmpty) {
          final splitted = timesString.split(RegExp(r"[:-]"));
          // 8:00-12:00
          //[8, 00, 12, 00]に変換
          return MapEntry(
            key,
            {
              "from": TimeOfDay(
                  hour: int.parse(splitted[0]), minute: int.parse(splitted[1])),
              "to": TimeOfDay(
                  hour: int.parse(splitted[2]), minute: int.parse(splitted[3])),
            },
          );
        } else {
          return MapEntry(key, null);
        }
      },
    );

    // saturday : 8:00-12:00
    // saturday : from: 8:00 to: 12:00  にしたい
updateStatus();
  }

  String get addressText =>
      '${address.prefecture}${address.city}${address.town}';

  String get openingText {
    return
      '月～金: ${formattedPeriod(opening['monfri'])}\n'
          '土: ${formattedPeriod(opening['saturday'])}\n'
          '日: ${formattedPeriod(opening['sunday'])}';
  }

  String formattedPeriod(Map<String, TimeOfDay> period) {
    if (period == null) return "休み";
    return '${period['from'].formatted()} - ${period['to'].formatted()}';
  }

  String get cleanPhone => phone.replaceAll(RegExp(r"[^\d]"), "");


  void updateStatus() {/*まさに今の営業状況確認*/
    final weekDay = DateTime
        .now()
        .weekday;
    Map<String, TimeOfDay> period;
    if (weekDay >= 1 && weekDay <= 5) {
      period = opening['monfri'];
    } else if (weekDay == 6) {
      period = opening['saturday'];
    } else {
      period = opening['sunday'];
    }
    final now = TimeOfDay.now();
    if(period == null){
      status = StoreStatus.closed;
    } else if(period['from'].toMinutes() < now.toMinutes()
        && period['to'].toMinutes() - 15 > now.toMinutes()){
      status = StoreStatus.open;
    } else if(period['from'].toMinutes() < now.toMinutes()
        && period['to'].toMinutes() > now.toMinutes()){
      status = StoreStatus.closing;
    } else {
      status = StoreStatus.closed;
    }
  }

  String get statusText {
    switch(status){
      case StoreStatus.closed:
        return '営業時間外';
      case StoreStatus.open:
        return '営業中';
      case StoreStatus.closing:
        return 'まもなく閉店';
      default:
        return '';
    }
  }

}