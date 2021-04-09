import 'package:flutter/material.dart';
import 'package:priceme/ui_utile/myColors.dart';


class MyCustomShape3 extends CustomPainter {



  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = new Paint()
      ..color = MyColors.primaryColor.withOpacity(0.7)
      ..style = PaintingStyle.fill
      ..strokeWidth = 1;


    Path path = Path();



    path.quadraticBezierTo(16, size.height*0.5, 0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);



    canvas.drawPath(path, paint);

  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {

    return true;
  }

}