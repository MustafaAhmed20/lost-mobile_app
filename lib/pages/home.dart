import 'package:flutter/material.dart';

import 'homeData.dart';
import 'wait.dart';
import 'forms.dart';

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

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return Dialog(
                child: operatioForm(),
              );
            },
          );
        },
        child: Text(
          '+',
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      appBar: AppBar(
        actions: <Widget>[
          InkWell(
              onTap: () {
                Navigator.pushNamed(context, '/login');
              },
              child: Icon(Icons.account_circle)),
          PopupMenuButton<String>(
            onSelected: handleClick,
            itemBuilder: (BuildContext context) {
              return {'Logout', 'Settings'}.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
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

void handleClick(String value) {
  // switch (value) {
  //   case 'Logout':
  //     break;
  //   case 'Settings':
  //     break;
  // }
  print(value);
}
