import 'package:flutter/material.dart';

import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;

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

      sleep(Duration(seconds: 2));
      exit(0);
    },
  );
  Widget continueButton = FlatButton(
    child: Text("Retry"),
    onPressed: () {
      Navigator.popAndPushNamed(context, '/');
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

    Future<void> getData() async {
      try {
        http.Response data =
            await http.get('https://jsonplaceholder.typicode.com/todos/1');

        Navigator.pushReplacementNamed(context, '/home');
      } catch (e) {
        showAlertDialog(context);
      }
    }

    getData();
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
