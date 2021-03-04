import 'package:flutter/material.dart';
import 'package:loja_virtual/models/product.dart';
import 'package:loja_virtual/screens/product/product_screen.dart';

class ProductListTile extends StatelessWidget {
  final Product product;

  ProductListTile(this.product);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.of(context).pushNamed(ProductScreen.routeName,arguments: product);
      },
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 16,vertical: 4,),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        child: Container(
          height: 100,
          padding: EdgeInsets.all(8),
          child: Row(
            children: [
              AspectRatio(
                aspectRatio: 1,
                child: Image.network(product.images.first),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 4),
                      child: Text(
                        product.description,
                        style: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 12,
                        ),
                      ),
                    ),
                    Text(
                      '¥${product.basePrice}',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    if(!product.hasStock)
                      Padding(
                        padding: EdgeInsets.only(top: 4),
                        child: Text(
                          '在庫切れ',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.red,
                          ),
                        ),
                      )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
