import 'package:flutter/material.dart';
import 'package:loja_virtual/common/custom_drawer.dart';
import 'package:loja_virtual/models/home_manager.dart';
import 'file:///C:/Users/marur/AndroidStudioProjects/loja_virtual/lib/screens/cart/cart_screen.dart';
import 'package:loja_virtual/screens/section_list.dart';
import 'package:loja_virtual/screens/section_staggered.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(225, 211, 118, 130),
                  Color.fromARGB(225, 253, 181, 168),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          CustomScrollView(
            slivers: [
              SliverAppBar(
                /*bodyの中にappBar入ってる*/
                snap: true,
                /*スクロールで中途半端に表示されなくなり一気に最大*/
                floating: true,
                /*上にスクロールし始めたとたん表示される*/
                elevation: 0,
                backgroundColor: Colors.transparent,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text('amadon'),
                  centerTitle: true,
                ),
                actions: [
                  IconButton(
                    icon: Icon(Icons.shopping_cart),
                    color: Colors.white,
                    onPressed: () =>
                        Navigator.of(context).pushNamed(CartScreen.routeName),
                  ),
                ],
              ),
              Consumer<HomeManager>(builder: (_, homeManager, __) {
                final List<Widget> children =
                    homeManager.sections.map<Widget>((section) {
                      switch(section.type){
                        case 'List':
                          return SectionList(section);
                        case 'Staggered':
                          return SectionStaggered(section);
                        default:
                          return Container();
                      }
                    }).toList();
                return SliverList(
                  delegate: SliverChildListDelegate(children),
                );
              }),
            ],
          ),
        ],
      ),
    );
  }
}
