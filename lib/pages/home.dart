import 'package:flutter/material.dart';

import 'homeData.dart';
import 'wait.dart';
import 'forms.dart';
import 'snackBars.dart';

// import the app data
import 'package:lost/models/appData.dart';
import 'package:lost/models/user.dart';
import 'package:provider/provider.dart';

//language support
import 'package:lost/app_localizations.dart';

// the main menu
import 'package:lost/pages/menu.dart';

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
    showSnake(context, massege);

    String selectedObject =
        Provider.of<AppSettings>(context, listen: true).selectedObjectString;

    // variable numbers of tabs
    List types =
        Provider.of<TypeOperationData>(context, listen: true).typeOperation;
    bool isLoading;

    if (types == null) {
      types = [];
      isLoading = true;
    } else {
      isLoading = false;
    }

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
    return Scaffold(
      drawer: Menu(logged: logged),
      floatingActionButton: isLoading || types.isEmpty
          ? null
          : Builder(
              // user Builder to have new context under Scaffold
              builder: (BuildContext context) => FloatingActionButton(
                onPressed: () {
                  // login if not already logged-in
                  logged
                      ? showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (BuildContext context) {
                            return Dialog(
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(32.0))),
                              child: OperatioForm(
                                  typeOperation: types[_currentPage]),
                            );
                          },
                        )
                      : // loggin page

                      Navigator.pushNamed(context, '/login',
                          arguments: {'showAlert': true}).then((value) {
                          // after login func
                          afterLogin(value, context);
                        });
                },
                child: Text(
                  '+',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        // actions: <Widget>[
        //   Builder(
        //     builder: (BuildContext context) => PopupMenuButton<String>(
        //       onSelected: (value) => handleClick(value, context),
        //       itemBuilder: (BuildContext context) {
        //         return [
        //           PopupMenuItem<String>(
        //             value: logged ? 'Logout' : 'Login',
        //             child: logged
        //                 ? Text(AppLocalizations.of(context)
        //                     .translate('home_Logout'))
        //                 : Text(AppLocalizations.of(context)
        //                     .translate('home_Login')),
        //           ),
        //           PopupMenuItem<String>(
        //             value: 'Settings',
        //             child: Text(AppLocalizations.of(context)
        //                 .translate('home_Settings')),
        //           ),
        //           PopupMenuItem<String>(
        //             value: 'feedback',
        //             child: Text(AppLocalizations.of(context)
        //                 .translate('home_FeedBack')),
        //           ),
        //           !admin
        //               ? null
        //               : PopupMenuItem<String>(
        //                   value: 'admin',
        //                   child: Text(AppLocalizations.of(context)
        //                       .translate('home_AdminPanel')),
        //                 ),
        //         ];
        //       },
        //     ),
        //   ),
        // ],
        title: Text(AppLocalizations.of(context).translate(selectedObject)),

        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: Size(double.infinity, 10),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: types.map((type) {
                int index = types.indexOf(type);
                return InkWell(
                    onTap: () {
                      setState(() {
                        _currentPage = index;
                      });
                      _pageController.animateToPage(
                        index,
                        duration: Duration(milliseconds: 400),
                        curve: Curves.easeInOut,
                      );
                    },
                    child: Container(
                      margin:
                          EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                      child: Text(
                        types[index].name,
                        style: TextStyle(
                          color: Theme.of(context).accentColor,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.0,

                          // decoration for selectes tab
                          decoration: index == _currentPage
                              ? TextDecoration.underline
                              : null,
                          decorationStyle: index == _currentPage
                              ? TextDecorationStyle.double
                              : null,
                        ),
                      ),
                    ));
              }).toList()),
        ),
      ),
      body: isLoading
          ? wait()
          : PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              itemCount: types.length,
              itemBuilder: (context, index) {
                return MultiProvider(
                  providers: [
                    ChangeNotifierProvider(
                      create: (context) => OperationData({
                        'country_id':
                            Provider.of<CountryData>(context, listen: false)
                                .selectedCountry
                                ?.id,
                        'type_id': types[index]?.id,
                      }),
                    ),
                  ],
                  child: HomeData(),
                );
              },
            ),
    );
  }
}

void handleClick(String value, context) {
  if (value == 'Login') {
    Navigator.pushNamed(context, '/login').then((value) {
      afterLogin(value, context);
    });
  }

  if (value == 'Logout') {
    // logout the user
    Provider.of<UserData>(context, listen: false).logut();
    Scaffold.of(context).showSnackBar(successLogoutSnackBar(context));
  }
  if (value == 'Settings') {
    Navigator.pushNamed(context, '/choose', arguments: {'pop': true});
  }

  if (value == 'feedback') {
    Navigator.pushNamed(context, '/feedback').then((value) {
      if (value != null) {
        // add feedback successfully
        Scaffold.of(context).showSnackBar(customSuccessSnackBar(context,
            AppLocalizations.of(context).translate('SnackBar_sendFeddBack')));
      }
    });
  }
}

void afterLogin(returnedValue, BuildContext context) {
  // run after the login page pop here in (home)
  bool logged = Provider.of<UserData>(context, listen: false).token == null
      ? false
      : true;
  // if logged-in show snakebar
  if (logged) {
    Scaffold.of(context).showSnackBar(successLoginSnackBar(context));
  }
  // if reseted the password
  if (returnedValue == null) {
    return;
  }
  if (returnedValue['reset'] != null) {
    Scaffold.of(context).showSnackBar(successResetSnackBar(context));
  }
  if (returnedValue['register'] != null) {
    Scaffold.of(context).showSnackBar(successRegisterSnackBar(context));
  }
}

showSnake(BuildContext context, String choice) {
  print('this happend');
  print('massege: $choice');
  Builder(builder: (context) {
    () {
      if (choice == null) {
        return;
      } else if (choice == 'addFeddBack') {
        // success add feddback
        Scaffold.of(context).showSnackBar(customSuccessSnackBar(context,
            AppLocalizations.of(context).translate('SnackBar_sendFeddBack')));
      } else if (choice == 'logout') {
        // logout successfully
        Scaffold.of(context).showSnackBar(successLogoutSnackBar(context));
      } else if (choice == 'logout') {}
    }();
    return;
  });
}
