import 'package:flutter/material.dart';
import 'package:loja_virtual/common/price_card.dart';
import 'package:loja_virtual/models/cart_manager.dart';
import 'package:loja_virtual/screens/address/zipcode_card.dart';
import 'package:loja_virtual/screens/checkout/checkout_screen.dart';
import 'package:provider/provider.dart';

class AddressScreen extends StatelessWidget {
  static const routeName = '/address';

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
          Consumer<CartManager>(
            builder: (_, cartManager, __) {
                return PriceCard(
                  buttonText: '支払いする',
                  onPressed: cartManager.isAddressValid ? () {
                    Navigator.of(context).pushNamed(CheckoutScreen.routeName);

                  } : null,
                );

            },
          ),
        ],
      ),
    );
  }
}
