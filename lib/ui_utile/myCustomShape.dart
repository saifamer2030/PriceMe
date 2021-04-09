import 'package:flutter/material.dart';
import 'package:priceme/ui_utile/myColors.dart';
import 'dart:ui' as ui;

class MyCustomShape extends CustomPainter {

  @override
  void paint(Canvas canvas, Size size) {



    Paint paint = new Paint()
      ..color = Colors.white
  ..style = PaintingStyle.fill
     ..strokeWidth = 1;
    paint.shader = ui.Gradient.linear(
        Offset(size.width*0.8,0),Offset(size.width*0.2,size.height),
       // [Color(0xfffe7210),Color(0xffff8b14),Color(0xffffbc16)],
        [MyColors.primaryColor,MyColors.lightPrimaryColor,MyColors.lightPrimaryColor.withOpacity(0.8)],
        [0.00,0.53,1.00]);



    Path path = Path();
    path.moveTo(0,0);
    path.lineTo(0,size.height*0.36);
    path.quadraticBezierTo(size.width*0.02,size.height*0.66,size.width*0.10,size.height*0.68);
    path.cubicTo(size.width*0.22,size.height*0.69,size.width*0.67,size.height*0.68,size.width*0.82,size.height*0.68);
    path.quadraticBezierTo(size.width*0.96,size.height*0.68,size.width,size.height);
    path.lineTo(size.width,0);
    path.lineTo(0,0);
    path.close();

    canvas.drawShadow(path, Colors.grey[900], 2.0, false);
    canvas.drawPath(path, paint);

  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

}