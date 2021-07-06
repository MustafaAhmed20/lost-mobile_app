import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';

// import the app data
import 'package:lost/models/appData.dart';
import 'package:provider/provider.dart';

// the models
import 'package:lost/models/operation/operation.dart';

import 'snackBars.dart';

// the validators functions
import 'validators.dart';

//language support
import 'package:lost/app_localizations.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  Map arguments;

  Future<String> _authUser(LoginData data, BuildContext context) async {
    Country selectedCountry =
        Provider.of<CountryData>(context, listen: false).selectedCountry;

    // login the user
    String result = await Provider.of<UserData>(context, listen: false)
        .login(data.name, data.password, selectedCountry.id);

    return result;
  }

  Future<String> _registerUser(LoginData data, BuildContext context) async {
    Country selectedCountry =
        Provider.of<CountryData>(context, listen: false).selectedCountry;

    // login the user
    String result = await Provider.of<UserData>(context, listen: false)
        .register(data.name, data.password, selectedCountry.id);

    return result;
  }

  Future<String> _recoverPassword(String name, BuildContext context) async {
    Country selectedCountry =
        Provider.of<CountryData>(context, listen: false).selectedCountry;

    // login the user
    String result = await Provider.of<UserData>(context, listen: false)
        .forgotPassword(name, selectedCountry.id);

    return result;
  }

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    Future<void> delay() async {
      await Future.delayed(Duration(seconds: 2));
      _scaffoldKey.currentState.showSnackBar(needLoginSnackBar(context));
    }

    arguments = ModalRoute.of(context).settings.arguments;
    if (arguments != null && arguments['showAlert'] != null) {
      delay();
    }

    Country selectedCountry =
        Provider.of<CountryData>(context, listen: false).selectedCountry;

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context).translate('login_Login'),
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
          title: AppLocalizations.of(context).translate('login_Login'),
          emailValidator: (value) {
            if (value.isEmpty) {
              return AppLocalizations.of(context).translate('login_mustPhone');
            }
            String notValid = validatPhone(context, value, selectedCountry);
            if (notValid != null) {
              return '$notValid\n تأكد من الرقم ومن الدولة المختارة';
            }

            return null;
          },
          passwordValidator: (value) {
            if (value.isEmpty) {
              return AppLocalizations.of(context).translate('login_mustPass');
            }
            if (value.length < 5) {
              return AppLocalizations.of(context)
                  .translate('login_mustPassLength');
            }
            return validatPassword(context, value);
          },
          messages: LoginMessages(
            confirmPasswordHint:
                AppLocalizations.of(context).translate('login_passConfirmHint'),
            usernameHint:
                AppLocalizations.of(context).translate('login_nameHint'),
            passwordHint:
                AppLocalizations.of(context).translate('login_passHint'),
            recoverPasswordDescription:
                AppLocalizations.of(context).translate('login_recoverPassword'),
            recoverPasswordSuccess: AppLocalizations.of(context)
                .translate('login_recoverPasswordSuccess'),
            confirmPasswordError: AppLocalizations.of(context)
                .translate('login_PassworConfirmError'),
            loginButton: AppLocalizations.of(context).translate('login_Login'),
            forgotPasswordButton:
                AppLocalizations.of(context).translate('login_PassworReset'),
            signupButton:
                AppLocalizations.of(context).translate('login_Signup'),
            goBackButton: AppLocalizations.of(context).translate('login_Back'),
            recoverPasswordButton:
                AppLocalizations.of(context).translate('login_Recover'),
            recoverPasswordIntro: AppLocalizations.of(context)
                .translate('login_recoverPasswordIntro'),
          ),
          onLogin: (data) => _authUser(data, context),
          onSubmitAnimationCompleted: () {
            // tell the home page to show snakebar throw Provider
            Provider.of<AppSettings>(context, listen: false)
                .setHomeSnakeBar('login');
            Navigator.of(context).pop();
          },
          onSignup: (data) => _registerUser(data, context).then((value) {
                // return to home and show snakebar
                if (value != null) {
                  return value;
                }
                // tell the home page to show snakebar throw Provider
                Provider.of<AppSettings>(context, listen: false)
                    .setHomeSnakeBar('register');
                Navigator.of(context).pop();
                return null;
              }),
          onRecoverPassword: (name) {
            return Future.value(
                AppLocalizations.of(context).translate('login_RecoverSorry'));
          }
          //     _recoverPassword(name, context).then((value) {
          //   // pop the screen
          //   if (value != null) {
          //     return value;
          //   }
          //   //Navigator.of(context).pop();

          //   Navigator.pushReplacementNamed(context, '/reset',
          //       arguments: {'phone': name});

          //   return null;
          // }
          // ),
          ),
    );
  }
}
