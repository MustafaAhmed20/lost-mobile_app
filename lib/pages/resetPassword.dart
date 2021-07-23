import 'package:flutter/material.dart';

// the providers
import 'package:provider/provider.dart';
import 'package:lost/models/appData.dart';

// the models
import 'package:lost/models/models.dart';

import 'package:flutter_form_builder/flutter_form_builder.dart';

import 'package:flutter_verification_code/flutter_verification_code.dart';

import 'validators.dart';
import 'snackBars.dart';

//language support
import 'package:lost/app_localizations.dart';

class ResetPassword extends StatefulWidget {
  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();

  bool _isButtonDisabled;

  // if true mean not finshed typing
  bool editting;

  String code;
  Map arguments;

  @override
  void initState() {
    super.initState();
    _isButtonDisabled = false;
  }

  @override
  Widget build(BuildContext context) {
    Country selectedCountry =
        Provider.of<CountryData>(context, listen: true).selectedCountry;

    arguments = ModalRoute.of(context).settings.arguments;

    String phone = arguments['phone'];

    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Center(
        child: Builder(
          // user Builder to have new context under Scaffold
          builder: (BuildContext context) => Container(
            height: 300,
            margin: EdgeInsets.symmetric(horizontal: 12),
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25.0),
                    bottomRight: Radius.circular(25.0))),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Center(
                  child: Text(
                    AppLocalizations.of(context).translate('reset_Reset'),
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                VerificationCode(
                  textStyle: TextStyle(fontSize: 20.0, color: Colors.red[900]),
                  keyboardType: TextInputType.number,
                  length: 6,
                  // clearAll is NOT required, you can delete it
                  // takes any widget, so you can implement your design
                  clearAll: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'clear all',
                      style: TextStyle(
                          fontSize: 14.0,
                          decoration: TextDecoration.underline,
                          color: Colors.blue[700]),
                    ),
                  ),
                  onCompleted: (String value) {
                    this.code = value;
                  },
                  onEditing: (bool value) {
                    this.editting = value;
                    this.code = '';
                  },
                ),
                FormBuilder(
                  key: _fbKey,
                  autovalidateMode: AutovalidateMode.always,
                  child: Column(
                    children: <Widget>[
                      FormBuilderTextField(
                        name: "password",
                        decoration: InputDecoration(labelText: "new password"),
                        validator: FormBuilderValidators.required(context),
                      )
                    ],
                  ),
                ),
                MaterialButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                  ),
                  color: Theme.of(context).primaryColor,
                  child: Text(
                    AppLocalizations.of(context).translate('reset_Submit'),
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: _isButtonDisabled
                      ? () => null
                      : () async {
                          if (_fbKey.currentState.saveAndValidate()) {
                            //print(_fbKey.currentState.value);
                            String password =
                                _fbKey.currentState.value['password'];

                            // validate
                            String result = validatPassword(context, password);
                            if (result != null) {
                              // not pass the validation
                              String massege = result;
                              Scaffold.of(context).showSnackBar(
                                  customErrorSnackBar(context, massege));
                              return;
                            }
                            if (editting) {
                              // not complate the code
                              String massege = 'Please enter the code!';
                              Scaffold.of(context).showSnackBar(
                                  customErrorSnackBar(context, massege));
                              return;
                            }
                            // reset the password
                            String resultReset = await Provider.of<UserData>(
                                    context,
                                    listen: false)
                                .resetPassword(
                                    phone, code, selectedCountry.id, password);

                            if (resultReset != null) {
                              Scaffold.of(context).showSnackBar(
                                  customErrorSnackBar(context, resultReset));
                              return;
                            }

                            // pop the screen

                            // disable the button
                            setState(() {
                              _isButtonDisabled = true;
                            });

                            // show the success massege
                            Scaffold.of(context)
                                .showSnackBar(successResetSnackBar(context));
                            await Future<void>.delayed(Duration(seconds: 2));
                            Navigator.of(context).pop({'reset': true});
                          }
                        },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
