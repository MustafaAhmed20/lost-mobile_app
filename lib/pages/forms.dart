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

class OperatioForm extends StatefulWidget {
  final TypeOperation typeOperation;
  OperatioForm({this.typeOperation});

  @override
  _OperatioFormState createState() =>
      _OperatioFormState(typeOperation: typeOperation);
}

class _OperatioFormState extends State<OperatioForm> {
  // form key
  GlobalKey<FormBuilderState> _fbKey;

  TypeOperation typeOperation;
  _OperatioFormState({this.typeOperation});

  // bool wait for uploading - true mean wait
  bool formWait = false;

  @override
  void initState() {
    super.initState();

    _fbKey = GlobalKey<FormBuilderState>();
  }

  @override
  Widget build(BuildContext context) {
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

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(40.0)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
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
                        format: formatter,
                        lastDate: now,
                        decoration: InputDecoration(
                            labelText: AppLocalizations.of(context)
                                .translate('operatioForm_date')),
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
                        decoration: InputDecoration(
                            labelText: AppLocalizations.of(context)
                                .translate('operatioForm_name')),
                      ),
                      FormBuilderDropdown(
                        attribute: "age_id",
                        decoration: InputDecoration(
                            labelText: AppLocalizations.of(context)
                                .translate('operatioForm_age')),
                        hint: Text(AppLocalizations.of(context)
                            .translate('operatioForm_AgeRange')),
                        validators: [
                          FormBuilderValidators.required(
                              errorText: AppLocalizations.of(context)
                                  .translate('operatioForm_requiredError')),
                        ],
                        items: ages
                            .map((age) => DropdownMenuItem(
                                value: age.id,
                                child: Text("${age.minAge} - ${age.maxAge}")))
                            .toList(),
                      ),
                      FormBuilderTextField(
                        attribute: 'details',
                        decoration: InputDecoration(
                          labelText: AppLocalizations.of(context)
                              .translate('operatioForm_details'),
                          alignLabelWithHint: true,
                        ),
                      ),
                      FormBuilderImagePicker(
                        labelText: AppLocalizations.of(context)
                            .translate('operatioForm_photos'),
                        maxImages: 5,
                        attribute: "photos",
                      ),
                      FormBuilderCustomField(
                          attribute: 'location',
                          formField: FormField(
                            enabled: true,
                            builder: (FormFieldState<dynamic> field) => Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                RaisedButton(
                                  child: Text(AppLocalizations.of(context)
                                      .translate(
                                          'operatioForm_Chooselocation')),
                                  onPressed: () async {
                                    // first check the Gps
                                    bool gps = false;
                                    await checkGps()
                                        .then((value) => gps = value);
                                    if (!gps) {
                                      // no gps - show alert massege
                                      showDialog(
                                        //barrierDismissible: false,
                                        context: context,
                                        builder: (BuildContext context) {
                                          return Dialog(
                                            child: AlertDialog(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(
                                                              32.0))),
                                              actionsPadding:
                                                  EdgeInsets.symmetric(
                                                      horizontal: 50),
                                              title: Text(AppLocalizations.of(
                                                      context)
                                                  .translate(
                                                      'operatioForm_ActivateGps')),
                                              content: Container(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment
                                                          .stretch,
                                                  children: <Widget>[
                                                    Text(AppLocalizations.of(
                                                            context)
                                                        .translate(
                                                            'operatioForm_PleaseActivate')),
                                                    RaisedButton(
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(18.0),
                                                      ),
                                                      color: Theme.of(context)
                                                          .primaryColor,
                                                      textColor: Colors.white,
                                                      child: Text("OK"),
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
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
                                SizedBox(
                                  width: 100,
                                ),
                                Icon(
                                  field.value == null
                                      ? null
                                      : Icons.check_circle,
                                  color:
                                      field.value == null ? null : Colors.green,
                                ),
                              ],
                            ),
                          )),
                    ],
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  formWait ? wait() : SizedBox.shrink(),
                  formWait
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
                            if (_fbKey.currentState.saveAndValidate()) {
                              //print(_fbKey.currentState.value);

                              //disable the button and wait
                              setState(() {
                                formWait = true;
                              });

                              // add the env data
                              Map data = {};
                              data.addAll(_fbKey.currentState.value);
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
                  formWait
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
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
