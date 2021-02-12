import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/models/cart_product.dart';

class CartTile extends StatelessWidget {
  final CartProduct cartProduct;

  const CartTile(this.cartProduct);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            SizedBox(
              height: 80,
              width: 80,
              child: Image.network(cartProduct.product.images.first),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: 16),
                child: Column(
                  children: [
                  Text(
                  cartProduct.product.name,
                  style:
                  TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    'サイズ: ${cartProduct.size}',
                    style: TextStyle(
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),
                Text(
                  /*cartProduct.product.selectedSize.price.toString()だとカートにM入れた後、もう一度ProductScreenでSサイズを選択しただけで、カートの金額だけ変更されちゃう*/
                  '¥${cartProduct.unitPrice}',
                style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ],
        ),
      ),
    ),]
    ,
    )
    ,
    )
    ,
    );
  }
}
