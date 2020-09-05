import 'package:flutter/material.dart';

import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:lost/models/appData.dart';

import 'package:provider/provider.dart';

import 'package:flutter/services.dart';
import 'dart:io';

// version info
//import 'package:package_info/package_info.dart';

//language support
import 'package:lost/app_localizations.dart';

showAlertDialog(BuildContext context) {
  // set up the buttons
  Widget cancelButton = FlatButton(
    textColor: Colors.red,
    child: Text(
      AppLocalizations.of(context).translate('loading_exit'),
    ),
    onPressed: () {
      Future<void> pop({bool animated}) async {
        await SystemChannels.platform
            .invokeMethod<void>('SystemNavigator.pop', animated);
      }

      pop();

      sleep(Duration(seconds: 3));
      exit(0);
    },
  );

  Widget continueButton = FlatButton(
    child: Text(AppLocalizations.of(context).translate('loading_Retry')),
    onPressed: () {
      Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text(AppLocalizations.of(context).translate('loading_NetworkError')),
    content: Text(AppLocalizations.of(context).translate('loading_massege')),
    actions: [
      cancelButton,
      continueButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

class Loading extends StatefulWidget {
  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  @override
  void initState() {
    super.initState();

    countryData() async {
      return await Provider.of<CountryData>(context, listen: false).loadData();
    }

    // check connection
    void loadData() async {
      bool result =
          await Provider.of<AppData>(context, listen: false).checkConnection();

      if (result == true) {
        //check loggin
        Provider.of<UserData>(context, listen: false).checkLogin();

        // load country data
        bool country = await countryData();
        if (country) {
          // home page
          Navigator.pushReplacementNamed(context, '/home');
        } else {
          // send him to choose
          Navigator.pushReplacementNamed(context, '/choose');
        }
      } else {
        showAlertDialog(context);
      }
    }

    // load the data
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child: SpinKitCircle(
              color: Colors.white,
              size: 100.0,
            ),
          ),
          Text(
            AppLocalizations.of(context).translate('loading_Loading'),
            style: TextStyle(
              color: Colors.white,
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
