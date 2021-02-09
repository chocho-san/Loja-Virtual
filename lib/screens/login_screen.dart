import 'package:flutter/material.dart';
import 'package:loja_virtual/helpers/validators.dart';
import 'package:loja_virtual/models/user.dart';
import 'package:loja_virtual/models/user_manager.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: const Text('ログイン'),
        centerTitle: true,
      ),
      body: Center(
        child: Card(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: Form(
            key: formKey,
            child: ListView(
              padding: const EdgeInsets.all(16),
              shrinkWrap: true,
              children: [
                TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(hintText: 'Eメール'),
                  keyboardType: TextInputType.emailAddress,
                  autocorrect: false,
                  validator: (email) {
                    if (!emailValid(email)) {
                      return 'このEメールは無効です';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: passController,
                  decoration: const InputDecoration(hintText: 'パスワード'),
                  autocorrect: false,
                  obscureText: true,
                  validator: (pass) {
                    if (pass.isEmpty || pass.length < 6) {
                      return 'パスワードが無効です';
                    }
                    return null;
                  },
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: FlatButton(
                    onPressed: () {
                    },
                    padding: EdgeInsets.zero,
                    child: const Text('パスワード忘れ'),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 44,
                  child: RaisedButton(
                    onPressed: () {
                      if (formKey.currentState.validate()) {
                        context.read<UserManager>().signIn(
                            user: Users(
                                email: emailController.text,
                                password: passController.text),
                            onFail: (e) {
                              scaffoldKey.currentState.showSnackBar(
                                 SnackBar(
                                  content: Text('$e'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            },
                            onSuccess: () {
                              // TODO: FECHAR TELA DE LOGIN
                            });
                      }
                    },
                    color: Theme.of(context).primaryColor,
                    textColor: Colors.white,
                    child: const Text(
                      'ログイン',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
