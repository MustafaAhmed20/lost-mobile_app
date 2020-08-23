/*
this the main state model of the app data

*/

// the server URL
import 'package:lost/pages/secrets.dart' as urls;

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'operation.dart';
import 'person.dart';
import 'user.dart';

import 'package:path/path.dart';

// storage user preferences
import 'package:shared_preferences/shared_preferences.dart';

String address = AppData().serverAddress;

class CountryData extends ChangeNotifier {
// countries available

  List<dynamic> countries;

  // the slected country now .. this will go as a filter for operation selecting
  Country selectedCountry;

  Future<bool> loadData() async {
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
            countries = body['data']['country'].map((item) {
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
    int countryId = prefs.getInt('countryId');

    if (countryId != null) {
      // set the country
      done.then((value) {
        this.selectedCountry = this.countries.firstWhere(
            (country) => country.id == countryId,
            orElse: () => this.countries[0]);
      });

      return Future<bool>.value(true);
    }
    return Future<bool>.value(false);
  }

  void setCountry(String countryName) async {
    // the user set the slected country
    this.selectedCountry = this.countries.firstWhere(
        (country) => country.name == countryName.toLowerCase(),
        orElse: () => this.countries[0]);
    final prefs = await SharedPreferences.getInstance();
    // set value
    prefs.setInt('countryId', selectedCountry.id);

    notifyListeners();
  }
}

class TypeOperationData extends ChangeNotifier {
// Type Operations available

  List<dynamic> typeOperation;

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

  // this will contain the available objects that the app can handel . like(person - car - wallet)
  static final availableObjectsTypes = ['Person'];

  final selectedObject = availableObjectsTypes[0];

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
  List<dynamic> operations;

  Map<String, String> filters = {};

  OperationData(Map f) {
    f.updateAll((key, value) => value.toString());
    this.filters.addAll(Map<String, String>.from(f));
  }

  void loadData(Map filters) async {
    Future<void> getData(filters) async {
      Map<String, String> temp = this.filters;

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
        }

        if (response.statusCode == 200) {
          Map<String, dynamic> body = json.decode(response.body);

          if (body['status'] != 'success') {
            // error handling
          } else if (body['status'] == 'success') {
            this.operations = body['data']['operations'].map((item) {
              return Operations.fromJson(item);
            }).toList();

            // updata the photos with server address
            for (int i = 0; i < this.operations.length; i++) {
              List photos = this.operations[i].object.photos;
              for (int j = 0; j < photos.length; j++) {
                var current = this.operations[i].object.photos[j];
                this.operations[i].object.photos[j] =
                    AppData().serverAddressImeges + current;
              }
            }
          }
        }
      } catch (e) {
        print(e);
      }
    }

    await getData(filters);

    notifyListeners();
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

  dynamic user;

  Future checkLogin() async {
    // check login if saved
    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
    if (token != null) {
      this.token = token;
      notifyListeners();
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
          this.user = body['data']['user'].map((item) {
            return Users.fromJson(item);
          }).toList()[0];
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

  Future<String> addOperation(Map data, String userToken) async {
    // add new operation through post api
    // return null if add correctly - return error massege if any

    List photos = data['photos'];
    data.remove('photos');

    if (data['location'] != null) {
      data['lat'] = data['location']['lat'];
      data['lng'] = data['location']['lng'];
      data.remove('location');
    }

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

  AppSettings() {
    Future<void> load() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String language = prefs.getString('language');
      if (language != null) {
        selectedLanguage = Locale(language);
      } else {
        // no language selected
        selectedLanguage = Locale('en');
      }
    }

    load();
  }

  Future<void> changeLanguage(String language) async {
    selectedLanguage = Locale(language);

    final prefs = await SharedPreferences.getInstance();
    // set value
    prefs.setString('language', language);
    notifyListeners();
  }
}
