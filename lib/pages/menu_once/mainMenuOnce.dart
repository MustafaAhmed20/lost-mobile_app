import 'package:flutter/material.dart';
import 'package:lost/pages/menu_once/welcome.dart';

import 'design.dart';

import 'package:lost/constants.dart';

// logic code
import 'package:lost/pages/menu_once/logic.dart';

class MainMenuOnce extends StatefulWidget {
  final bool showCountryPage;

  MainMenuOnce({@required this.showCountryPage});
  @override
  _MainMenuOnceState createState() => _MainMenuOnceState();
}

class _MainMenuOnceState extends State<MainMenuOnce> {
  bool showWelcome = false;
  bool showLanguag = false;

  bool showCountryPage;

  void dismissWelcome(BuildContext context) {
    setState(() {
      showWelcome = false;
    });
  }

  void dismissLange(BuildContext context) {
    setState(() {
      showLanguag = false;
    });
  }

  void dismissCountry(BuildContext context) {
    setState(() {
      showCountryPage = false;
    });
  }

  // push the main page - the code in logic.dart
  Function pushFirstButton = pushFirstButtonLogic;
  Function pushSecoundButton = pushSecoundButtonLogic;

  @override
  void initState() {
    // check storeg to show welcome massege
    showWelcomeMassege().then((val) {
      if (val != showWelcome) {
        setState(() {
          showWelcome = val;
        });
      }
    });

    // check storeg to show Language Selector page
    showLanguageSelector().then((val) {
      if (val != showLanguag) {
        setState(() {
          showLanguag = val;
        });
      }
    });

    // shw country bool from the loading page
    showCountryPage = widget.showCountryPage;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
        backgroundColor: scaffoldColor,
        body: SafeArea(
          child: Stack(
            children: [
              // the image in the back
              BackgrounDesign(),

              // the Top menu icon
              // Positioned(
              //     top: 7,
              //     right: 4,
              //     child: Icon(
              //       Icons.menu,
              //       size: 35,
              //     )),

              // the BIG Tiltel
              Positioned(
                top: 60,
                child: Container(
                  width: screenSize.width,
                  child: Center(
                    child: Text(
                      'أنا يوسف',
                      style: TextStyle(
                          color: mainTextColor,
                          fontSize: 42,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),

              // the rigth bottom sttings icon
              // Positioned(
              //   bottom: 7,
              //   right: 7,
              //   child: Icon(
              //     Icons.settings_outlined,
              //     color: mainTextColor,
              //     size: 40,
              //   ),
              // ),

              // the Three Big Buttons
              Container(
                width: screenSize.width,
                height: screenSize.height,
                margin: EdgeInsets.only(top: 180, bottom: 60),
                padding: EdgeInsets.symmetric(vertical: 40),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  // mainAxisSize: MainAxisSize.min,
                  children: [
                    MenueSquareButton(
                      color: mainLiteColor,
                      image: 'imeges/personal.png',
                      text: 'مفقودات',
                      onClick: pushFirstButton,
                    ),
                    MenueSquareButton(
                      color: mainDarkColor,
                      image: 'imeges/accident.png',
                      text: 'حوادث السير',
                      onClick: pushSecoundButton,
                    ),
                    // AddButton(),
                  ],
                ),
              ),

              // the Hover screens
              showWelcome
                  ? Welcome(
                      onDismiss: dismissWelcome,
                      mode: 'welcome',
                    )
                  : showLanguag
                      ? Welcome(
                          onDismiss: dismissLange,
                          mode: 'language',
                        )
                      : showCountryPage
                          ? Welcome(
                              onDismiss: dismissCountry,
                              mode: 'country',
                            )
                          : SizedBox.shrink(),
            ],
          ),
        ));
  }
}

class MenueSquareButton extends StatelessWidget {
  final Color color;
  final String text;
  final String image;

  final onClick;

  MenueSquareButton({
    @required this.color,
    @required this.image,
    @required this.text,
    @required this.onClick,
  });

  @override
  Widget build(BuildContext context) {
    double size = 140.0;
    return InkWell(
      onTap: () => onClick(context),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: color,
          border: Border.all(style: BorderStyle.none),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
                color: color,
                spreadRadius: -5,
                blurRadius: 20,
                offset: Offset(0, 10)),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // some space in Top
            SizedBox(
              height: 5,
            ),
            Expanded(
              child: Image.asset(
                image,
                color: mainTextColor,
              ),
            ),
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  color: mainTextColor,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AddButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RaisedButton(
        shape: CircleBorder(),
        color: mainDarkColor,
        child: Icon(
          Icons.add,
          color: mainTextColor,
          size: 60,
        ),
        onPressed: () {});
  }
}
