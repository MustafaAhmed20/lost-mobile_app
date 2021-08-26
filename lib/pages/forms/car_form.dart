import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:flutter_form_builder/flutter_form_builder.dart';

//language support
import 'package:lost/app_localizations.dart';
import 'package:lost/pages/forms/details_field.dart';

// validation
import 'package:lost/pages/validators.dart';

class FormCar extends StatefulWidget {
  final GlobalKey<FormBuilderState> formKey;
  final Map<String, dynamic> data;
  final void Function() onChange;

  FormCar({@required this.formKey, @required this.data, this.onChange});

  @override
  _FormCarState createState() => _FormCarState();
}

class _FormCarState extends State<FormCar> {
  final TextEditingController controller = TextEditingController();

  bool isTextFieldUpdatedByUser = false;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FormBuilder(
      onChanged: widget.onChange != null ? () => widget.onChange() : null,
      key: widget.formKey,
      autovalidateMode: AutovalidateMode.always,
      child: Column(children: [
        // car Details
        Text(
          AppLocalizations.of(context).translate('carForm_operatioDetails'),
          style: TextStyle(fontSize: 20),
        ),

        // Brand
        FormBuilderTextField(
          name: "brand",
          decoration: InputDecoration(
              labelText:
                  AppLocalizations.of(context).translate('carForm_brand')),
          validator: FormBuilderValidators.required(context,
              errorText: AppLocalizations.of(context)
                  .translate('operatioForm_requiredError')),
        ),

        // Modle
        FormBuilderTextField(
          name: "model",
          decoration: InputDecoration(
              labelText:
                  AppLocalizations.of(context).translate('carForm_model')),
          validator: FormBuilderValidators.required(context,
              errorText: AppLocalizations.of(context)
                  .translate('operatioForm_requiredError')),
        ),

        // type - this field not used now
        Offstage(
          offstage: true,
          child: FormBuilderDropdown(
              name: "car_type",
              initialValue: 1,
              decoration: InputDecoration(
                labelText:
                    AppLocalizations.of(context).translate('carForm_type'),
              ),
              hint:
                  Text(AppLocalizations.of(context).translate('carForm_type')),
              validator: FormBuilderValidators.required(context,
                  errorText: AppLocalizations.of(context)
                      .translate('operatioForm_requiredError')),
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

        // plate number & letters
        Row(
          children: [
            // plate number - letters
            Expanded(
              child: FormBuilderTextField(
                  name: "plate_number_letters",
                  controller: controller,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)
                        .translate('carForm_plateLetters'),
                    labelStyle: TextStyle(
                      letterSpacing: 1.0,
                    ),
                  ),
                  valueTransformer: (value) {
                    // return '88';
                    return value;
                  },
                  onChanged: (value) {
                    // print(value);
                    // formKey.currentState.fields['plate_number_letters']
                    //     .didChange('8');

                    // widget.formKey.currentState.fields['plate_number_letters']
                    //     .setValue('8');
                    // setState(() {
                    // print('this happend');
                    // if (!isTextFieldUpdatedByUser) {
                    //   isTextFieldUpdatedByUser = true;

                    //   print('change happend!');
                    //   setState(() {
                    //     controller.text = '8';
                    //   });
                    //   return;
                    // }
                    // isTextFieldUpdatedByUser = false;
                    // });
                  },
                  style: TextStyle(
                    letterSpacing: 7.0,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  validator: (val) {
                    String firstValidate = FormBuilderValidators.required(
                        context,
                        errorText: AppLocalizations.of(context)
                            .translate('operatioForm_requiredError'))(val);

                    if (firstValidate != null) return firstValidate;

                    // validate the value

                    return validatPlateNumberLetters(context, val);
                  }),
            ),

            // plate number - numbers
            Expanded(
              child: FormBuilderTextField(
                name: "plate_number_numbers",
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
                validator: (value) {
                  String firstValidate = FormBuilderValidators.required(context,
                      errorText: AppLocalizations.of(context)
                          .translate('operatioForm_requiredError'))(value);

                  if (firstValidate != null) return firstValidate;

                  // validate the value
                  return validatPlateNumberNumbers(context, value);
                },
              ),
            )
          ],
        ),

        //details
        Visibility(
          // not show if use Accident object
          visible: widget.data['object_type'] != 'Accident',
          child: Container(
            width: double.infinity,
            child: DetailsField(
              data: widget.data,
            ),
          ),
        ),
      ]),
    );
  }
}
