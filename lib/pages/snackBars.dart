import 'package:flutter/material.dart';

//language support
import 'package:lost/app_localizations.dart';

// succses login massege
SnackBar successLoginSnackBar(BuildContext context) => SnackBar(
      content: Row(
        children: <Widget>[
          Icon(Icons.check_circle_outline),
          SizedBox(width: 10),
          Text(AppLocalizations.of(context).translate('SnackBar_successLogin'))
        ],
      ),
      backgroundColor: Colors.green,
    );

// succses login massege
SnackBar successRegisterSnackBar(BuildContext context) => SnackBar(
      content: Row(
        children: <Widget>[
          Icon(Icons.check_circle_outline),
          SizedBox(width: 10),
          Text(AppLocalizations.of(context)
              .translate('SnackBar_successRegister'))
        ],
      ),
      backgroundColor: Colors.green,
    );

// succses logout massege
SnackBar successLogoutSnackBar(BuildContext context) => SnackBar(
      content: Row(
        children: <Widget>[
          Icon(Icons.directions_run),
          SizedBox(width: 10),
          Text(AppLocalizations.of(context).translate('SnackBar_successLogout'))
        ],
      ),
      backgroundColor: Colors.green,
    );

// need login massege
SnackBar needLoginSnackBar(BuildContext context) => SnackBar(
      content: Row(
        children: <Widget>[
          Icon(
            Icons.info_outline,
            color: Colors.black,
          ),
          SizedBox(width: 10),
          Text(AppLocalizations.of(context).translate('SnackBar_needLogin'),
              style: TextStyle(
                  fontSize: 18,
                  color: Colors.black) //, fontWeight: FontWeight.bold),
              )
        ],
      ),
      backgroundColor: Colors.yellow[300],
    );

// succses Reset password massege
SnackBar successResetSnackBar(BuildContext context) => SnackBar(
      content: Row(
        children: <Widget>[
          Icon(Icons.check_circle_outline),
          SizedBox(width: 10),
          Text(AppLocalizations.of(context).translate('SnackBar_successReset'))
        ],
      ),
      backgroundColor: Colors.green,
    );

// choose location by click
SnackBar chooseLocationSnackBar(BuildContext context) => SnackBar(
      content: Row(
        children: <Widget>[
          Icon(Icons.info_outline),
          SizedBox(width: 10),
          Text(
              AppLocalizations.of(context).translate('SnackBar_chooseLocation'))
        ],
      ),
      backgroundColor: Colors.blue[300],
      //backgroundColor: Colors.green[100],
    );

// error massege with custom string
SnackBar customErrorSnackBar(BuildContext context, string) => SnackBar(
      content: Row(
        children: <Widget>[
          Icon(Icons.highlight_off),
          SizedBox(width: 10),
          Text(string)
        ],
      ),
      backgroundColor: Colors.red[900],
    );

// succses massege with custom string
SnackBar customSuccessSnackBar(BuildContext context, string) => SnackBar(
      content: Row(
        children: <Widget>[
          Icon(Icons.check_circle_outline),
          SizedBox(width: 10),
          Text(string)
        ],
      ),
      backgroundColor: Colors.green,
    );
