import 'package:flutter/material.dart';

class BackgrounDesign extends StatelessWidget {
  bool useDesign2;
  BackgrounDesign({this.useDesign2 = false});
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        // background image
        Container(
          width: screenWidth,
          height: MediaQuery.of(context).size.height,
          child: Image(
            image: AssetImage(useDesign2
                ? 'imeges/background2.jpg'
                : 'imeges/background.jpg'),
            fit: BoxFit.fill,
          ),
        ),
      ],
    );
  }
}
