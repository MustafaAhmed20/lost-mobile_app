import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:lost/constants.dart';

import 'package:lost/pages/loading.dart';
import 'package:lost/pages/login.dart';
import 'package:lost/pages/home.dart';
import 'package:lost/pages/dataDetails.dart';
import 'package:lost/pages/choosecountry.dart';
import 'package:lost/pages/resetPassword.dart';
import 'package:lost/pages/googlemap.dart';
import 'package:lost/pages/feedback.dart';
import 'package:lost/pages/comments.dart';

import 'models/appData.dart';

// the provider to manege state
import 'package:provider/provider.dart';

// translate for my app
import 'app_localizations.dart';

void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => AppSettings()),
    ChangeNotifierProvider(create: (context) => CountryData()),
    ChangeNotifierProvider(create: (context) => TypeOperationData()),
    ChangeNotifierProvider(create: (context) => StatusOperationData()),
    ChangeNotifierProvider(create: (context) => AgeData()),
    ChangeNotifierProvider(create: (context) => AppData()),
    ChangeNotifierProvider(create: (context) => UserData()),
    ChangeNotifierProvider(create: (context) => UserStatusData()),
    ChangeNotifierProvider(create: (context) => UserPermissionData()),
    ChangeNotifierProvider(create: (context) => PostData()),
    ChangeNotifierProvider(create: (context) => OperationData()),
  ], child: MyApp()));
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale selectedLanguage;

  @override
  Widget build(BuildContext context) {
    selectedLanguage =
        Provider.of<AppSettings>(context, listen: true).selectedLanguage;
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        fontFamily: 'theSans',

        // This is the theme of your application.

        //primaryColor: Colors.purple[800],
        // primaryColor: Colors.orange[800],
        primaryColor: scaffoldColor,

        //accentColor: Colors.purpleAccent[300],
        accentColor: Colors.white,
        backgroundColor: Colors.purple[50],
        //backgroundColor: Colors.purple[100],

        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.deepPurple[800],
          // backgroundColor: Colors.orange[800],
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
        '/details': (context) => DataDetails(),
        '/choose': (context) => ChooseCountry(),
        '/reset': (context) => ResetPassword(),
        '/map': (context) => ChooseMap(),
        '/feedback': (context) => FeedBack(),
      },
      // List all of the app's supported locales here
      supportedLocales: [
        // Locale('en', ''),
        Locale('ar', ''),
      ],
      locale: selectedLanguage,

      // These delegates make sure that the localization data for the proper language is loaded
      localizationsDelegates: [
        // A class which loads the translations from JSON files
        AppLocalizations.delegate,
        // Built-in localization of basic text for Material widgets
        GlobalMaterialLocalizations.delegate,
        // Built-in localization for text direction LTR/RTL
        GlobalWidgetsLocalizations.delegate,
      ],
      // Returns a locale which will be used by the app
      localeResolutionCallback: (locale, supportedLocales) {
        // Check if the current device locale is supported
        for (var supportedLocale in supportedLocales) {
          if (supportedLocale.languageCode == locale.languageCode) // &&
          //supportedLocale.countryCode == locale.countryCode)
          {
            return supportedLocale;
          }
        }
        // If the locale of the device is not supported, use the first one
        // from the list (English, in this case).
        return supportedLocales.first;
      },
    );
  }
}
