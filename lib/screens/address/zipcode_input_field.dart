import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loja_virtual/common/custom_icon_button.dart';
import 'package:loja_virtual/models/address.dart';
import 'package:loja_virtual/models/cart_manager.dart';
import 'package:provider/provider.dart';

class ZipCodeInputField extends StatelessWidget {
  final Address address;

  ZipCodeInputField(this.address);

  final TextEditingController zipController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final cartManager = context.watch<CartManager>();

    if (address.postal == null)
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextFormField(
          controller: zipController,
          onChanged: (text) => cartManager.postAddress = text,
          initialValue: address.postal,
          decoration: InputDecoration(
              isDense: true, labelText: '郵便番号', hintText: '1234567'),
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly //数字のみ使用可
          ],
          validator: (text) {
            if (text.isEmpty) {
              return '入力して下さい';
            } else if (text.length > 7 || text.length < 5) {
              return '無効な郵便番号';
            } else {
              return null;
            }
          },
        ),
        if(cartManager.loading)
          LinearProgressIndicator(
            valueColor: AlwaysStoppedAnimation(Theme.of(context).primaryColor),
          backgroundColor: Colors.transparent,
          ),
        RaisedButton(
          color: Theme.of(context).primaryColor,
          disabledColor: Theme.of(context).primaryColor.withAlpha(100),
          textColor: Colors.white,
          child: Text('検索'),
          onPressed: !cartManager.loading ?() async {
            if (Form.of(context).validate()) {
              Form.of(context).save();
              try {
                //郵便番号情報受け取り失敗または入力ミスを通知。
                await context.read<CartManager>().getAddress(zipController.text);
              } catch (e) {
                Scaffold.of(context).showSnackBar(
                  SnackBar(
                    content: Text('郵便番号を再入力して下さい'),
                    backgroundColor: Colors.red,

                  ),
                );

              }
            }
          }:null,
        ),
      ],
    );
    else //情報取得できたら埋め込みテキスト。
      return Padding(
        padding:  EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Text(
                '〒 ${address.postal}',
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.w700,
                  fontSize: 17,
                ),
              ),
            ),
            CustomIconButton(
              iconData: Icons.edit,
              color: Theme.of(context).primaryColor,
              size: 20,
              onTap: () {
                context.read<CartManager>().removeAddress(); //郵便番号をクリア　
              },
            )
          ],
        ),
      );
  }
}
