import 'package:flutter/material.dart';
import 'package:loja_virtual/common/empty_card.dart';
import 'package:loja_virtual/common/login_card.dart';
import 'package:loja_virtual/common/price_card.dart';
import 'package:loja_virtual/models/cart_manager.dart';
import 'package:loja_virtual/screens/address/address_screen.dart';
import 'package:loja_virtual/screens/cart/cart_tile.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('カート'),
        centerTitle: true,
      ),
      body: Consumer<CartManager>(
        builder: (_, cartManager, __) {
          if(cartManager.users ==null){
            return LoginCard();
          }
          if(cartManager.items.isEmpty){
            return EmptyCard(
              iconData: Icons.remove_shopping_cart,
              title: 'お客様のカートに商品はありません。',
            );
          }
          return ListView(
            children: [
              Column(
                children: cartManager.items
                    .map((cartProduct) => CartTile(cartProduct))
                    .toList(),
              ),
              PriceCard(
                buttonText: '購入',
                onPressed: cartManager.isCartValid ? () {
                  Navigator.of(context).pushNamed(AddressScreen.routeName);
                } : null,
              ),
            ],
          );
        },
      ),
    );
  }
}
