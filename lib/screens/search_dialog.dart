import 'package:flutter/material.dart';

class SearchDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: 2,
          left: 4,
          right: 4,
          child: Card(
            child: TextFormField(
              // initialValue: initialText,
              textInputAction: TextInputAction.search,/*Enterを虫眼鏡アイコンに*/
              autofocus: true,/*キーボード自動表示*/
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 15),
                prefixIcon: IconButton(
                  icon: Icon(Icons.arrow_back),
                  color: Colors.grey[700],
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
              onFieldSubmitted: (text) {
                Navigator.of(context).pop(text); //popした際に入力されたtextを渡す。
              },            ),
          ),
        ),
      ],
    );
  }
}
