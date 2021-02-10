import 'package:cloud_firestore/cloud_firestore.dart';

class Users{
  String id;
  String name;
   String email;
   String password;
   String confirmPassword;



  Users({this.id,this.name,this.email,this.password});



  DocumentReference get firestoreRef=>
  FirebaseFirestore.instance.collection('users').doc(id);
  
  Future<void> saveData()async{
    await firestoreRef.set(toMap());
  }

  Map<String,dynamic>toMap(){
    return{
      'name':name,
      'email':email,
    };
  }
  
}