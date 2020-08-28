import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:priceme/adminscreens/sparepartsadmin.dart';

import 'addadv.dart';

class HomeTest extends StatefulWidget {
  HomeTest();
  @override
  _HomeTestState createState() => _HomeTestState();
}
class _HomeTestState extends State<HomeTest > {

@override
void initState() {
  super.initState();

  FirebaseAuth.instance.currentUser().then((user) => user != null
        ?
  setState(() {     //  a=user.photoUrl.toString()+"+++"+user.displayName.toString()+"+++"+user.phoneNumber.toString()+"/////"+user.email.toString()+"////"+user.providerData[1].providerId.toString();
  })

        :
setState((){})
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
              alignment: Alignment.center,
              child: Text("يوجد خطأ بالشبكة", style: TextStyle(fontSize: 16.0)),
            ),
            SizedBox(
              height: 50.0,
            ),
            Container(
              height: 44.0,
              margin: const EdgeInsets.only(top: 20.0, bottom: 10.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                //color: CustomColors.kTabBarIconColor,
              ),
              child: InkWell(
                onTap: ()  {

                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AddAdv()));
                },
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(Icons.refresh),

                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Test",
                          style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                      ),


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
