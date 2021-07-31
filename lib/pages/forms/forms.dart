import 'package:flutter/material.dart';

import 'package:flutter_form_builder/flutter_form_builder.dart';

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
  Map data;

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
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      // wait
                      formWait ? wait(context) : SizedBox.shrink(),
                      // Submit
                      Expanded(
                        child: formWait
                            ? SizedBox.shrink()
                            : MaterialButton(
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
                        child: formWait
                            ? SizedBox.shrink()
                            : MaterialButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
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
      return FormPersonalBelongings(formKey: formKey);
    }

    // default form if the user not select a form yet
    return formPerson(context, formKey, data);
  }
}

// Widget form2(context, formKey, data) {
//   // current time
//   DateTime now = new DateTime.now();

//   // this help make the date with the correct format
//   var formatter = new DateFormat('yyyy-MM-dd');
//   return FormBuilder(
//     key: formKey,
//     autovalidateMode: AutovalidateMode.always,
//     child: Column(
//       children: [
//         Text(
//           AppLocalizations.of(context)
//               .translate('operatioForm_operatioDetails'),
//           style: TextStyle(fontSize: 20),
//         ),
//         // date
//         FormBuilderDateTimePicker(
//           name: "date",
//           initialValue:
//               data['date'] != null ? DateTime.parse(data['date']) : now,
//           inputType: InputType.date,
//           format: formatter,
//           lastDate: now,
//           decoration: InputDecoration(
//               labelText:
//                   AppLocalizations.of(context).translate('operatioForm_date')),
//           validator: FormBuilderValidators.required(context),
//           valueTransformer: (value) {
//             if (value != null) {
//               return formatter.format(value);
//             }
//             return value;
//           },
//         ),

//         Row(
//           children: [
//             // state

//             Expanded(
//               child: FormBuilderTextField(
//                 name: 'state',
//                 initialValue: data['state'] ?? null,
//                 decoration: InputDecoration(
//                   border: InputBorder.none,
//                   labelText: AppLocalizations.of(context)
//                       .translate('operatioForm_state'),
//                   alignLabelWithHint: true,
//                 ),
//                 validator: FormBuilderValidators.required(context,
//                     errorText: AppLocalizations.of(context)
//                         .translate('operatioForm_requiredError')),
//               ),
//             ),

//             // city
//             Expanded(
//               child: FormBuilderTextField(
//                 name: 'city',
//                 initialValue: data['city'] ?? null,
//                 decoration: InputDecoration(
//                   border: InputBorder.none,
//                   labelText: AppLocalizations.of(context)
//                       .translate('operatioForm_city'),
//                   alignLabelWithHint: true,
//                 ),
//                 validator: FormBuilderValidators.required(context,
//                     errorText: AppLocalizations.of(context)
//                         .translate('operatioForm_requiredError')),
//               ),
//             ),
//           ],
//         ),

//         // details
//         /*
//         FormBuilderTextField(
//           name: 'details',
//           initialValue: data['details'] ?? null,
//           decoration: InputDecoration(
//             labelText:
//                 AppLocalizations.of(context).translate('operatioForm_details'),
//             alignLabelWithHint: true,
//           ),
//         ),
//         */
//         // photos
//         FormBuilderField<List<File>>(
//           name: "photos",
//           initialValue: data['photos'] ?? null,
//           builder: (field) => InputDecorator(
//             decoration: InputDecoration(
//               labelText:
//                   AppLocalizations.of(context).translate('operatioForm_photos'),
//               border: InputBorder.none,
//             ),
//             child: Container(
//               margin: EdgeInsets.only(top: 10),
//               child: PhotosUploaderBox(
//                 oldFilePhotos: data['photos'] ?? [],
//                 onChange: (c, photos) {
//                   field.didChange(photos.map((e) => e.image).toList());
//                 },
//               ),
//             ),
//           ),
//         ),

//         // FormBuilderImagePicker(
//         //   initialValue: data['photos'] ?? null,
//         //   decoration: InputDecoration(border: InputBorder.none),
//         //   labelText:
//         //       AppLocalizations.of(context).translate('operatioForm_photos'),
//         //   imageQuality: 70,
//         //   maxImages: 5,
//         //   name: "photos",
//         // ),

//         // Gps location

//         FormBuilderField(
//             initialValue: data['location'] ?? null,
//             name: 'location',
//             builder: (field) => FormField(
//                   enabled: true,
//                   builder: (FormFieldState<dynamic> field) => Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       // the labelText
//                       Text(
//                         'اختر الموقع:',
//                       ),

//                       // the button
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceAround,
//                         children: <Widget>[
//                           // RaisedButton(
//                           ElevatedButton(
//                             child: Text(AppLocalizations.of(context)
//                                 .translate('operatioForm_Chooselocation')),
//                             onPressed: () async {
//                               // first check the Gps
//                               bool gps = false;
//                               await checkGps().then((value) => gps = value);
//                               if (!gps) {
//                                 // no gps - show alert massege
//                                 showDialog(
//                                   //barrierDismissible: false,
//                                   context: context,
//                                   builder: (BuildContext context) {
//                                     return Dialog(
//                                       child: AlertDialog(
//                                         shape: RoundedRectangleBorder(
//                                             borderRadius: BorderRadius.all(
//                                                 Radius.circular(32.0))),
//                                         actionsPadding: EdgeInsets.symmetric(
//                                             horizontal: 50),
//                                         title: Text(AppLocalizations.of(context)
//                                             .translate(
//                                                 'operatioForm_ActivateGps')),
//                                         content: Container(
//                                           child: Column(
//                                             mainAxisAlignment:
//                                                 MainAxisAlignment.spaceEvenly,
//                                             mainAxisSize: MainAxisSize.min,
//                                             crossAxisAlignment:
//                                                 CrossAxisAlignment.stretch,
//                                             children: <Widget>[
//                                               Text(AppLocalizations.of(context)
//                                                   .translate(
//                                                       'operatioForm_PleaseActivate')),
//                                               RaisedButton(
//                                                 shape: RoundedRectangleBorder(
//                                                   borderRadius:
//                                                       BorderRadius.circular(
//                                                           18.0),
//                                                 ),
//                                                 color: Theme.of(context)
//                                                     .primaryColor,
//                                                 textColor: Colors.white,
//                                                 child: Text("OK"),
//                                                 onPressed: () {
//                                                   Navigator.of(context).pop();
//                                                 },
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//                                       ),
//                                     );
//                                   },
//                                 );
//                               } else {
//                                 await Navigator.pushNamed(context, '/map')
//                                     .then((value) {
//                                   field.didChange(value);
//                                 });
//                               }
//                             },
//                           ),
//                           Icon(
//                             field.value == null ? null : Icons.check_circle,
//                             color: field.value == null ? null : Colors.green,
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 )),
//       ],
//     ),
//   );
// }
