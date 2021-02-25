import 'package:flutter/material.dart';
import 'package:loja_virtual/models/home_manager.dart';
import 'package:loja_virtual/models/section.dart';

class AddSectionWidget extends StatelessWidget {
  final HomeManager homeManager;

  AddSectionWidget(this.homeManager);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: FlatButton(
            onPressed: () {
              homeManager.addSection(Section(type: 'List'));
            },
            textColor: Colors.white,
            child: Text('リストを追加'),
          ),
        ),
        Expanded(
          child: FlatButton(
            onPressed: () {
              homeManager.addSection(Section(type: 'Staggered'));
            },
            textColor: Colors.white,
            child: Text('グリッドを追加'),
          ),
        ),
      ],
    );
  }
}
