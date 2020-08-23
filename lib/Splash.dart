import 'package:flutter/material.dart';
import 'package:adobe_xd/gradient_xd_transform.dart';

class Splash extends StatelessWidget {
  final ImageProvider ic_logo;
  Splash({
    Key key,
    this.ic_logo = const AssetImage('assets/images/ic_logo.png'),
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfffafafa),
      body: Stack(
        children: <Widget>[
          Container(
            width: 360.0,
            height: 640.0,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment(1.38, -0.81),
                end: Alignment(-1.38, 0.67),
                colors: [const Color(0xff001e50), const Color(0xff051631)],
                stops: [0.0, 1.0],
              ),
            ),
          ),
          Transform.translate(
            offset: Offset(26.0, 563.0),
            child:
                // Adobe XD layer: 'Sign In' (group)
                Stack(
              children: <Widget>[
                // Adobe XD layer: 'Background' (shape)
                Container(
                  width: 308.0,
                  height: 47.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(9.0),
                    border:
                        Border.all(width: 1.0, color: const Color(0xffff5423)),
                  ),
                ),
                Transform.translate(
                  offset: Offset(110.0, 17.5),
                  child:
                      // Adobe XD layer: 'SIGN IN' (text)
                      SizedBox(
                    width: 88.0,
                    child: Text(
                      'تخطي الدخول',
                      style: TextStyle(
                        fontFamily: 'Helvetica',
                        fontSize: 15,
                        color: const Color(0xffffffff),
                        height: 1,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Transform.translate(
            offset: Offset(26.0, 502.0),
            child:
                // Adobe XD layer: 'Sign In' (group)
                Stack(
              children: <Widget>[
                // Adobe XD layer: 'Background' (shape)
                Container(
                  width: 308.0,
                  height: 47.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(9.0),
                    gradient: RadialGradient(
                      center: Alignment(-0.93, 0.0),
                      radius: 1.092,
                      colors: [
                        const Color(0xffff2121),
                        const Color(0xffff5423),
                        const Color(0xffff7024),
                        const Color(0xffff904a)
                      ],
                      stops: [0.0, 0.562, 0.867, 1.0],
                      transform: GradientXDTransform(1.0, 0.0, 0.0, 1.837, 0.0,
                          -0.419, Alignment(-0.93, 0.0)),
                    ),
                  ),
                ),
                Transform.translate(
                  offset: Offset(108.0, 17.5),
                  child:
                      // Adobe XD layer: 'SIGN IN' (text)
                      SizedBox(
                    width: 91.0,
                    child: Text(
                      'تسجيل الدخول',
                      style: TextStyle(
                        fontFamily: 'Helvetica',
                        fontSize: 15,
                        color: const Color(0xffffffff),
                        height: 1,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Transform.translate(
            offset: Offset(115.0, 170.46),
            child: Container(
              width: 129.7,
              height: 77.0,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: ic_logo,
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
