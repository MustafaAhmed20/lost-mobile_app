import 'package:flutter/material.dart';

import 'package:flutter_spinkit/flutter_spinkit.dart';

//language support
import 'package:lost/app_localizations.dart';

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

Widget noData(BuildContext context) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      Center(
        child: Text(
          AppLocalizations.of(context).translate('wait_noData'),
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
        ),
      ),
    ],
  );
}
