import 'package:flutter/material.dart';

// colors
import 'package:lost/constants.dart';

class VerificationCode extends StatefulWidget {
  final ValueChanged<String> onCompleted;
  final ValueChanged<String> onChanged;
  final ValueChanged<bool> onEditing;
  final TextInputType keyboardType;
  final int length;
  final double itemSize;
  // in case underline color is null it will use primaryColor from Theme
  final Color underlineColor;
  final TextStyle textStyle;
  //TODO autofocus == true bug
  final bool autofocus;

  ///takes any widget, display it, when tap on that element - clear all fields
  final Widget clearAll;

  VerificationCode({
    Key key,
    @required this.onCompleted,
    @required this.onChanged,
    @required this.onEditing,
    this.keyboardType = TextInputType.number,
    this.length = 4,
    this.underlineColor,
    this.itemSize = 50,
    this.textStyle = const TextStyle(fontSize: 25.0),
    this.autofocus = false,
    this.clearAll,
  })  : assert(length > 0),
        assert(itemSize > 0),
        assert(onCompleted != null),
        assert(onChanged != null),
        assert(onEditing != null),
        super(key: key);

  @override
  _VerificationCodeState createState() => _VerificationCodeState();
}

class _VerificationCodeState extends State<VerificationCode> {
  List<FocusNode> _listFocusNode = <FocusNode>[];
  List<TextEditingController> _listControllerText = <TextEditingController>[];
  List<String> _code = [];
  int _currentIndex = 0;

  @override
  void initState() {
    _listFocusNode.clear();
    for (var i = 0; i < widget.length; i++) {
      _listFocusNode.add(FocusNode(debugLabel: '$i'));
      _listControllerText.add(TextEditingController());
      _code.add('');
    }
    super.initState();
  }

  String _getInputVerify() {
    String verifyCode = "";
    for (var i = 0; i < widget.length; i++) {
      for (var index = 0; index < _listControllerText[i].text.length; index++) {
        if (_listControllerText[i].text[index] != "") {
          verifyCode += _listControllerText[i].text[index];
        }
      }
    }
    return verifyCode;
  }

  Widget _buildInputItem(int index) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: mainLiteColor),
          ),
          child: TextField(
            keyboardType: widget.keyboardType,
            maxLines: 1,
            maxLength: 1,
            controller: _listControllerText[index],
            focusNode: _listFocusNode[index],
            showCursor: true,
            maxLengthEnforced: true,
            autocorrect: false,
            textAlign: TextAlign.center,
            autofocus: widget.autofocus,
            style: widget.textStyle,
            decoration: InputDecoration(
              // enabledBorder: UnderlineInputBorder(
              //   borderSide: BorderSide(color: Colors.grey),
              // ),
              // focusedBorder: UnderlineInputBorder(
              //   borderSide: BorderSide(
              //       color: widget.underlineColor ?? Theme.of(context).primaryColor),
              // ),
              border: InputBorder.none,
              counterText: "",
              contentPadding: EdgeInsets.all(((widget.itemSize * 2) / 10)),
              errorMaxLines: 1,
            ),
            // textInputAction: TextInputAction.previous,
            onChanged: (String value) {
              if ((_currentIndex + 1) == widget.length && value.length > 0) {
                widget.onEditing(false);
                widget.onChanged(_getInputVerify());
              } else {
                widget.onEditing(true);
                widget.onChanged(_getInputVerify());
              }

              if (value.length > 0 && index < widget.length ||
                  index == 0 && value.isNotEmpty) {
                if (index == widget.length - 1) {
                  widget.onCompleted(_getInputVerify());
                  return;
                }
                if (_listControllerText[index + 1].value.text.isEmpty) {
                  _listControllerText[index + 1].value =
                      TextEditingValue(text: "");
                }
                if (index < widget.length - 1) {
                  _next(index);
                }

                return;
              }
              if (value.length == 0 && index >= 0) {
                _prev(index);
              }
            },
          ),
        ),

        // some space
        // SizedBox(
        //   height: 7,
        // ),
        // // underLine
        // Container(
        //   decoration: BoxDecoration(
        //     color: Color(0xffdfc8b9),
        //     borderRadius: BorderRadius.circular(20),
        //     // border: Border.all(color: praimaryColor),
        //   ),
        //   width: widget.itemSize,
        //   height: 6,
        // ),
      ],
    );
  }

  void _next(int index) {
    if (index != widget.length - 1) {
      setState(() {
        _currentIndex = index + 1;
      });
      FocusScope.of(context).requestFocus(_listFocusNode[_currentIndex]);
    }
  }

  void _prev(int index) {
    if (index > 0) {
      setState(() {
        if (_listControllerText[index].text.isEmpty) {}
        _currentIndex = index - 1;
      });
      FocusScope.of(context).requestFocus(FocusNode());
      FocusScope.of(context).requestFocus(_listFocusNode[_currentIndex]);
    }
  }

  List<Widget> _buildListWidget() {
    List<Widget> listWidget = [];
    for (int index = 0; index < widget.length; index++) {
      double left = (index == 0) ? 0.0 : (widget.itemSize / 10);
      listWidget.add(Container(
          // height: widget.itemSize + 20,
          width: widget.itemSize,
          margin: EdgeInsets.only(left: left),
          child: _buildInputItem(index)));
    }
    return listWidget;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: _buildListWidget(),
            ),
            widget.clearAll != null
                ? _clearAllWidget(widget.clearAll)
                : Container(),
          ],
        ));
  }

  Widget _clearAllWidget(child) {
    return GestureDetector(
      onTap: () {
        widget.onEditing(true);
        for (var i = 0; i < widget.length; i++) {
          _listControllerText[i].text = '';
        }
        setState(() {
          _currentIndex = 0;
          FocusScope.of(context).requestFocus(_listFocusNode[0]);
        });
      },
      child: child,
    );
  }
}
