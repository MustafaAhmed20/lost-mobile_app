import 'package:flutter/material.dart';

import 'package:flutter_form_builder/flutter_form_builder.dart';

//language support
import 'package:lost/app_localizations.dart';

// the colors
import 'package:lost/constants.dart';

// the models
import 'package:lost/models/models.dart';

// validation
import 'package:lost/pages/validators.dart';

import 'package:provider/provider.dart';
import 'package:lost/models/appData.dart';

import 'package:chips_choice/chips_choice.dart';

class Form1 extends StatefulWidget {
  final Map<dynamic, dynamic> data;

  final GlobalKey<FormBuilderState> formKey;

  final void Function() autoSubmit;

  Form1({
    @required this.data,
    @required this.formKey,
    this.autoSubmit,
  });

  @override
  _Form1State createState() => _Form1State();
}

class _Form1State extends State<Form1> {
  Map<String, String> objects;

  @override
  void didChangeDependencies() {
    // the list of available objects
    objects = Provider.of<AppSettings>(context, listen: false).availableObjects;

    // remove 'Accident object'
    objects.remove('Accident');

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return FormBuilder(
      key: widget.formKey,
      onChanged: widget.autoSubmit != null ? () => widget.autoSubmit() : null,
      autovalidateMode: AutovalidateMode.always,
      child: Column(
        children: [
          Text(
            AppLocalizations.of(context).translate('typeObject'),
            style: TextStyle(fontSize: 20),
          ),

          // stage 0 - the type of operation
          FormBuilderField<String>(
            name: "object_type",
            initialValue: widget.data['object_type'] ?? null,
            validator: FormBuilderValidators.required(
              context,
              errorText: AppLocalizations.of(context)
                  .translate('operatioForm_requiredError'),
            ),
            builder: (field) => Padding(
              padding: EdgeInsets.all(8.0),
              child: InputDecorator(
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  errorText: field.errorText,
                ),
                child: ChipsChoice<String>.single(
                  direction: Axis.vertical,
                  runAlignment: WrapAlignment.spaceAround,
                  onChanged: (v) {
                    setState(() {
                      field.didChange(v);
                    });
                  },
                  choiceItems: C2Choice.listFrom<String, String>(
                    source: objects.keys.toList(),
                    label: (index, item) =>
                        AppLocalizations.of(context).translate(objects[item]),
                    value: (index, item) => item,
                  ),
                  value: field.value,
                  choiceStyle: C2ChoiceStyle(
                    borderColor: textColorHint,
                  ),
                  choiceActiveStyle: C2ChoiceStyle(
                    borderColor: Colors.black,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
