import 'package:flutter/material.dart';
import 'package:adobe_xd/gradient_xd_transform.dart';
import 'package:priceme/screens/network_connection.dart';
import 'package:priceme/screens/signin.dart';

import 'classes/sharedpreftype.dart';

class Splash  extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {


  @override
  void initState() {
    super.initState();
    SessionManager prefs =  SessionManager();
    Future<String> authType= prefs.getAuthType();
    authType.then((data) {
      print("authToken " + data.toString());
      if(data.toString()=="user"){
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ConnectionScreen()));
      }else if (data.toString()=="trader"){
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ConnectionScreen()));
      }
    },onError: (e) {
      print(e);
    });

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment(1.38, -0.81),
                end: Alignment(-1.38, 0.67),
                colors: [ const Color(0xff001e50), const Color(0xff051631),],
                stops: [0.0, 1.0],
              ),
            ),
            child:ListView(
              physics: BouncingScrollPhysics(),
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 200),
                  child: Center(
                    child: Container(
                      width: 250,
                      height: 95.0,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image:AssetImage('assets/images/ic_logo.png'),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(top: 230,left: 20,right: 20),
                  child: InkWell(

                    onTap: ()  {

                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SignIn()));
                    },
                    child: Container(

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

                      child: Center(
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
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20,left: 20,right: 20),
                  child: Container(
                    width: 308.0,
                    height: 47.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(9.0),
                      border:
                      Border.all(width: 1.0, color: const Color(0xffff5423)),
                    ),
                    child: Center(
                      child: Text(
                        ' الدخول كزائر',
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
                ),


              ],
            ),
          ),


    );

  }

}

