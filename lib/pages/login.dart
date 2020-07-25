import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';

// import the app data
import 'package:lost/models/appData.dart';
import 'package:provider/provider.dart';
import 'snackBars.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  Map arguments;

  Future<String> _authUser(LoginData data) async {
    // login the user
    bool result = await Provider.of<UserData>(context, listen: false)
        .login(data.name, data.password);

    return result ? null : Future<String>.value('wrong phone or password!');
  }

  Future<String> _recoverPassword(String name) {
    // print('Name: $name');
    // return Future.delayed(loginTime).then((_) {
    //   if (!users.containsKey(name)) {
    //     return 'Username not exists';
    //   }
    //   return null;
    // });
    return null;
  }

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    Future<void> delay() async {
      await Future.delayed(Duration(seconds: 2));
      _scaffoldKey.currentState.showSnackBar(needLoginSnackBar);
    }

    arguments = ModalRoute.of(context).settings.arguments;
    if (arguments != null && arguments['showAlert'] != null) {
      delay();
    }

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          'Login',
          style: TextStyle(
            color: Colors.black,
            letterSpacing: 1.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.grey[50],
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
      ),
      body: FlutterLogin(
        title: 'Login',
        emailValidator: (value) {
          if (value.isEmpty) {
            return 'you must enter your phone number';
          }
          if (double.tryParse(value) == null) {
            return 'this not valid number';
          }
          return null;
        },
        passwordValidator: (value) {
          if (value.isEmpty) {
            return 'enter your password';
          }
          return null;
        },
        messages: LoginMessages(
          usernameHint: "you'r phone number",
          passwordHint: 'you\'r password',
          recoverPasswordDescription: 'We will send you a confirm number.',
        ),
        onLogin: _authUser,
        onSignup: _authUser,
        onSubmitAnimationCompleted: () {
          Navigator.of(context).pop();
        },
        onRecoverPassword: _recoverPassword,
      ),
    );
  }
}
