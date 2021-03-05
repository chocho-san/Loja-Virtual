import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:loja_virtual/helpers/validators.dart';
import 'package:loja_virtual/models/users.dart';
import 'package:loja_virtual/models/user_manager.dart';
import 'package:provider/provider.dart';

import '../signup/signup_screen.dart';

class SignInScreen extends StatelessWidget {
  static const routeName = '/login';

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final _passFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text('ログイン'),
        centerTitle: true,
        actions: [
          FlatButton(
            onPressed: () {
              Navigator.of(context).pushNamed(SignUpScreen.routeName);
            },
            textColor: Colors.white,
            child: Text(
              'アカウント作成',
              style: TextStyle(fontSize: 14),
            ),
          )
        ],
      ),
      body: Center(
        child: Card(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: Form(
            key: formKey,
            child: Consumer<UserManager>(
              builder: (_, userManager, child) {
                if (userManager.loadingGoogle) {
                   return Padding(
                    padding: EdgeInsets.all(16),
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(
                        Theme.of(context).primaryColor,
                      ),
                    ),
                  );
                }
                return ListView(
                  padding: EdgeInsets.all(16),
                  shrinkWrap: true,
                  children: [
                    TextFormField(
                      controller: emailController,
                      enabled: !userManager.loading,
                      decoration: InputDecoration(hintText: 'Eメール'),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.emailAddress,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_passFocusNode);
                      },
                      autocorrect: false,
                      validator: (email) {
                        if (!emailValid(email)) {
                          return 'このEメールは無効です';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: passController,
                      enabled: !userManager.loading,
                      decoration: InputDecoration(hintText: 'パスワード'),
                      autocorrect: false,
                      obscureText: true,
                      /*入力を隠す*/
                      focusNode: _passFocusNode,
                      validator: (pass) {
                        if (pass.isEmpty || pass.length < 6) {
                          return 'パスワードが無効です';
                        }
                        return null;
                      },
                    ),
                    child,
                    SizedBox(height: 16),
                    RaisedButton(
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      onPressed: userManager.loading
                          ? null
                          : () {
                              /*画面popされない！？！？*/
                              if (formKey.currentState.validate()) {
                                userManager.signIn(
                                  user: Users(
                                    email: emailController.text,
                                    password: passController.text,
                                  ),
                                  onFail: (error) {
                                    scaffoldKey.currentState.showSnackBar(
                                      SnackBar(
                                        content: Text(error),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  },
                                  onSuccess: () {
                                    Navigator.of(context).pop();
                                  },
                                );
                              }
                            },
                      color: Theme.of(context).primaryColor,
                      disabledColor:
                          Theme.of(context).primaryColor.withAlpha(100),
                      textColor: Colors.white,
                      child: userManager.loading
                          ? CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation(Colors.white),
                            )
                          : Text(
                              'ログイン',
                              style: TextStyle(fontSize: 15),
                            ),
                    ),
                    SignInButton(
                      Buttons.Google,
                      text: 'Googleでログイン',
                      onPressed: () {
                        userManager.googleLogin(
                          onFail: (error) {
                            scaffoldKey.currentState.showSnackBar(
                              SnackBar(
                                content: Text(error),
                                backgroundColor: Colors.red,
                              ),
                            );
                          },
                          onSuccess: () {
                            Navigator.of(context).pop();
                          },
                        );
                      },
                    ),
                  ],
                );
              },
              child: Align(
                alignment: Alignment.centerRight,
                child: FlatButton(
                  onPressed: () {},
                  padding: EdgeInsets.zero,
                  child: Text('パスワード忘れ'),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
