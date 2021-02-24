import 'package:flutter/material.dart';
import 'package:loja_virtual/models/product.dart';
import 'package:loja_virtual/screens/edit_product/images_form.dart';
import 'package:loja_virtual/screens/edit_product/sizes_form.dart';
import 'package:provider/provider.dart';

class EditProductScreen extends StatelessWidget {
  static const routeName = '/edit_product';

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final Product product = ModalRoute.of(context)
        .settings
        .arguments; //Productの引数を取得。製品情報を引き継いでそれを編集
    return ChangeNotifierProvider.value(
      value: product,
      child: Scaffold(
        appBar: AppBar(
          title: Text((product.name != null) ? '編集' : '新規作成'),
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
                      onSaved: (name) => product.name = name,
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
                      validator: (desc) {
                        if (desc.isEmpty) {
                          return '詳細が未入力です';
                        } else {
                          return null;
                        }
                      },
                      onSaved: (desc) => product.description = desc,
                    ),
                    SizesForm(product),
                    SizedBox(height: 20),
                    Consumer<Product>(builder: (_, product, __) {
                      return SizedBox(
                        height: 44,
                        child: RaisedButton(
                          onPressed: !product.loading
                              ? () async{
                                  // 各Fieldのvalidatorを呼び出す
                                  if (formKey.currentState.validate()) {
                                    // 入力データが正常な場合の処理
                                    formKey.currentState.save();
                                    await product.save();
                                    Navigator.of(context).pop();
                                  }
                                }
                              : null,
                          child: product.loading
                              ? CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation(Colors.white),
                          )
                              : Text(
                                  '保存',
                                  style: TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                          textColor: Colors.white,
                          color: Theme.of(context).primaryColor,
                          disabledColor:
                              Theme.of(context).primaryColor.withAlpha(100),
                        ),
                      );
                    })
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
