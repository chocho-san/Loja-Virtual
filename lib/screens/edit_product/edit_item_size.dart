import 'package:flutter/material.dart';
import 'package:loja_virtual/common/custom_icon_button.dart';
import 'package:loja_virtual/models/item_size.dart';

class EditItemSize extends StatelessWidget {
  final ItemSize size;
  final VoidCallback onRemove;
  final VoidCallback onMoveUp;
  final VoidCallback onMoveDown;


  EditItemSize({Key key, this.size, this.onRemove,
    this.onMoveUp, this.onMoveDown}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 30,
          child: TextFormField(
            initialValue: size.name,
            decoration: InputDecoration(
              labelText: 'サイズ',
              isDense: true,
            ),
            validator: (name){
              if(name.isEmpty){
                return 'サイズを入力してください';
              }return null;
            },
            onChanged: (name) => size.name =name ,
          ),

        ),
        SizedBox(width: 4),
        Expanded(
          flex: 30,
          child: TextFormField(
            initialValue: size.stock?.toString(),
            decoration: InputDecoration(
              labelText: '数量',
              isDense: true,
            ),
            keyboardType: TextInputType.number,
            validator: (stock){
              if(int.tryParse(stock)==null){ //整数かどうか
                return '無効';
              }return null;
            },
            onChanged: (stock) => size.stock =int.tryParse(stock) ,

          ),
        ),
        SizedBox(width: 4),

        Expanded(
          flex: 40,
          child: TextFormField(
            initialValue: size.price?.toString(),
            decoration: InputDecoration(
              labelText: '価格',
              isDense: true,
              prefixText: '¥',
            ),
            keyboardType: TextInputType.number,
            validator: (price){
              if(int.tryParse(price)==null){
                return '無効';
              }return null;
            },
            onChanged: (price) => size.price =int.tryParse(price) ,

          ),
        ),
        CustomIconButton(
          iconData: Icons.delete,
          color: Colors.red,
          onTap: onRemove,
        ),

        CustomIconButton(
          iconData: Icons.arrow_drop_up,
          color: Colors.black,
          onTap: onMoveUp,
        ),
        CustomIconButton(
          iconData: Icons.arrow_drop_down,
          color: Colors.black,
          onTap: onMoveDown,
        )
      ],
    );
  }
}
