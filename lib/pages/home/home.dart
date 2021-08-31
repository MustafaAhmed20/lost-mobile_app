import 'package:flutter/material.dart';

import 'package:lost/pages/menu_once/design.dart';
import 'package:lost/pages/settings_hover.dart';

import 'package:lost/pages/operations/homeData.dart';
import 'package:lost/pages/wait.dart';
import 'package:lost/pages/forms/forms.dart';
import 'package:lost/pages/snackBars.dart';

// import the app data
import 'package:lost/models/appData.dart';
import 'package:provider/provider.dart';

//language support
import 'package:lost/app_localizations.dart';

// the main menu
import 'package:lost/pages/home/menu.dart';

// the colors
import 'package:lost/constants.dart';

//
import 'package:lost/pages/home/bottom_app_bar.dart';

// sizer
import 'package:sizer/sizer.dart';

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
  static const int _INITIAlPAGE = 0;
  int _currentPage = _INITIAlPAGE;

  PageController _pageController;

  // key for the scaffold - helps in show the snackbar
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  //
  String selectedObject;

  /// the mode for menu
  /// true mean use it for search
  bool useMenuForSearch = false;

  @override
  void initState() {
    super.initState();

    _pageController =
        PageController(initialPage: _INITIAlPAGE, keepPage: false);

    // load data
    Provider.of<OperationData>(context, listen: false)
        .loadData(context: context);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // use default value of 'Accident' object string - this is a fix for a bug that somtimes apper
    String tempSelectedObject =
        Provider.of<AppSettings>(context, listen: true).selectedObjectString ??
            'menu_accident';

    if (selectedObject != tempSelectedObject) {
      // the object changed
      selectedObject = tempSelectedObject;
      _currentPage = _INITIAlPAGE;
    }

    // check if there is a snakebar need to show from provider
    String massege =
        Provider.of<AppSettings>(context, listen: true).homeSnakeBar;

    // show the snakebar
    Future.delayed(Duration(seconds: 0)).then((value) {
      showSnake(context, massege, _scaffoldKey);
    });
  }

  @override
  Widget build(BuildContext context) {
    // variable numbers of tabs
    List types =
        Provider.of<TypeOperationData>(context, listen: true).typeOperation ??
            [];

    // login state - true if user logged-in
    bool logged = Provider.of<UserData>(context, listen: true).token == null
        ? false
        : true;

    // the operation types names
    Map names = Provider.of<TypeOperationData>(context, listen: true).names;

    Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      key: _scaffoldKey,
      drawer: Menu(logged: logged, searchMode: useMenuForSearch),
      onDrawerChanged: (isOpened) {
        // when Drawer closed
        // set the flage to false
        if (!isOpened) {
          Future.delayed(Duration(milliseconds: 300)).then((value) {
            setState(() {
              useMenuForSearch = false;
            });
          });
        }
      },
      appBar: PreferredSize(
        child: Container(color: scaffoldColor),
        preferredSize: Size(0, 0),
      ),
      floatingActionButton: Container(
        margin: EdgeInsets.symmetric(horizontal: 4.5.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            FloatingActionButton(
              backgroundColor: mainLiteColor,
              child: SettingsCornerIcon(),
              onPressed: null,
            ),
            FloatingActionButton(
              backgroundColor: mainLiteColor,
              child: Icon(Icons.search, size: 25.sp),
              onPressed: () {
                // open with searh mode
                setState(() {
                  useMenuForSearch = true;
                });

                _scaffoldKey.currentState.openDrawer();
              },
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBarWidget(),
      body: Stack(children: [
        // the design
        SafeArea(
          child: BackgrounDesign(
            useDesign2: true,
          ),
        ),

        // the menu icon
        Positioned(
          top: 0.3.h,
          right: 0,
          child: InkWell(
            onTap: () => _scaffoldKey.currentState.openDrawer(),
            child: Container(
              height: 6.h,
              width: 6.h,
              // color: Colors.red,
            ),
          ),
        ),

        // the BIG Title
        Positioned(
          top: 1.h,
          child: Container(
            width: screenSize.width,
            // color: Colors.red,
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
                        : // all the objects
                        Column(
                            children: [
                              // page view controll buttons
                              // no tap bar if the objct selected is accident
                              Container(
                                height: 40,
                                clipBehavior: Clip.hardEdge,
                                margin: EdgeInsets.symmetric(horizontal: 50),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: mainLiteColor, width: 1.2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: types?.map((type) {
                                          int index = types.indexOf(type);
                                          return Expanded(
                                            child: InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    _currentPage = index;
                                                  });
                                                  _pageController.animateToPage(
                                                    index,
                                                    duration: Duration(
                                                        milliseconds: 400),
                                                    curve: Curves.easeInOut,
                                                  );
                                                },
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    // border: Border.all(
                                                    //     color:
                                                    //         mainLiteColor),
                                                    color: index == _currentPage
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
                                                            FontWeight.bold,
                                                        fontSize: 14,
                                                        letterSpacing: 1.0,
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
                                  },
                                ),
                              ),
                            ],
                          ),
          ),
        ),

        // pull to refrech row
        // Positioned(
        //   bottom: 0,
        //   child: Container(
        //     height: 70,
        //     width: screenSize.width,
        //     // padding: EdgeInsets.only(right: 10),
        //     // color: Colors.red,
        //     child: Column(
        //       // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //       // mainAxisSize: MainAxisSize.max,
        //       children: [
        //         // the text
        //         Text(
        //           'لتحديث الصفحة اسحب الشاشة للأسفل',
        //           style: TextStyle(
        //             fontSize: 12,
        //             color: textColorHint,
        //           ),
        //         ),
        //         // the icon
        //         Icon(
        //           Icons.arrow_downward,
        //           color: textColorHint,
        //         ),
        //       ],
        //     ),
        //   ),
        // ),
      ]),
    );
  }
}

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
