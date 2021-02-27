import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/models/cart_manager.dart';
import 'package:loja_virtual/models/product.dart';
import 'package:loja_virtual/models/user_manager.dart';
import 'file:///C:/Users/marur/AndroidStudioProjects/loja_virtual/lib/screens/cart/cart_screen.dart';
import 'package:loja_virtual/screens/edit_product/edit_product_screen.dart';
import 'file:///C:/Users/marur/AndroidStudioProjects/loja_virtual/lib/screens/login/login_screen.dart';
import 'file:///C:/Users/marur/AndroidStudioProjects/loja_virtual/lib/screens/product/size_widget.dart';
import 'package:provider/provider.dart';

class ProductScreen extends StatelessWidget {
  static const routeName = '/product';

  @override
  Widget build(BuildContext context) {
    final Product product = ModalRoute.of(context).settings.arguments;
    //Screen画面なのでbuild下に引数定義
    return ChangeNotifierProvider.value(
      value: product,
      child: Scaffold(
        appBar: AppBar(
          title: Text(product.name),
          centerTitle: true,
          actions: [
            Consumer<UserManager>(builder: (_, userManager, __) {
              if (userManager.adminEnabled) {
                return IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    Navigator.of(context).pushReplacementNamed(
                      EditProductScreen.routeName,
                      arguments: product,
                    );
                  },
                );
              } else {
                return Container();
              }
            }),
          ],
        ),
        backgroundColor: Colors.white,
        body: ListView(
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: Carousel(
                images: product.images.map((url) {
                  return NetworkImage(url);
                }).toList(),
                dotSize: 4,
                dotSpacing: 15,
                dotBgColor: Colors.transparent,
                dotColor: Theme.of(context).primaryColor,
                autoplay: false,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    product.name,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 8),
                    child: Text(
                      '価格',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 13,
                      ),
                    ),
                  ),
                  Text(
                    '¥${product.basePrice}',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 16, bottom: 8),
                    child: Text(
                      '詳細',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Text(
                    product.description,
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 16, bottom: 8),
                    child: Text(
                      'サイズ',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Wrap(
                    spacing: 10,
                    runSpacing: 8,
                    children: product.sizes.map((s) {
                      return SizeWidget(
                        size: s,
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 20),
                  if (product.hasStock)
                    Consumer2<UserManager, Product>(
                      /*2つの状態変数を使いたい*/
                      builder: (_, userManager, product, __) {
                        return SizedBox(
                          height: 44,
                          child: RaisedButton(
                            onPressed: product.selectedSize != null
                                ? () {
                                    if (userManager.isLoggedIn) {
                                      context
                                          .read<CartManager>()
                                          .addToCart(product);
                                      Navigator.of(context)
                                          .pushNamed(CartScreen.routeName);
                                    } else {
                                      Navigator.of(context)
                                          .pushNamed(LoginScreen.routeName);
                                    }
                                  }
                                : null,
                            color: Theme.of(context).primaryColor,
                            textColor: Colors.white,
                            child: Text(
                              userManager.isLoggedIn ? 'カートに追加' : 'ログインして購入',
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
