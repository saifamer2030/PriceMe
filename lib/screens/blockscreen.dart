import 'dart:io';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';


class BlockScreen extends StatefulWidget {

  @override
  _BlockScreenState createState() => _BlockScreenState();
}
class _BlockScreenState extends State<BlockScreen > {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: new BoxDecoration(
          image: new DecorationImage(
            image: new AssetImage("assets/images/ic_background.png"),
            fit: BoxFit.cover,
          ),
        ),
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              width: 100.0,
              height: 100.0,
              child:   Icon(Icons.block,size: 100,color: Colors.red,),
            ),
            SizedBox(
              height: 50.0,
            ),
            Container(
              alignment: Alignment.center,
              child: Text(
                "برجاء مراجعة الادمن",
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Container(
              alignment: Alignment.center,
              child: Text("تم حظر هذا الحساب", style: TextStyle(fontSize: 16.0)),
            ),
            SizedBox(
              height: 50.0,
            ),

          ],
        ),
      ),
    );
  }
}
