import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:flutter_form_builder/flutter_form_builder.dart';

//language support
import 'package:lost/app_localizations.dart';
import 'package:lost/pages/forms/details_field.dart';

// colors
import 'package:lost/constants.dart';

// validation
import 'package:lost/pages/validators.dart';

// sizer
import 'package:sizer/sizer.dart';

//
import 'package:lost/widgets/verification_code.dart';

class FormCar extends StatefulWidget {
  final GlobalKey<FormBuilderState> formKey;
  final Map<String, dynamic> data;
  final void Function() onChange;

  FormCar({@required this.formKey, @required this.data, this.onChange});

  @override
  _FormCarState createState() => _FormCarState();
}

class _FormCarState extends State<FormCar> {
  @override
  void dispose() {
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

        // plate number title
        Padding(
          padding: const EdgeInsets.only(top: 20, bottom: 10),
          child: Column(
            children: [
              Text(
                AppLocalizations.of(context).translate('carForm_plate'),
                style: TextStyle(fontSize: 16),
              ),
              Text(
                '(من اليسار لليمين)',
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),

        // plate number & letters
        Column(
          children: [
            // plate letters
            FormBuilderField<String>(
              name: "plate_number_letters",
              builder: (field) => InputDecorator(
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)
                      .translate('carForm_plateLetters'),
                  border: InputBorder.none,
                  errorText: field.errorText,
                ),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 1.h),
                  width: 100.w,
                  child: Directionality(
                    textDirection: TextDirection.ltr,
                    child: VerificationCode(
                      textStyle: TextStyle(
                          fontSize: 16.0.sp, color: textColorDarkBlack),
                      itemSize: 50.sp,
                      keyboardType: TextInputType.text,
                      length: 4,
                      onCompleted: (String value) {},
                      onChanged: (value) {
                        field.didChange(value);
                      },
                      onEditing: (bool value) {},
                    ),
                  ),
                ),
              ),
              validator: (val) {
                String firstValidate = FormBuilderValidators.required(context,
                    errorText: AppLocalizations.of(context)
                        .translate('operatioForm_requiredError'))(val);

                if (firstValidate != null) return firstValidate;

                // validate the value
                return validatPlateNumberLetters(context, val);
              },
            ),

            // plate numbers
            FormBuilderField<String>(
              name: "plate_number_numbers",
              builder: (field) => InputDecorator(
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)
                      .translate('carForm_plateNumbers'),
                  border: InputBorder.none,
                  errorText: field.errorText,
                ),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 1.h),
                  width: 100.w,
                  child: Directionality(
                    textDirection: TextDirection.ltr,
                    child: VerificationCode(
                      textStyle: TextStyle(
                          fontSize: 16.0.sp, color: textColorDarkBlack),
                      itemSize: 50.sp,
                      keyboardType: TextInputType.number,
                      length: 4,
                      onCompleted: (String value) {},
                      onChanged: (value) {
                        field.didChange(value);
                      },
                      onEditing: (bool value) {},
                    ),
                  ),
                ),
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
          ],
        ),

        // // Row(
        //   children: [
        //     // plate number - letters
        //     Expanded(
        //       child: FormBuilderTextField(
        //           name: "plate_number_letters",
        //           controller: controller,
        //           decoration: InputDecoration(
        //             labelText: AppLocalizations.of(context)
        //                 .translate('carForm_plateLetters'),
        //             labelStyle: TextStyle(
        //               letterSpacing: 1.0,
        //             ),
        //           ),
        //           valueTransformer: (value) {
        //             // return '88';
        //             return value;
        //           },
        //           onChanged: (value) {
        //             // print(value);
        //             // formKey.currentState.fields['plate_number_letters']
        //             //     .didChange('8');

        //             // widget.formKey.currentState.fields['plate_number_letters']
        //             //     .setValue('8');
        //             // setState(() {
        //             // print('this happend');
        //             // if (!isTextFieldUpdatedByUser) {
        //             //   isTextFieldUpdatedByUser = true;

        //             //   print('change happend!');
        //             //   setState(() {
        //             //     controller.text = '8';
        //             //   });
        //             //   return;
        //             // }
        //             // isTextFieldUpdatedByUser = false;
        //             // });
        //           },
        //           style: TextStyle(
        //             letterSpacing: 7.0,
        //             fontSize: 20,
        //             fontWeight: FontWeight.bold,
        //           ),
        //           validator: (val) {
        //             String firstValidate = FormBuilderValidators.required(
        //                 context,
        //                 errorText: AppLocalizations.of(context)
        //                     .translate('operatioForm_requiredError'))(val);

        //             if (firstValidate != null) return firstValidate;

        //             // validate the value

        //             return validatPlateNumberLetters(context, val);
        //           }),
        //     ),

        //     // plate number - numbers
        //     Expanded(
        //       child: FormBuilderTextField(
        //         name: "plate_number_numbers",
        //         decoration: InputDecoration(
        //           labelText: AppLocalizations.of(context)
        //               .translate('carForm_plateNumbers'),
        //           labelStyle: TextStyle(
        //             letterSpacing: 1.0,
        //           ),
        //         ),
        //         style: TextStyle(
        //           letterSpacing: 7.0,
        //           fontSize: 20,
        //           fontWeight: FontWeight.bold,
        //         ),
        //         validator: (value) {
        //           String firstValidate = FormBuilderValidators.required(context,
        //               errorText: AppLocalizations.of(context)
        //                   .translate('operatioForm_requiredError'))(value);

        //           if (firstValidate != null) return firstValidate;

        //           // validate the value
        //           return validatPlateNumberNumbers(context, value);
        //         },
        //       ),
        //     )
        //   ],
        // ),

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
