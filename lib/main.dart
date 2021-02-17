import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:loja_virtual/models/cart_manager.dart';
import 'package:loja_virtual/models/home_manager.dart';
import 'package:loja_virtual/models/product_manager.dart';
import 'package:loja_virtual/models/user_manager.dart';
import 'package:loja_virtual/screens/cart_screen.dart';
import 'package:loja_virtual/screens/login_screen.dart';
import 'package:loja_virtual/screens/product_screen.dart';
import 'package:provider/provider.dart';

import 'screens/base_screen.dart';
import 'screens/signup_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(),
      builder: (context, snapshot) {
        // Firebaseのinitialize完了したら表示したいWidget
        if (snapshot.connectionState == ConnectionState.done) {
          return MultiProvider(
            providers: [
              ChangeNotifierProvider(

                create: (_) => UserManager(),
                lazy:
                    false, /*怠惰でない☞プロバイダーが発動されるまで待つのではなく、すぐさま読み込まれる。lazy: trueや省略の時は、値が最初に読み取られたときに呼び出される*/
              ),
              ChangeNotifierProvider(
                create: (_) => ProductManager(),
                lazy: false,
              ),
              Provider(
                create: (_)=>HomeManager(),
                lazy: false,
              ),
              ChangeNotifierProxyProvider<UserManager, CartManager>(
                create: (_) => CartManager(),
                lazy: false,
                update: (_, userManager, cartManager) =>
                    cartManager..updateUser(userManager),
              ),
            ],
            child: MaterialApp(
              title: 'Loja Virtual',
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                primaryColor: Color.fromARGB(255, 4, 125, 141),
                scaffoldBackgroundColor: Color.fromARGB(255, 4, 125, 141),
                appBarTheme: AppBarTheme(
                  elevation: 0,
                ),
                visualDensity: VisualDensity.adaptivePlatformDensity,
              ),
              home: BaseScreen(),
              routes: {
                BaseScreen.routeName: (context) => BaseScreen(),
                SignUpScreen.routeName: (context) => SignUpScreen(),
                LoginScreen.routeName: (context) => LoginScreen(),
                ProductScreen.routeName: (context) => ProductScreen(),
                CartScreen.routeName: (context) => CartScreen(),
              },
            ),
          );
        }
        // Firebaseのinitializeが完了するのを待つ間に表示するWidget
        return Container(
          color: Colors.grey,
        );
      },
    );
  }
}
