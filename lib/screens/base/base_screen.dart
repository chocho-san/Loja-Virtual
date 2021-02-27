import 'package:flutter/material.dart';
import 'package:loja_virtual/common/custom_drawer.dart';
import 'package:loja_virtual/models/page_manager.dart';
import 'package:loja_virtual/models/user_manager.dart';
import 'package:loja_virtual/screens/admin_users/admin_users_screen.dart';
import 'package:loja_virtual/screens/home/home_screen.dart';
import 'package:loja_virtual/screens/products/products_screen.dart';
import 'package:provider/provider.dart';

class BaseScreen extends StatelessWidget {
  static const routeName = '/base';

  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    Provider.of<PageManager>(context).pageControllers = _pageController;
    return Consumer<UserManager>(
        builder: (_,userManager, __) {
          return PageView(
            controller: _pageController,
            physics: NeverScrollableScrollPhysics(),
            children: [
              HomeScreen(),
              ProductsScreen(),
              Scaffold(
                drawer: CustomDrawer(),
                appBar: AppBar(
                  title: Text('My Orders'),
                ),
              ),
              Scaffold(
                drawer: CustomDrawer(),
                appBar: AppBar(
                  title: Text('Location'),
                ),
              ),
              if(userManager.adminEnabled)
                ...[/*[ A,B, ...[C,D]] ==[A,B,C,D]　マップも同じ*/
                  AdminUsersScreen(),
                  Scaffold(
                    drawer: CustomDrawer(),
                    appBar: AppBar(
                      title: Text('Orders'),
                    ),
                  ),
                ]
            ],
          );
        }

    );
  }
}
