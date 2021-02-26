import 'package:flutter/material.dart';
import 'package:loja_virtual/models/address.dart';
import 'package:loja_virtual/screens/address/address_input_field.dart';
import 'package:loja_virtual/screens/address/address_selection.dart';
import 'package:loja_virtual/screens/address/street_address_input_field.dart';
import 'package:loja_virtual/service/postal.dart';
import 'package:provider/provider.dart';

class AddressCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: EdgeInsets.fromLTRB(16, 16, 16, 4),
        child: Consumer<Postal>(builder: (_, postal, __) {
          final address = postal.address ?? Address(); //nullだったら空情報。
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
                AddressInputField(address),
                if (address.postal != null &&
                    !postal.townSelectValue)
                  //addressの情報がない場合は非表示。townSelectValue押されたら非表示。
                  AddressSelection(address),
                if (postal.townSelectValue)
                  if (address.postal != null) StreetAddressInputField(address),
              ],
            ),
          );
        }),
      ),
    );
  }
}
