import 'package:flutter/material.dart';

// colors
import 'package:lost/constants.dart';

//language support
import 'package:lost/app_localizations.dart';

import 'dart:math' as math;

import 'package:provider/provider.dart';
import 'package:lost/models/appData.dart';

// sizer
import 'package:sizer/sizer.dart';

class SettingsCornerIcon extends StatefulWidget {
  @override
  _SettingsCornerIconState createState() => _SettingsCornerIconState();
}

class _SettingsCornerIconState extends State<SettingsCornerIcon> {
  double height, width, xPosition, yPosition;
  bool isSettingsOpened = false;
  OverlayEntry floatingSettingsQuarterCircle;

  // login state - true if user logged-in
  bool logged;

  // remove the
  void closeFloatingSettings() {
    setState(() {
      floatingSettingsQuarterCircle?.remove();

      floatingSettingsQuarterCircle = null;

      isSettingsOpened = false;
    });
  }

  // create the Overlay
  OverlayEntry _createFloatingSettings() {
    return OverlayEntry(builder: (context) {
      Size screenSize = MediaQuery.of(context).size;
      return GestureDetector(
        onTap: () {
          // close the drop down when click outside
          closeFloatingSettings();
        },
        child: Container(
          width: screenSize.width,
          height: screenSize.height,
          color: Colors.transparent,
          child: Stack(
            children: [
              Positioned(
                right: 0,
                bottom: 0,
                child: Opacity(
                  opacity: 0.7,
                  child: Container(
                    width: 270,
                    height: 270,
                    child: QuarterCircle(
                      circleAlignment: CircleAlignment.bottomRight,
                      color: mainDarkColor,
                    ),
                  ),
                ),
              ),

              // change the lang
              Positioned(
                right: 5,
                bottom: 150,
                child: Material(
                  type: MaterialType.transparency,
                  child: InkWell(
                    onTap: () {
                      // first close the hover
                      closeFloatingSettings();

                      // push settings page
                      Navigator.pushNamed(context, '/choose',
                          arguments: {'pop': true});
                    },
                    child: Container(
                      width: 170,
                      height: 50,
                      padding: EdgeInsets.symmetric(vertical: 5),
                      // color: Colors.red,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // the text
                          Text(
                            'تغيير اللغة / الدولة',
                            style: TextStyle(
                              color: mainTextColor,
                            ),
                          ),

                          // the icon
                          Image.asset(
                            'imeges/lang.png',
                            color: mainTextColor,
                            fit: BoxFit.fitHeight,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // send notes
              Positioned(
                right: 70,
                bottom: 80,
                child: Material(
                  type: MaterialType.transparency,
                  child: InkWell(
                    onTap: () {
                      // first close the hover
                      closeFloatingSettings();

                      Navigator.pushNamed(context, '/feedback').then(
                        (value) {
                          if (value != null) {
                            // add feedback successfully

                            // tell the home page to show snakebar throw Provider
                            Provider.of<AppSettings>(context, listen: false)
                                .setHomeSnakeBar('addFeddBack');
                          }
                        },
                      );
                    },
                    child: Container(
                      width: 150,
                      height: 50,
                      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                      // color: Colors.red,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // the text
                          Text(
                            'ارسال الملاحظات',
                            style: TextStyle(
                              color: mainTextColor,
                            ),
                          ),

                          // the icon
                          Icon(
                            Icons.border_color,
                            color: mainTextColor,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // logout / login
              Positioned(
                right: 100,
                bottom: 10,
                child: Material(
                  type: MaterialType.transparency,
                  child: InkWell(
                    onTap: () {
                      // first close the hover
                      closeFloatingSettings();
                      if (logged) {
                        // logout
                        Provider.of<UserData>(context, listen: false).logut();
                        // tell the home page to show snakebar throw Provider
                        Provider.of<AppSettings>(context, listen: false)
                            .setHomeSnakeBar('logout');
                      } else {
                        // show login screen
                        Navigator.pushNamed(context, '/login');
                      }
                    },
                    child: Container(
                      width: 130,
                      height: 50,
                      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                      // color: Colors.red,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          logged
                              ? Text(
                                  AppLocalizations.of(context)
                                      .translate('home_Logout'),
                                  style: TextStyle(
                                    color: mainTextColor,
                                  ),
                                )
                              : Text(
                                  AppLocalizations.of(context)
                                      .translate('home_Login'),
                                  style: TextStyle(
                                    color: mainTextColor,
                                  ),
                                ),

                          // the icon
                          logged
                              ? Icon(
                                  Icons.exit_to_app,
                                  color: mainTextColor,
                                )
                              : Icon(
                                  Icons.perm_identity,
                                  color: mainTextColor,
                                ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    logged = Provider.of<UserData>(context, listen: true).token == null
        ? false
        : true;
    return InkWell(
      onTap: () {
        // show the QuarterCircle
        setState(() {
          if (isSettingsOpened) {
            // close it if open
            floatingSettingsQuarterCircle.remove();
            floatingSettingsQuarterCircle = null;
          } else {
            // findDropdownData();
            floatingSettingsQuarterCircle = _createFloatingSettings();
            // open the drop down
            Overlay.of(context).insert(floatingSettingsQuarterCircle);
          }

          isSettingsOpened = !isSettingsOpened;
        });
      },
      child: Container(
        width: double.infinity,
        height: double.infinity,
        // color: Colors.red,
        child: Icon(
          Icons.settings_outlined,
          color: mainTextColor,
          size: 25.sp,
        ),
      ),
    );
  }
}

enum CircleAlignment {
  topLeft,
  topRight,
  bottomLeft,
  bottomRight,
}

class QuarterCircle extends StatelessWidget {
  final CircleAlignment circleAlignment;
  final Color color;

  const QuarterCircle({
    this.color = Colors.grey,
    this.circleAlignment = CircleAlignment.topLeft,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: ClipRect(
        child: CustomPaint(
          painter: QuarterCirclePainter(
            circleAlignment: circleAlignment,
            color: color,
          ),
        ),
      ),
    );
  }
}

class QuarterCirclePainter extends CustomPainter {
  final CircleAlignment circleAlignment;
  final Color color;

  const QuarterCirclePainter({this.circleAlignment, this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final radius = math.min(size.height, size.width);
    final offset = circleAlignment == CircleAlignment.topLeft
        ? Offset(.0, .0)
        : circleAlignment == CircleAlignment.topRight
            ? Offset(size.width, .0)
            : circleAlignment == CircleAlignment.bottomLeft
                ? Offset(.0, size.height)
                : Offset(size.width, size.height);
    canvas.drawCircle(offset, radius, Paint()..color = color);
  }

  @override
  bool shouldRepaint(QuarterCirclePainter oldDelegate) {
    return color == oldDelegate.color &&
        circleAlignment == oldDelegate.circleAlignment;
  }
}
