import 'package:flutter/material.dart';
import 'package:loja_virtual/models/product.dart';
import 'package:loja_virtual/screens/edit_product/images_form.dart';

class EditProductScreen extends StatelessWidget {
  static const routeName = '/edit_product';

  @override
  Widget build(BuildContext context) {
    final Product product =
        ModalRoute.of(context).settings.arguments; /*製品を引き継いでそれを編集*/
    return Scaffold(
      appBar: AppBar(
        title: Text('editing'),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          ImagesForm(product),
        ],
      ),
    );
  }
}
