import 'package:flutter/material.dart';

import 'package:flutter_form_builder/flutter_form_builder.dart';

//language support
import 'package:lost/app_localizations.dart';

// validation
import 'package:lost/pages/validators.dart';

Widget formCar(context, formKey, data, {void Function() onChange}) {
  // the emoji used - get it from provider
  //List cars = Provider.of<AppSettings>(context, listen: false).cars;
  return FormBuilder(
    onChanged: onChange != null ? () => onChange() : null,
    key: formKey,
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
            labelText: AppLocalizations.of(context).translate('carForm_brand')),
        validator: FormBuilderValidators.required(context,
            errorText: AppLocalizations.of(context)
                .translate('operatioForm_requiredError')),
      ),
      // Modle
      FormBuilderTextField(
        name: "model",
        decoration: InputDecoration(
            labelText: AppLocalizations.of(context).translate('carForm_model')),
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
              labelText: AppLocalizations.of(context).translate('carForm_type'),
            ),
            hint: Text(AppLocalizations.of(context).translate('carForm_type')),
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
      Row(
        children: [
          // plate number - letters
          Expanded(
            child: FormBuilderTextField(
                name: "plate_number_letters",
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
                validator: (val) {
                  String firstValidate = FormBuilderValidators.required(context,
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
        visible: data['object_type'] != 'Accident',
        child: Container(
          height: 200,
          width: double.infinity,
          child: FormBuilderTextField(
            maxLines: 8,
            name: 'details',
            //initialValue: data['details'] ?? null,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.greenAccent, width: 0.8),
                //borderRadius: BorderRadius.circular(18.0),
              ),
              labelText: AppLocalizations.of(context)
                  .translate('operatioForm_details'),
              alignLabelWithHint: true,
            ),
          ),
        ),
      ),
    ]),
  );
}
