import 'package:flutter/material.dart';
import 'package:loja_virtual/models/product_manager.dart';
import 'package:loja_virtual/models/section_item.dart';
import 'file:///C:/Users/marur/AndroidStudioProjects/loja_virtual/lib/screens/product/product_screen.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';

class ItemTile extends StatelessWidget {
  final SectionItem item;

  ItemTile( this.item);


  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: (){
        if(item.product != null){
          final product = context.read<ProductManager>()
              .findProductById(item.product);
          if(product != null){
            Navigator.of(context).pushNamed(ProductScreen.routeName, arguments: product);
          }
        }
      },
      child: AspectRatio(
        aspectRatio: 1,
        child: FadeInImage.memoryNetwork(
          placeholder: kTransparentImage,
          image: item.image,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
