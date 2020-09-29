import 'package:flutter/material.dart';

import 'package:flutter_spinkit/flutter_spinkit.dart';

//language support
import 'package:lost/app_localizations.dart';

Widget wait(BuildContext context) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      Center(
        child: SpinKitCircle(
          color: Theme.of(context).primaryColor,
          size: 100.0,
        ),
      ),
    ],
  );
}

Widget noData(BuildContext context) {
  // return Column(
  //   mainAxisAlignment: MainAxisAlignment.center,
  //   children: <Widget>[
  //     Center(
  //       child: Text(
  //         AppLocalizations.of(context).translate('wait_noData'),
  //         style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
  //       ),
  //     ),
  //   ],
  // )
  var h = MediaQuery.of(context).size.height - 100;
  return Container(
      height: h,
      child: Center(
        child: Text(
          AppLocalizations.of(context).translate('wait_noData'),
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
        ),
      ));
}
