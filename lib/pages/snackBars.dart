import 'package:flutter/material.dart';

// succses login massege
SnackBar successLoginSnackBar = SnackBar(
  content: Row(
    children: <Widget>[
      Icon(Icons.check_circle_outline),
      Text('You logged-in!')
    ],
  ),
  backgroundColor: Colors.green,
);

// succses logout massege
SnackBar successLogoutSnackBar = SnackBar(
  content: Row(
    children: <Widget>[
      Icon(Icons.directions_run),
      Text('You logout successfully!')
    ],
  ),
  backgroundColor: Colors.green,
);

// need login massege
SnackBar needLoginSnackBar = SnackBar(
  content: Row(
    children: <Widget>[
      Icon(Icons.info_outline),
      Text('You need to login first!!')
    ],
  ),
  backgroundColor: Colors.yellow[300],
);
