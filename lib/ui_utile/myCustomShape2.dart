import 'package:flutter/material.dart';
import 'package:priceme/ui_utile/myColors.dart';
import 'dart:ui' as ui;

class MyCustomShape2 extends CustomPainter {



  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = new Paint()
    ..color = Colors.white
    ..style = PaintingStyle.fill
    ..strokeWidth = 1;
    paint.shader = ui.Gradient.linear(
    Offset(size.width*0.8,0),Offset(size.width*0.2,size.height),
    [Color(0xfffe7210),Color(0xffff8b14),Color(0xffffbc16)],
    [0.00,0.53,1.00]);

    Path path = Path();
    path.lineTo(0, size.height/2);
    path.quadraticBezierTo(size.width/2, size.height, size.width, size.height/2);
    path.lineTo(size.width, 0);
    path.lineTo(0,0);

    canvas.drawShadow(path, Colors.grey[900], 2.0, false);
    canvas.drawPath(path, paint);

  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
  }

}