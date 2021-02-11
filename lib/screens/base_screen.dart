import 'package:flutter/material.dart';
import 'package:loja_virtual/common/custom_drawer.dart';
import 'package:loja_virtual/models/page_manager.dart';
import 'package:provider/provider.dart';

class BaseScreen extends StatelessWidget {
  static const routeName = '/base';

  final PageController pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (_) => PageManager(pageController),
      child: PageView(
        controller: pageController,
        physics: NeverScrollableScrollPhysics(),
        children: [
          Scaffold(
            drawer: CustomDrawer(),
            appBar: AppBar(
              title: Text('Home'),
            ),
          ),
          Scaffold(
            drawer: CustomDrawer(),
            appBar: AppBar(
              title: Text('Products'),
            ),
          ),
          Scaffold(
            drawer: CustomDrawer(),
            appBar: AppBar(
              title: Text('Orders'),
            ),
          ),
          Scaffold(
            drawer: CustomDrawer(),
            appBar: AppBar(
              title: Text('Location'),
            ),
          ),
        ],
      ),
    );
  }
}
