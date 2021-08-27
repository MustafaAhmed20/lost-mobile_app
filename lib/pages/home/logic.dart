import 'package:flutter/material.dart';

// import the app data
import 'package:lost/models/appData.dart';
import 'package:lost/pages/forms/forms.dart';
import 'package:provider/provider.dart';

/// if logged-in go to add operation page
/// go to the loggin page if not
void onAddLogic(BuildContext context) async {
  bool logged = Provider.of<UserData>(context, listen: false).token != null;

  String selectedObject =
      Provider.of<AppSettings>(context, listen: false).selectedObjectString ??
          'menu_accident';

  if (logged) {
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => OperatioForm(
                  accident: selectedObject == 'menu_accident',
                )));
  } else {
    // loggin page
    Navigator.pushNamed(context, '/login', arguments: {'showAlert': true});
  }
}
