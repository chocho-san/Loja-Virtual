import 'package:flutter/material.dart';
import 'package:loja_virtual/screens/address/address_card.dart';

class AddressScreen extends StatelessWidget {
  static const routeName='/address';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('配達'),
        centerTitle: true,
      ),
      body: ListView(
        children: <Widget>[
          AddressCard(),
        ],
      ),
    );
  }
}
