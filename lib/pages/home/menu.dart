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

import 'package:country_pickers/country_pickers.dart' as CountryPickers;

// input field
import 'package:lost/widgets/text_input.dart';

import 'package:intl/intl.dart' show DateFormat;

//
import 'package:lost/widgets/buttons.dart';

// sizer
import 'package:sizer/sizer.dart';

class Menu extends StatefulWidget {
  // the will be true if the user is loged-in else false
  final bool logged;

  // use menu for search
  final bool searchMode;

  Menu({this.logged, this.searchMode = false});

  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
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
          height: widget.searchMode ? 50.h : null,
          child: widget.searchMode
              ? SearchBox()
              : Drawer(
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
                        widget.logged
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
                                // width: 100,
                                child: Builder(
                                  builder: (context) {
                                    var country =
                                        CountryPickers.CountryPickerUtils
                                            .getCountryByIsoCode(
                                                selectedCountry?.isoName ??
                                                    countries[0].isoName);
                                    return Row(
                                      children: [
                                        // the flag
                                        CountryPickers.CountryPickerUtils
                                            .getDefaultFlagImage(country),

                                        SizedBox(
                                          width: 8.0,
                                        ),
                                        Text("${country.name}"),
                                      ],
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),

                        // the logo
                        getIcon(),

                        // some space
                        SizedBox(height: 1),

                        // the app name
                        Text(
                          'أنا نور',
                          style: TextStyle(
                            color: hoverColor,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
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

class SearchBox extends StatefulWidget {
  @override
  _SearchBoxState createState() => _SearchBoxState();
}

class _SearchBoxState extends State<SearchBox> {
  // this help make the date with the correct format
  DateFormat formatter = new DateFormat('yyyy-MM-dd');

  //
  //

  String searchByText = '';

  // controller for textfield
  TextEditingController controller;

  DateTime firstDate;
  DateTime endDate;

  void clearAllFilters(BuildContext context) {
    Provider.of<OperationData>(context, listen: false).clearCustomFilters();

    setState(() {
      searchByText = '';
      firstDate = null;
      endDate = null;
    });
  }

  // filter by text
  void filter(BuildContext context) {
    Provider.of<OperationData>(context, listen: false).filterDataCustomFilters(
        textFilter: searchByText,
        endDateRange: endDate,
        firstDateRange: firstDate);
  }

  @override
  void initState() {
    // get the filters data
    searchByText = Provider.of<OperationData>(context, listen: false)
            .customFilters['text'] ??
        '';

    firstDate = Provider.of<OperationData>(context, listen: false)
        .customFilters['from_date'];

    endDate = Provider.of<OperationData>(context, listen: false)
        .customFilters['end_date'];

    // set the controller
    controller = TextEditingController(text: searchByText);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool showDeleteButton = (searchByText?.isNotEmpty ?? true) ||
        (firstDate != null) ||
        (endDate != null);
    return Drawer(
        child: Container(
      padding: EdgeInsets.only(top: 2.h, bottom: 2.h, left: 3.w, right: 3.w),
      height: 20.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          bottomLeft: Radius.circular(25),
        ),
      ),
      child: Column(
        children: [
          // the search titel
          Text(
            'تصفية النتائج',
            style: TextStyle(
              fontSize: 14.sp,
              color: mainDarkColor,
              fontWeight: FontWeight.bold,
            ),
          ),

          SizedBox(height: 1.h),

          // search by text
          Container(
            height: 7.h,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // lable
                Text(
                  'البحث نصياً',
                  textDirection: TextDirection.rtl,
                  style: TextStyle(
                    fontSize: 10.sp,
                    color: textColorDarkBlack,
                  ),
                ),

                Expanded(
                  child: TextInput(
                    borderRadius: 10,
                    controller: controller,
                    onChange: (c, text) {
                      setState(() {
                        searchByText = text;
                      });
                      filter(c);
                    },
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 1.h),

          // search date
          Container(
            height: 7.h,

            // color: Colors.red,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // lable
                Text(
                  'البحث بالتاريخ',
                  textDirection: TextDirection.rtl,
                  style: TextStyle(
                    fontSize: 10.sp,
                    color: textColorDarkBlack,
                  ),
                ),

                // date input
                Expanded(
                  child: FormBuilder(
                    child: Row(
                      children: [
                        Expanded(
                          child: FormBuilderDateTimePicker(
                            name: "from_date",
                            lastDate: DateTime.now(),
                            inputType: InputType.date,
                            format: formatter,
                            initialValue: firstDate,
                            onChanged: (value) {
                              setState(() {
                                firstDate = value;
                              });
                              filter(context);
                            },
                            decoration: InputDecoration(
                                labelText: 'من',
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10))),
                          ),
                        ),

                        // some space
                        SizedBox(width: 2.w),

                        // end date
                        Expanded(
                          child: FormBuilderDateTimePicker(
                            name: "end_date",
                            inputType: InputType.date,
                            format: formatter,
                            lastDate: DateTime.now(),
                            initialValue: endDate,
                            onChanged: (value) {
                              setState(() {
                                endDate = value;
                              });

                              filter(context);
                            },
                            decoration: InputDecoration(
                                labelText: 'الى',
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10))),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          Spacer(),

          // delete filters button
          showDeleteButton
              ? Container(
                  height: 5.h,
                  child: Button50HBig(
                    color: textColorRedError,
                    function: clearAllFilters,
                    text: 'حذف الفلاتر',
                    textColor: Colors.white,
                    borderRadius: 10,
                  ),
                )
              : SizedBox.shrink(),
        ],
      ),
    ));
  }
}
