import 'package:flutter/material.dart';

import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:lost/models/appData.dart';

import 'package:provider/provider.dart';

import 'package:flutter/services.dart';
import 'dart:io';

showAlertDialog(BuildContext context) {
  // set up the buttons
  Widget cancelButton = FlatButton(
    textColor: Colors.red,
    child: Text("Exit"),
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
    child: Text("Retry"),
    onPressed: () {
      Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Network error!"),
    content:
        Text("Check your connection and then try again , or close the app"),
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
      Provider.of<CountryData>(context, listen: false).loadData();
    }

    // check connection
    void loadData() async {
      bool result =
          await Provider.of<AppData>(context, listen: false).checkConnection();

      if (result == true) {
        // load country data
        await countryData();
        Navigator.pushReplacementNamed(context, '/home');
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
      backgroundColor: Colors.purple[800],
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
            "Loading...",
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
