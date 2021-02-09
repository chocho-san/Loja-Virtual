import 'package:flutter/material.dart';
import 'package:loja_virtual/common/drawer_tile.dart';

class CustomDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerTile(
            iconData: Icons.home,
            title: 'Home',
            page: 0,
          ),
          DrawerTile(
            iconData: Icons.list,
            title: 'Products',
            page: 1,
          ),
          DrawerTile(
            iconData: Icons.playlist_add_check,
            title: 'Orders',
            page: 2,
          ),
          DrawerTile(
            iconData: Icons.location_on,
            title: 'Location',
            page: 3,
          ),
        ],
      ),
    );
  }
}
