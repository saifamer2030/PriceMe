import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:adobe_xd/gradient_xd_transform.dart';

class Logintrader extends StatelessWidget {
  Logintrader({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfffafafa),
      body:
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment(1.38, -0.81),
                end: Alignment(-1.38, 0.67),
                colors: [
                  const Color(0xff04939b),
                  const Color(0xff008d95),
                  const Color(0xff15494a)
                ],
                stops: [0.0, 0.0, 1.0],
              ),
            ),
            child: ListView(
              physics: BouncingScrollPhysics(),
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 80),
                  child: Container(
                    height: 170.0,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: const AssetImage('assets/images/ic_logo2.png'),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 50, left: 20, right: 20),
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(13.0),
                      color: const Color(0xffffffff),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          'البريد الالكتروني',
                          style: TextStyle(
                            fontSize: 14,
                            color: const Color(0xffa2a2a2),
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: Icon(
                            Icons.person,
                            color: const Color(0xffa2a2a2),
                          ),
                        )
                      ],
                    ),
                  ),
                ),             Padding(
                  padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(13.0),
                      color: const Color(0xffffffff),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          'كلمة المرور',
                          style: TextStyle(
                            fontSize: 14,
                            color: const Color(0xffa2a2a2),
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: Icon(
                            Icons.lock_outline,
                            color: const Color(0xffa2a2a2),
                          ),
                        ),

                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 50, left: 20, right: 20),
                  child: Container(
                    width: 292.0,
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
                        transform: GradientXDTransform(1.0, 0.0, 0.0, 1.837,
                            0.0, -0.419, Alignment(-0.93, 0.0)),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        'تسجيل الدخول',
                        style: TextStyle(
                          fontFamily: 'Helvetica',
                          fontSize: 13,
                          color: const Color(0xffffffff),
                          height: 1,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    'نسيت كلمة السر ؟',
                    style: TextStyle(
                      fontFamily: 'Ubuntu',
                      fontSize: 14,
                      color: const Color(0xffffffff),
                      fontWeight: FontWeight.w300,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Text(
                        'حساب جديد',
                        style: TextStyle(
                          fontSize: 13,
                          color: const Color(0xff249cd2),
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Text(
                      'ليس لديك حساب؟',
                      style: TextStyle(
                        fontSize: 13,
                        color: const Color(0xffffffff),
                        fontWeight: FontWeight.w300,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                )
              ],
            ),
          ),



    );
  }
}

