import 'package:flutter/material.dart';

import 'package:flutter_form_builder/flutter_form_builder.dart';

// use json
import 'dart:convert';

//language support
import 'package:lost/app_localizations.dart';

// the forms
import 'package:lost/pages/forms/car_form.dart';
import 'package:lost/pages/forms/person_form.dart';

class FormAccident extends StatefulWidget {
  final GlobalKey<FormBuilderState> formKey;

  final Map data;

  FormAccident({this.formKey, this.data});

  @override
  _FormAccidentState createState() => _FormAccidentState();
}

class _FormAccidentState extends State<FormAccident> {
  List<Widget> cars = [];
  List<GlobalKey<FormBuilderState>> carsFormsKeys = [];

  List<Widget> persons = [];
  List<GlobalKey<FormBuilderState>> personsFormsKeys = [];

  void collectData() {
    // collect the data from the forms and put it in the main form as json

    // delete the main form data
    widget.formKey.currentState.fields['cars'].reset();
    widget.formKey.currentState.fields['persons'].reset();

    if (carsFormsKeys.isEmpty && personsFormsKeys.isEmpty) {
      // no cars and no persons added
      return;
    }

    for (int i = 0, l = carsFormsKeys.length; i < l; i++) {
      // check if the forms is ready for submit
      if (!carsFormsKeys[i].currentState.saveAndValidate()) {
        return;
      }
    }

    // the persons forms
    for (int i = 0, l = personsFormsKeys.length; i < l; i++) {
      // check if the forms is ready for submit
      if (!personsFormsKeys[i].currentState.saveAndValidate()) {
        return;
      }
    }

    // collect the data and convarte it to json and save it to the main form
    //
    // cars
    List<Map> carsData = [];
    for (int i = 0, l = carsFormsKeys.length; i < l; i++) {
      Map value = carsFormsKeys[i].currentState.value;
      carsData.add(value);
    }
    // persons
    List<Map> personsData = [];
    for (int i = 0, l = personsFormsKeys.length; i < l; i++) {
      Map value = personsFormsKeys[i].currentState.value;
      personsData.add(value);
    }

    // save it as json

    widget.formKey.currentState.fields['cars'].setValue(jsonEncode(carsData));
    widget.formKey.currentState.fields['persons']
        .setValue(jsonEncode(personsData));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
            // title
            Text(
              AppLocalizations.of(context).translate('accidentForm_details'),
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
            ),
            SizedBox(
              height: 15,
            ),
            // cars title
            Text(
              AppLocalizations.of(context).translate('accidentForm_cars'),
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            SizedBox(
              height: 15,
            ),
          ] +
          cars.map((e) {
            int index = cars.indexOf(e);
            return ExpansionTile(
              maintainState: true,
              initiallyExpanded: true,
              title: Text(
                  AppLocalizations.of(context).translate('accidentForm_car') +
                      ' ${index + 1}',
                  style: TextStyle(color: Colors.black)),
              trailing:
                  // RaisedButton(
                  ElevatedButton(

                      // style: ButtonStyle(
                      // shape: CircleBorder(),
                      // foregroundColor: Colors.red,

                      // ),
                      child: Icon(Icons.delete, color: Colors.white),
                      onPressed: () {
                        setState(() {
                          carsFormsKeys.removeAt(index);
                          cars.removeAt(index);
                        });
                      }),
              children: [e],
            );
          }).toList() +
          [
            SizedBox(
              height: 15,
            ),
            // add car
            RaisedButton(
                color: Colors.green,
                child: Text(
                    AppLocalizations.of(context).translate('accidentForm_add'),
                    style: TextStyle(
                      color: Colors.white,
                    )),
                onPressed: () {
                  setState(() {
                    GlobalKey<FormBuilderState> key =
                        GlobalKey<FormBuilderState>();
                    carsFormsKeys.add(key);
                    cars.add(formCar(context, key, widget.data,
                        onChange: collectData));
                  });
                }),
            Divider(),
            Text(
              AppLocalizations.of(context).translate('accidentForm_persons'),
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            SizedBox(
              height: 15,
            ),
          ] +
          persons.map((e) {
            int index = persons.indexOf(e);
            return ExpansionTile(
              initiallyExpanded: true,
              maintainState: true,
              title: Text(
                  AppLocalizations.of(context)
                          .translate('accidentForm_person') +
                      ' ${index + 1}',
                  style: TextStyle(color: Colors.black)),
              trailing: RaisedButton(
                  shape: CircleBorder(),
                  color: Colors.red,
                  child: Icon(Icons.delete, color: Colors.white),
                  onPressed: () {
                    setState(() {
                      personsFormsKeys.removeAt(index);
                      persons.removeAt(index);
                    });
                  }),
              children: [e],
            );
          }).toList() +
          [
            SizedBox(
              height: 15,
            ),
            // add persons
            RaisedButton(
                color: Colors.green,
                child: Text(
                    AppLocalizations.of(context).translate('accidentForm_add'),
                    style: TextStyle(
                      color: Colors.white,
                    )),
                onPressed: () {
                  setState(() {
                    GlobalKey<FormBuilderState> key =
                        GlobalKey<FormBuilderState>();
                    personsFormsKeys.add(key);
                    persons.add(formPerson(context, key, widget.data,
                        onChange: collectData));
                  });
                }),

            // not visble form with the main form key
            // this will control the submit to the main form
            FormBuilder(
              key: widget.formKey,
              child: Column(
                children: [
                  // cars json
                  Offstage(
                    offstage: true,
                    child: FormBuilderTextField(
                        name: 'cars',
                        validator: (val) {
                          if (val == null || val == '') {
                            // the other field must not be null
                            var other = widget
                                .formKey.currentState.fields['persons'].value;
                            if (other == null || other == '') {
                              return 'error';
                            }
                          }

                          return null;
                        }),
                  ),
                  // persons json
                  Offstage(
                    offstage: true,
                    child: FormBuilderTextField(
                        name: 'persons',
                        validator: (val) {
                          if (val == null || val == '') {
                            // the other field must not be null
                            var other = widget
                                .formKey.currentState.fields['cars'].value;
                            if (other == null || other == '') {
                              return 'error';
                            }
                          }

                          return null;
                        }),
                  ),
                  //details
                  Container(
                    height: 200,
                    width: double.infinity,
                    child: FormBuilderTextField(
                      maxLines: 8,
                      name: 'details',
                      //initialValue: data['details'] ?? null,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.greenAccent, width: 0.8),
                          //borderRadius: BorderRadius.circular(18.0),
                        ),
                        labelText: AppLocalizations.of(context)
                            .translate('operatioForm_details'),
                        alignLabelWithHint: true,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
    );
  }
}
