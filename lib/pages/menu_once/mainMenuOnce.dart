import 'package:flutter/material.dart';
import 'package:lost/pages/menu_once/welcome.dart';
import 'package:lost/widgets/exit_app_confirmation.dart';

import 'design.dart';

import 'package:lost/constants.dart';

// import the app data
import 'package:lost/models/appData.dart';
import 'package:provider/provider.dart';

// logic code
import 'package:lost/pages/menu_once/logic.dart';

//language support
import 'package:lost/app_localizations.dart';

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

  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

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
  // Function pushFirstButton = pushFirstButtonLogic;
  void pushFirstButton(BuildContext context) {
    _scaffoldKey.currentState.openDrawer();
  }

  Function(BuildContext context) pushSecoundButton = pushSecoundButtonLogic;

  @override
  void initState() {
    // load the app settings

    // load tha app data
    Future fetchData() async {
      // load the Type Operation
      Provider.of<TypeOperationData>(context, listen: false).loadData();
      // load the Status Operation
      Provider.of<StatusOperationData>(context, listen: false).loadData();
      // load the age ranges
      Provider.of<AgeData>(context, listen: false).loadData();

      //user data - Permission & Status
      Provider.of<UserStatusData>(context, listen: false).loadData();
      Provider.of<UserPermissionData>(context, listen: false).loadData();
    }

    fetchData();

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

    // show country bool from the loading page
    showCountryPage = widget.showCountryPage;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    return WillPopScope(
      onWillPop: () => exitApp(context),
      child: Scaffold(
          key: _scaffoldKey,
          backgroundColor: scaffoldColor,
          drawer: FirstMenu(),
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
                    ],
                  ),
                ),

                // the Hover screens
                showWelcome
                    ? Welcome(
                        onDismiss: dismissWelcome,
                        mode: 'welcome',
                      )
                    : false
                        // showLanguag
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
          )),
    );
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

class FirstMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return SafeArea(
      child: Theme(
        data: Theme.of(context).copyWith(
          canvasColor: Colors.transparent,
        ),
        child: Container(
          width: screenSize.width * (2 / 3),
          height: 300,
          child: Drawer(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25),
                  bottomLeft: Radius.circular(25),
                ),
              ),
              child: Column(
                children: [
                  // the menu titel
                  Text(
                    'المفقودات',
                    style: TextStyle(
                      fontSize: 30,
                      color: mainDarkColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  // the menu
                  ListView(
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    children: <Widget>[
                      //people
                      ListTile(
                        leading: Icon(
                          Icons.people,
                        ),
                        title: Text(AppLocalizations.of(context)
                            .translate('menu_people')),
                        onTap: () {
                          Navigator.of(context).pop();
                          // change the object selected
                          Provider.of<AppSettings>(context, listen: false)
                              .changeObject('Person');
                          // push home
                          pushHome(context);
                        },
                      ),

                      //cars
                      ListTile(
                        leading: Icon(Icons.directions_car),
                        title: Text(AppLocalizations.of(context)
                            .translate('menu_cars')),
                        onTap: () {
                          Navigator.of(context).pop();
                          // change the object selected
                          Provider.of<AppSettings>(context, listen: false)
                              .changeObject('Car');
                          // push home
                          pushHome(context);
                        },
                      ),

                      //PersonalBelongings
                      ListTile(
                        leading: Icon(Icons.phone_android),
                        title: Text(AppLocalizations.of(context)
                            .translate('menu_PersonalBelongings')),
                        onTap: () {
                          Navigator.of(context).pop();
                          // change the object selected
                          Provider.of<AppSettings>(context, listen: false)
                              .changeObject('PersonalBelongings');
                          // push home
                          pushHome(context);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
