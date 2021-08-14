import 'package:flutter/material.dart';

import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:lost/models/appData.dart';
import 'package:lost/pages/forms/form2.dart';

import 'package:lost/pages/menu_once/design.dart';

import 'package:provider/provider.dart';

//language support
import 'package:lost/app_localizations.dart';

import 'package:lost/pages/wait.dart';

// the colors
import 'package:lost/constants.dart';

// the forms
import 'package:lost/pages/forms/accident_form.dart';
import 'package:lost/pages/forms/person_form.dart';
import 'package:lost/pages/forms/car_form.dart';
import 'package:lost/pages/forms/personal_belongings_form.dart';
import 'package:lost/pages/forms/form0.dart';
import 'package:lost/pages/forms/form1.dart';

class OperatioForm extends StatefulWidget {
  // if object selected is accident
  final bool accident;
  OperatioForm({this.accident});

  @override
  _OperatioFormState createState() => _OperatioFormState();
}

class _OperatioFormState extends State<OperatioForm> {
  // forms key

  // make list of the forms keys to access it with 'stage' integer
  final List<GlobalKey<FormBuilderState>> formsKeys =
      List.generate(4, (index) => GlobalKey<FormBuilderState>());

  // stage - this integer will help the form be like stages
  int stage = 0;

  // bool wait for uploading - true mean wait
  bool formWait = false;

  //the summation of the forms data
  Map<String, dynamic> data;

  // data needed to post from provider
  Map<String, String> envData;

  // the current logged in user
  String userToken;

  /// the logic to continue in the steps
  /// i Separates it to be able to use it inside the form
  void continueSteps() {
    var formKey = formsKeys[stage];
    // validate the currnt form
    if (formKey.currentState.saveAndValidate()) {
      // valid state form

      // add the form data to the global data var
      data.addAll(formKey.currentState.value);

      if (stage < 3) {
        // mean the form stages not completed
        setState(() {
          stage += 1;
        });
        return;
      }

      // now done with the forms
      // send the form

      //disable the button and wait
      setState(() {
        formWait = true;
      });

      // add the env data
      data.addAll(envData);

      try {
        Provider.of<PostData>(context, listen: false)
            .addOperation(data, userToken)
            .then((value) {
          // stop waiting
          setState(() {
            formWait = false;
          });
          if (value != null) {
            print(value);
          } else {
            // refresh the data
            Provider.of<OperationData>(context, listen: false)
                .reLoad(context: context);

            // pop the screen
            Navigator.of(context).pop();
          }
        });
      } catch (e) {
        // stop waiting
        setState(() {
          formWait = false;
        });
        throw e;
      }
    }
  }

  // the back button logic
  void backStep() {
    var formKey = formsKeys[stage];

    // add the form data to the global data var
    formKey.currentState.save();
    data.addAll(formKey.currentState.value);

    if (widget.accident && stage == 2) {
      // don't back from stage 3(index 2)
      Navigator.pop(context);
      return;
    }

    if (stage > 0) {
      setState(() {
        stage -= 1;
      });
    } else {
      Navigator.pop(context);
    }
  }

  @override
  void initState() {
    super.initState();

    data = {};

    // data needed to post from provider
    envData = {
      'country_id': Provider.of<CountryData>(context, listen: false)
          .selectedCountry
          .id
          .toString(),
    };

    if (widget.accident) {
      // the accident form only use two forms
      stage = 2;

      // the default data unique to 'Accident' object
      data.addAll({
        'object_type': Provider.of<AppSettings>(context, listen: false)
            .selectedObject
            .toString(),
        // not important field - just put the first in the list
        'type_id': Provider.of<TypeOperationData>(context, listen: false)
            .typeOperation[0]
            .id
            .toString(),
      });
    }
  }

  @override
  void didChangeDependencies() {
    userToken = Provider.of<UserData>(context, listen: false).token;

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    // the steps Decoration
    BoxDecoration stepsBoxDecoration = BoxDecoration(
      // color: Colors.grey[200],
      color: Colors.white,
      borderRadius: BorderRadius.circular(25),
    );

    EdgeInsets stepsPadding = EdgeInsets.all(8);

    EdgeInsets stepsMargin = EdgeInsets.only(top: 60);

    List<Step> steps = [
      Step(
        title: SizedBox.shrink(),
        isActive: stage == 0,
        state: stage > 0 ? StepState.complete : StepState.indexed,
        content: Container(
            decoration: stepsBoxDecoration,
            padding: stepsPadding,
            margin: stepsMargin,
            child:
                // form0(context, formsKeys[0], data, autoSubmit: continueSteps)
                Form0(
                    formKey: formsKeys[0],
                    data: data,
                    autoSubmit: continueSteps)),
      ),
      Step(
        title: SizedBox.shrink(),
        isActive: stage == 1,
        state: stage > 1 ? StepState.complete : StepState.indexed,
        content: Container(
            padding: stepsPadding,
            margin: stepsMargin,
            decoration: stepsBoxDecoration,
            child:
                // form1(context, formsKeys[1], data, autoSubmit: continueSteps)
                Form1(
                    formKey: formsKeys[1],
                    data: data,
                    autoSubmit: continueSteps)),
      ),
      Step(
        title: SizedBox.shrink(),
        isActive: stage == 2,
        state: stage > 2 ? StepState.complete : StepState.indexed,
        content: Container(
            padding: stepsPadding,
            decoration: stepsBoxDecoration,
            // child: form2(context, formsKeys[2], data)
            child: Form2(formKey: formsKeys[2], data: data)),
      ),
      Step(
        title: SizedBox.shrink(),
        isActive: stage == 3,
        state: stage > 3 ? StepState.complete : StepState.indexed,
        content: Container(
            padding: stepsPadding,
            decoration: stepsBoxDecoration,
            child:
                // chooseObjectForm(context, formsKeys[3], data, widget.accident)
                ChooseObjectForm(
                    formKey: formsKeys[3],
                    data: data,
                    isAccident: widget.accident)),
      ),
    ];

    Size screenSize = MediaQuery.of(context).size;

    return WillPopScope(
      onWillPop: () async {
        backStep();
        return false;
      },
      child: Scaffold(
        backgroundColor: scaffoldColor,
        body: SafeArea(
          child: Stack(children: [
            // the image in the back
            BackgrounDesign(),

            // the Top close icon
            Positioned(
                top: 5,
                // right: 2,
                child: IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: Icon(
                      Icons.close,
                      size: 35,
                      color: Colors.red,
                    ))),

            // the BIG Tiltel
            Positioned(
              top: 40,
              child: Container(
                width: screenSize.width,
                child: Center(
                  child: Text(
                    'إضافة',
                    style: TextStyle(
                        color: mainTextColor,
                        fontSize: 42,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),

            // the data
            Container(
              margin:
                  EdgeInsets.only(top: 130, bottom: 10, right: 10, left: 10),
              padding: EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                // color: Colors.white,
                // color: liteBackground,
                color: mainDarkColor.withOpacity(0.7),
                borderRadius: BorderRadius.circular(25),
              ),
              clipBehavior: Clip.hardEdge,
              width: screenSize.width,
              height: screenSize.height,
              child: Stepper(
                type: StepperType.horizontal,
                currentStep: stage,
                steps: steps,
                onStepContinue: () {},
                onStepCancel: backStep,
                controlsBuilder: (context,
                    {VoidCallback onStepContinue, VoidCallback onStepCancel}) {
                  return
                      // wait
                      formWait
                          ? Container(
                              margin: EdgeInsets.symmetric(vertical: 5),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'الرجاء الانتظار',
                                    textDirection: TextDirection.rtl,
                                    textAlign: TextAlign.right,
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SpinKitThreeBounce(
                                    color: Colors.white,
                                    size: 25.0,
                                  ),
                                ],
                              ),
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                // Submit
                                Expanded(
                                  child: MaterialButton(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                    ),
                                    color: Theme.of(context).primaryColor,
                                    child: Text(
                                      AppLocalizations.of(context)
                                          .translate('operatioForm_Submit'),
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    onPressed: () {
                                      continueSteps();
                                    },
                                  ),
                                ),

                                // cancel
                                Expanded(
                                  child: MaterialButton(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(18.0),
                                        side: BorderSide(color: Colors.red)),
                                    color: Colors.red,
                                    child: Text(
                                      AppLocalizations.of(context)
                                          .translate('operatioForm_Cancel'),
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    onPressed: () {
                                      //_fbKey.currentState.reset();
                                      onStepCancel();
                                    },
                                  ),
                                ),
                              ],
                            );
                },
              ),
            ),
          ]),
        ),
      ),
    );
  }
}

class ChooseObjectForm extends StatelessWidget {
  final Map<dynamic, dynamic> data;

  final bool isAccident;

  final GlobalKey<FormBuilderState> formKey;

  ChooseObjectForm({
    @required this.data,
    @required this.isAccident,
    @required this.formKey,
  });

  @override
  Widget build(BuildContext context) {
    String object = data['object_type'] ?? '';
    if (isAccident) {
      // accident form
      return FormAccident(formKey: formKey, data: data);
    } else if (object == 'Person') {
      return formPerson(context, formKey, data);
    } else if (object == 'Car') {
      return formCar(context, formKey, data);
    } else if (object == 'PersonalBelongings') {
      return FormPersonalBelongings(
        formKey: formKey,
        data: data,
      );
    }

    // default form if the user not select a form yet
    return formPerson(context, formKey, data);
  }
}
