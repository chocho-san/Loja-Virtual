import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Product{

  Product.fromDocument(DocumentSnapshot document) {
    id = document.id;
    name = document.data()['name'] as String;
    description = document.data()['description']as String;
    images = List<String>.from(document.data()['images']);
  }

  String id;
  String name;
  String description;
  List<String> images;

}