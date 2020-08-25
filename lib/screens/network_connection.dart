import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ConnectionScreen extends StatefulWidget {
  ConnectionScreen();
  @override
  _ConnectionScreenState createState() => _ConnectionScreenState();
}
class _ConnectionScreenState extends State<ConnectionScreen > {
var a;
 /** void check() {
    Future.delayed(Duration(seconds: 0), () async {
      try {
        final result = await InternetAddress.lookup('google.com');
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          final regiondatabaseReference =
          FirebaseDatabase.instance.reference().child("citydatabase");
          regiondatabaseReference.once().then((DataSnapshot snapshot) {
            var KEYS = snapshot.value.keys;
            var DATA = snapshot.value;
            //Toast.show("${snapshot.value.keys}",context,duration: Toast.LENGTH_LONG,gravity:  Toast.BOTTOM);
            regionlist.clear();
            for (var individualkey in KEYS) {
              CityClass regionclass =new CityClass(
                DATA[individualkey]['ccity'],

              );
              setState(() {
                regionlist.add(DATA[individualkey]['ccity']);

              });

            }
            init(regionlist);
            print("llllllll"+regionlist.toString());

          });

        }
      } on SocketException catch (_) {


      }
    });

  }
  init(regionlist)  {
    // Navigator.of(context).pushNamed('/login');
    FirebaseAuth.instance.currentUser().then((user) => user != null
        ?
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                FragmentSouq1(regionlist)))
        :
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                SignIn(regionlist))),
    );


  }
**/

@override
void initState() {
  super.initState();

  FirebaseAuth.instance.currentUser().then((user) => user != null
        ?
  setState(() {       a=user.photoUrl.toString()+"+++"+user.displayName.toString()+"+++"+user.phoneNumber.toString()+"/////"+user.email.toString()+"////"+user.providerData[1].providerId.toString();
  })

        :
    a=""

    );

}
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              width: 90.0,
              height: 100.0,
              child: Image.asset('assets/images/antenna.png'),
            ),
            SizedBox(
              height: 50.0,
            ),
            Container(
              alignment: Alignment.center,
              child: Text(
                "برجاء مراجعة الاتصال بالشبكة",
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Container(
              alignment: Alignment.center,
              child: Text("يوجد خطأ بالشبكة", style: TextStyle(fontSize: 16.0)),
            ),
            SizedBox(
              height: 50.0,
            ),
            Container(
              alignment: Alignment.center,
              child: Text(a.toString(), style: TextStyle(fontSize: 16.0)),
            ),
            Container(
              height: 44.0,
              margin: const EdgeInsets.only(top: 20.0, bottom: 10.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                //color: CustomColors.kTabBarIconColor,
              ),
              child: InkWell(
                onTap: () async {
                 // check();
//                  try {
//                    final result = await InternetAddress.lookup('google.com');
//                    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
//                      FirebaseAuth.instance.currentUser().then((user) => user !=
//                              null
//                          ?  Navigator.push(
//                          context,
//                          MaterialPageRoute(
//                              builder: (context) =>
//                                  FragmentSouq1(widget.regionlist)))
//                          :
//                      Navigator.push(
//                          context,
//                          MaterialPageRoute(
//                              builder: (context) =>
//                                  SignIn(widget.regionlist))),);
//                          }
//                  } on SocketException catch (_) {
////Toast.show(_.toString()+"jjjjjjjjjjjj",context,duration: Toast.LENGTH_LONG,gravity:  Toast.BOTTOM);
//
//                  }
                },
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(Icons.refresh),

                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "حاول ثانيأ",
                          style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                      ),

//                  RaisedButton(
//                    //color: CustomColors.kTabBarIconColor,
//                    onPressed: () async {
//                      try {
//                        final result = await InternetAddress.lookup('google.com');
//                        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
//                          FirebaseAuth.instance.currentUser().then((user) => user != null
//                              ? Navigator.of(context).pushReplacementNamed('/fragmentnaql')//setState(() {Navigator.of(context).pushReplacementNamed('/fragmentnaql'); })
//                              : Navigator.of(context).pushReplacementNamed('/login'));
//                        }
//                      } on SocketException catch (_) {
//
////Toast.show(_.toString()+"jjjjjjjjjjjj",context,duration: Toast.LENGTH_LONG,gravity:  Toast.BOTTOM);
//
//                      }
//                    },
//                    child: Text(
//                      "حاول ثانيأ",
//                      style: TextStyle(
//                          fontSize: 16.0,
//                          color: Colors.white,
//                          fontWeight: FontWeight.bold),
//                    ),
//                    shape: RoundedRectangleBorder(
//                      borderRadius: BorderRadius.circular(10.0),
//                    ),
//                  ),
                    ],
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
