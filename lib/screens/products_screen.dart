import 'package:flutter/material.dart';
import 'package:loja_virtual/common/custom_drawer.dart';
import 'package:loja_virtual/models/product_manager.dart';
import 'package:loja_virtual/screens/product_list_tile.dart';
import 'package:loja_virtual/screens/search_dialog.dart';
import 'package:provider/provider.dart';

class ProductsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(),
      appBar: AppBar(
        title: Text('Product'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () async {
              await showDialog(context: context, builder: (_) => SearchDialog());
            },
          ),
        ],
      ),
      body: Consumer<ProductManager>(
        builder: (_, productManager, __) {
          return ListView.builder(
            padding: EdgeInsets.all(4),
            itemCount: productManager.allProducts.length,
            itemBuilder: (_, index) {
              return ProductListTile(productManager.allProducts[index]);
            },
          );
        },
      ),
    );
  }
}
