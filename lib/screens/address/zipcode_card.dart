import 'package:flutter/material.dart';
import 'package:loja_virtual/models/address.dart';
import 'package:loja_virtual/models/cart_manager.dart';
import 'package:loja_virtual/screens/address/zipcode_input_field.dart';
import 'package:loja_virtual/screens/address/address_input_field.dart';
import 'package:provider/provider.dart';

class AddressCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: EdgeInsets.fromLTRB(16, 16, 16, 4),
        child: Consumer<CartManager>(builder: (_, cartManager, __) {
          final address = cartManager.address ?? Address(); //nullだったら空情報。
          return Form(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  '配送先住所',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                ZipCodeInputField(address),
                // if (address.postal != null && !cartManager.townSelectValue)
                  //addressの情報がない場合は非表示。townSelectValue押されたら非表示。
                // if (cartManager.townSelectValue)
                  if (address.postal != null)
                    AddressInputField(address),
              ],
            ),
          );
        }),
      ),
    );
  }
}
