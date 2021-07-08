/*
this the main state model of the app data

*/

import 'package:flutter/material.dart';

// the server URL
import 'package:lost/api.dart' as urls;

import 'package:http/http.dart' as http;
import 'dart:convert';

// the models
import 'package:lost/models/models.dart';

import 'package:path/path.dart';

// storage user preferences
import 'package:shared_preferences/shared_preferences.dart';

// emojis
import 'package:emojis/emojis.dart';
import 'package:emojis/emoji.dart';

// the provider package
import 'package:provider/provider.dart';

String address = AppData().serverAddress;

class CountryData extends ChangeNotifier {
// countries available

  List<Country> countries;

  // the slected country now .. this will go as a filter for operation selecting
  Country selectedCountry;

  Future<bool> loadData({@required BuildContext context}) async {
    // return True if there is selected country , return False if no selected contry

    Future<void> getData() async {
      try {
        http.Response response = await http.get(address + '/getcountry');

        if (response.statusCode != 200) {
          // throw some error
        }

        if (response.statusCode == 200) {
          Map<String, dynamic> body = json.decode(response.body);

          if (body['status'] != 'success') {
            // error handling
          } else if (body['status'] == 'success') {
            countries = (body['data']['country'] as List).map((item) {
              return Country.fromJson(item);
            }).toList();
          }
        }
      } catch (e) {
        print(e);
      }
      notifyListeners();
    }

    // load the countries
    Future<void> done = getData();

    //  try load the selected country from storge
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String country = prefs.getString('country');

    if (country != null) {
      Country countryObject = Country.fromJson(json.decode(country));

      // set the country
      setCountry(context: context, countryObject: countryObject);

      // set the country
      done.then((value) {
        Country country = this.countries.firstWhere(
            (country) => country.id == countryObject.id,
            orElse: () => this.countries[0]);

        // reset the country so any change will be save
        setCountry(context: context, countryObject: country);
      });

      return Future<bool>.value(true);
    }
    return Future<bool>.value(false);
  }

  void setCountry(
      {@required BuildContext context,
      String countryName,
      Country countryObject}) async {
    if (countryName == null && countryObject == null) {
      // must pass one
      throw 'must use countryName OR countryObject';
    }
    if (countryObject != null) {
      this.selectedCountry = countryObject;
    } else {
      // the user set the slected country
      this.selectedCountry = this.countries.firstWhere(
          (country) => country.name == countryName.toLowerCase(),
          orElse: () => this.countries[0]);
    }

    final prefs = await SharedPreferences.getInstance();

    // set value
    prefs.setString('country', json.encode(selectedCountry.toJson()));

    notifyListeners();
  }
}

class TypeOperationData extends ChangeNotifier {
// Type Operations available

  List<dynamic> typeOperation;

  // the translate of the type operation
  Map names = {'found': 'typeOperation_found', 'lost': 'typeOperation_lost'};

  void loadData() async {
    Future<void> getData() async {
      try {
        http.Response response = await http.get(address + '/gettypeoperation');

        if (response.statusCode != 200) {
          // throw some error
        }

        if (response.statusCode == 200) {
          Map<String, dynamic> body = json.decode(response.body);

          if (body['status'] != 'success') {
            // error handling
          } else if (body['status'] == 'success') {
            this.typeOperation = body['data']['type_operation'].map((item) {
              return TypeOperation.fromJson(item);
            }).toList();
          }
        }
      } catch (e) {
        throw e;
      }
    }

    await getData();

    notifyListeners();
  }
}

class StatusOperationData extends ChangeNotifier {
// Type Operations available

  List<dynamic> statusOperation;

  void loadData() async {
    Future<void> getData() async {
      try {
        http.Response response =
            await http.get(address + '/getstatusoperation');

        if (response.statusCode != 200) {
          // throw some error
        }

        if (response.statusCode == 200) {
          Map<String, dynamic> body = json.decode(response.body);

          if (body['status'] != 'success') {
            // error handling
          } else if (body['status'] == 'success') {
            this.statusOperation = body['data']['status_operation'].map((item) {
              return StatusOperation.fromJson(item);
            }).toList();
          }
        }
      } catch (e) {
        throw e;
      }
    }

    await getData();

    notifyListeners();
  }
}

class AppData extends ChangeNotifier {
  final serverAddress = urls.serverAddress;
  final serverAddressImeges = urls.serverAddressImeges;

  final serverName = urls.serverName;
  final apiSec = urls.apiSec;

  Future<bool> checkConnection() async {
    Future<bool> getData() async {
      try {
        http.Response data = await http.get(address + '/checkconnection');

        if (data.statusCode != 200) {
          return Future<bool>.value(false);
        }

        return Future<bool>.value(true);
      } catch (e) {
        print(e);
        return Future<bool>.value(false);
      }
    }

    bool result = await getData();

    return result;
  }
}

class OperationData extends ChangeNotifier {
  // operations loaded
  List<Operations> unFilteredOperations = [];
  List<Operations> operations = [];

  // the operations for the logged-in user
  List<Operations> myOperations = [];

  // if this is true mean show temp screen
  bool isLoading;

  List<bool Function(Operations)> filters = [];

  // filter the data by values
  void filterData(List<bool Function(Operations)> filters) {
    if (filters?.isEmpty ?? true) {
      // all the Operations
      operations = unFilteredOperations;
    } else {
      // get the operations where all the filters apply
      operations = unFilteredOperations.where((e) {
        return filters.every((element) => element(e));
      }).toList();
    }
  }

  // Future<void> loadData(Map filters) async {
  Future<void> loadData({@required BuildContext context}) async {
    // till the screen to wait
    isLoading = true;

    Future<void> getData(filters) async {
      int countryId =
          Provider.of<CountryData>(context, listen: false).selectedCountry?.id;
      Map<String, String> temp = {'country_id': countryId.toString()};

      if (filters != null && filters.isNotEmpty) {
        filters.updateAll((key, value) => value.toString());
        temp.addAll(Map<String, String>.from(filters));
      }

      try {
        var uri = Uri.https(
            AppData().serverName, AppData().apiSec + '/getoperation', temp);

        http.Response response = await http.get(uri.toString());
        if (response.statusCode != 200) {
          // throw some error
          this.unFilteredOperations = [];
        }

        if (response.statusCode == 200) {
          Map<String, dynamic> body = json.decode(response.body);

          if (body['status'] != 'success') {
            // error handling
          } else if (body['status'] == 'success') {
            this.unFilteredOperations =
                _loadOperations(body['data']['operations'] as List);
          }
        }
      } catch (e) {
        print(e);
      }
    }

    await getData(this.filters);
    isLoading = false;
    notifyListeners();
  }

  Future<void> reLoad({@required BuildContext context}) async {
    isLoading = true;
    notifyListeners();
    await loadData(context: context);
  }

  // load the "my operations"
  Future<void> loadMyOperations(
      {@required BuildContext context, @required String userToken}) async {
    // till the screen to wait
    isLoading = true;

    Future<void> getData() async {
      // headers
      Map<String, String> headers = {'token': userToken.toString()};

      try {
        var uri = Uri.https(
            AppData().serverName, AppData().apiSec + '/getmyoperations');

        http.Response response =
            await http.get(uri.toString(), headers: headers);
        if (response.statusCode != 200) {
          // throw some error
          this.myOperations = [];
        }

        if (response.statusCode == 200) {
          Map<String, dynamic> body = json.decode(response.body);

          if (body['status'] != 'success') {
            // error handling
          } else if (body['status'] == 'success') {
            this.myOperations =
                _loadOperations(body['data']['operations'] as List);
          }
        }
      } catch (e) {
        print(e);
      }
    }

    await getData();
    isLoading = false;
    notifyListeners();
  }

  List<Operations> _loadOperations(List data) {
    List operations = data.map((item) {
      Operations operation = Operations.fromJson(item);
      // load the object data manually
      var object = operation.objectType;
      if (object == 'Person') {
        operation.object = Person.fromJson(item['object']);
      } else if (object == 'Car') {
        operation.object = Car.fromJson(item['object']);
      } else if (object == 'Accident') {
        operation.object = Accident.fromJson(item['object']);
      } else if (object == 'PersonalBelongings') {
        operation.object = PersonalBelongings.fromJson(item['object']);
      }

      return operation;
    }).toList();

    // updata the photos with server address
    for (int i = 0; i < this.operations.length; i++) {
      List photos = this.operations[i].photos;
      for (int j = 0; j < photos.length; j++) {
        var current = this.operations[i].photos[j];
        this.operations[i].photos[j] = AppData().serverAddressImeges + current;
      }
    }
    return operations;
  }

  // *********************
  // ***** comments *****
  // *********************

  // load the comments
  Future loadComments(
      {@required Operations operation, @required String userToken}) async {
    Future<void> getData() async {
      Map<String, String> temp = {'operationid': operation.id.toString()};

      try {
        var uri = Uri.https(
            AppData().serverName, AppData().apiSec + '/getcomment', temp);

        http.Response response = await http.get(uri.toString());
        if (response.statusCode != 200) {
          // throw some error
          print(response.body);
        }

        if (response.statusCode == 200) {
          Map<String, dynamic> body = json.decode(response.body);

          if (body['status'] != 'success') {
            // error handling
          } else if (body['status'] == 'success') {
            operation.comments = (body['data']['comments'] as List)
                .map((e) => Comment.fromJson(e))
                .toList();
          }
        }
      } catch (e) {
        print(e);
        //throw e;
      }
    }

    await getData();

    notifyListeners();
  }

  Future sendComment(
      {@required Operations operation,
      @required String userToken,
      @required String text}) async {
    // send Comment - return null if success else string error message
    try {
      // headers
      Map<String, String> headers = {
        'token': userToken.toString(),
        "Content-Type": "application/json"
      };
      String body = json.encode({'text': text, "operationid": operation.id});
      http.Response response = await http.post(address + '/sendcomment',
          body: body, headers: headers);

      if (response.statusCode != 201) {
        // throw some error
        Map<String, dynamic> body = json.decode(response.body);

        return body['message'];
      }

      if (response.statusCode == 201) {
        return null;
      }
    } catch (e) {
      print(e);
      return Future.value(e.toString());
    }
    return Future.value('error');
  }
}

class AgeData extends ChangeNotifier {
  List<dynamic> ages;

  void loadData() async {
    Future<void> getData() async {
      try {
        http.Response response = await http.get(address + '/getage');

        if (response.statusCode != 200) {
          // throw some error
        }

        if (response.statusCode == 200) {
          Map<String, dynamic> body = json.decode(response.body);

          if (body['status'] != 'success') {
            // error handling
          } else if (body['status'] == 'success') {
            this.ages = body['data']['age'].map((item) {
              return Age.fromJson(item);
            }).toList();
          }
        }
      } catch (e) {
        print(e);
      }
    }

    await getData();

    notifyListeners();
  }
}

class UserData extends ChangeNotifier {
  // the user currently use the app

  // save the user phone for easy login
  String phone;
  String token;

  Users user;

  Future<bool> checkLoginToken(String token) async {
    // this will check if the token is valid or not

    http.Response response = await http.post(address + '/checklogin',
        headers: {"Content-Type": "application/json", 'token': token});
    if (response.statusCode != 200) {
      // remove the token
      this.token = null;
      notifyListeners();

      // remove the token from the Preferences
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('token', null);
      return false;
    } else {
      // new token
      Map<String, dynamic> body = json.decode(response.body);
      String token = body['data']['token'];
      this.token = token;

      // save it in the Preferences
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('token', token);
    }
    return true;
  }

  Future checkLogin() async {
    // check login if saved
    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
    if (token != null) {
      this.token = token;
      notifyListeners();

      // check the token if valid or not - if not valid the token will be deleted
      checkLoginToken(token);
    }
  }

  Future<String> login(phone, password, selectedCountryId) async {
    Future<String> getData() async {
      // return null if success else erroe massege
      try {
        String body = json.encode({
          'phone': phone,
          'password': password,
          'country_id': selectedCountryId
        });
        http.Response response = await http.post(address + '/login',
            body: body, headers: {"Content-Type": "application/json"});

        if (response.statusCode != 200) {
          // throw some error
          Map<String, dynamic> body = json.decode(response.body);

          return body['message'];
        }

        if (response.statusCode == 200) {
          Map<String, dynamic> body = json.decode(response.body);

          if (body['status'] != 'success') {
            // error handling
          } else if (body['status'] == 'success') {
            this.token = body['data']['token'];
            this.phone = phone;
            // load the user data
            loadUserdata();

            // save the token
            final prefs = await SharedPreferences.getInstance();
            prefs.setString('token', this.token);

            return null;
          }
        }
      } catch (e) {
        return e.toString();
      }
      return null;
    }

    String result = await getData();
    notifyListeners();
    return result;
  }

  Future<String> register(phone, password, selectedCountryId) async {
    Future<String> getData() async {
      // return null if success else erroe massege
      try {
        String body = json.encode({
          'phone': phone,
          'password': password,
          'country_id': selectedCountryId
        });
        http.Response response = await http.post(address + '/registeruser',
            body: body, headers: {"Content-Type": "application/json"});

        Map<String, dynamic> resultBody = json.decode(response.body);

        if (response.statusCode != 201) {
          // throw some error
          return resultBody['message'];
        }

        if (response.statusCode == 201) {
          if (resultBody['status'] != 'success') {
            // error handling
          } else if (resultBody['status'] == 'success') {
            this.token = resultBody['data']['token'];
            this.phone = phone;
            // load the user data
            loadUserdata();
            notifyListeners();
            return null;
          }
        }
      } catch (e) {
        return e.toString();
      }
      return null;
    }

    String result = await getData();

    return result;
  }

  Future<String> forgotPassword(phone, selectedCountryId) async {
    Future<String> getData() async {
      // return null if success else erroe massege
      try {
        String body =
            json.encode({'phone': phone, 'country_id': selectedCountryId});
        http.Response response = await http.post(address + '/forgotpassword',
            body: body, headers: {"Content-Type": "application/json"});

        if (response.statusCode != 200) {
          // throw some error
          Map<String, dynamic> body = json.decode(response.body);

          return body['message'];
        }

        if (response.statusCode == 200) {
          Map<String, dynamic> body = json.decode(response.body);

          if (body['status'] != 'success') {
            // error handling
          } else if (body['status'] == 'success') {
            return null;
          }
        }
      } catch (e) {
        return e.toString();
      }
      return null;
    }

    String result = await getData();

    return result;
  }

  Future<String> resetPassword(phone, code, selectedCountryId, password) async {
    Future<String> getData() async {
      // return null if success else erroe massege
      try {
        String body = json.encode({
          'phone': phone,
          'country_id': selectedCountryId,
          'code': code,
          'password': password
        });
        http.Response response = await http.post(address + '/resetpassword',
            body: body, headers: {"Content-Type": "application/json"});

        if (response.statusCode != 200) {
          // throw some error
          Map<String, dynamic> body = json.decode(response.body);

          return body['message'];
        }

        if (response.statusCode == 200) {
          Map<String, dynamic> body = json.decode(response.body);

          if (body['status'] != 'success') {
            // error handling
          } else if (body['status'] == 'success') {
            return null;
          }
        }
      } catch (e) {
        return e.toString();
      }
      return null;
    }

    String result = await getData();

    return result;
  }

  void logut() {
    // logut the user
    this.token = null;
    this.user = null;
    Future clear() async {
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('token', null);
    }

    clear();
    notifyListeners();
  }

  Future<void> loadUserdata() async {
    try {
      String body = json.encode({
        'phone': this.phone,
      });
      http.Response response = await http.post(address + '/getuser',
          body: body, headers: {"Content-Type": "application/json"});

      if (response.statusCode != 200) {
        // throw some error
      }

      if (response.statusCode == 200) {
        Map<String, dynamic> body = json.decode(response.body);

        if (body['status'] != 'success') {
          // error handling
        } else if (body['status'] == 'success') {
          this.user = (body['data']['user'] as List)
              .map((u) => Users.fromJson((u as Map<String, dynamic>)))
              .toList()[0];
        }
      }
    } catch (e) {
      print(e);
    }
  }
}

class UserStatusData extends ChangeNotifier {
  List<dynamic> userStatus;

  void loadData() async {
    Future<void> getData() async {
      try {
        http.Response response = await http.get(address + '/getstatus');

        if (response.statusCode != 200) {
          // throw some error
        }

        if (response.statusCode == 200) {
          Map<String, dynamic> body = json.decode(response.body);

          if (body['status'] != 'success') {
            // error handling
          } else if (body['status'] == 'success') {
            this.userStatus = body['data']['status'].map((item) {
              return Status.fromJson(item);
            }).toList();
          }
        }
      } catch (e) {
        print(e);
      }
    }

    await getData();

    notifyListeners();
  }
}

class UserPermissionData extends ChangeNotifier {
  List<dynamic> userPermission;

  void loadData() async {
    Future<void> getData() async {
      try {
        http.Response response = await http.get(address + '/getpermission');

        if (response.statusCode != 200) {
          // throw some error
        }

        if (response.statusCode == 200) {
          Map<String, dynamic> body = json.decode(response.body);

          if (body['status'] != 'success') {
            // error handling
          } else if (body['status'] == 'success') {
            this.userPermission = body['data']['permission'].map((item) {
              return Permission.fromJson(item);
            }).toList();
          }
        }
      } catch (e) {
        print(e);
      }
    }

    await getData();

    notifyListeners();
  }
}

class PostData extends ChangeNotifier {
  // this class for posting new data

  Future<String> addOperation(
      Map<dynamic, dynamic> passedData, String userToken) async {
    // add new operation through post api
    // return null if add correctly - return error massege if any

    // create local copy from the data
    Map<dynamic, dynamic> data = Map<dynamic, dynamic>()..addAll(passedData);

    List photos = data['photos'];
    data.remove('photos');

    if (data['location'] != null) {
      data['lat'] = data['location']['lat'];
      data['lng'] = data['location']['lng'];
      data.remove('location');
    }

    // any field with value null will be deleted
    data.removeWhere((key, value) => value == null);

    // convarte all values to string
    data.updateAll((key, value) => value.toString());
    data = Map<String, String>.from(data);

    try {
      // headers
      Map<String, String> headers = {'token': userToken.toString()};

      var uri =
          Uri.https(AppData().serverName, AppData().apiSec + '/addoperation');
      var request = http.MultipartRequest('POST', uri);
      request.fields.addAll(data);

      photos.map((file) {
        request.files.add(http.MultipartFile.fromBytes(
            'photos', file.readAsBytesSync(),
            filename: basename(file.path)));
      }).toList();

      request.headers.addAll(headers);

      var response = await request.send();
      //print(utf8.decode(await response.stream.toBytes()));

      Map<String, dynamic> body =
          json.decode(utf8.decode(await response.stream.toBytes()));

      if (response.statusCode != 201) {
        // throw some error
        return body['message'];
      }

      if (response.statusCode == 201) {
        // success

        return null;
      }
    } catch (e) {
      print(e);
      return e.toString();
    }
    return 'error in code';
  }

  Future<String> addFeedBack(String text, {String userToken}) async {
    // send feedback - return null if success else string error message
    try {
      // headers
      Map<String, String> headers = {
        'token': userToken.toString(),
        "Content-Type": "application/json"
      };
      String body = json.encode({'feedback': text});
      http.Response response = await http.post(address + '/addfeedback',
          body: body, headers: headers);

      if (response.statusCode != 201) {
        // throw some error
        Map<String, dynamic> body = json.decode(response.body);

        return body['message'];
      }

      if (response.statusCode == 201) {
        return null;
      }
    } catch (e) {
      print(e);
      return Future.value(e.toString());
    }
    return Future.value('error');
  }
}

class AppSettings extends ChangeNotifier {
  Locale selectedLanguage;

  // this determine the selected object (like person, cars , etc)
  Map availableObjects = {
    'Accident': 'menu_accident',
    'Person': 'menu_people',
    'Car': 'menu_cars',
    'PersonalBelongings': 'menu_PersonalBelongings'
  };
  String selectedObject = 'Accident';
  String selectedObjectString;

  // main screen(Home) snkebar - if have value then the home page will show snakbar
  String homeSnakeBar;

  // person available skin colors (image - name)
  List<List> skins;

  // person available genders
  Map availableGenders = {'male': 'gender_male', "female": "gender_female"};

  // car available types (Emoji - name)
  List<List> cars;

  // available types of 'PersonalBelongings' object
  // its list of list [name of type, [list of its subtype if any]]
  List<List> availablePersonalBelongingsTypes;

  AppSettings() {
    this.selectedObjectString = availableObjects[this.selectedObject];

    Future<void> load() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String language = prefs.getString('language');
      if (language != null) {
        selectedLanguage = Locale(language);
      } else {
        // no language selected - default is Arabic
        selectedLanguage = Locale('ar');
      }
    }

    load();

    skins = [
      ['1.png', 'skin_light'],
      ['2.png', 'skin_mediumLight'],
      ['3.png', 'skin_medium'],
      ['4.png', 'skin_mediumDark'],
      ['5.png', 'skin_dark']
    ];

    cars = [
      [Emoji.byChar(Emojis.automobile), 'light'],
      [Emoji.byChar(Emojis.tramCar), 'mediumLight'],
      [Emoji.byChar(Emojis.minibus), 'medium'],
    ];

    availablePersonalBelongingsTypes = [
      [
        'BelongingsTypes_wallet',
        [
          'BelongingsTypes_wallet_subtype_id',
          'BelongingsTypes_wallet_subtype_passport',
          'BelongingsTypes_wallet_subtype_drivingLicense',
          'BelongingsTypes_wallet_subtype_visa'
        ]
      ],
      ['BelongingsTypes_mobile', []],
      ['BelongingsTypes_bag', []],
      ['BelongingsTypes_papers', []],
      ['BelongingsTypes_other', []],
    ];
  }

  Future<void> changeLanguage(String language) async {
    selectedLanguage = Locale(language);

    final prefs = await SharedPreferences.getInstance();
    // set value
    prefs.setString('language', language);
    notifyListeners();
  }

  changeObject(String newObject) {
    this.selectedObject = newObject;
    this.selectedObjectString = availableObjects[newObject];
    notifyListeners();
  }

  setHomeSnakeBar(String value) {
    this.homeSnakeBar = value;
    notifyListeners();
  }

  clearHomeSnakeBar() {
    this.homeSnakeBar = null;
  }
}
