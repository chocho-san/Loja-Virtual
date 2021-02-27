import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:loja_virtual/models/address.dart';

class Users {
  String name;
  String id;
  String email;
  String password;
  String confirmPassword;
  bool admin=false;
  Address address;

  Users({this.id, this.name, this.email, this.password});


  Users.fromDocument(DocumentSnapshot document) {
    id =document.id;
    name = document.data()['name'];
    email = document.data()['email'];
    if(document.data().containsKey('address')){
      address = Address.fromMap(
          document.data()['address'] as Map<String, dynamic>);
    }
  }




/*Firestoreにユーザーを保存*/
  Future<void> saveData() async {
    await firestoreRef.set(toMap());
  }

  DocumentReference get firestoreRef =>
      FirebaseFirestore.instance.collection('users').doc(id);


  /*Firestoreにカート内商品を追加*/
  CollectionReference get cartRef =>
      firestoreRef.collection('cart');

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      if(address != null)
        'address':address.toMap(),
    };
  }

  void setAddress(Address address){
    this.address = address;
    saveData();
  }




}
