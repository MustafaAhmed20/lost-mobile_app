import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:lost/models/appData.dart';
import 'package:lost/models/operation/operation.dart';
import 'package:lost/pages/wait.dart';

import 'package:flutter_form_builder/flutter_form_builder.dart';

//language support
import 'package:lost/app_localizations.dart';

import 'package:country_pickers/country_pickers.dart' as CountryPickers;

class ChooseCountry extends StatefulWidget {
  @override
  _ChooseCountryState createState() => _ChooseCountryState();
}

class _ChooseCountryState extends State<ChooseCountry> {
  // form key
  GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();

  Map arguments;
  bool pop = false;

  @override
  Widget build(BuildContext context) {
    // pop or not
    arguments = ModalRoute.of(context).settings.arguments;
    if (arguments != null && arguments['pop'] != null) {
      pop = true;
    }

    // the countries
    List<Country> countries =
        Provider.of<CountryData>(context, listen: true).countries;

    Country selectedCountry =
        Provider.of<CountryData>(context, listen: true).selectedCountry;
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context).translate('Settings_Settings'),
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.grey[50],
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
      ),
      body: countries == null
          ? wait(context)
          : Center(
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(25.0),
                        bottomRight: Radius.circular(25.0))),
                margin: EdgeInsets.symmetric(horizontal: 25),
                width: double.infinity,
                height: 300,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: FormBuilder(
                        key: _fbKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            FormBuilderField<Country>(
                              name: 'country_name',
                              enabled: true,
                              initialValue: selectedCountry ?? countries[0],
                              validator:
                                  FormBuilderValidators.required(context),
                              builder: (field) => InputDecorator(
                                decoration: InputDecoration(
                                  labelText: AppLocalizations.of(context)
                                      .translate('Settings_Country'),
                                  border: InputBorder.none,
                                  errorText: field.errorText,
                                ),
                                child: CountryPickers.CountryPickerDropdown(
                                  initialValue: selectedCountry?.isoName ??
                                      countries[0].isoName,
                                  isFirstDefaultIfInitialValueNotProvided: true,
                                  onValuePicked: (value) {
                                    field.didChange(countries.firstWhere(
                                        (element) =>
                                            element.isoName == value.isoCode));
                                  },
                                  itemFilter: (country) {
                                    Country filterdCountry =
                                        countries.firstWhere(
                                            (element) =>
                                                element.isoName ==
                                                country.isoCode,
                                            orElse: () => null);

                                    if (filterdCountry != null) return true;
                                    return false;
                                  },
                                ),
                              ),
                            ),

                            // the lang
                            FormBuilderChoiceChip(
                              alignment: WrapAlignment.center,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                labelText: AppLocalizations.of(context)
                                    .translate('Settings_language'),
                              ),
                              spacing: 10,
                              name: 'lan',
                              initialValue: 'ar',
                              enabled: true,
                              validator: (value) {
                                if (value == null) {
                                  return 'You must choose a language!';
                                }
                                return null;
                              },
                              options: [
                                // FormBuilderFieldOption(
                                //   value: 'en',
                                //   child: Text(
                                //     'English',
                                //     style: TextStyle(
                                //       fontWeight: FontWeight.bold,
                                //       fontSize: 20,
                                //     ),
                                //   ),
                                // ),
                                FormBuilderFieldOption(
                                  value: 'ar',
                                  child: Text(
                                    'عربي',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        MaterialButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          ),
                          color: Theme.of(context).primaryColor,
                          child: Text(
                            AppLocalizations.of(context)
                                .translate('Settings_Submit'),
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () {
                            if (_fbKey.currentState.saveAndValidate()) {
                              var value = _fbKey.currentState.value;

                              Provider.of<CountryData>(context, listen: false)
                                  .setCountry(
                                      context: context,
                                      countryObject: value['country_name']);

                              // change the lang
                              Provider.of<AppSettings>(context, listen: false)
                                  .changeLanguage(value['lan']);
                              if (pop) {
                                Navigator.pop(context);
                              } else {
                                Navigator.pushReplacementNamed(
                                    context, '/home');
                              }
                            }
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
