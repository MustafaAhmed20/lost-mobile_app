import 'package:flutter/material.dart';

import 'dart:io';

Future<bool> exitApp(BuildContext context) {
  return showDialog(
        context: context,
        builder: (context) => Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            title: Text(
              'هل انت متأكد؟',
              style: TextStyle(
                fontSize: 14,
              ),
            ),
            content: Text(
              'هل انت متأكد من قفل التطبيق؟',
              style: TextStyle(
                fontSize: 14,
              ),
            ),
            actions: <Widget>[
              FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text('تراجع'),
              ),
              FlatButton(
                onPressed: () => exit(0),
                /*Navigator.of(context).pop(true)*/
                child: Text(
                  'خروج',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ) ??
      false;
}
