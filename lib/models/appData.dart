/*
this the main state model of the app data

*/

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'operation.dart';

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

  final serverName = '192.168.56.1:8080';
  final apiSec = '/api';

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
