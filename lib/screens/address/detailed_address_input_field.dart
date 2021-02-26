import 'package:flutter/material.dart';
import 'package:loja_virtual/models/address.dart';
import 'package:loja_virtual/models/cart_manager.dart';
import 'package:provider/provider.dart';

class DetailedAddressInputField extends StatelessWidget {
  DetailedAddressInputField(this.address);

  final Address address;

  @override
  Widget build(BuildContext context) {
    final cartManager = context.watch<CartManager>();

    if (address.postal != null) //住所入力完了し保存したら別Widget。
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          TextFormField(
            enabled: !cartManager.loading,
            initialValue: '${address.prefecture}${address.city}',
            //選択された住所別に表示。
            decoration:
                InputDecoration(labelText: '都道府県市区町村', hintText: '東京都千代田区'),
            validator: (text) {
              if (text.isEmpty) {
                return '入力してください';
              } else {
                return null;
              }
            },
            onSaved: (text) => address.allStreetAddress = text,
          ),
          TextFormField(
            enabled: !cartManager.loading,

            initialValue: '${address.town}',
            //選択された住所別に表示。
            decoration: InputDecoration(
              labelText: '番地・建物名',
            ),
            validator: (text) {
              if (text.isEmpty) {
                return '入力してください';
              } else {
                return null;
              }
            },
            onSaved: (text) => address.subStreetAddress = text,
          ),
          if (cartManager.loading)
            LinearProgressIndicator(
              valueColor: AlwaysStoppedAnimation(
                Theme.of(context).primaryColor,
              ),
              backgroundColor: Colors.transparent,
            ),
          RaisedButton(
            color: Theme.of(context).primaryColor,
            disabledColor: Theme.of(context).primaryColor.withAlpha(100),
            textColor: Colors.white,
            child: Text('住所確定'),
            onPressed: !cartManager.loading ?() async {
              if (Form.of(context).validate()) {
                Form.of(context).save(); /*上のonSaved2つを保存*/
                try {
                  await context.read<CartManager>().setAddress(address);
                } catch (e) {
                  Scaffold.of(context).showSnackBar(
                    SnackBar(
                      content: Text('$e'),
                      /*setAddressのエラーテキスト*/
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            }:null,
          )
        ],
      );
    else if (address.postal != null)
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(
            address.allStreetAddress,
            style: TextStyle(fontSize: 17),
          ),
          Text(
            address.subStreetAddress,
            style: TextStyle(fontSize: 17),
          ),
        ],
      );
    else
      return Container();
  }
}
