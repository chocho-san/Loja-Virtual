import 'package:flutter/material.dart';
import 'package:loja_virtual/models/address.dart';

class ExportAddressDialog extends StatelessWidget {

  const ExportAddressDialog(this.address);

  final Address address;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title:  Text('配送先住所'),
      content: Text(
        '〒${address.postal}\n'
        '${address.prefecture}${address.city}${address.town}'

      ),
      contentPadding:  EdgeInsets.fromLTRB(16, 16, 16, 0),
      actions: <Widget>[
        FlatButton(

          textColor: Theme.of(context).primaryColor,
          child: Text('配送'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        )
      ],
    );
  }
}