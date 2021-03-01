import 'package:flutter/material.dart';
import 'package:loja_virtual/common/price_card.dart';
import 'package:loja_virtual/models/cart_manager.dart';
import 'package:loja_virtual/models/checkout_manager.dart';
import 'package:loja_virtual/screens/base/base_screen.dart';
import 'package:loja_virtual/screens/cart/cart_screen.dart';
import 'package:loja_virtual/screens/product/product_screen.dart';
import 'package:provider/provider.dart';

class CheckoutScreen extends StatelessWidget {
  static const routeName = 'checkout';

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProxyProvider<CartManager, CheckoutManager>(
      create: (_) => CheckoutManager(),
      update: (_, cartManager, checkoutManager) =>
      checkoutManager..updateCart(cartManager),
      lazy: false,
      child: Scaffold(
        appBar: AppBar(
          title: Text('注文確定'),
          centerTitle: true,
        ),
        body: Consumer<CheckoutManager>(
          builder: (_, checkoutManager, __) {
            if (checkoutManager.loading) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(Colors.white),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Text(
                      '注文中.....',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 16),
                    )
                  ],
                ),
              );
            }
            return Form(
              key: formKey,
              child: ListView(
                children: <Widget>[
                  PriceCard(
                    buttonText: '注文を確定する',
                    onPressed: () {
                      if (formKey.currentState.validate()) {
                        checkoutManager.checkout(
                          onStockFail: (e) {
                            /*在庫切れなどの場合*/
                            Navigator.popUntil(
                              /*CartScreenからスタックされてきた画面をクリアしCartScreenまで戻る*/
                              context,
                              ModalRoute.withName(ProductScreen.routeName),
                            );
                          },
                          onSuccess: (order) {
                            Navigator.of(context).popUntil((route) => route.isFirst);
                        },
                        );
                      }
                    },
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
