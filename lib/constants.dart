import 'package:flutter/material.dart';

// const Color liteBackground =  Color(0x502A6D);
Color liteBackground = mainDarkColor.withOpacity(0.3);

// lite
const Color mainLiteColor = Color(0xff823476);

// dark
const Color mainDarkColor = Color(0xff502A6D);

// the hover const Color
const Color hoverColor = Color(0xff3F276A);

const Color scaffoldColor = hoverColor;

// text const Colors
const Color mainTextColor = Colors.white;
// const Color otherTextconst Color = mainLiteconst Color;

const Color otherTextColor = hoverColor;

const Color textColorHint = Color(0xffb3bdcb);

const Color textColorDarkBlack = Color(0xff2e384d);

const Color textColorRedError = Color(0xffe84242);

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
Widget getIcon() {
  return SizedBox(
    child: Container(
      padding: EdgeInsets.all(20),
      clipBehavior: Clip.hardEdge,
      height: 100,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
      child: Image.asset(
        'imeges/logo.png',
        height: 100,
      ),
    ),
  );
}
