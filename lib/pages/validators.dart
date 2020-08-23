import 'package:flutter/material.dart';

//language support
import 'package:lost/app_localizations.dart';

// validators functions with regex

String validatPhone(BuildContext context, phone, country) {
  // return error massege if not pass the validation else null

  RegExp exp = RegExp(r"^(?:((\+|00)?(?<code>" +
      country.phoneCode.toString() +
      r"))|0)?(?<phone>\d{" +
      country.phoneLength.toString() +
      r"})$");
  bool result = exp.hasMatch(phone);
  if (!result) {
    // wrong formated string
    return AppLocalizations.of(context).translate('validation_notValidPhone');
  }
  return null;
}

String validatPassword(BuildContext context, password) {
// return error massege if not pass the validation else null

//must contain at least one number
  String pattren1 = r'\d';

//must contain at least one letter
  String pattren2 = r'[a-zA-Z]';

  RegExp exp1 = RegExp(pattren1);
  RegExp exp2 = RegExp(pattren2);

  if (!exp1.hasMatch(password)) {
    // not have digits
    return AppLocalizations.of(context).translate('validation_mustDigits');
  }
  if (!exp2.hasMatch(password)) {
    // not have letters
    return AppLocalizations.of(context).translate('validation_mustEnglish');
  }
  return null;
}
