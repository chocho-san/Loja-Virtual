import 'dart:io';

import 'package:flutter/material.dart';
import 'package:loja_virtual/models/home_manager.dart';
import 'package:loja_virtual/models/product.dart';
import 'package:loja_virtual/models/product_manager.dart';
import 'package:loja_virtual/models/section.dart';
import 'package:loja_virtual/models/section_item.dart';
import 'package:loja_virtual/screens/product/product_screen.dart';
import 'package:loja_virtual/screens/select_product/select_product_screen.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';

class ItemTile extends StatelessWidget {
  final SectionItem item;

  ItemTile(this.item);

  @override
  Widget build(BuildContext context) {
    final homeManager = context.watch<HomeManager>();
    return GestureDetector(
      onTap: () {  /*ワンタップ*/
        if (item.product != null) {
          final product =
              context.read<ProductManager>().findProductById(item.product);
          if (product != null) {
            Navigator.of(context)
                .pushNamed(ProductScreen.routeName, arguments: product);
          }
        }
      },
      onLongPress: homeManager.editing?(){  /*長押し*/
        showDialog(
            context: context,
            builder: (_){
              final product = context.read<ProductManager>()
                  .findProductById(item.product);
              return AlertDialog(
                title: Text('編集する'),
                content: product != null
                    ? ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Image.network(product.images.first),
                  title: Text(product.name),
                  subtitle: Text('¥ ${product.basePrice}'),
                )
                    : null,
                actions: <Widget>[
                  FlatButton(
                    onPressed: (){
                      context.read<Section>().removeItem(item);
                      Navigator.of(context).pop();
                    },
                    textColor: Colors.red,
                    child: Text('削除'),
                  ),
                  FlatButton(
                    onPressed: () async {
                      if(product != null){
                        item.product = null;
                      } else {
                        final Product product = await Navigator.of(context)
                            .pushNamed(SelectProductScreen.routeName) as Product;
                        item.product = product?.id;
                      }
                      Navigator.of(context).pop();
                    },
                    child: Text(
                        product != null
                            ? 'リンク解除'
                            : 'リンクさせる'
                    ),
                  ),
                ],
              );
            }
        );
      }:null,
      child: AspectRatio(
        aspectRatio: 1,
        child: item.image is String
            ? FadeInImage.memoryNetwork(
                placeholder: kTransparentImage,
                image: item.image as String,
                fit: BoxFit.cover,
              )
            : Image.file(
                item.image as File,
                fit: BoxFit.cover,
              ),
      ),
    );
  }
}
