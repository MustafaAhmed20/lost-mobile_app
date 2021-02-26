import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:lost/models/appData.dart';

// storage user preferences
import 'package:shared_preferences/shared_preferences.dart';

//
// THE welcome massege

Future<bool> showWelcomeMassege() async {
  //  try load the sittings
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool welcomeMessageBool = prefs.getBool('welcomeMessage');

  if (welcomeMessageBool != null) {
    // dont show the message
    return false;
  }
  return true;
}

void setDontShowWelcomeMassege(bool answer) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setBool('welcomeMessage', answer);
}

Future<bool> showLanguageSelector() async {
  //  try load the sittings
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String language = prefs.getString('language');

  if (language != null) {
    // dont show the message
    return false;
  }
  return true;
}

// *******
// set the lang
Future<void> setLang(BuildContext context, String lang) {
  Provider.of<CountryData>(context, listen: false).setCountry(lang);
}

// push the main
void pushFirstButtonLogic(BuildContext context) {
  // change the object to person
  Provider.of<AppSettings>(context, listen: false).changeObject('Person');
  // push home
  pushHome(context);
}

void pushSecoundButtonLogic(BuildContext context) => pushHome(context);

void pushHome(BuildContext context) {
  // push home
  Navigator.pushReplacementNamed(context, '/home');
}
