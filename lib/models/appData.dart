/*
this the main state model of the app data

*/

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'operation.dart';
import 'person.dart';

import 'package:path/path.dart';

String address = AppData().serverAddress;

class CountryData extends ChangeNotifier {
// countries available

  List<dynamic> countries;

  // the slected country now .. this will go as a filter for operation selecting
  Country selectedCountry;

  void loadData() async {
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
    }

    await getData();

    // make the selected country the first country (this will change later)
    selectedCountry = countries[0];

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
  final serverAddress = 'http://192.168.56.1:8080/api';
  final serverAddressImeges = 'http://192.168.56.1:8080/';

  final serverName = '192.168.56.1:8080';
  final apiSec = '/api';

  // this will contain the availabl objects that the app can handel . like(person - car - wallet)
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
        var uri = Uri.http(
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

  Future<bool> login(phone, password) async {
    Future<bool> getData() async {
      try {
        String body = json.encode({'phone': phone, 'password': password});
        http.Response response = await http.post(address + '/login',
            body: body, headers: {"Content-Type": "application/json"});

        if (response.statusCode != 200) {
          // throw some error
          Map<String, dynamic> body = json.decode(response.body);
          print(body['message']);
          return false;
        }

        if (response.statusCode == 200) {
          Map<String, dynamic> body = json.decode(response.body);

          if (body['status'] != 'success') {
            // error handling
          } else if (body['status'] == 'success') {
            this.token = body['data']['token'];
            this.phone = phone;
            return true;
          }
        }
      } catch (e) {
        print(e);
        return false;
      }
      return false;
    }

    bool result = await getData();
    notifyListeners();
    return result;
  }

  void logut() {
    // logut the user
    this.token = null;
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

    // print(photos.length);
    // print(photos);
    // return '';

    data.updateAll((key, value) => value.toString());
    data = Map<String, String>.from(data);

    try {
      // headers
      Map<String, String> headers = {'token': userToken.toString()};

      var uri =
          Uri.http(AppData().serverName, AppData().apiSec + '/addoperation');
      var request = http.MultipartRequest('POST', uri);
      request.fields.addAll(data);

      photos.map((file) {
        request.files.add(http.MultipartFile.fromBytes(
            'photos', file.readAsBytesSync(),
            filename: basename(file.path)));
      }).toList();

      request.headers.addAll(headers);

      var response = await request.send();

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
      return 'some error';
    }
    return 'error in code';
  }
}
