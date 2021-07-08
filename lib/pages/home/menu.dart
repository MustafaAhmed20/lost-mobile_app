import 'package:flutter/material.dart';

//language support
import 'package:lost/app_localizations.dart';

import 'package:provider/provider.dart';
import 'package:lost/models/appData.dart';

// the colors
import 'package:lost/constants.dart';

// form
import 'package:flutter_form_builder/flutter_form_builder.dart';

// the models
import 'package:lost/models/models.dart';

// my operations page
import 'package:lost/pages/operations/my_operations_page.dart';

class Menu extends StatelessWidget {
  // the will be true if the user is loged-in else false
  final bool logged;
  Menu({this.logged});

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    // the countries
    List countries = Provider.of<CountryData>(context, listen: true).countries;

    Country selectedCountry =
        Provider.of<CountryData>(context, listen: true).selectedCountry;

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

                  // my operations tile
                  logged
                      ? ListTile(
                          leading: Icon(Icons.person),
                          title: Text(AppLocalizations.of(context)
                              .translate('menu_my_operations')),
                          onTap: () {
                            Navigator.of(context).pop();

                            // open my operations
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (c) => MyOperationsPage(),
                            ));
                          },
                        )
                      : SizedBox.shrink(),

                  // the selected contry
                  Container(
                    width: screenSize.width * (2 / 3),
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    // color: Colors.blue,
                    child: Column(
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // the lable
                        Text(
                          'الدولة المختارة الان',
                          style: TextStyle(fontSize: 10),
                        ),

                        // the selected contry
                        Container(
                          width: 100,
                          child: FormBuilderCountryPicker(
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              // labelText: "الدولة الحالية",
                            ),
                            attribute: 'country_name',
                            readOnly: true,
                            initialValue: selectedCountry?.isoName ??
                                countries[0].isoName,
                            dialogTitle: Text(AppLocalizations.of(context)
                                .translate('Settings_Country')),
                            // countryFilterByIsoCode: countries
                            //     .map((e) => e.isoName.toString())
                            //     .toList(),
                          ),
                        ),
                      ],
                    ),
                  ),

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
