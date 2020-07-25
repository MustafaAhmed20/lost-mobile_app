import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import 'homeData.dart';
import 'wait.dart';
import 'forms.dart';
import 'snackBars.dart';

// import the app data
import 'package:lost/models/appData.dart';
import 'package:provider/provider.dart';

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

  // form key
  GlobalKey<FormBuilderState> _fbKey;

  @override
  void initState() {
    super.initState();

    _fbKey = GlobalKey<FormBuilderState>();

    _pageController = PageController(initialPage: 0, keepPage: true);

    // load tha app data
    Future fetchData() async {
      // load the Type Operation
      Provider.of<TypeOperationData>(context, listen: false).loadData();
      // load the Status Operation
      Provider.of<StatusOperationData>(context, listen: false).loadData();
      // load the age ranges
      Provider.of<AgeData>(context, listen: false).loadData();
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

    return Scaffold(
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
                              // show add form with key and current type page
                              child: operatioForm(
                                  context, _fbKey, types[_currentPage]),
                            );
                          },
                        )
                      : // loggin page

                      Navigator.pushNamed(context, '/login',
                          arguments: {'showAlert': true}).then((value) {
                          bool logged =
                              Provider.of<UserData>(context, listen: false)
                                          .token ==
                                      null
                                  ? false
                                  : true;
                          // if logged-in show snakebar
                          if (logged) {
                            Scaffold.of(context)
                                .showSnackBar(successLoginSnackBar);
                          }
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
        actions: <Widget>[
          Builder(
            builder: (BuildContext context) => PopupMenuButton<String>(
              onSelected: (value) => handleClick(value, context),
              itemBuilder: (BuildContext context) {
                return [
                  PopupMenuItem<String>(
                    value: logged ? 'Logout' : 'Login',
                    child: logged ? Text('Logout') : Text('Login'),
                  ),
                ];
              },
            ),
          ),
        ],
        title: Text('Home'),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: null,
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
                                .id,
                        'type_id': types[index].id,
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
      bool logged = Provider.of<UserData>(context, listen: false).token == null
          ? false
          : true;
      // if logged-in show snakebar
      if (logged) {
        Scaffold.of(context).showSnackBar(successLoginSnackBar);
      }
    });
  }

  if (value == 'Logout') {
    // logout the user
    Provider.of<UserData>(context, listen: false).logut();
    Scaffold.of(context).showSnackBar(successLogoutSnackBar);
  }
}
