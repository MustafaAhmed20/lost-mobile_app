import 'package:flutter/material.dart';
import 'homeData.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Home'),
          centerTitle: true,
          bottom: TabBar(
            labelStyle: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
            tabs: <Widget>[
              Tab(
                text: 'Lost',
              ),
              Tab(
                text: 'Found',
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            HomeData(type: 'lost'),
            HomeData(type: 'found'),
          ],
        ),
      ),
    );
  }
}
