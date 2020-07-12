// the main part of the home page

import 'package:flutter/material.dart';

class HomeData extends StatefulWidget {
  final String type;
  HomeData({this.type});
  @override
  _HomeDataState createState() => _HomeDataState();
}

class _HomeDataState extends State<HomeData> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Card(
          child: Text('Hi ${widget.type}'),
        ),
      ],
    );
  }
}
