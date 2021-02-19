import 'package:flutter/material.dart';
import 'package:loja_virtual/models/product.dart';
import 'package:loja_virtual/screens/edit_product/images_form.dart';
import 'package:loja_virtual/screens/edit_product/sizes_form.dart';

class EditProductScreen extends StatelessWidget {
  static const routeName = '/edit_product';

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final Product product =
        ModalRoute.of(context).settings.arguments; /*製品を引き継いでそれを編集*/
    return Scaffold(
      appBar: AppBar(
        title: Text('editing'),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: Form(
        key: formKey,
        child: ListView(
          children: [
            ImagesForm(product),
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    initialValue: product.name,
                    decoration: InputDecoration(
                      hintText: 'タイトル',
                      border: InputBorder.none,
                    ),
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                    validator: (name) {
                      if (name.isEmpty) {
                        return '商品名が未入力です';
                      } else {
                        return null;
                      }
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 4),
                    child: Text(
                      '価格',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 13,
                      ),
                    ),
                  ),
                  Text(
                    '¥...',
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
                  TextFormField(
                    initialValue: product.description,
                    style: TextStyle(
                      fontSize: 16,
                    ),
                    decoration: InputDecoration(
                      hintText: '詳細',
                      border: InputBorder.none,
                    ),
                    maxLines: null,
                    validator: (desc){
                      if(desc.isEmpty){
                        return '詳細が未入力です';
                      } else {
                        return null;
                      }
                    },
                  ),

                  SizesForm(product),
                  RaisedButton(
                    onPressed: () {
                      // 各Fieldのvalidatorを呼び出す
                      if (formKey.currentState.validate()) {
                        // 入力データが正常な場合の処理
                        print('valid');
                      }
                    },
                    child: Text('保存'),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
