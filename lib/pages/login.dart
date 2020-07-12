import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

// const users = const {
//   'dribbble@gmail.com': '12345',
//   'hunter@gmail.com': 'hunter',
// };

class _LoginState extends State<Login> {
  Duration get loginTime => Duration(milliseconds: 2250);

  Future<String> _authUser(LoginData data) {
    //   print('Name: ${data.name}, Password: ${data.password}');
    //   return Future.delayed(loginTime).then((_) {
    //     if (!users.containsKey(data.name)) {
    //       return 'Username not exists';
    //     }
    //     if (users[data.name] != data.password) {
    //       return 'Password does not match';
    //     }
    //     return null;
    //   });
    return null;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        //logo: 'assets/images/ecorp-lightblue.png',
        messages: LoginMessages(
          usernameHint: "you'r phone number",
          passwordHint: 'you\'r password',
          recoverPasswordDescription: 'We will send you a confirm number.',
        ),
        onLogin: _authUser,
        onSignup: _authUser,

        // onSubmitAnimationCompleted: () {
        //   Navigator.of(context).pushReplacement(MaterialPageRoute(
        //     builder: (context) => DashboardScreen(),
        //   )
        //   );
        //},
        onRecoverPassword: _recoverPassword,
      ),
    );
  }
}
