import 'package:flutter/material.dart';
import 'wait.dart';

//language support
import 'package:lost/app_localizations.dart';

// import the app data
import 'package:lost/models/appData.dart';
import 'package:provider/provider.dart';

import 'snackBars.dart';

class FeedBack extends StatefulWidget {
  @override
  _FeedBackState createState() => _FeedBackState();
}

class _FeedBackState extends State<FeedBack> {
  // wait for submitting
  bool waiting = false;

  // Create a text controller and use it to retrieve the current value
  // of the TextField.
  final myController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // the current logged in user if any
    String userToken = Provider.of<UserData>(context, listen: false).token;

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).translate('home_FeedBack')),
      ),
      body: SingleChildScrollView(
        child: Builder(
          // use Builder to have new context to show snakbar
          builder: (BuildContext context) => Container(
            margin: EdgeInsets.symmetric(horizontal: 30, vertical: 50),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  AppLocalizations.of(context).translate('home_FeedBack'),
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 30,
                ),
                Container(
                  height: 200,
                  width: double.infinity,
                  child: TextFormField(
                    controller: myController,
                    maxLines: 8,
                    minLines: null,
                    //expands: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.greenAccent, width: 3.0),
                        borderRadius: BorderRadius.circular(18.0),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                waiting
                    ? wait(context)
                    : RaisedButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                        ),
                        color: Theme.of(context).primaryColor,
                        child: Text(
                          AppLocalizations.of(context)
                              .translate('feedback_Send'),
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () {
                          // no empty feed back
                          if (myController.text == '') {
                            // show error massege
                            Scaffold.of(context).showSnackBar(
                                customErrorSnackBar(
                                    context,
                                    AppLocalizations.of(context)
                                        .translate('feedback_errorEmpty')));

                            return;
                          }

                          // wait
                          setState(() {
                            waiting = true;
                          });

                          // send the feedback
                          Provider.of<PostData>(context, listen: false)
                              .addFeedBack(myController.text,
                                  userToken: userToken)
                              .then((value) {
                            // disable waiting
                            setState(() {
                              waiting = false;
                            });
                            if (value != null) {
                              // show error massege
                              Scaffold.of(context).showSnackBar(
                                  customErrorSnackBar(context, "value"));
                            }
                            // success
                            myController.clear();
                            // pop with succes massege
                            Navigator.pop(context, {'feedback': true});
                          });
                        },
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
