import 'package:flutter/material.dart';

import 'dart:math' as math;

// the colors
import 'package:lost/constants.dart';
import 'package:lost/pages/settings_hover.dart';

// logic file
import 'package:lost/pages/home/logic.dart';

// sizer
import 'package:sizer/sizer.dart';

class BottomAppBarWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: mainLiteColor,
      shape: DoubleCircularNotchedButton(),
      // shape: CircularNotchedRectangle(),
      // shape: AutomaticNotchedShape(Border()),
      child: Container(
        height: 7.h,
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(vertical: 0.2.h),
        child: GestureDetector(
          onTap: () => onAddLogic(context),
          child: Container(
            child: Column(
              children: [
                // add icon
                Expanded(
                  child: Container(
                      width: 8.w,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: mainTextColor,
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                      ),
                      child: Icon(
                        Icons.add,
                        color: mainLiteColor,
                        size: 20.sp,
                      )),
                ),

                SizedBox(height: 0.5.h),

                // add text
                Text(
                  'اضافة',
                  style: TextStyle(color: mainTextColor, fontSize: 8.sp),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DoubleCircularNotchedButton extends NotchedShape {
  const DoubleCircularNotchedButton();
  @override
  Path getOuterPath(Rect host, Rect guest) {
    if (guest == null || !host.overlaps(guest)) return Path()..addRect(host);

    final double notchRadius = guest.height / 2.0;

    const double s1 = 15.0;
    const double s2 = 1.0;

    final double r = notchRadius;
    final double a = -1.0 * r - s2;
    final double b = host.top - 0;

    final double n2 = math.sqrt(b * b * r * r * (a * a + b * b - r * r));
    final double p2xA = ((a * r * r) - n2) / (a * a + b * b);
    final double p2xB = ((a * r * r) + n2) / (a * a + b * b);
    final double p2yA = math.sqrt(r * r - p2xA * p2xA);
    final double p2yB = math.sqrt(r * r - p2xB * p2xB);

    ///Cut-out 1
    final List<Offset> px = List<Offset>(6);

    px[0] = Offset(a - s1, b);
    px[1] = Offset(a, b);
    final double cmpx = b < 0 ? -1.0 : 1.0;
    px[2] = cmpx * p2yA > cmpx * p2yB ? Offset(p2xA, p2yA) : Offset(p2xB, p2yB);

    px[3] = Offset(-1.0 * px[2].dx, px[2].dy);
    px[4] = Offset(-1.0 * px[1].dx, px[1].dy);
    px[5] = Offset(-1.0 * px[0].dx, px[0].dy);

    for (int i = 0; i < px.length; i += 1)
      px[i] += Offset(0 + (notchRadius + 12), 0); //Cut-out 1 positions

    ///Cut-out 2
    final List<Offset> py = List<Offset>(6);

    py[0] = Offset(a - s1, b);
    py[1] = Offset(a, b);
    final double cmpy = b < 0 ? -1.0 : 1.0;
    py[2] = cmpy * p2yA > cmpy * p2yB ? Offset(p2xA, p2yA) : Offset(p2xB, p2yB);

    py[3] = Offset(-1.0 * py[2].dx, py[2].dy);
    py[4] = Offset(-1.0 * py[1].dx, py[1].dy);
    py[5] = Offset(-1.0 * py[0].dx, py[0].dy);

    for (int i = 0; i < py.length; i += 1)
      py[i] += Offset(host.width - (notchRadius + 12), 0); //Cut-out 2 positions

    return Path()
      ..moveTo(host.left, host.top)
      ..lineTo(px[0].dx, px[0].dy)
      ..quadraticBezierTo(px[1].dx, px[1].dy, px[2].dx, px[2].dy)
      ..arcToPoint(
        px[3],
        radius: Radius.circular(notchRadius),
        clockwise: false,
      )
      ..quadraticBezierTo(px[4].dx, px[4].dy, px[5].dx, px[5].dy)
      ..lineTo(py[0].dx, py[0].dy)
      ..quadraticBezierTo(py[1].dx, py[1].dy, py[2].dx, py[2].dy)
      ..arcToPoint(
        py[3],
        radius: Radius.circular(notchRadius),
        clockwise: false,
      )
      ..quadraticBezierTo(py[4].dx, py[4].dy, py[5].dx, py[5].dy)
      ..lineTo(host.right, host.top)
      ..lineTo(host.right, host.bottom)
      ..lineTo(host.left, host.bottom)
      ..close();
  }
}
