import 'package:flutter/material.dart';

// the contents colors
import 'package:lost/constants.dart';

// logic code
import 'package:lost/pages/menu_once/logic.dart';

// provider
import 'package:provider/provider.dart';

// data classes
import 'package:lost/models/appData.dart';
import 'package:lost/models/operation/operation.dart';

// form builder
import 'package:flutter_form_builder/flutter_form_builder.dart';

import 'package:country_pickers/country_pickers.dart' as CountryPickers;

class Welcome extends StatefulWidget {
  final String mode;
  final Function onDismiss;
  Welcome({
    @required this.mode,
    @required this.onDismiss,
  });
  @override
  _WelcomeState createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  // this for info mode - if true mean the user clicked on (don't show again)
  bool dontShowAgain = false;
  void changeShowStatus() {
    setState(() {
      dontShowAgain = !dontShowAgain;
    });

    // save the settings
    setDontShowWelcomeMassege(dontShowAgain);
  }

  void dismiss() {
    // in the language mode dont use this
    if (widget.mode != 'welcome') {
      return;
    }
    widget.onDismiss(context);
  }

  @override
  Widget build(BuildContext context) {
    int sensitivity = 6;
    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        if (details.delta.dx > sensitivity || details.delta.dx < -sensitivity) {
          dismiss();
        }
      },
      onTap: () {
        dismiss();
      },
      child: Stack(
        children: [
          // hover color
          Opacity(
              opacity: 0.9,
              child: Container(
                color: hoverColor,
              )),

          widget.mode == 'welcome'
              ? Info(
                  dontShowAgain: dontShowAgain,
                  onDontShowAgain: changeShowStatus,
                )
              : widget.mode == 'language'
                  ?
                  // the main screen
                  Language(
                      dismissFun: widget.onDismiss,
                    )

                  // country page
                  : widget.mode == 'country'
                      ? CountryPage(
                          dismissFun: widget.onDismiss,
                        )
                      : SizedBox.shrink(),
        ],
      ),
    );
  }
}

class CountryPage extends StatelessWidget {
  final Function dismissFun;
  CountryPage({@required this.dismissFun});

  // form key
  GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    // the countries
    List<Country> countries =
        Provider.of<CountryData>(context, listen: true).countries;

    Country selectedCountry =
        Provider.of<CountryData>(context, listen: true).selectedCountry;

    return Container(
      width: screenSize.width,
      height: screenSize.height,
      child: Column(
        children: [
          // some space from top
          Expanded(
            flex: 1,
            child: Container(),
          ),

          // the main part
          Expanded(
            flex: 4,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // choose language Text
                Text(
                  'اختر الدولة',
                  style: TextStyle(
                    color: mainTextColor,
                    fontSize: 40,
                    height: 0.60,
                  ),
                ),
                Text(
                  'select country',
                  style: TextStyle(
                    color: mainTextColor,
                    fontSize: 20,
                  ),
                ),

                // some space
                SizedBox(
                  height: 30,
                ),

                // country form
                Container(
                  color: Colors.white,
                  margin: EdgeInsets.symmetric(horizontal: 50),
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: FormBuilder(
                    key: _fbKey,

                    child: FormBuilderField<Country>(
                      name: 'country_name',
                      enabled: true,
                      initialValue: null,
                      validator: FormBuilderValidators.required(context),
                      builder: (field) => InputDecorator(
                        decoration: InputDecoration(border: InputBorder.none),
                        child: CountryPickers.CountryPickerDropdown(
                          initialValue:
                              selectedCountry?.isoName ?? countries[0].isoName,
                          isFirstDefaultIfInitialValueNotProvided: true,
                          onValuePicked: (value) {
                            field.didChange(countries.firstWhere(
                                (element) => element.isoName == value.isoCode));
                          },
                          itemFilter: (country) {
                            Country filterdCountry = countries.firstWhere(
                                (element) => element.isoName == country.isoCode,
                                orElse: () => null);

                            if (filterdCountry != null) return true;
                            return false;
                          },
                        ),
                      ),
                    ),

                    // FormBuilderCountryPicker(
                    //   attribute: 'country_name',
                    //   decoration: InputDecoration(border: InputBorder.none),
                    //   initialValue: null,
                    //   countryFilterByIsoCode: countries != null
                    //       ? countries.map((e) => e.isoName.toString()).toList()
                    //       : [],
                    //   validators: [FormBuilderValidators.required()],
                    // ),
                  ),
                ),

                // some space
                SizedBox(
                  height: 20,
                ),

                // submit button
                InkWell(
                  onTap: () {
                    // set the country
                    if (_fbKey.currentState.saveAndValidate()) {
                      var value = _fbKey.currentState.value;

                      Provider.of<CountryData>(context, listen: false)
                          .setCountry(
                              context: context,
                              countryObject: value['country_name']);
                      // dismiss the screen
                      dismissFun(context);
                    }
                  },
                  child: Container(
                    width: 200,
                    height: 50,
                    decoration: BoxDecoration(
                        color: mainLiteColor,
                        borderRadius: BorderRadius.all(Radius.circular(15))),
                    child: Center(
                      child: Text(
                        'choose',
                        style: TextStyle(
                          color: mainTextColor,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // icon
          Expanded(
            flex: 2,
            child: getIcon(),
          ),
        ],
      ),
    );
  }
}

class Info extends StatelessWidget {
  bool dontShowAgain;
  Function() onDontShowAgain;

  Info({@required this.dontShowAgain, @required this.onDontShowAgain});

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    return Container(
      width: screenSize.width,
      height: screenSize.height,
      child: Column(
        children: [
          // the info icon
          Expanded(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Image.asset(
                  'imeges/info.jpg',
                  color: mainTextColor,
                  scale: 10,
                ),
              ],
            ),
          ),

          // the text
          Expanded(
            flex: 2,
            child: Container(
              padding: EdgeInsets.only(right: 20, left: 10),
              child: Center(
                child: Text(
                  infoText,
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    color: mainTextColor,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          ),

          // don't show this page again button
          InkWell(
            onTap: onDontShowAgain,
            child: Container(
              width: screenSize.width,
              padding: EdgeInsets.symmetric(horizontal: 20),
              height: 40,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // the text
                  Text(
                    'لا تظهر هذه الرسالة مرة أخرى',
                    style: TextStyle(
                      color: mainTextColor,
                    ),
                  ),

                  // the check Box
                  Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      // color: Colors.blue,
                      border: Border.all(color: mainTextColor),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: dontShowAgain
                        ? Icon(
                            Icons.check,
                            color: mainTextColor,
                          )
                        : SizedBox.shrink(),
                  ),
                ],
              ),
            ),
          ),

          // the bottom icon
          Expanded(
            flex: 1,
            child: getIcon(),
          ),
        ],
      ),
    );
  }
}

class Language extends StatelessWidget {
  final Function dismissFun;
  Language({@required this.dismissFun});
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    return Container(
      width: screenSize.width,
      height: screenSize.height,
      child: Column(
        children: [
          // some space from top
          Expanded(
            flex: 1,
            child: Container(),
          ),

          // the main part
          Expanded(
            flex: 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // choose language Text
                Text(
                  'اختر اللغة',
                  style: TextStyle(
                    color: mainTextColor,
                    fontSize: 40,
                    height: 0.60,
                  ),
                ),
                Text(
                  'select language',
                  style: TextStyle(
                    color: mainTextColor,
                    fontSize: 20,
                  ),
                ),

                // some space
                SizedBox(
                  height: 30,
                ),

                // arabic button
                InkWell(
                  onTap: () {
                    // set the lang
                    setLang(context, 'ar');

                    // dismiss
                    dismissFun(context);
                  },
                  child: LanguageButton(
                      color: mainLiteColor,
                      textColor: mainTextColor,
                      text: 'عربي'),
                ),

                // some space
                SizedBox(
                  height: 15,
                ),

                // English button
                InkWell(
                  onTap: () {
                    // set the lang
                    setLang(context, 'en');

                    // dismiss
                    dismissFun(context);
                  },
                  child: LanguageButton(
                      textColor: otherTextColor,
                      color: mainTextColor,
                      text: 'English'),
                ),
              ],
            ),
          ),

          // icon
          Expanded(
            flex: 1,
            child: getIcon(),
          ),
        ],
      ),
    );
  }
}

class LanguageButton extends StatelessWidget {
  Color color;
  Color textColor;
  String text;
  LanguageButton({this.color, this.textColor, this.text});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 230,
      height: 50,
      decoration: BoxDecoration(
        color: color,
        border: Border.all(style: BorderStyle.none),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}
