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

class Form2 extends StatelessWidget {
  final Map<dynamic, dynamic> data;

  final GlobalKey<FormBuilderState> formKey;

  Form2({
    @required this.data,
    @required this.formKey,
  });

  @override
  Widget build(BuildContext context) {
    // current time
    DateTime now = new DateTime.now();

    // this help make the date with the correct format
    var formatter = new DateFormat('yyyy-MM-dd');
    return FormBuilder(
      key: formKey,
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
            initialValue:
                data['date'] != null ? DateTime.parse(data['date']) : now,
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

          Row(
            children: [
              // state
              Expanded(
                child: Container(
                  child: FormBuilderField<String>(
                    name: 'state',
                    initialValue: data['state'] ?? null,
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
                            onChange: (c, text) => field.didChange(text),
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
                    initialValue: data['city'] ?? null,
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
                            onChange: (c, text) => field.didChange(text),
                          ),
                        )),
                  ),
                ),
              ),

              // city
              // Expanded(
              //   child: FormBuilderTextField(
              //     name: 'city',
              //     initialValue: data['city'] ?? null,
              //     decoration: InputDecoration(
              //       border: InputBorder.none,
              //       labelText: AppLocalizations.of(context)
              //           .translate('operatioForm_city'),
              //       alignLabelWithHint: true,
              //     ),
              //     validator: FormBuilderValidators.required(context,
              //         errorText: AppLocalizations.of(context)
              //             .translate('operatioForm_requiredError')),
              //   ),
              // ),
            ],
          ),

          // details
          /*
        FormBuilderTextField(
          name: 'details',
          initialValue: data['details'] ?? null,
          decoration: InputDecoration(
            labelText:
                AppLocalizations.of(context).translate('operatioForm_details'),
            alignLabelWithHint: true,
          ),
        ),
        */
          // photos
          FormBuilderField<List<File>>(
            name: "photos",
            initialValue: data['photos'] ?? null,
            builder: (field) => InputDecorator(
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)
                    .translate('operatioForm_photos'),
                border: InputBorder.none,
              ),
              child: Container(
                margin: EdgeInsets.only(top: 10),
                child: PhotosUploaderBox(
                  oldFilePhotos: data['photos'] ?? [],
                  onChange: (c, photos) {
                    field.didChange(photos.map((e) => e.image).toList());
                  },
                ),
              ),
            ),
          ),

          // FormBuilderImagePicker(
          //   initialValue: data['photos'] ?? null,
          //   decoration: InputDecoration(border: InputBorder.none),
          //   labelText:
          //       AppLocalizations.of(context).translate('operatioForm_photos'),
          //   imageQuality: 70,
          //   maxImages: 5,
          //   name: "photos",
          // ),

          // Gps location
          FormBuilderField(
              initialValue: data['location'] ?? null,
              name: 'location',
              builder: (field) => FormField(
                    enabled: true,
                    builder: (FormFieldState<dynamic> field) => Column(
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
                                          actionsPadding: EdgeInsets.symmetric(
                                              horizontal: 50),
                                          title: Text(AppLocalizations.of(
                                                  context)
                                              .translate(
                                                  'operatioForm_ActivateGps')),
                                          content: Container(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.stretch,
                                              children: <Widget>[
                                                Text(AppLocalizations.of(
                                                        context)
                                                    .translate(
                                                        'operatioForm_PleaseActivate')),
                                                RaisedButton(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            18.0),
                                                  ),
                                                  color: Theme.of(context)
                                                      .primaryColor,
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
                  )),
        ],
      ),
    );
  }
}
