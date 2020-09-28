import 'package:flutter/material.dart';

import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';

import 'package:lost/models/appData.dart';

import 'package:provider/provider.dart';

// check Gps func
import 'package:lost/pages/googlemap.dart';
//language support
import 'package:lost/app_localizations.dart';

import 'wait.dart';

// validation
import 'validators.dart';

// use json
import 'dart:convert';

class OperatioForm extends StatefulWidget {
  // if object selected is accident
  final bool accident;
  OperatioForm({this.accident});

  @override
  _OperatioFormState createState() => _OperatioFormState();
}

class _OperatioFormState extends State<OperatioForm> {
  // forms key
  GlobalKey<FormBuilderState> _form0;
  GlobalKey<FormBuilderState> _form1;
  GlobalKey<FormBuilderState> _form2;
  GlobalKey<FormBuilderState> _form3;

  // make list of the forms keys to access it with 'stage' integer
  List<GlobalKey<FormBuilderState>> formsKeys;

  // stage - this integer will help the form be like stages
  int stage = 0;

  // bool wait for uploading - true mean wait
  bool formWait = false;

  //the summation of the forms data
  Map data;

  // data needed to post from provider
  Map<String, String> envData;

  @override
  void initState() {
    super.initState();

    _form0 = GlobalKey<FormBuilderState>();
    _form1 = GlobalKey<FormBuilderState>();
    _form2 = GlobalKey<FormBuilderState>();
    _form3 = GlobalKey<FormBuilderState>();

    formsKeys = [_form0, _form1, _form2, _form3];

    data = {};

    // the accident form only use two forms
    if (widget.accident) {
      stage = 2;
    }

    // data needed to post from provider
    envData = {
      'country_id': Provider.of<CountryData>(context, listen: false)
          .selectedCountry
          .id
          .toString(),
    };

    if (widget.accident) {
      // the default data unique to 'Accident' object
      envData.addAll({
        'object_type': Provider.of<AppSettings>(context, listen: false)
            .selectedObject
            .toString(),
        // not important field - just put the first in the list
        'type_id': Provider.of<TypeOperationData>(context, listen: false)
            .typeOperation[0]
            .id
            .toString(),
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // the current logged in user
    String userToken = Provider.of<UserData>(context, listen: false).token;

    List<Step> steps = [
      Step(
        title: SizedBox.shrink(),
        isActive: stage == 0,
        state: stage > 0 ? StepState.complete : StepState.indexed,
        content: Container(
            decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(25)),
            padding: EdgeInsets.all(8),
            margin: EdgeInsets.only(top: 60),
            child: form0(context, formsKeys[0], data)),
      ),
      Step(
        title: SizedBox.shrink(),
        isActive: stage == 1,
        state: stage > 1 ? StepState.complete : StepState.indexed,
        content: Container(
            padding: EdgeInsets.all(8),
            margin: EdgeInsets.only(top: 60),
            decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(25)),
            child: form1(context, formsKeys[1], data)),
      ),
      Step(
        title: SizedBox.shrink(),
        isActive: stage == 2,
        state: stage > 2 ? StepState.complete : StepState.indexed,
        content: Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(25)),
            child: form2(context, formsKeys[2], data)),
      ),
      Step(
        title: SizedBox.shrink(),
        isActive: stage == 3,
        state: stage > 3 ? StepState.complete : StepState.indexed,
        content: Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(25)),
            child:
                chooseObjectForm(context, formsKeys[3], data, widget.accident)),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
          leading: FlatButton(
        child: Icon(Icons.close, color: Colors.white),
        onPressed: () {
          Navigator.of(context).pop();
        },
      )),
      body: Stepper(
        type: StepperType.horizontal,
        currentStep: stage,
        steps: steps,
        onStepContinue: () {
          setState(() {
            stage += 1;
          });
        },
        onStepCancel: () {
          if (widget.accident && stage == 2) {
            // don't back from stage 3(index 2)
            Navigator.pop(context);
          }

          if (stage > 0) {
            setState(() {
              stage -= 1;
            });
          } else {
            Navigator.pop(context);
          }
        },
        controlsBuilder: (context,
            {VoidCallback onStepContinue, VoidCallback onStepCancel}) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              // wait
              formWait ? wait(context) : SizedBox.shrink(),
              // Submit
              Expanded(
                child: formWait
                    ? SizedBox.shrink()
                    : MaterialButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                        ),
                        color: Theme.of(context).primaryColor,
                        child: Text(
                          AppLocalizations.of(context)
                              .translate('operatioForm_Submit'),
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () {
                          var formKey = formsKeys[stage];
                          // validate the currnt form
                          if (formKey.currentState.saveAndValidate()) {
                            // valid state form

                            // add the form data to the global data var
                            data.addAll(formKey.currentState.value);

                            if (stage < 3) {
                              // mean the form stages not completed
                              onStepContinue();
                              return;
                            }

                            // now done with the forms
                            // send the form

                            //disable the button and wait
                            setState(() {
                              formWait = true;
                            });

                            // add the env data
                            data.addAll(envData);

                            try {
                              Provider.of<PostData>(context, listen: false)
                                  .addOperation(data, userToken)
                                  .then((value) {
                                // stop waiting
                                setState(() {
                                  formWait = false;
                                });
                                if (value != null) {
                                  print(value);
                                } else {
                                  Navigator.of(context).pop();
                                }
                              });
                            } catch (e) {
                              // stop waiting
                              setState(() {
                                formWait = false;
                              });
                              throw e;
                            }
                          }
                        },
                      ),
              ),
              // cancel
              Expanded(
                child: formWait
                    ? SizedBox.shrink()
                    : MaterialButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                            side: BorderSide(color: Colors.red)),
                        color: Colors.red,
                        child: Text(
                          AppLocalizations.of(context)
                              .translate('operatioForm_Cancel'),
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () {
                          //_fbKey.currentState.reset();
                          onStepCancel();
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}

Widget chooseObjectForm(context, formKey, data, accident) {
  String object = data['object_type'] ?? '';
  if (accident) {
    // accident form
    return FormAccident(formKey: formKey);
  } else if (object == 'Person') {
    return formPerson(context, formKey);
  } else if (object == 'Car') {
    return formCar(context, formKey);
  }

  // default form if the user not select a form yet
  return formPerson(context, formKey);
}

Widget formPerson(context, formKey, {Function onChange}) {
  // the ages ranges - for 'person' object
  List ages = Provider.of<AgeData>(context, listen: false).ages;

  // the emoji used - get it from provider
  List skins = Provider.of<AppSettings>(context, listen: false).skins;

  // list of genders
  Map genders =
      Provider.of<AppSettings>(context, listen: false).availableGenders;

  return FormBuilder(
    onChanged: onChange != null ? (val) => onChange() : null,
    key: formKey,
    autovalidate: true,
    child: Column(children: [
      // person Details
      Text(
        AppLocalizations.of(context).translate('personForm_operatioDetails'),
        style: TextStyle(fontSize: 20),
      ),
      // name
      FormBuilderTextField(
        attribute: "person_name",
        decoration: InputDecoration(
            labelText:
                AppLocalizations.of(context).translate('operatioForm_name')),
      ),
      // gender
      FormBuilderRadioGroup(
        activeColor: Colors.blue,
        orientation: GroupedRadioOrientation.vertical,
        attribute: "gender",
        decoration: InputDecoration(
          labelText:
              AppLocalizations.of(context).translate('personForm_gender'),
        ),
        validators: [
          FormBuilderValidators.required(
              errorText: AppLocalizations.of(context)
                  .translate('operatioForm_requiredError')),
        ],
        options: genders.keys
            .map((sex) => FormBuilderFieldOption(
                  value: sex,
                  child: Text(
                      AppLocalizations.of(context).translate(genders[sex])),
                ))
            .toList(),
      ),
      // age
      FormBuilderDropdown(
        attribute: "age_id",
        decoration: InputDecoration(
            labelText:
                AppLocalizations.of(context).translate('operatioForm_age')),
        hint: Text(
            AppLocalizations.of(context).translate('operatioForm_AgeRange')),
        validators: [
          FormBuilderValidators.required(
              errorText: AppLocalizations.of(context)
                  .translate('operatioForm_requiredError')),
        ],
        items: ages
            .map((age) => DropdownMenuItem(
                value: age.id, child: Text("${age.minAge} - ${age.maxAge}")))
            .toList(),
      ),
      // skin color
      FormBuilderDropdown(
        attribute: "skin",
        decoration: InputDecoration(
          labelText: AppLocalizations.of(context).translate('personForm_skin'),
        ),
        hint: Text(
            AppLocalizations.of(context).translate('personForm_skinApprox')),
        items: skins
            .map((skin) => DropdownMenuItem(
                value: skins.indexOf(skin) + 1,
                child: Row(
                  children: [
                    Image.asset(
                      'imeges/person/${skin[0]}',
                      width: 50,
                    ),
                    Text(
                      AppLocalizations.of(context).translate(skin[1]),
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                )))
            .toList(),
      ),
    ]),
  );
}

Widget formCar(context, formKey, {Function onChange}) {
  // the emoji used - get it from provider
  List cars = Provider.of<AppSettings>(context, listen: false).cars;
  return FormBuilder(
    onChanged: onChange != null ? (val) => onChange() : null,
    key: formKey,
    autovalidate: true,
    child: Column(children: [
      // car Details
      Text(
        AppLocalizations.of(context).translate('carForm_operatioDetails'),
        style: TextStyle(fontSize: 20),
      ),
      // Brand
      FormBuilderTextField(
        attribute: "brand",
        decoration: InputDecoration(
            labelText: AppLocalizations.of(context).translate('carForm_brand')),
        validators: [
          FormBuilderValidators.required(
              errorText: AppLocalizations.of(context)
                  .translate('operatioForm_requiredError')),
        ],
      ),
      // Modle
      FormBuilderTextField(
        attribute: "model",
        decoration: InputDecoration(
            labelText: AppLocalizations.of(context).translate('carForm_model')),
        validators: [
          FormBuilderValidators.required(
              errorText: AppLocalizations.of(context)
                  .translate('operatioForm_requiredError')),
        ],
      ),
      // type - this field not used now
      Offstage(
        offstage: true,
        child: FormBuilderDropdown(
            attribute: "car_type",
            initialValue: 1,
            decoration: InputDecoration(
              labelText: AppLocalizations.of(context).translate('carForm_type'),
            ),
            hint: Text(AppLocalizations.of(context).translate('carForm_type')),
            validators: [
              FormBuilderValidators.required(
                  errorText: AppLocalizations.of(context)
                      .translate('operatioForm_requiredError')),
            ],
            items: []
            //cars
            //     .map((type) => DropdownMenuItem(
            //         value: cars.indexOf(type) + 1,
            //         child: Text(
            //           '${type[0]} ${type[1]}',
            //           style: TextStyle(fontSize: 20),
            //         )))
            //     .toList(),
            ),
      ),

      // plate number
      Padding(
        padding: const EdgeInsets.only(top: 20, bottom: 10),
        child: Text(
          AppLocalizations.of(context).translate('carForm_plate'),
          style: TextStyle(fontSize: 16),
        ),
      ),
      Row(
        children: [
          // plate number - letters
          Expanded(
            child: FormBuilderTextField(
              attribute: "plate_number_letters",
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)
                    .translate('carForm_plateLetters'),
                labelStyle: TextStyle(
                  letterSpacing: 1.0,
                ),
              ),
              style: TextStyle(
                letterSpacing: 4.0,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              validators: [
                FormBuilderValidators.required(
                    errorText: AppLocalizations.of(context)
                        .translate('operatioForm_requiredError')),
                // validate the value
                (val) {
                  return validatPlateNumberLetters(context, val);
                },
              ],
            ),
          ),
          // plate number - numbers
          Expanded(
            child: FormBuilderTextField(
              attribute: "plate_number_numbers",
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)
                    .translate('carForm_plateNumbers'),
                labelStyle: TextStyle(
                  letterSpacing: 1.0,
                ),
              ),
              style: TextStyle(
                letterSpacing: 7.0,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              validators: [
                FormBuilderValidators.required(
                    errorText: AppLocalizations.of(context)
                        .translate('operatioForm_requiredError')),
                // validate the value
                (val) {
                  return validatPlateNumberNumbers(context, val);
                },
              ],
            ),
          )
        ],
      ),
    ]),
  );
}

Widget form0(context, formKey, data) {
  // the types of operations
  List typeOperation =
      Provider.of<TypeOperationData>(context, listen: false).typeOperation;
  // opeation type translator
  Map names = Provider.of<TypeOperationData>(context, listen: false).names;
  return FormBuilder(
    key: formKey,
    autovalidate: true,
    child: Column(
      children: [
        Text(
          AppLocalizations.of(context).translate('typeOperation'),
          style: TextStyle(fontSize: 20),
        ),
        // stage 0 - the type of operation
        Padding(
          padding: EdgeInsets.all(8.0),
          child: FormBuilderChoiceChip(
            attribute: "type_id",
            initialValue: data['type_id'] ?? null,
            direction: Axis.vertical,
            shape: RoundedRectangleBorder(),
            validators: [
              FormBuilderValidators.required(
                errorText: AppLocalizations.of(context)
                    .translate('operatioForm_requiredError'),
              )
            ],
            options: typeOperation
                .map((type) => FormBuilderFieldOption(
                    value: type.id,
                    child: Text(
                      "${AppLocalizations.of(context).translate(names[type.name])}",
                      style: TextStyle(fontSize: 18),
                    )))
                .toList(),
          ),
        ),
      ],
    ),
  );
}

Widget form1(context, formKey, data) {
  // the list of available objects
  Map objects =
      Provider.of<AppSettings>(context, listen: false).availableObjects;
  // remove 'Accident object'
  objects.remove('Accident');

  return FormBuilder(
    key: formKey,
    autovalidate: true,
    child: Column(
      children: [
        Text(
          AppLocalizations.of(context).translate('typeObject'),
          style: TextStyle(fontSize: 20),
        ),
        // stage 1 - the object type
        FormBuilderChoiceChip(
          attribute: "object_type",
          initialValue: data['object_type'] ?? null,
          direction: Axis.vertical,
          shape: RoundedRectangleBorder(),
          validators: [
            FormBuilderValidators.required(
              errorText: AppLocalizations.of(context)
                  .translate('operatioForm_requiredError'),
            )
          ],
          options: objects.keys
              .map((object) => FormBuilderFieldOption(
                  value: object,
                  child: Text(
                    AppLocalizations.of(context).translate(objects[object]),
                    style: TextStyle(fontSize: 18),
                  )))
              .toList(),
        ),
      ],
    ),
  );
}

Widget form2(context, formKey, data) {
  // current time
  DateTime now = new DateTime.now();

  // this help make the date with the correct format
  var formatter = new DateFormat('yyyy-MM-dd');
  return FormBuilder(
    key: formKey,
    autovalidate: true,
    child: Column(
      children: [
        Text(
          AppLocalizations.of(context)
              .translate('operatioForm_operatioDetails'),
          style: TextStyle(fontSize: 20),
        ),
        // date
        FormBuilderDateTimePicker(
          attribute: "date",
          initialValue:
              data['date'] != null ? DateTime.parse(data['date']) : now,
          inputType: InputType.date,
          format: formatter,
          lastDate: now,
          decoration: InputDecoration(
              labelText:
                  AppLocalizations.of(context).translate('operatioForm_date')),
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
        // state
        FormBuilderTextField(
            attribute: 'state',
            initialValue: data['state'] ?? null,
            decoration: InputDecoration(
              labelText:
                  AppLocalizations.of(context).translate('operatioForm_state'),
              alignLabelWithHint: true,
            ),
            validators: [
              FormBuilderValidators.required(
                  errorText: AppLocalizations.of(context)
                      .translate('operatioForm_requiredError')),
            ]),
        // city
        FormBuilderTextField(
            attribute: 'city',
            initialValue: data['city'] ?? null,
            decoration: InputDecoration(
              labelText:
                  AppLocalizations.of(context).translate('operatioForm_city'),
              alignLabelWithHint: true,
            ),
            validators: [
              FormBuilderValidators.required(
                  errorText: AppLocalizations.of(context)
                      .translate('operatioForm_requiredError')),
            ]),
        // details
        FormBuilderTextField(
          attribute: 'details',
          initialValue: data['details'] ?? null,
          decoration: InputDecoration(
            labelText:
                AppLocalizations.of(context).translate('operatioForm_details'),
            alignLabelWithHint: true,
          ),
        ),
        // photos
        FormBuilderImagePicker(
          initialValue: data['photos'] ?? null,
          labelText:
              AppLocalizations.of(context).translate('operatioForm_photos'),
          imageQuality: 70,
          maxImages: 5,
          attribute: "photos",
        ),
        // Gps location
        FormBuilderCustomField(
            initialValue: data['location'] ?? null,
            attribute: 'location',
            formField: FormField(
              enabled: true,
              builder: (FormFieldState<dynamic> field) => Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  RaisedButton(
                    child: Text(AppLocalizations.of(context)
                        .translate('operatioForm_Chooselocation')),
                    onPressed: () async {
                      // first check the Gps
                      bool gps = false;
                      await checkGps().then((value) => gps = value);
                      if (!gps) {
                        // no gps - show alert massege
                        showDialog(
                          //barrierDismissible: false,
                          context: context,
                          builder: (BuildContext context) {
                            return Dialog(
                              child: AlertDialog(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(32.0))),
                                actionsPadding:
                                    EdgeInsets.symmetric(horizontal: 50),
                                title: Text(AppLocalizations.of(context)
                                    .translate('operatioForm_ActivateGps')),
                                content: Container(
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: <Widget>[
                                      Text(AppLocalizations.of(context)
                                          .translate(
                                              'operatioForm_PleaseActivate')),
                                      RaisedButton(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(18.0),
                                        ),
                                        color: Theme.of(context).primaryColor,
                                        textColor: Colors.white,
                                        child: Text("OK"),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      } else {
                        await Navigator.pushNamed(context, '/map')
                            .then((value) {
                          field.didChange(value);
                        });
                      }
                    },
                  ),
                  Icon(
                    field.value == null ? null : Icons.check_circle,
                    color: field.value == null ? null : Colors.green,
                  ),
                ],
              ),
            )),
      ],
    ),
  );
}

class FormAccident extends StatefulWidget {
  final GlobalKey<FormBuilderState> formKey;

  FormAccident({this.formKey});

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
    widget.formKey.currentState.fields['cars'].currentState.reset();
    widget.formKey.currentState.fields['persons'].currentState.reset();

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

    widget.formKey.currentState.fields['cars'].currentState
        .setValue(jsonEncode(carsData));
    widget.formKey.currentState.fields['persons'].currentState
        .setValue(jsonEncode(personsData));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
            // not visble form with the main form key
            // this will control the submit to the main form
            Offstage(
              offstage: true,
              child: FormBuilder(
                key: widget.formKey,
                child: Column(
                  children: [
                    FormBuilderTextField(
                      attribute: 'cars',
                      validators: [
                        (val) {
                          if (val == null || val == '') {
                            // the other field must not be null
                            var other = widget.formKey.currentState
                                .fields['persons'].currentState.value;
                            if (other == null || other == '') {
                              return 'error';
                            }
                          }

                          return null;
                        }
                      ],
                    ),
                    FormBuilderTextField(
                      attribute: 'persons',
                      validators: [
                        (val) {
                          if (val == null || val == '') {
                            // the other field must not be null
                            var other = widget.formKey.currentState
                                .fields['cars'].currentState.value;
                            if (other == null || other == '') {
                              return 'error';
                            }
                          }

                          return null;
                        }
                      ],
                    ),
                  ],
                ),
              ),
            ),
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
              trailing: RaisedButton(
                  shape: CircleBorder(),
                  color: Colors.red,
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
                    cars.add(formCar(context, key, onChange: collectData));
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
                    persons
                        .add(formPerson(context, key, onChange: collectData));
                  });
                }),
          ],
    );
  }
}
