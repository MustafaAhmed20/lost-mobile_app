import 'package:flutter/material.dart';

//language support
import 'package:lost/app_localizations.dart';

import 'package:provider/provider.dart';
import 'package:lost/models/appData.dart';

// the colors
import 'package:lost/constants.dart';

class Menu extends StatelessWidget {
  // the will be true if the user is loged-in else false
  final bool logged;
  Menu({this.logged});

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
          child: Drawer(
            child: Container(
              padding: EdgeInsets.only(top: 20, bottom: 10),
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
                    'القائمة',
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
                      // DrawerHeader(
                      //   child: Text(
                      //     'Side menu',
                      //     style: TextStyle(color: Colors.white, fontSize: 25),
                      //   ),
                      //   decoration: BoxDecoration(
                      //       color: Colors.green,
                      //       image: DecorationImage(
                      //           fit: BoxFit.fill, image: AssetImage('imeges/menu.jpg'))),
                      // ),
                      // Divider with text in middel

                      // Row(
                      //   children: <Widget>[
                      //     Expanded(child: Divider()),
                      //     Text("Sections"),
                      //     Expanded(child: Divider()),
                      //   ],
                      // ),

                      //accident
                      ListTile(
                        leading: Image.asset(
                          'imeges/accident.png',
                          width: 40,
                        ),
                        title: Text(AppLocalizations.of(context)
                            .translate('menu_accident')),
                        onTap: () {
                          Navigator.of(context).pop();
                          // change the object selected
                          Provider.of<AppSettings>(context, listen: false)
                              .changeObject('Accident');
                        },
                      ),
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
                        },
                      ),

                      // Divider with text in middel
                      // Row(
                      //   children: <Widget>[
                      //     Expanded(child: Divider()),
                      //     Text("Settings"),
                      //     Expanded(child: Divider()),
                      //   ],
                      // ),

                      // ListTile(
                      //   leading: Icon(Icons.settings),
                      //   title:
                      //       Text(AppLocalizations.of(context).translate('home_Settings')),
                      //   onTap: () {
                      //     Navigator.of(context).pop();
                      //     Navigator.pushNamed(context, '/choose', arguments: {'pop': true});
                      //   },
                      // ),
                      // ListTile(
                      //   leading: Icon(Icons.border_color),
                      //   title:
                      //       Text(AppLocalizations.of(context).translate('home_FeedBack')),
                      //   onTap: () {
                      //     // Navigator.of(context).pop();
                      //     Navigator.pushNamed(context, '/feedback').then((value) {
                      //       if (value != null) {
                      //         // add feedback successfully

                      //         // tell the home page to show snakebar throw Provider
                      //         Provider.of<AppSettings>(context, listen: false)
                      //             .setHomeSnakeBar('addFeddBack');
                      //       }
                      //       Navigator.of(context).pop();
                      //     });
                      //   },
                      // ),
                      // ListTile(
                      //   leading:
                      //       logged ? Icon(Icons.exit_to_app) : Icon(Icons.perm_identity),
                      //   title: logged
                      //       ? Text(AppLocalizations.of(context).translate('home_Logout'))
                      //       : Text(AppLocalizations.of(context).translate('home_Login')),
                      //   onTap: () {
                      //     if (logged) {
                      //       // pop the menu
                      //       Navigator.of(context).pop();

                      //       // logout
                      //       Provider.of<UserData>(context, listen: false).logut();
                      //       // tell the home page to show snakebar throw Provider
                      //       Provider.of<AppSettings>(context, listen: false)
                      //           .setHomeSnakeBar('logout');
                      //     } else {
                      //       // pop the menu
                      //       Navigator.of(context).pop();

                      //       // show login screen
                      //       Navigator.pushNamed(context, '/login');
                      //     }
                      //   },
                      // ),
                    ],
                  ),

                  // push the icon down
                  Spacer(),

                  // the logo
                  getIcon(),

                  // some space
                  SizedBox(height: 5),

                  // the app name
                  Text(
                    'أنا يوسف',
                    style: TextStyle(
                      color: hoverColor,
                      fontSize: 20,
                    ),
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
