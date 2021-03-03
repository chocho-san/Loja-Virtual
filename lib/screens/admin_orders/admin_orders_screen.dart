import 'package:flutter/material.dart';
import 'package:loja_virtual/common/custom_drawer.dart';
import 'package:loja_virtual/common/custom_icon_button.dart';
import 'package:loja_virtual/common/empty_card.dart';
import 'package:loja_virtual/common/order_tile.dart';
import 'package:loja_virtual/models/admin_order_manager.dart';
import 'package:loja_virtual/models/order.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class AdminOrdersScreen extends StatelessWidget {
  final PanelController panelController = PanelController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(),
      appBar: AppBar(
        title: Text('Orders'),
        centerTitle: true,
      ),
      body: Consumer<AdminOrderManager>(
        builder: (_, adminOrderManager, __) {
          return SlidingUpPanel(
            controller: panelController,
            body: Column(
              children: <Widget>[
                if (adminOrderManager.userFilter != null)
                  Padding(
                    padding: EdgeInsets.fromLTRB(16, 0, 16, 2),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            '${adminOrderManager.userFilter.name}さんの注文',
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        CustomIconButton(
                          iconData: Icons.close,
                          color: Colors.white,
                          onTap: () {
                            adminOrderManager.setUserFilter(null);
                            /*フィルター外してみんなのオーダー画面に切り替わる*/
                          },
                        )
                      ],
                    ),
                  ),
                if (adminOrderManager.filteredOrders.isEmpty)
                  Expanded(
                    child: EmptyCard(
                      title: '注文がありません',
                      iconData: Icons.border_clear,
                    ),
                  )
                else
                  Expanded(
                    child: ListView.builder(
                        itemCount: adminOrderManager.filteredOrders.length,
                        itemBuilder: (_, index) {
                          return OrderTile(
                            adminOrderManager.filteredOrders[index],
                            showControls: true,
                          );
                        }),
                  ),
                SizedBox(height: 120),
              ],
            ),
            minHeight: 40,
            maxHeight: 250,
            panel: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                GestureDetector(
                  onTap: () {
                    /*タップするだけでもOK*/
                    if (panelController.isPanelClosed) {
                      panelController.open();
                    } else {
                      panelController.close();
                    }
                  },
                  child: Container(
                    height: 40,
                    color: Colors.white,
                    alignment: Alignment.center,
                    child: Text(
                      'フィルター',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    children: Status.values.map((Status status) {
                      return CheckboxListTile(
                        title: Text(Order.getStatusText(status)),
                        dense: true,
                        activeColor: Theme.of(context).primaryColor,
                        value: adminOrderManager.statusFilter.contains(status),
                        onChanged: (bool value) {
                          adminOrderManager.setStatusFilter(
                            status: status,
                            enabled: value,
                          );
                        },
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
