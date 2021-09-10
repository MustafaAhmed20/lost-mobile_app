import 'dart:io';

import 'package:flutter/material.dart';

import 'package:flutter_form_builder/flutter_form_builder.dart';

//language support
import 'package:lost/app_localizations.dart';

// the colors
import 'package:lost/constants.dart';

// the models
import 'package:lost/models/models.dart';

// check Gps func
import 'package:lost/pages/googlemap.dart';

// validation
import 'package:lost/pages/validators.dart';
import 'package:lost/widgets/photos_uploader_box.dart';
import 'package:lost/widgets/text_input.dart';

import 'package:provider/provider.dart';
import 'package:lost/models/appData.dart';

import 'package:intl/intl.dart' show DateFormat;

class Form2 extends StatefulWidget {
  final Map<dynamic, dynamic> data;

  final GlobalKey<FormBuilderState> formKey;

  Form2({
    @required this.data,
    @required this.formKey,
  });

  @override
  _Form2State createState() => _Form2State();
}

class _Form2State extends State<Form2> {
  TextEditingController stateController;
  TextEditingController cityController;

  @override
  void initState() {
    stateController = TextEditingController(text: widget.data['state'] ?? '');
    cityController = TextEditingController(text: widget.data['city'] ?? '');
    super.initState();
  }

  @override
  void dispose() {
    stateController.dispose();
    cityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // current time
    DateTime now = new DateTime.now();

    // this help make the date with the correct format
    DateFormat formatter = new DateFormat('yyyy-MM-dd');

    return FormBuilder(
      key: widget.formKey,
      autovalidateMode: AutovalidateMode.always,
      child: Column(
        children: [
          Text(
            AppLocalizations.of(context)
                .translate('operatioForm_operatioDetails'),
            style: TextStyle(fontSize: 20),
          ),

          // date
          FormBuilderDateTimePicker(
            name: "date",
            initialValue: widget.data['date'] != null
                ? DateTime.parse(widget.data['date'])
                : now,
            inputType: InputType.date,
            format: formatter,
            lastDate: now,
            decoration: InputDecoration(
                labelText: AppLocalizations.of(context)
                    .translate('operatioForm_date')),
            validator: FormBuilderValidators.required(context),
            valueTransformer: (value) {
              if (value != null) {
                return formatter.format(value);
              }
              return value;
            },
          ),

          // state & city
          Row(
            children: [
              // state
              Expanded(
                child: Container(
                  child: FormBuilderField<String>(
                    name: 'state',
                    initialValue: widget.data['state'] ?? null,
                    validator: FormBuilderValidators.required(context,
                        errorText: AppLocalizations.of(context)
                            .translate('operatioForm_requiredError')),
                    builder: (field) => InputDecorator(
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.zero,
                          border: InputBorder.none,
                          labelText: AppLocalizations.of(context)
                              .translate('operatioForm_state'),
                          // alignLabelWithHint: true,
                          errorText: field.errorText,
                          errorStyle: TextStyle(fontSize: 8),
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: TextInput(
                            height: 6,
                            textSize: 12,
                            onChange: (c, text) => field.didChange(text),
                            controller: stateController,
                          ),
                        )),
                  ),
                ),
              ),

              // some space
              SizedBox(width: 2),

              // city
              Expanded(
                child: Container(
                  child: FormBuilderField<String>(
                    name: 'city',
                    initialValue: widget.data['city'] ?? null,
                    validator: FormBuilderValidators.required(context,
                        errorText: AppLocalizations.of(context)
                            .translate('operatioForm_requiredError')),
                    builder: (field) => InputDecorator(
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.zero,
                          border: InputBorder.none,
                          labelText: AppLocalizations.of(context)
                              .translate('operatioForm_city'),
                          // alignLabelWithHint: true,
                          errorText: field.errorText,
                          errorStyle: TextStyle(fontSize: 8),
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: TextInput(
                            height: 6,
                            textSize: 12,
                            onChange: (c, text) => field.didChange(text),
                            controller: cityController,
                          ),
                        )),
                  ),
                ),
              ),
            ],
          ),

          // photos
          FormBuilderField<List<File>>(
            name: "photos",
            initialValue: widget.data['photos'] ?? null,
            builder: (field) => InputDecorator(
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)
                    .translate('operatioForm_photos'),
                border: InputBorder.none,
              ),
              child: Container(
                margin: EdgeInsets.only(top: 10),
                child: PhotosUploaderBox(
                  oldFilePhotos: widget.data['photos'] ?? [],
                  onChange: (c, photos) {
                    field.didChange(photos.map((e) => e.image).toList());
                  },
                ),
              ),
            ),
          ),

          // Gps location
          FormBuilderField(
            initialValue: widget.data['location'] ?? null,
            name: 'location',
            builder: (field) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // the labelText
                Text(
                  'اختر الموقع:',
                ),

                // the button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    // RaisedButton(
                    ElevatedButton(
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}
