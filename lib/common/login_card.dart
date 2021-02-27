import 'package:flutter/material.dart';
import 'package:loja_virtual/screens/login/login_screen.dart';

class LoginCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: const EdgeInsets.all(16),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Icon(
                Icons.account_circle,
                color: Theme.of(context).primaryColor,
                size: 100,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'ログインが必要です',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
              RaisedButton(
                onPressed: (){
                  Navigator.of(context).pushNamed(LoginScreen.routeName);
                },
                color: Theme.of(context).primaryColor,
                textColor: Colors.white,
                child: const Text(
                    'ログイン'
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}