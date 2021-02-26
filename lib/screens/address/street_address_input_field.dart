import 'package:flutter/material.dart';
import 'package:loja_virtual/models/address.dart';
import 'package:loja_virtual/service/postal.dart';
import 'package:provider/provider.dart';


class StreetAddressInputField extends StatelessWidget {
  StreetAddressInputField(this.address);
  final Address address;

  @override
  Widget build(BuildContext context) {
    final postal = context.watch<Postal>();
    final addressData = context.watch<Address>();
    final city = '${address.prefecture}${address.city}';
    final town = '${address.town}';

    if (!postal.onSaved) //住所入力完了し保存したら別Widget。
      return Column(
        children: <Widget>[
          TextFormField(
            initialValue:
                 city
               , //選択された住所別に表示。
            decoration:
            InputDecoration(labelText: '都道府県市区町村', hintText: '東京都千代田区'),
            validator: (text) {
              if (text.isEmpty) {
                return '入力してください';
              } else {
                return null;
              }
            },
            onSaved: (text) => addressData.allStreetAddress = text,
          ),
          TextFormField(
            initialValue:
                 town
                , //選択された住所別に表示。
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
            onSaved: (text) => addressData.subStreetAddress = text,
          ),
          if (!postal.onSaved)
            RaisedButton(
              onPressed: () {
                if (Form.of(context).validate()) {
                  //validate問題無ければセーブ。
                  Form.of(context).save();
                  context.read<Postal>().onSave = true;
                }
              },
              color: Theme.of(context).primaryColor,
              disabledColor: Theme.of(context).primaryColor.withAlpha(100),
              textColor: Colors.white,
              child: Text('住所確定'),
            )
        ],
      );
    else
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(addressData.allStreetAddress,style: TextStyle(fontSize: 17),),
          Text(addressData.subStreetAddress,style: TextStyle(fontSize: 17),),
        ],
      );
  }
}