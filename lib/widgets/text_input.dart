import 'package:flutter/material.dart';

// the colors
import 'package:lost/constants.dart';

// sizer
import 'package:sizer/sizer.dart';

class TextInput extends StatefulWidget {
  TextAlign textAlign;
  double textSize;
  Color textColor;

  Color borderColor;
  Color backgroundColor;

  double textPaddingFromEdge;

  double height;

  double borderRadius;

  String hintText;
  TextStyle hintStyle;

  bool multiLine;
  bool readOnly;
  bool isPassword;

  TextInputType keyboardType;

  // the controllers to get the text

  // the key
  GlobalKey<FormState> formKey;

  // the Controller
  TextEditingController controller;

  // the validate func
  Function validate;

  TextStyle errorStyle;

  // onChange func
  Function(BuildContext, String) onChange;

  // show border
  bool showBorder;

  TextInput({
    this.textAlign = TextAlign.right,
    this.textSize = 14,
    this.textColor = textColorDarkBlack,
    this.borderColor = textColorHint,
    this.textPaddingFromEdge = 10,
    this.backgroundColor = Colors.white,
    this.height = 8,
    this.borderRadius = 15,
    this.hintText = '',
    this.multiLine = false,
    this.hintStyle = const TextStyle(color: textColorHint, fontSize: 12),
    this.readOnly = false,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    this.errorStyle = const TextStyle(fontSize: 10),
    this.onChange,

    //
    this.showBorder = true,
    this.formKey,
    this.controller,
    this.validate,
  });

  @override
  _TextInputState createState() => _TextInputState();
}

class _TextInputState extends State<TextInput> {
  // temp value if no value passed
  TextEditingController tempController = TextEditingController();

  GlobalKey<FormState> tempformKey = GlobalKey<FormState>();

  GlobalKey<FormState> formKey;

  /// return True if there validation error else false
  bool showErrorOuterBorder() {
    // in error
    if (!(formKey?.currentState?.validate() ?? true)) {
      return true;
    }

    return false;
  }

  @override
  void initState() {
    formKey = widget.formKey != null ? widget.formKey : tempformKey;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: widget.height.h,
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        borderRadius: BorderRadius.circular(widget.borderRadius),
        border: Border.all(
            color: !widget.showBorder
                ? Colors.transparent
                : showErrorOuterBorder()
                    ? textColorRedError
                    : widget.borderColor),
      ),
      clipBehavior: Clip.hardEdge,
      child: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: Form(
          key: formKey,
          child: TextFormField(
            onChanged: (val) {
              if (widget.onChange != null) widget.onChange(context, val);

              // rebuild so if there is error the border change color
              setState(() {});
            },
            validator: (value) =>
                widget.validate != null ? widget.validate(value) : null,
            controller:
                widget.controller != null ? widget.controller : tempController,
            textAlignVertical: TextAlignVertical.center,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            obscureText: widget.isPassword,
            textAlign: widget.textAlign,
            readOnly: widget.readOnly,
            keyboardType: widget.multiLine
                ? TextInputType.multiline
                : widget.keyboardType,
            minLines: null,
            maxLines: widget.multiLine
                ? 20
                : widget.isPassword
                    ? 1
                    : null,
            style: TextStyle(
              color: widget.textColor,
              fontSize: widget.textSize.sp,
              decorationColor: widget.backgroundColor,
              decoration: TextDecoration.none,
              decorationThickness: 0.01,
            ),
            decoration: InputDecoration(
              // The Borders shape
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(widget.borderRadius),
                borderSide: BorderSide(color: Colors.transparent),
              ),
              errorBorder: InputBorder.none,
              // OutlineInputBorder(
              //   borderRadius: BorderRadius.circular(widget.borderRadius),
              //   borderSide: BorderSide(color: Colors.transparent),
              // ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(widget.borderRadius),
                borderSide: BorderSide(color: Colors.transparent),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(widget.borderRadius),
                borderSide: BorderSide(color: Colors.transparent),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(widget.borderRadius),
                borderSide: BorderSide(color: Colors.transparent),
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(widget.borderRadius),
                borderSide: BorderSide(color: Colors.transparent),
              ),

              hintText: widget.hintText,
              hintStyle: widget.hintStyle,

              contentPadding: EdgeInsets.only(
                right: widget.textPaddingFromEdge,
                left: widget.textPaddingFromEdge,
                bottom: 0,
                top: widget.multiLine ? 10 : 0,
              ),

              // errorStyle: widget.errorStyle.height == null
              //     ? widget.errorStyle.copyWith(height: 0.07)
              //     : widget.errorStyle,
              errorStyle: widget.errorStyle,
            ),
          ),
        ),
      ),
    );
  }
}
