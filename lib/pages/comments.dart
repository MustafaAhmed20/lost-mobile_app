import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:lost/pages/menu_once/design.dart';
import 'package:lost/pages/wait.dart';

import 'package:provider/provider.dart';
import 'package:lost/models/appData.dart';
import 'package:lost/models/operation.dart';

// the colors
import 'package:lost/constants.dart';

// format time
import 'package:intl/intl.dart';

class Comments extends StatefulWidget {
  Operations operation;

  Comments({
    @required this.operation,
  });
  @override
  _CommentsState createState() => _CommentsState();
}

class _CommentsState extends State<Comments> {
  bool waitForSend = false;

  // load the comments
  Future loadComments() async {
    // the current logged in user if any
    String userToken = Provider.of<UserData>(context, listen: false).token;

    // load the comments
    Provider.of<OperationData>(context, listen: false)
        .loadComments(operation: widget.operation, userToken: userToken)
        .then((val) {
      // refresh the page
      setState(() {});
    });
  }

  Future sendComment(BuildContext context, String comment) async {
    // wait
    setState(() {
      waitForSend = true;
    });

    // the current logged in user if any
    String userToken = Provider.of<UserData>(context, listen: false).token;

    await Provider.of<OperationData>(context, listen: false).sendComment(
      operation: widget.operation,
      text: comment,
      userToken: userToken,
    );

    // reload the comments
    loadComments();

    setState(() {
      waitForSend = false;
    });
  }

  @override
  void initState() {
    // load the comments
    loadComments();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // the comments
    List<Comment> comments = widget.operation.comments;
    Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: scaffoldColor,
      body: Stack(
        children: [
          SafeArea(
            child: BackgrounDesign(
              useDesign2: true,
            ),
          ),

          // the menu icon
          Positioned(
            top: 40,
            right: 0,
            child: InkWell(
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                height: 50,
                width: 35,
                color: Colors.white,
                child: Icon(Icons.arrow_back),
              ),
            ),
          ),

          // the BIG Tiltel
          Positioned(
            top: 50,
            child: Container(
              width: screenSize.width,
              child: Center(
                child: Text(
                  'التعليقات',
                  style: TextStyle(
                      color: mainTextColor,
                      fontSize: 30,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),

          // the content
          Container(
            height: screenSize.height,
            width: screenSize.width,
            margin: EdgeInsets.only(top: 200, right: 20, left: 20, bottom: 20),
            // padding: EdgeInsets.only(left: 10, right: 10),
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              // color: Colors.red,
              border: Border.all(color: mainDarkColor),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25),
                topRight: Radius.circular(25),
              ),
            ),
            child: Column(
              children: [
                // header
                Container(
                  height: 50,
                  color: mainDarkColor,
                ),

                // the masseges
                Expanded(
                  child: ListView.builder(
                    // scroll from donw up
                    reverse: true,
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemCount: comments?.length ?? 0,
                    itemBuilder: (BuildContext context, int index) {
                      int length = comments?.length ?? 0;

                      return ChatMessageBox(
                        // reversed the list so the last message on top

                        message: comments[length - (1 + index)],
                      );
                    },
                  ),
                ),

                // new massege box
                waitForSend
                    ? wait(context)
                    : NewMessageBox(
                        onNewMessage: sendComment,
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ChatMessageBox extends StatelessWidget {
  Comment message;

  ChatMessageBox({
    @required this.message,
  });

  @override
  Widget build(BuildContext context) {
    // formate time & date
    String formattedTime = DateFormat.jm().format(message?.time) ?? null;
    String formattedDate =
        DateFormat('dd-MMM-yyyy').format(message?.time) ?? null;
    Size screenSize = MediaQuery.of(context).size;

    // user id
    String userId =
        Provider.of<UserData>(context, listen: false).user?.publicId ?? null;

    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(vertical: 5),
      padding: EdgeInsets.only(left: 10, right: 10),
      child: Column(
        children: [
          // the date & name
          Container(
            padding:
                // this message sent by user
                message.user.publicId == userId
                    ? EdgeInsets.only(right: (15 / 100) * screenSize.width)
                    : EdgeInsets.zero,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // date & time
                Text(
                  '$formattedDate   $formattedTime',
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.black,
                  ),
                ),

                // the name
                Text(
                  message.user.name,
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.black,
                  ),
                )
              ],
            ),
          ),

          // the message
          Row(
            mainAxisAlignment:
                // this message sent by user
                MainAxisAlignment.start,
            // message.user.publicId == userId
            //     ? MainAxisAlignment.start
            //     : MainAxisAlignment.end,
            children: [
              Container(
                width: (70 / 100) * screenSize.width,
                height: 100,
                decoration: BoxDecoration(
                  color:
                      // this message sent by user
                      message.user.publicId == userId
                          ? textColorHint
                          : textColorHint,
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.only(top: 15, right: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // the message
                    Flexible(
                      child: Text(
                        message.text,
                        textAlign: TextAlign.right,
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class NewMessageBox extends StatefulWidget {
  Function(BuildContext, String) onNewMessage;

  NewMessageBox({
    @required this.onNewMessage,
  });

  @override
  _NewMessageBoxState createState() => _NewMessageBoxState();
}

class _NewMessageBoxState extends State<NewMessageBox> {
  Function onUploadFileOrImage = (BuildContext context) {};

  GlobalKey<FormBuilderState> formKey = GlobalKey<FormBuilderState>();

  void submit(BuildContext context) {
    if (!formKey.currentState.saveAndValidate()) {
      return;
    }

    // get the value
    String textValue = formKey.currentState.value['text'];

    // only if the input is validated so call the main func

    widget.onNewMessage(
      context,
      textValue,
    );

    // clear the text
    formKey.currentState.reset();

    // close the keybord
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Container(
        padding: EdgeInsets.only(right: 30, left: 15, top: 5, bottom: 5),
        height: 125,
        width: double.infinity,
        color: Colors.grey[300],
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // Message input
            Expanded(
              child: Container(
                // height: 50,
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: mainDarkColor),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: FormBuilder(
                  key: formKey,
                  child: FormBuilderTextField(
                    attribute: 'text',
                    maxLines: 5,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'تعليقك هنا',
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 12)),
                    validators: [
                      FormBuilderValidators.required(
                          errorText: 'رجاء ادخل تعليقك'),
                    ],
                  ),
                ),
              ),
            ),

            // send button
            InkWell(
              onTap: () => submit(context),
              child: Container(
                height: 40,
                width: 100,
                margin: EdgeInsets.only(top: 5),
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(
                  color: mainDarkColor,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Center(
                  child: Text(
                    'ارسال',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ]);
  }
}
