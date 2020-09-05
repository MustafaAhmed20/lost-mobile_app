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

import 'package:lost/models/operation.dart';

// validation
import 'validators.dart';

class OperatioForm extends StatefulWidget {
  final TypeOperation typeOperation;
  OperatioForm({this.typeOperation});

  @override
  _OperatioFormState createState() =>
      _OperatioFormState(typeOperation: typeOperation);
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

  TypeOperation typeOperation;
  _OperatioFormState({this.typeOperation});

  // bool wait for uploading - true mean wait
  bool formWait = false;

  //the summation of the forms data
  Map data;

  @override
  void initState() {
    super.initState();

    _form0 = GlobalKey<FormBuilderState>();
    _form1 = GlobalKey<FormBuilderState>();
    _form2 = GlobalKey<FormBuilderState>();
    _form3 = GlobalKey<FormBuilderState>();

    formsKeys = [_form0, _form1, _form2, _form3];

    data = {};
  }

  @override
  Widget build(BuildContext context) {
    // data needed to post from provider

    Map<String, String> envData = {
      //'type_id': typeOperation.id.toString(),
      'country_id': Provider.of<CountryData>(context, listen: false)
          .selectedCountry
          .id
          .toString(),
      //'object_type':
      //    Provider.of<AppData>(context, listen: false).selectedObject.toString()
    };

    // the current logged in user
    String userToken = Provider.of<UserData>(context, listen: false).token;

    return ConstrainedBox(
      constraints: new BoxConstraints(
        minHeight: 200,
        maxHeight: 500.0,
      ),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            //crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              // the form
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: chooseForm(stage, context, formsKeys, data),
              ),

              // the buttons
              Row(
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

                                // add the data form to the global data var
                                data.addAll(formKey.currentState.value);

                                if (stage < 3) {
                                  // mean the form stages not completed
                                  setState(() {
                                    stage += 1;
                                  });
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
                              Navigator.pop(context);
                            },
                          ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

Widget chooseForm(int stage, context, formsList, data) {
  if (stage == 0) {
    return form0(context, formsList[stage]);
  } else if (stage == 1) {
    return form1(context, formsList[stage]);
  } else if (stage == 2) {
    return form2(context, formsList[stage]);
  } else if (stage == 3) {
    if (data['object_type'] == 'Person') {
      return formPerson(context, formsList[stage]);
    } else if (data['object_type'] == 'Car') {
      return formCar(context, formsList[stage]);
    }
  } else {
    return SizedBox.shrink();
  }
}

Widget formPerson(context, formKey) {
  // the ages ranges - for 'person' object
  List ages = Provider.of<AgeData>(context, listen: true).ages;

  // the emoji used - get it from provider
  List skins = Provider.of<AppSettings>(context, listen: true).skins;

  // list of genders
  Map genders =
      Provider.of<AppSettings>(context, listen: true).availableGenders;

  return FormBuilder(
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
        //hint: Text(AppLocalizations.of(context).translate('personForm_gender')),
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
                child: Text(
                  '${skin[0]} ${skin[1]}',
                  style: TextStyle(fontSize: 20),
                )))
            .toList(),
      ),
    ]),
  );
}

Widget formCar(context, formKey) {
  // the emoji used - get it from provider
  List cars = Provider.of<AppSettings>(context, listen: true).cars;
  return FormBuilder(
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
      // type
      FormBuilderDropdown(
        attribute: "car_type",
        decoration: InputDecoration(
          labelText: AppLocalizations.of(context).translate('carForm_type'),
        ),
        hint: Text(AppLocalizations.of(context).translate('carForm_type')),
        validators: [
          FormBuilderValidators.required(
              errorText: AppLocalizations.of(context)
                  .translate('operatioForm_requiredError')),
        ],
        items: cars
            .map((type) => DropdownMenuItem(
                value: cars.indexOf(type) + 1,
                child: Text(
                  '${type[0]} ${type[1]}',
                  style: TextStyle(fontSize: 20),
                )))
            .toList(),
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
                }
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
                }
              ],
            ),
          )
        ],
      ),
    ]),
  );
}

Widget form0(context, formKey) {
  // the types of operations
  List typeOperation =
      Provider.of<TypeOperationData>(context, listen: true).typeOperation;
  // opeation type translator
  Map names = Provider.of<TypeOperationData>(context, listen: true).names;
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
          child: FormBuilderDropdown(
            attribute: "type_id",
            decoration: InputDecoration(
                labelText:
                    AppLocalizations.of(context).translate('typeOperation')),
            hint: Text(AppLocalizations.of(context).translate('typeOperation')),
            validators: [
              FormBuilderValidators.required(
                errorText: AppLocalizations.of(context)
                    .translate('operatioForm_requiredError'),
              )
            ],
            items: typeOperation
                .map((type) => DropdownMenuItem(
                    value: type.id,
                    child: Text(
                        "${AppLocalizations.of(context).translate(names[type.name])}")))
                .toList(),
          ),
        ),
      ],
    ),
  );
}

Widget form1(context, formKey) {
  // the list of available objects
  Map objects =
      Provider.of<AppSettings>(context, listen: true).availableObjects;

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
        Padding(
          padding: EdgeInsets.all(8.0),
          child: FormBuilderDropdown(
            attribute: "object_type",
            decoration: InputDecoration(
                labelText:
                    AppLocalizations.of(context).translate('typeObject')),
            hint: Text(AppLocalizations.of(context).translate('typeObject')),
            validators: [
              FormBuilderValidators.required(
                errorText: AppLocalizations.of(context)
                    .translate('operatioForm_requiredError'),
              )
            ],
            items: objects.keys
                .map((object) => DropdownMenuItem(
                    value: object,
                    child: Text(AppLocalizations.of(context)
                        .translate(objects[object]))))
                .toList(),
          ),
        ),
      ],
    ),
  );
}

Widget form2(context, formKey) {
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
          initialValue: now,
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
          decoration: InputDecoration(
            labelText:
                AppLocalizations.of(context).translate('operatioForm_details'),
            alignLabelWithHint: true,
          ),
        ),
        // photos
        FormBuilderImagePicker(
          labelText:
              AppLocalizations.of(context).translate('operatioForm_photos'),
          maxImages: 5,
          attribute: "photos",
        ),
        // Gps location
        FormBuilderCustomField(
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
