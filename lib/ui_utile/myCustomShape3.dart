import 'package:flutter/material.dart';
import 'package:priceme/ui_utile/myColors.dart';
import 'dart:ui' as ui;

class MyCustomShape3 extends CustomPainter {



  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = new Paint()
      ..color = Colors.orange[200]
      ..style = PaintingStyle.fill
      ..strokeWidth = 1;


    Path path = Path();

    /*
    path.moveTo(20, 0);
    path.lineTo(0,size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);
    path.lineTo(20, 0);
*/

    path.quadraticBezierTo(16, size.height*0.5, 0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);


   // canvas.drawShadow(path, Colors.grey[900], 2.0, false);
    canvas.drawPath(path, paint);

  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
  }

}