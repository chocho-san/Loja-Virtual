import 'package:flutter/material.dart';
import 'package:loja_virtual/models/cart_product.dart';
import 'package:loja_virtual/screens/product/product_screen.dart';

class OrderProductTile extends StatelessWidget {

  final CartProduct cartProduct;

  OrderProductTile(this.cartProduct);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.of(context).pushNamed(
           ProductScreen.routeName, arguments: cartProduct.product);
      },
      child: Container(
        margin:  EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        padding:  EdgeInsets.all(8),
        child: Row(
          children: <Widget>[
            SizedBox(
              height: 60,
              width: 60,
              child: Image.network(cartProduct.product.images.first),
            ),
             SizedBox(width: 8,),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    cartProduct.product.name,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 17.0,
                    ),
                  ),
                  Text(
                    'サイズ: ${cartProduct.size}',
                    style: TextStyle(fontWeight: FontWeight.w300),
                  ),
                  Text(
                    '¥ ${(cartProduct.fixedPrice ?? cartProduct.unitPrice)}',
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold
                    ),
                  )
                ],
              ),
            ),
            Text(
              '${cartProduct.quantity}',
              style:  TextStyle(
                  fontSize: 20
              ),
            ),
          ],
        ),
      ),
    );
  }
}
