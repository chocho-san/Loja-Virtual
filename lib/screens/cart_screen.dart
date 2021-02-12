import 'package:flutter/material.dart';
import 'package:loja_virtual/models/cart_manager.dart';
import 'package:loja_virtual/screens/cart_tile.dart';
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
          return /*CartTile(cartManager.items[0]);*/

          Column(
            children:
              cartManager.items
                  .map((cartProduct) => CartTile(cartProduct))
                  .toList(),

          );
        },
      ),
    );
  }
}
