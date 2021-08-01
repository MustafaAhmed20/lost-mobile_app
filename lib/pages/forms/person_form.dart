import 'package:flutter/material.dart';

import 'package:flutter_form_builder/flutter_form_builder.dart';

//language support
import 'package:lost/app_localizations.dart';
import 'package:lost/pages/forms/details_field.dart';

// validation
import 'package:lost/pages/validators.dart';

import 'package:provider/provider.dart';
import 'package:lost/models/appData.dart';

Widget formPerson(context, formKey, data, {void Function() onChange}) {
  // the ages ranges - for 'person' object
  List ages = Provider.of<AgeData>(context, listen: false).ages;

  // the emoji used - get it from provider
  List skins = Provider.of<AppSettings>(context, listen: false).skins;

  // list of genders
  Map genders =
      Provider.of<AppSettings>(context, listen: false).availableGenders;

  // bool if true mean show the shelter - show shelter if selected type is 'found'
  List types =
      Provider.of<TypeOperationData>(context, listen: false).typeOperation;

  bool showShelter =
      types.firstWhere((e) => e.name == 'found').id == data['type_id'];

  return FormBuilder(
    onChanged: onChange != null ? () => onChange() : null,
    key: formKey,
    autovalidateMode: AutovalidateMode.always,
    child: Column(children: [
      // person Details
      Text(
        AppLocalizations.of(context).translate('personForm_operatioDetails'),
        style: TextStyle(fontSize: 20),
      ),

      // name
      FormBuilderTextField(
        name: "person_name",
        decoration: InputDecoration(
            labelText:
                AppLocalizations.of(context).translate('operatioForm_name')),
      ),

      // gender
      FormBuilderRadioGroup(
        activeColor: Colors.black,
        orientation: OptionsOrientation.vertical,
        name: "gender",
        decoration: InputDecoration(
          labelText:
              AppLocalizations.of(context).translate('personForm_gender'),
        ),
        validator: FormBuilderValidators.required(context,
            errorText: AppLocalizations.of(context)
                .translate('operatioForm_requiredError')),
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
        name: "age_id",
        decoration: InputDecoration(
            labelText:
                AppLocalizations.of(context).translate('operatioForm_age')),
        // hint: Text(
        //   AppLocalizations.of(context).translate('operatioForm_AgeRange'),
        //   style: TextStyle(fontSize: 10),
        // ),
        validator: FormBuilderValidators.required(context,
            errorText: AppLocalizations.of(context)
                .translate('operatioForm_requiredError')),

        items: ages
                ?.map((age) => DropdownMenuItem(
                    value: age.id,
                    child: Text("${age.minAge} - ${age.maxAge}")))
                ?.toList() ??
            [],
      ),

      // skin color
      FormBuilderDropdown(
        name: "skin",
        decoration: InputDecoration(
          labelText: AppLocalizations.of(context).translate('personForm_skin'),
        ),
        // hint: Text(
        //     AppLocalizations.of(context).translate('personForm_skinApprox')),
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

      // shelter
      Visibility(
        visible: showShelter,
        child: FormBuilderCheckbox(
          name: 'shelter',
          initialValue: false,
          title: Text(
            'داخل ملجأ؟',
            style: TextStyle(fontSize: 16),
          ),
          checkColor: Colors.black,
          valueTransformer: (value) {
            // the true value will be 'true' - false value will be empty string
            // this will solve bug of sending boolean in the form
            if (!value) {
              return '';
            } else {
              return 'true';
            }
          },
        ),
      ),

      //details
      Container(
        margin: EdgeInsets.only(top: 10),
        child: Visibility(
          // not show if use Accident object
          visible: data['object_type'] != 'Accident',
          child: DetailsField(
            data: data,
          ),
        ),
      ),
    ]),
  );
}
