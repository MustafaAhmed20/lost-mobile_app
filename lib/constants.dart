import 'package:flutter/material.dart';

// Color liteBackground = Color(0x502A6D);
Color liteBackground = mainDarkColor.withOpacity(0.3);

// lite
Color mainLiteColor = Color(0xff823476);
// dark
Color mainDarkColor = Color(0xff502A6D);

// the hover color
Color hoverColor = Color(0xff3F276A);

Color scaffoldColor = hoverColor;

// text colors
Color mainTextColor = Colors.white;
// Color otherTextColor = mainLiteColor;
Color otherTextColor = hoverColor;

const Color textColorHint = Color(0xffb3bdcb);

// the info text
String infoText = """
يختض هذا التطبيق بجميع المفقودات
من أشخاص, وسيارات, ومتعلقات شخصية
كما يتيح لك خاصية إضافة الحوادث المرورية
التي تواجهك في الطريق مما يسهل على
الجميع التعرف على ذويهم في حال حدوث
مكروه لا سمح الله
""";

// the app icon
Widget getIcon() => FlutterLogo(
      size: 100,
    );
