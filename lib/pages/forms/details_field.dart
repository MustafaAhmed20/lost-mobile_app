import 'package:flutter/material.dart';

import 'package:flutter_form_builder/flutter_form_builder.dart';

//language support
import 'package:lost/app_localizations.dart';

class DetailsField extends StatelessWidget {
  final Map<String, dynamic> data;

  DetailsField({@required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 200,
      width: double.infinity,
      child: Column(
        children: [
          // spacer with text
          Container(
            margin: EdgeInsets.symmetric(vertical: 5),
            child: Row(
              children: [
                Expanded(child: Divider()),
                Text(AppLocalizations.of(context)
                    .translate('operatioForm_details')),
                Expanded(child: Divider()),
              ],
            ),
          ),

          FormBuilderTextField(
            maxLines: 8,
            name: 'details',
            initialValue: data['details'] ?? null,
            decoration: InputDecoration(
              hintText: 'ادخل اي تفاصيل اخرى',
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.greenAccent, width: 0.8),
                borderRadius: BorderRadius.circular(18.0),
              ),
              labelText: AppLocalizations.of(context)
                  .translate('operatioForm_details'),
              alignLabelWithHint: true,
            ),
          ),
        ],
      ),
    );
  }
}
