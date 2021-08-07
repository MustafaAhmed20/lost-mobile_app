import 'package:flutter/material.dart';

import 'package:lost/widgets/text_input.dart';

// colors
import 'package:lost/constants.dart';

//
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:percent_indicator/percent_indicator.dart';

import 'dart:async';

class ProcessAndWait extends StatefulWidget {
  final Future<String> process;

  int expectedWaitTimeInSeconds;

  // if Error message show up - the time will keep the screen before pop it
  final int errorWaitSeconds;

  ProcessAndWait({
    @required this.process,
    int expectedWaitTimeInSeconds,
    this.errorWaitSeconds = 4,
  }) {
    if ((expectedWaitTimeInSeconds ?? -1) < 0)
      this.expectedWaitTimeInSeconds = 0;
    else
      this.expectedWaitTimeInSeconds = expectedWaitTimeInSeconds;
  }

  @override
  _ProcessAndWaitState createState() => _ProcessAndWaitState();
}

class _ProcessAndWaitState extends State<ProcessAndWait> {
  String errorMessage;
  bool isDone = false;

  // is the proccess success
  bool success;

  DateTime workStartTime;

  Future work() async {
    await widget.process.then((val) {
      if (val == null) {
        // no error message - pop the screen
        setState(() {
          success = true;
          isDone = true;
        });

        // popScreen();
      } else {
        setState(() {
          errorMessage = val;
          success = false;
          // pop the small screen
          if (waitScreenResult != null) {
            Navigator.of(context).pop(success);
          }

          // remove the screen after some time with false success
          Future.delayed(Duration(seconds: widget.errorWaitSeconds)).then((v) {
            setState(() {
              isDone = true;
              errorMessage = null;
            });
          });
        });
      }
    });
  }

  void popScreen() => Navigator.of(context).pop(success);

  // this used for re call the page if the user clicked back
  Future waitScreenResult;

  void showSmallScreen(BuildContext context) async {
    if (isDone) return;
    // show the page
    waitScreenResult = showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => WaitScreen(
        errorMessage: errorMessage,
        expectedWaitTimeDuration: workStartTime
            .add(Duration(seconds: widget.expectedWaitTimeInSeconds))
            .difference(DateTime.now()),
      ),
    ).then((v) {
      setState(() {
        waitScreenResult = null;
      });
    });
  }

  @override
  void initState() {
    // the start working moment
    workStartTime = DateTime.now();

    // start the prccess
    work();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (waitScreenResult == null && !isDone) {
      Future.delayed(Duration(seconds: 0)).then((val) {
        showSmallScreen(context);
      });
    }
    if (isDone) {
      Future.delayed(Duration(seconds: 0)).then((v) {
        popScreen();
      });
    }

    return WillPopScope(
      onWillPop: () async => false,
      child: Container(
        color: Colors.transparent,
      ),
    );
  }
}

class WaitScreen extends StatefulWidget {
  final String errorMessage;
  final Duration expectedWaitTimeDuration;

  WaitScreen(
      {@required this.errorMessage, @required this.expectedWaitTimeDuration});

  @override
  _WaitScreenState createState() => _WaitScreenState();
}

class _WaitScreenState extends State<WaitScreen> {
  Timer _timer;

  double percent = 0.0;

  double incrementSize = 0.0;

  // spliter speed points
  List<double> speedSplitersPoints = [
    0.5,
    0.75,
    0.875,
    0.9,
    0.92,
    0.95,
    0.98,
    0.99
  ];

  @override
  void initState() {
    if (widget.expectedWaitTimeDuration != null) {
      incrementSize = 100 / (widget.expectedWaitTimeDuration?.inSeconds ?? 100);

      _timer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
        setState(() {
          percent += (incrementSize / 100);
          if (percent > 1.0) {
            // stop increment
            percent = 1.0;
          }
        });
        // split speed
        if (speedSplitersPoints.isNotEmpty) {
          if (percent >= speedSplitersPoints[0]) {
            incrementSize /= 2;
            speedSplitersPoints.removeAt(0);
          }
        }
      });
    }
    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    return WillPopScope(
      onWillPop: () async => false,
      child: Dialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        child: Container(
          height: screenSize.height / 3,
          padding: EdgeInsets.only(left: 10, right: 30, top: 30, bottom: 30),
          decoration: BoxDecoration(
            color: Colors.white,
            // color: Colors.red,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // wait Text
                Text(
                  'الرجاء الانتظار',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),

                widget.errorMessage == null
                    ?
                    //
                    widget.expectedWaitTimeDuration?.isNegative ?? true
                        ? SpinKitThreeBounce(
                            color: mainDarkColor,
                            size: 30.0,
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CircularPercentIndicator(
                                radius: 130.0,
                                // animation: true,
                                // animationDuration:
                                //     widget.expectedWaitTimeDuration.inMilliseconds,
                                lineWidth: 10.0,

                                // percent: 1,
                                percent: percent,
                                center: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      "جاري الرفع",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20.0),
                                    ),

                                    // The percent
                                    Text(
                                        '%${(percent * 100).toStringAsFixed(1)}'),
                                  ],
                                ),
                                circularStrokeCap: CircularStrokeCap.butt,
                                backgroundColor: textColorHint,
                                progressColor: mainDarkColor,
                              ),

                              // text
                              Container(
                                margin: EdgeInsets.only(top: 10),
                                child: Text(
                                  'قد يأخذ الرفع وقت يصل الى 10 دقائق بحسب عدد الصور',
                                  style: TextStyle(
                                    fontSize: 9,
                                  ),
                                ),
                              ),
                            ],
                          )
                    :
                    // Error Message
                    Expanded(
                        child: ErrorBox(
                          message: widget.errorMessage,
                        ),
                      )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ErrorBox extends StatelessWidget {
  String message;
  ErrorBox({@required this.message});
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'خطأ',
          textAlign: TextAlign.right,
          style: TextStyle(
            color: textColorRedError,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Expanded(
          child: TextInput(
            multiLine: true,
            readOnly: true,
            controller: TextEditingController(text: message),
            borderColor: textColorRedError,
          ),
        ),
      ],
    );
  }
}
