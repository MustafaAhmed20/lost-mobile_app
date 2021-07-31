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

class Form0 extends StatefulWidget {
  final Map<dynamic, dynamic> data;

  final GlobalKey<FormBuilderState> formKey;

  final void Function() autoSubmit;

  Form0({
    @required this.data,
    @required this.formKey,
    this.autoSubmit,
  });

  @override
  _Form0State createState() => _Form0State();
}

class _Form0State extends State<Form0> {
  @override
  Widget build(BuildContext context) {
    // the types of operations
    List<TypeOperation> typeOperation =
        Provider.of<TypeOperationData>(context, listen: false).typeOperation;
    // opeation type translator
    Map names = Provider.of<TypeOperationData>(context, listen: false).names;
    return FormBuilder(
      key: widget.formKey,
      // auto submit with the click
      onChanged: widget.autoSubmit != null ? () => widget.autoSubmit() : null,
      autovalidateMode: AutovalidateMode.always,
      child: Column(
        children: [
          Text(
            AppLocalizations.of(context).translate('typeOperation'),
            style: TextStyle(fontSize: 20),
          ),

          // stage 0 - the type of operation
          FormBuilderField<int>(
            name: "type_id",
            initialValue: widget.data['type_id'] ?? null,
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
                child: ChipsChoice<int>.single(
                  onChanged: (v) {
                    setState(() {
                      field.didChange(v);
                    });
                  },
                  choiceItems: C2Choice.listFrom<int, TypeOperation>(
                    source: typeOperation,
                    label: (index, item) => AppLocalizations.of(context)
                        .translate(names[item.name]),
                    value: (index, item) => item.id,
                  ),
                  value: field.value,
                  choiceStyle: C2ChoiceStyle(
                    borderColor: textColorHint,
                    avatarBorderColor: Colors.blue,
                    borderRadius: BorderRadius.circular(15),
                    disabledColor: Colors.black,
                  ),
                  choiceActiveStyle: C2ChoiceStyle(
                    borderColor: Colors.black,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
