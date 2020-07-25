import 'package:flutter/material.dart';

import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';

import 'package:lost/models/appData.dart';

import 'package:provider/provider.dart';

Widget operatioForm(BuildContext context, _fbKey, typeOperation) {
  // the ages ranges
  List ages = Provider.of<AgeData>(context, listen: true).ages;

  // data needed to post from provider

  Map<String, String> envData = {
    'type_id': typeOperation.id.toString(),
    'country_id': Provider.of<CountryData>(context, listen: false)
        .selectedCountry
        .id
        .toString(),
    'object_type':
        Provider.of<AppData>(context, listen: false).selectedObject.toString()
  };

  // the current logged in user
  String userToken = Provider.of<UserData>(context, listen: false).token;

  // current time
  DateTime now = new DateTime.now();
  // this help make the date with the correct format
  var formatter = new DateFormat('yyyy-MM-dd');

  return SingleChildScrollView(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Center(
            child: Text(
              typeOperation.name,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24.0,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: FormBuilder(
            key: _fbKey,
            autovalidate: true,
            child: Column(
              children: <Widget>[
                FormBuilderDateTimePicker(
                  attribute: "date",
                  initialValue: now,
                  inputType: InputType.date,
                  format: DateFormat('y-MM-dd'),
                  lastDate: now,
                  decoration: InputDecoration(labelText: "Date"),
                  validators: [
                    FormBuilderValidators.required(),
                  ],
                  valueTransformer: (value) {
                    if (value != null) {
                      return formatter.format(value);
                    }
                    return value;
                  },
                ),
                FormBuilderTextField(
                  attribute: "person_name",
                  decoration: InputDecoration(labelText: "name"),
                ),
                FormBuilderDropdown(
                  attribute: "age_id",
                  decoration: InputDecoration(labelText: "Age"),
                  hint: Text('Select Age Range'),
                  validators: [
                    FormBuilderValidators.required(),
                  ],
                  items: ages
                      .map((age) => DropdownMenuItem(
                          value: age.id,
                          child: Text("${age.minAge} - ${age.maxAge}")))
                      .toList(),
                ),
                FormBuilderImagePicker(
                  labelText: "photos:",
                  maxImages: 5,
                  attribute: "photos",
                ),
              ],
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            MaterialButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
              ),
              color: Theme.of(context).primaryColor,
              child: Text(
                "Submit",
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                if (_fbKey.currentState.saveAndValidate()) {
                  //print(_fbKey.currentState.value);

                  // add the env data
                  Map data = {};
                  data.addAll(_fbKey.currentState.value);
                  data.addAll(envData);

                  Provider.of<PostData>(context, listen: false)
                      .addOperation(data, userToken)
                      .then((value) {
                    if (value != null) {
                      print(value);
                    } else {
                      Navigator.of(context).pop();
                    }
                  });
                }
              },
            ),
            MaterialButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                  side: BorderSide(color: Colors.red)),
              color: Colors.red,
              child: Text(
                "Cancel",
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                //_fbKey.currentState.reset();
                Navigator.pop(context);
              },
            ),
          ],
        )
      ],
    ),
  );
}
