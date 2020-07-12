import 'package:flutter/material.dart';
import 'package:lost/pages/loading.dart';
import 'package:lost/pages/login.dart';
import 'package:lost/pages/home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.

        primaryColor: Colors.purple[800],

        accentColor: Colors.purpleAccent[300],
        //backgroundColor: Colors.purple[100],

        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.lightBlueAccent[900],
          foregroundColor: Colors.white,
        ),

        //primarySwatch: Colors.purple[800],
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      routes: {
        '/': (context) => Loading(),
        '/home': (context) => Home(),
        '/login': (context) => Login(),
      },
    );
  }
}
