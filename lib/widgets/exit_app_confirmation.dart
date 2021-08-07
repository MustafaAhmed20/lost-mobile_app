import 'package:flutter/material.dart';

import 'dart:io';

import 'package:lost/constants.dart';

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

/// conform Dialog
Future<bool> conformDialog(
    BuildContext context, String title, String question) {
  return (showDialog(
        context: context,
        builder: (context) => Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            title: Text(
              title,
              textDirection: TextDirection.rtl,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: Text(
              question,
              textDirection: TextDirection.rtl,
              style: TextStyle(
                fontSize: 12,
              ),
            ),
            actions: <Widget>[
              FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text('تراجع',
                    textDirection: TextDirection.rtl,
                    style: TextStyle(fontSize: 12)),
              ),
              FlatButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text(
                  'تأكيد',
                  textDirection: TextDirection.rtl,
                  style: TextStyle(
                    fontSize: 16,
                    color: mainDarkColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      )) ??
      false;
}
