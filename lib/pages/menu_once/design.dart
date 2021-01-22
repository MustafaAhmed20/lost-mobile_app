import 'package:flutter/material.dart';

class BackgrounDesign extends StatelessWidget {
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
            image: AssetImage('imeges/background.jpg'),
            fit: BoxFit.fill,
          ),
        ),
      ],
    );
  }
}
