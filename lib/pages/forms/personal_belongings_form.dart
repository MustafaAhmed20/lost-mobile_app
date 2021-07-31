import 'package:flutter/material.dart';

import 'package:flutter_form_builder/flutter_form_builder.dart';

//language support
import 'package:lost/app_localizations.dart';

// validation
import 'package:lost/pages/validators.dart';

import 'package:provider/provider.dart';
import 'package:lost/models/appData.dart';

class FormPersonalBelongings extends StatefulWidget {
  final GlobalKey<FormBuilderState> formKey;

  final void Function() onChange;

  FormPersonalBelongings({this.formKey, this.onChange});
  @override
  _FormPersonalBelongingsState createState() => _FormPersonalBelongingsState();
}

class _FormPersonalBelongingsState extends State<FormPersonalBelongings> {
  // this bool used to hide the subtype dropdwon
  bool hideSubtype = false;
  // the list of items in the subtype
  List<DropdownMenuItem> subtypeList;

  @override
  Widget build(BuildContext context) {
    List<List> types = Provider.of<AppSettings>(context, listen: false)
        .availablePersonalBelongingsTypes;
    return FormBuilder(
      onChanged: widget.onChange != null ? () => widget.onChange() : null,
      key: widget.formKey,
      autovalidateMode: AutovalidateMode.always,
      child: Column(children: [
        // car Details
        Text(
          AppLocalizations.of(context).translate('menu_PersonalBelongings'),
          style: TextStyle(fontSize: 20),
        ),
        // type
        FormBuilderDropdown(
          name: "personal_belongings_type",
          decoration: InputDecoration(
              labelText: AppLocalizations.of(context)
                  .translate('belongingsForm_type')),
          validator: FormBuilderValidators.required(context,
              errorText: AppLocalizations.of(context)
                  .translate('operatioForm_requiredError')),
          onChanged: (val) {
            // set the subtype if any
            List item = types[val - 1];
            List subtype = item[1];
            if (subtype.length > 0) {
              setState(() {
                hideSubtype = true;
                subtypeList = subtype.map((e) {
                  return DropdownMenuItem(
                    value: subtype.indexOf(e) + 1,
                    child: Text(AppLocalizations.of(context).translate(e)),
                  );
                }).toList();
              });
            } else {
              // no subtypes
              setState(() {
                hideSubtype = false;
                subtypeList = null;
              });
            }
          },
          items: types.map((e) {
            return DropdownMenuItem(
              value: types.indexOf(e) + 1,
              child: Text(AppLocalizations.of(context).translate(e[0])),
            );
          }).toList(),
        ),
        // subtype
        Visibility(
          visible: hideSubtype,
          child: FormBuilderDropdown(
            name: "personal_belongings_subtype",
            decoration: InputDecoration(
                labelText: AppLocalizations.of(context)
                    .translate('belongingsForm_subtype')),
            validator: FormBuilderValidators.required(context,
                errorText: AppLocalizations.of(context)
                    .translate('operatioForm_requiredError')),
            items: subtypeList,
          ),
        ),
        //details
        Container(
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
      ]),
    );
  }
}
