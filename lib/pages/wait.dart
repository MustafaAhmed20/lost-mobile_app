import 'package:flutter/material.dart';

import 'package:flutter_spinkit/flutter_spinkit.dart';

Widget wait() {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      Center(
        child: SpinKitCircle(
          color: Colors.purple[800],
          size: 100.0,
        ),
      ),
    ],
  );
}

Widget noData() {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      Center(
        child: Text(
          'No Data Found!',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
        ),
      ),
    ],
  );
}
