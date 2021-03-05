import 'package:flutter/material.dart';
import 'package:loja_virtual/common/custom_drawer_header.dart';
import 'package:loja_virtual/common/drawer_tile.dart';
import 'package:loja_virtual/models/user_manager.dart';
import 'package:provider/provider.dart';

class CustomDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(225, 203, 236, 241),
                  Colors.white,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          ListView(
            children: [
              CustomDrawerHeader(),
              DrawerTile(
                iconData: Icons.home,
                title: 'トップ',
                page: 0,
              ),
              DrawerTile(
                iconData: Icons.list,
                title: '商品一覧',
                page: 1,
              ),
              DrawerTile(
                iconData: Icons.playlist_add_check,
                title: '注文履歴',
                page: 2,
              ),
              DrawerTile(
                iconData: Icons.location_on,
                title: '店舗',
                page: 3,
              ),
              Consumer<UserManager>(builder: (_, userManager, __) {
                if (userManager.adminEnabled) {
                  return Column(
                    children: [
                      DrawerTile(
                        iconData: Icons.settings,
                        title: 'ユーザー管理',
                        page: 4,
                      ),
                      DrawerTile(
                        iconData: Icons.settings,
                        title: '注文管理　',
                        page: 5,
                      ),
                    ],
                  );
                } else {
                  return Container();
                }
              }),
            ],
          ),
        ],
      ),
    );
  }
}
