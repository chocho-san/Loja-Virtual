import 'package:flutter/material.dart';
import 'package:loja_virtual/models/address.dart';
import 'package:loja_virtual/service/postal.dart';
import 'package:provider/provider.dart';

class AddressSelection extends StatelessWidget {
  AddressSelection(this.address);

  final Address address;

  @override
  Widget build(BuildContext context) {
    final town = '${address.prefecture}${address.city}${address.town}';
    final townSelect = context.watch<Postal>();
    return Column(
      children: <Widget>[
        Container(
          child: Column(
            children: <Widget>[
              TownSelect(
                town: town,
                townSelect: townSelect.townSelectValue,
                onSelect: (val) {
                  townSelect.townSelect = val;
                },
              ),
            ],
          ),
        )
      ],
    );
  }
}

class TownSelect extends StatelessWidget {
  TownSelect({this.town, this.townSelect, this.onSelect});

  final String town;
  final bool townSelect;
  final onSelect;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Text(town),
        Checkbox(
          value: townSelect,
          onChanged: onSelect,
        ),
      ],
    );
  }
}
