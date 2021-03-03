import 'package:flutter/material.dart';
import 'package:loja_virtual/common/cancel_order_dialog.dart';
import 'package:loja_virtual/common/export_address_dialog.dart';
import 'package:loja_virtual/models/order.dart';
import 'package:loja_virtual/screens/orders/order_product_tile.dart';

class OrderTile extends StatelessWidget {
  final Order order;
  final bool showControls;

  OrderTile(this.order, {this.showControls = false});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ExpansionTile(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  order.formattedId,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                Text(
                  '¥ ${order.price}',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            Text(
              order.statusText,
              style: TextStyle(
                  fontWeight: FontWeight.w400,
                  color: order.status == Status.canceled
                      ? Colors.red
                      : Theme.of(context).primaryColor,
                  fontSize: 14),
            )
          ],
        ),
        children: [
          Column(
            children: order.items.map((e) {
              return OrderProductTile(e);
            }).toList(),
          ),
          if (showControls &&
              order.status != Status.canceled) /*キャンセル押されたら下は表示されない*/
            SizedBox(
              height: 50,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: <Widget>[
                  FlatButton(
                    textColor: Colors.red,
                    child: Text('キャンセル'),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (_) => CancelOrderDialog(order),
                      );
                    },
                  ),
                  FlatButton(
                    /*onPressed:nullの時は自動で色が薄くなる*/
                    onPressed: order.back,
                    child: Text('戻る'),
                  ),
                  FlatButton(
                    onPressed: order.advance,
                    child: Text('進む'),
                  ),
                  FlatButton(
                    textColor: Theme.of(context).primaryColor,
                    child: Text('完了'),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (_) => ExportAddressDialog(order.address),
                      );
                    },
                  )
                ],
              ),
            )
        ],
      ),
    );
  }
}
