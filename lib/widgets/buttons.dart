import 'package:flutter/material.dart';

class Button144X50 extends StatelessWidget {
  Color color;
  Function function;
  String text;
  Color textColor;

  Button144X50(
      {@required this.color,
      @required this.function,
      @required this.text,
      @required this.textColor});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 144,
      height: 50,
      child: RaisedButton(
        onPressed: () => function(context),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Text(
          text,
          style: TextStyle(
              color: textColor, fontSize: 14, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

class Button50HBig extends StatelessWidget {
  Color color;
  Function function;
  String text;
  Color textColor;
  double textSize;

  double height;

  double borderRadius;
  Color borderColor;

  // the left side icon or image(String)
  IconData icon;
  String image;
  double iconSize;

  Button50HBig({
    @required this.color,
    @required this.function,
    @required this.text,
    @required this.textColor,
    this.textSize,
    this.height,
    this.borderRadius,
    this.borderColor = Colors.transparent,
    this.icon,
    this.image,
    this.iconSize = 20,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => function(context),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 5),
        height: height == null ? 50 : height,
        decoration: BoxDecoration(
            color: color,
            borderRadius: borderRadius == null
                ? BorderRadius.circular(15)
                : BorderRadius.circular(borderRadius),
            border: Border.all(color: borderColor)),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Flexible(
                child: Text(
                  text,
                  textAlign: TextAlign.right,
                  style: TextStyle(
                      color: textColor,
                      fontSize: textSize != null ? textSize : 14),
                ),
              ),

              // the image
              icon != null || image != null
                  ? Container(
                      width: iconSize,
                      height: iconSize,
                      margin: EdgeInsets.only(right: 8),
                      child: icon != null
                          ? Icon(
                              icon,
                              color: textColor,
                              size: iconSize,
                            )
                          : Image.asset(
                              image,
                              fit: BoxFit.contain,
                            ),
                    )
                  : SizedBox.shrink(),
            ],
          ),
        ),
      ),
    );
  }
}
