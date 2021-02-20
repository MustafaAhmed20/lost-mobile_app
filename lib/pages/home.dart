import 'package:flutter/material.dart';
import 'package:lost/pages/menu_once/design.dart';
import 'package:lost/pages/settings_hover.dart';

import 'homeData.dart';
import 'wait.dart';
import 'forms.dart';
import 'snackBars.dart';

// import the app data
import 'package:lost/models/appData.dart';
import 'package:provider/provider.dart';

//language support
import 'package:lost/app_localizations.dart';

// the main menu
import 'package:lost/pages/menu.dart';

// the colors
import 'package:lost/constants.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<dynamic> operations = [];

  // the types of operations
  List types;
  bool isLoading;

  // current page viewed
  int _currentPage = 0;

  PageController _pageController;

  // this will be true if logged in user is admin
  bool admin = false;

  // key for the scaffold - helps in show the snackbar
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();

    _pageController = PageController(initialPage: 0, keepPage: true);

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
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // check if there is a snakebar need to show from provider
    String massege =
        Provider.of<AppSettings>(context, listen: true).homeSnakeBar;
    // show the snakebar
    Future.delayed(Duration(seconds: 0)).then((value) {
      showSnake(context, massege, _scaffoldKey);
    });

    // use default value of 'Accident' object string - this is a fix for a bug that somtimes apper
    String selectedObject =
        Provider.of<AppSettings>(context, listen: true).selectedObjectString ??
            'menu_accident';

    // variable numbers of tabs
    List types =
        Provider.of<TypeOperationData>(context, listen: true).typeOperation ??
            [];

    // login state - true if user logged-in
    bool logged = Provider.of<UserData>(context, listen: true).token == null
        ? false
        : true;
    if (logged) {
      // check if user is admin
      dynamic user = Provider.of<UserData>(context, listen: false).user;
      List<dynamic> permission =
          Provider.of<UserPermissionData>(context, listen: true).userPermission;

      if (permission != null && user != null) {
        if (user.permission ==
            permission.firstWhere((element) => element.name == 'admin').id) {
          admin = true;
        } else {
          admin = false;
        }
      }
    } else {
      admin = false;
    }

    // the operation types names
    Map names = Provider.of<TypeOperationData>(context, listen: true).names;

    Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      key: _scaffoldKey,
      drawer: Menu(logged: logged),
      floatingActionButton: types?.isEmpty ?? true
          ? null
          : AddButton(
              logged: logged,
              selectedObject: selectedObject,
            ),
      // plusButton(context, selectedObject, logged),
      // appBar: AppBar(
      //   backgroundColor: Theme.of(context).primaryColor,
      //   title: Text(AppLocalizations.of(context).translate(selectedObject)),
      //   centerTitle: true,
      //   // no tap bar if the objct selected is accident
      //   bottom: selectedObject == 'menu_accident'
      //       ? null
      //       : PreferredSize(
      //           preferredSize: Size(double.infinity, 20),
      //           child: Row(
      //               mainAxisAlignment: MainAxisAlignment.spaceAround,
      //               children: types?.map((type) {
      //                     int index = types.indexOf(type);
      //                     return InkWell(
      //                         onTap: () {
      //                           setState(() {
      //                             _currentPage = index;
      //                           });
      //                           _pageController.animateToPage(
      //                             index,
      //                             duration: Duration(milliseconds: 400),
      //                             curve: Curves.easeInOut,
      //                           );
      //                         },
      //                         child: Container(
      //                           color:
      //                               index == _currentPage ? Colors.white : null,
      //                           padding: EdgeInsets.symmetric(
      //                               horizontal: 10, vertical: 3),
      //                           margin: EdgeInsets.symmetric(
      //                               vertical: 10.0, horizontal: 2.0),
      //                           child: Text(
      //                             AppLocalizations.of(context)
      //                                 .translate(names[types[index].name]),
      //                             style: TextStyle(
      //                               //color: Theme.of(context).accentColor,
      //                               color: index == _currentPage
      //                                   ? Theme.of(context).primaryColor
      //                                   : Theme.of(context).accentColor,
      //                               fontWeight: FontWeight.bold,
      //                               fontSize: 14,
      //                               letterSpacing: 1.0,
      //                             ),
      //                           ),
      //                         ));
      //                   })?.toList() ??
      //                   // if the types is null
      //                   []),
      //         ),
      // ),
      backgroundColor: scaffoldColor,
      body: Stack(children: [
        // the design
        SafeArea(
          child: BackgrounDesign(
            useDesign2: true,
          ),
        ),

        // the menu icon
        Positioned(
          top: 40,
          right: 0,
          child: InkWell(
            onTap: () => _scaffoldKey.currentState.openDrawer(),
            child: Container(
              height: 50,
              width: 50,
              // color: Colors.red,
            ),
          ),
        ),

        // the BIG Tiltel
        Positioned(
          top: 50,
          child: Container(
            width: screenSize.width,
            child: Center(
              child: Text(
                AppLocalizations.of(context).translate(selectedObject),
                style: TextStyle(
                    color: mainTextColor,
                    fontSize: 30,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),

        // the content
        SafeArea(
          child: Container(
            margin: EdgeInsets.only(top: 120),
            padding: EdgeInsets.only(left: 10, right: 10, top: 20),
            width: screenSize.width,
            height: screenSize.height,
            // color: Colors.red,
            child: types == null
                ?
                // null mean still loading
                wait(context)
                : types.isEmpty
                    ?
                    // no data
                    noData(context)
                    :
                    // if selected object is accident not use pageView
                    selectedObject == 'menu_accident'
                        ?
                        // Accident object
                        HomeData()
                        // ChangeNotifierProvider(
                        //     create: (context) => OperationData({
                        //       'country_id': Provider.of<CountryData>(context,
                        //               listen: false)
                        //           .selectedCountry
                        //           ?.id,
                        //     }),
                        //     child: HomeData(),
                        //   )
                        : // all the objects
                        Column(
                            children: [
                              // page view controll buttons
                              // no tap bar if the objct selected is accident
                              selectedObject == 'menu_accident'
                                  ? null
                                  : Container(
                                      height: 40,
                                      clipBehavior: Clip.hardEdge,
                                      margin:
                                          EdgeInsets.symmetric(horizontal: 50),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: mainLiteColor, width: 1.2),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: types?.map((type) {
                                                int index = types.indexOf(type);
                                                return Expanded(
                                                  child: InkWell(
                                                      onTap: () {
                                                        setState(() {
                                                          _currentPage = index;
                                                        });
                                                        _pageController
                                                            .animateToPage(
                                                          index,
                                                          duration: Duration(
                                                              milliseconds:
                                                                  400),
                                                          curve:
                                                              Curves.easeInOut,
                                                        );
                                                      },
                                                      child: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          // border: Border.all(
                                                          //     color:
                                                          //         mainLiteColor),
                                                          color: index ==
                                                                  _currentPage
                                                              ? mainLiteColor
                                                              : null,
                                                        ),
                                                        // padding: EdgeInsets
                                                        //     .symmetric(
                                                        //         horizontal: 10,
                                                        //         vertical: 3),

                                                        child: Center(
                                                          child: Text(
                                                            AppLocalizations.of(
                                                                    context)
                                                                .translate(names[
                                                                    types[index]
                                                                        .name]),
                                                            style: TextStyle(
                                                              //color: Theme.of(context).accentColor,
                                                              color: index ==
                                                                      _currentPage
                                                                  ? Colors.white
                                                                  : mainLiteColor,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 14,
                                                              letterSpacing:
                                                                  1.0,
                                                            ),
                                                          ),
                                                        ),
                                                      )),
                                                );
                                              })?.toList() ??
                                              // if the types is null
                                              []),
                                    ),

                              // the data
                              Expanded(
                                child: PageView.builder(
                                  // use the 'selectedObject' as key to force the pageView to rebuild if the object changed.
                                  key: ValueKey(selectedObject),
                                  controller: _pageController,

                                  onPageChanged: (index) {
                                    setState(() {
                                      _currentPage = index;
                                    });
                                  },
                                  itemCount: types?.length ?? 0,
                                  itemBuilder: (context, index) {
                                    return HomeData(
                                      typeId: types[index]?.id,
                                    );
                                    // ChangeNotifierProvider(
                                    //   create: (context) => OperationData({
                                    //     'country_id': Provider.of<CountryData>(
                                    //             context,
                                    //             listen: false)
                                    //         .selectedCountry
                                    //         ?.id,
                                    // 'type_id': types[index]?.id,
                                    //   }),
                                    //   child: HomeData(),
                                    // );
                                  },
                                ),
                              ),
                            ],
                          ),
          ),
        ),

        // the settings corner
        Positioned(
          right: 0,
          bottom: 0,
          child: Container(
            height: 80,
            child: Stack(
              children: [
                Image(
                  image: AssetImage(
                    'imeges/background_corner.jpg',
                  ),
                  fit: BoxFit.fill,
                ),
                // the icon
                Positioned(
                  top: 20,
                  // right: 25,
                  child: SettingsCornerIcon(),
                ),
              ],
            ),
          ),
        ),

        // pull to refrech row
        Positioned(
          bottom: 0,
          child: Container(
            height: 70,
            width: screenSize.width,
            // padding: EdgeInsets.only(right: 10),
            // color: Colors.red,
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              // mainAxisSize: MainAxisSize.max,
              children: [
                // the text
                Text(
                  'لتحديث الصفحة اسحب الشاشة للأسفل',
                  style: TextStyle(
                    fontSize: 12,
                    color: textColorHint,
                  ),
                ),
                // the icon
                Icon(
                  Icons.arrow_downward,
                  color: textColorHint,
                ),
              ],
            ),
          ),
        ),
      ]),
    );
  }
}

class AddButton extends StatelessWidget {
  final String selectedObject;
  final bool logged;

  AddButton({
    @required this.selectedObject,
    @required this.logged,
  });
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: mainDarkColor,
      child: Icon(
        Icons.add,
        color: mainTextColor,
        size: 50,
      ),
      onPressed: () {
        // login if not already logged-in
        logged
            ? Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => OperatioForm(
                          accident: selectedObject == 'menu_accident',
                        )))
            : // loggin page

            Navigator.pushNamed(context, '/login',
                arguments: {'showAlert': true});
      },
    );
  }
}

// Widget plusButton(BuildContext context, selectedObject, logged) {
//   return FloatingActionButton.extended(
//     onPressed: () {
//       // login if not already logged-in
//       logged
//           ? Navigator.push(
//               context,
//               MaterialPageRoute(
//                   builder: (context) => OperatioForm(
//                         accident: selectedObject == 'menu_accident',
//                       )))
//           : // loggin page

//           Navigator.pushNamed(context, '/login',
//               arguments: {'showAlert': true});
//     },
//     label: Text(
//       selectedObject == 'menu_accident'
//           ? AppLocalizations.of(context).translate('home_addAccident')
//           : '+',
//       style: TextStyle(
//         fontSize: 20.0,
//         fontWeight: FontWeight.bold,
//       ),
//     ),
//     // this only when the selected object is accident
//     icon: selectedObject == 'menu_accident'
//         ? Image.asset(
//             'imeges/accident.png',
//             width: 30,
//           )
//         : null,
//     shape: selectedObject == 'menu_accident'
//         ? RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(18.0),
//           )
//         : null,
//   );
// }

showSnake(BuildContext context, String choice, GlobalKey<ScaffoldState> key) {
  if (choice == null) {
    return;
  } else if (choice == 'addFeddBack') {
    // success add feddback
    key.currentState.showSnackBar(customSuccessSnackBar(context,
        AppLocalizations.of(context).translate('SnackBar_sendFeddBack')));
  } else if (choice == 'logout') {
    // logout successfully
    key.currentState.showSnackBar(successLogoutSnackBar(context));
  } else if (choice == 'login') {
    key.currentState.showSnackBar(successLoginSnackBar(context));
  } else if (choice == 'register') {
    //user succefully registed
    key.currentState.showSnackBar(successRegisterSnackBar(context));
  } else if (choice == 'reset') {
    // user reseted the password
    key.currentState.showSnackBar(successResetSnackBar(context));
  }

  // clear the massege after show it
  Provider.of<AppSettings>(context, listen: false).clearHomeSnakeBar();
}
