import 'package:flutter/material.dart';
import 'package:loja_virtual/helpers/validators.dart';
import 'package:loja_virtual/models/users.dart';
import 'package:loja_virtual/models/user_manager.dart';
import 'package:loja_virtual/screens/base_screen.dart';
import 'package:provider/provider.dart';

class SignUpScreen extends StatelessWidget {
  static const routeName = '/signUp';

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final _nameFocusNode = FocusNode();
  final _emailFocusNode = FocusNode();
  final _passFocusNode = FocusNode();
  final _passComFocusNode = FocusNode();


  final Users user = Users();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text('アカウント作成'),
        centerTitle: true,
      ),
      body: Center(
        child: Card(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: Form(
            key: formKey,
            child: Consumer<UserManager>(
              builder: (_, userManager, __) {
                return ListView(
                  padding: const EdgeInsets.all(16),
                  shrinkWrap: true,
                  children: [
                    TextFormField(
                      decoration: InputDecoration(hintText: '名前'),
                      enabled: !userManager.loading,
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_emailFocusNode);
                      },
                      focusNode: _nameFocusNode,
                      autocorrect: false,
                      validator: (name) {
                        if (name.isEmpty) {
                          return '入力必須です';
                        } else if (name.trim().split('　').length <= 1) {
                          return 'フルネームを入力してください。空白必須。';
                        }
                        return null;
                      },
                      onSaved: (name) => user.name = name,
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      // controller: passController,
                      enabled: !userManager.loading,
                      decoration: const InputDecoration(hintText: 'Eメール'),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_passFocusNode);
                      },
                      autocorrect: false,
                      keyboardType: TextInputType.emailAddress,
                      focusNode: _emailFocusNode,
                      validator: (email) {
                        if (email.isEmpty) {
                          return '入力必須です';
                        } else if (!emailValid(email)) {
                          return 'このEメールは無効です';
                        }
                        return null;
                      },
                      onSaved: (email) => user.email = email,
                    ),
                    SizedBox(height: 16),

                    TextFormField(
                      // controller: passController,
                      enabled: !userManager.loading,
                      decoration: const InputDecoration(hintText: 'パスワード'),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_passComFocusNode);
                      },
                      autocorrect: false,
                      obscureText: true,
                      /*入力を隠す*/
                      focusNode: _passFocusNode,
                      validator: (pass) {
                        if (pass.isEmpty) {
                          return '入力必須です';
                        } else if (pass.length < 6) {
                          return '6文字以上';
                        }
                        return null;
                      },
                      onSaved: (pass) => user.password = pass,
                    ),
                    SizedBox(height: 16),

                    TextFormField(
                      // controller: passController,
                      enabled: !userManager.loading,
                      decoration: const InputDecoration(hintText: 'パスワード確認'),
                      autocorrect: false,
                      obscureText: true,
                      focusNode: _passComFocusNode,
                      validator: (pass) {
                        if (pass.isEmpty) {
                          return '入力必須です';
                        } else if (pass.length < 6) {
                          return '6文字以上';
                        }
                        return null;
                      },
                      onSaved: (pass) => user.confirmPassword = pass,
                    ),
                    // child,
                    SizedBox(height: 16),
                    SizedBox(
                      height: 44,
                      child: RaisedButton(
                        color: Theme.of(context).primaryColor,
                        disabledColor:
                            Theme.of(context).primaryColor.withAlpha(100),
                        textColor: Colors.white,
                        onPressed: userManager.loading
                            ? null
                            : () {
                                if (formKey.currentState.validate()) {
                                  formKey.currentState.save();

                                  if (user.password != user.confirmPassword) {
                                    scaffoldKey.currentState.showSnackBar(
                                      SnackBar(
                                        content: Text('パスワードが一致しません'),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                    return;
                                  }
                                  userManager.signUp(
                                    user: user,
                                    onFail: (error) {
                                      scaffoldKey.currentState.showSnackBar(
                                        SnackBar(
                                          content: Text(error),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                    },
                                    onSuccess: () {
                                      Navigator.of(context)
                                          .pushNamed(BaseScreen.routeName);
                                    },
                                  );
                                }
                              },
                        child: userManager.loading
                            ? CircularProgressIndicator(
                          valueColor:
                          AlwaysStoppedAnimation(Colors.white),
                        )
                            : Text(
                          '登録',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    )
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
