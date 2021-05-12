import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:priceme/ChatRoom/widget/home.dart';
import 'package:priceme/Videos/photosvideomine.dart';
import 'package:priceme/classes/SparePartsClass.dart';
import 'package:priceme/classes/sharedpreftype.dart';
import 'package:priceme/screens/PrivcyPolicy.dart';
import 'package:priceme/screens/advertisements.dart';
import 'package:priceme/screens/alloffers.dart';
import 'package:priceme/screens/allrents.dart';
import 'package:priceme/screens/favoritePage.dart';
import 'package:priceme/screens/myalarms.dart';
import 'package:priceme/screens/myoffers.dart';
import 'package:priceme/screens/myrents.dart';
import 'package:priceme/screens/personalpage.dart';
import 'package:priceme/trader/myphotos.dart';
import 'package:priceme/ui_utile/myColors.dart';
import 'package:priceme/ui_utile/myCustomShape2.dart';
import '../Splash.dart';
import 'homepage.dart';
import 'myadvertisement.dart';

class MorePriceMe extends StatefulWidget {
  MorePriceMe();

  @override
  _MorePriceMeState createState() => _MorePriceMeState();
}

class _MorePriceMeState extends State<MorePriceMe> {
  final double _minimumPadding = 5.0;
  String _userId;
  FirebaseAuth _firebaseAuth;
  String _cName = "";
  String _cMobile = "";
  String _cType = "";
  List<String> mainfaultsList = [];
  List<String> mainsparsList = [];
  bool enableNotification = false;

  void getDataf() {
    setState(() {
      //  print("ooooooo${widget.sparepartsList[0]}");
      final SparePartsReference = Firestore.instance;

      mainfaultsList.clear;
      mainfaultsList.add("الكل");

      SparePartsReference.collection("faults")
          .getDocuments()
          .then((QuerySnapshot snapshot) {
        snapshot.documents.forEach((sparepart) {
          SparePartsClass spc = SparePartsClass(
            sparepart.data['sid'],
            sparepart.data['sName'],
            sparepart.data['surl'],
            const Color(0xff8C8C96),
            false,
          );
          // const Color(0xff171732);
          setState(() {
            mainfaultsList.add(sparepart.data['sName']);
          });
        });
      });
    });

  }
  void getDatas() {
    setState(() {
      //  print("ooooooo${widget.sparepartsList[0]}");
      final SparePartsReference = Firestore.instance;
      final SparePartsReference1 = Firestore.instance;

      mainsparsList.clear;
      mainsparsList.add("الكل");

      SparePartsReference.collection("spareparts")
          .getDocuments()
          .then((QuerySnapshot snapshot) {
        snapshot.documents.forEach((sparepart) {
          SparePartsClass spc = SparePartsClass(
            sparepart.data['sid'],
            sparepart.data['sName'],
            sparepart.data['surl'],
            const Color(0xff8C8C96),
            false,
          );
          setState(() {
            mainsparsList.add(sparepart.data['sName'],);
            // print(sparepartsList.length.toString() + "llll");
          });

        });
      });
    });

  }
  @override
  void initState() {
    super.initState();

    getDatas(); 
    getDataf();
    _firebaseAuth = FirebaseAuth.instance;
    FirebaseAuth.instance.currentUser().then((user) => user == null
        ? null
        : setState(() {
            _userId = user.uid;
            var userQuery = Firestore.instance.collection('users').where('uid', isEqualTo: _userId).limit(1);
            userQuery.getDocuments().then((data){
              if (data.documents.length > 0){
                setState(() {
                  _cType = data.documents[0].data['cType'];
                 
                });
              }
            });
          }));

//    FirebaseAuth.instance.currentUser().then((user) => user == null
//        ? null
//        : setState(() {
//            _userId = user.uid;
//          }));

 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffffffff),
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 2,
        title: Text("إعدادات عامة", textAlign: TextAlign.right, textDirection: TextDirection.rtl,
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        )
      ),
      body:
      
      moreWidget()
      /*
       Form(
        child: Padding(
          padding: EdgeInsets.only(
              top: _minimumPadding * 23,
              bottom: _minimumPadding * 2,
              right: _minimumPadding * 2,
              left: _minimumPadding * 2),
          child: ListView(
            physics: BouncingScrollPhysics(),
            children: <Widget>[
              Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[


                    Container(

                      child:
                         Center(
              child: Text(
                'إعدادات عامة',
                style: TextStyle(

                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange,
                  height: 1.0800000190734864,
                ),
                textAlign: TextAlign.right,
              ),
          )



                    ),

                   SizedBox(height: 16,),

                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            new MaterialPageRoute(
                                builder: (context) => Advertisements()));

                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Icon(
                            Icons.keyboard_arrow_left,
                            color: const Color(0xff171732),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Text(
                                'الطلبات',
                                style: TextStyle(
//                                      fontFamily: 'Estedad-Black',
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xff171732),
                                  height: 1.2307692307692308,
                                ),
                                textAlign: TextAlign.right,
                              ),

                              // Adobe XD layer: 'world-wide-web-icon…' (shape)
                              Padding(
                                padding: const EdgeInsets.all(8.0),

                                child: new Icon(
                                  Icons.receipt,
                                  color: Colors.grey,
                                ),

//                                    child:  new Icon(
//                                      Icons.chat,
//                                      color: Colors.grey,
//
//                                    ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: .2,
                      color: Colors.grey,
                    ),
                    InkWell(
                      onTap: () {
                        if (_userId == null) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Splash()));
                        } else {
                          Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => MyAdvertisement()));
//                           if (_userId != null && _cType != null) {
//                             if ( _cType == "user") {
//                               Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                       builder: (context) => MyAdvertisement()));
//                             }else if(_cType == "trader"){
//                               Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                       builder: (context) => MyAdvertisement()));
//                             }
//
//                           } else {
//                             showDialog(
//                               context: context,
//                               builder: (BuildContext context) =>
//                               new CupertinoAlertDialog(
//                                 title: new Text(
//                                   "تنبية",
//                                   style: TextStyle(
// //                                      fontFamily: 'Estedad-Black',
//                                   ),
//                                 ),
//                                 content: new Text(
//                                   "برجاء تسجيل الدخول اولا",
//                                   style: TextStyle(
// //                                      fontFamily: 'Estedad-Black',
//                                   ),
//                                 ),
//                                 actions: [
//                                   CupertinoDialogAction(
//                                       isDefaultAction: false,
//                                       child: new FlatButton(
//                                         onPressed: () {
//                                           Navigator.pop(context, false);
//                                           Navigator.push(
//                                               context,
//                                               new MaterialPageRoute(
//                                                   builder: (context) =>
//                                                       PersonalPage()));
//                                         },
//                                         child: Text(
//                                           "موافق",
//                                           style: TextStyle(
// //                                              fontFamily: 'Estedad-Black',
//                                           ),
//                                         ),
//                                       )),
//                                 ],
//                               ),
//                             );
//                           }
                        }
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Icon(
                            Icons.keyboard_arrow_left,
                            color: const Color(0xff171732),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Text(
                                'تسعيراتى',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xff171732),
                                  height: 1.2307692307692308,
                                ),
                                textAlign: TextAlign.right,
                              ),

                              // Adobe XD layer: 'world-wide-web-icon…' (shape)
                              Padding(
                                  padding: const EdgeInsets.all(8.0),

                                  child: new Icon(
                                    Icons.monetization_on,
                                    color: Colors.grey,
                                  )),
                            ],
                          ),
                        ],
                      ),
                    ),

                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: .2,
                      color: Colors.grey,
                    ),
                    ( _cType =="trader")? InkWell(
                      onTap: () {
                        if (_userId == null) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Splash()));
                        } else {
                          if (_userId != null && _cType =="trader") {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MyPhotos()));
                          } else {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) =>
                              new CupertinoAlertDialog(
                                title: new Text(
                                  "تنبية",
                                  style: TextStyle(
//                                      fontFamily: 'Estedad-Black',
                                  ),
                                ),
                                content: new Text(
                                  "برجاء تسجيل الدخول اولا",
                                  style: TextStyle(
//                                      fontFamily: 'Estedad-Black',
                                  ),
                                ),
                                actions: [
                                  CupertinoDialogAction(
                                      isDefaultAction: false,
                                      child: new FlatButton(
                                        onPressed: () {
                                          Navigator.pop(context, false);
                                          Navigator.push(
                                              context,
                                              new MaterialPageRoute(
                                                  builder: (context) =>
                                                      Splash()));
                                        },
                                        child: Text(
                                          "موافق",
                                          style: TextStyle(
//                                              fontFamily: 'Estedad-Black',
                                          ),
                                        ),
                                      )),
                                ],
                              ),
                            );
                          }
                        }
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Icon(
                            Icons.keyboard_arrow_left,
                            color: const Color(0xff171732),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Text(
                                'صورى',
                                style: TextStyle(
//                                      fontFamily: 'Estedad-Black',
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xff171732),
                                  height: 1.2307692307692308,
                                ),
                                textAlign: TextAlign.right,
                              ),

                              // Adobe XD layer: 'world-wide-web-icon…' (shape)
                              Padding(
                                  padding: const EdgeInsets.all(8.0),

                                  child: new Icon(
                                    Icons.image,
                                    color: Colors.grey,
                                  )),
                            ],
                          ),
                        ],
                      ),
                    ):Container(),

                    ( _cType =="trader")? Container(
                      width: MediaQuery.of(context).size.width,
                      height: .2,
                      color: Colors.grey,
                    ):Container(),


                    /**
                        InkWell(
                        onTap: () {
                        Navigator.push(
                        context,
                        new MaterialPageRoute(
                        builder: (context) => AllOffers()));

                        },
                        child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                        Icon(
                        Icons.keyboard_arrow_left,
                        color: const Color(0xff171732),
                        ),
                        Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                        Text(
                        'العروض',
                        style: TextStyle(
                        //                                      fontFamily: 'Estedad-Black',
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xff171732),
                        height: 1.2307692307692308,
                        ),
                        textAlign: TextAlign.right,
                        ),

                        // Adobe XD layer: 'world-wide-web-icon…' (shape)
                        Padding(
                        padding: const EdgeInsets.all(8.0),

                        child: new Icon(
                        Icons.email,
                        color: Colors.grey,
                        ),

                        //                                    child:  new Icon(
                        //                                      Icons.chat,
                        //                                      color: Colors.grey,
                        //
                        //                                    ),
                        ),
                        ],
                        ),
                        ],
                        ),
                        ),
                        Container(
                        width: MediaQuery.of(context).size.width,
                        height: .2,
                        color: Colors.grey,
                        ),
                        InkWell(
                        onTap: () {
                        Navigator.push(
                        context,
                        new MaterialPageRoute(
                        builder: (context) => MyOffers()));

                        },
                        child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                        Icon(
                        Icons.keyboard_arrow_left,
                        color: const Color(0xff171732),
                        ),
                        Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                        Text(
                        'عروضي',
                        style: TextStyle(
                        //                                      fontFamily: 'Estedad-Black',
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xff171732),
                        height: 1.2307692307692308,
                        ),
                        textAlign: TextAlign.right,
                        ),

                        // Adobe XD layer: 'world-wide-web-icon…' (shape)
                        Padding(
                        padding: const EdgeInsets.all(8.0),

                        child: new Icon(
                        Icons.email,
                        color: Colors.grey,
                        ),

                        //                                    child:  new Icon(
                        //                                      Icons.chat,
                        //                                      color: Colors.grey,
                        //
                        //                                    ),
                        ),
                        ],
                        ),
                        ],
                        ),
                        ),
                        Container(
                        width: MediaQuery.of(context).size.width,
                        height: .2,
                        color: Colors.grey,
                        ),
                        InkWell(
                        onTap: () {
                        Navigator.push(
                        context,
                        new MaterialPageRoute(
                        builder: (context) => AllRents()));

                        },
                        child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                        Icon(
                        Icons.keyboard_arrow_left,
                        color: const Color(0xff171732),
                        ),
                        Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                        Text(
                        'الايجار',
                        style: TextStyle(
                        //                                      fontFamily: 'Estedad-Black',
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xff171732),
                        height: 1.2307692307692308,
                        ),
                        textAlign: TextAlign.right,
                        ),

                        // Adobe XD layer: 'world-wide-web-icon…' (shape)
                        Padding(
                        padding: const EdgeInsets.all(8.0),

                        child: new Icon(
                        Icons.email,
                        color: Colors.grey,
                        ),

                        //                                    child:  new Icon(
                        //                                      Icons.chat,
                        //                                      color: Colors.grey,
                        //
                        //                                    ),
                        ),
                        ],
                        ),
                        ],
                        ),
                        ),
                        Container(
                        width: MediaQuery.of(context).size.width,
                        height: .2,
                        color: Colors.grey,
                        ),
                        InkWell(
                        onTap: () {
                        Navigator.push(
                        context,
                        new MaterialPageRoute(
                        builder: (context) => MyRents()));

                        },
                        child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                        Icon(
                        Icons.keyboard_arrow_left,
                        color: const Color(0xff171732),
                        ),
                        Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                        Text(
                        'إيجاراتي',
                        style: TextStyle(
                        //                                      fontFamily: 'Estedad-Black',
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xff171732),
                        height: 1.2307692307692308,
                        ),
                        textAlign: TextAlign.right,
                        ),

                        // Adobe XD layer: 'world-wide-web-icon…' (shape)
                        Padding(
                        padding: const EdgeInsets.all(8.0),

                        child: new Icon(
                        Icons.email,
                        color: Colors.grey,
                        ),

                        //                                    child:  new Icon(
                        //                                      Icons.chat,
                        //                                      color: Colors.grey,
                        //
                        //                                    ),
                        ),
                        ],
                        ),
                        ],
                        ),
                        ),
                        Container(
                        width: MediaQuery.of(context).size.width,
                        height: .2,
                        color: Colors.grey,
                        ),
                     **/

                    ( _cType =="trader")?    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            new MaterialPageRoute(
                                builder: (context) => VidiosPhotoMine()));

                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Icon(
                            Icons.keyboard_arrow_left,
                            color: const Color(0xff171732),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Text(
                                'فيديوهاتي',
                                style: TextStyle(
//                                      fontFamily: 'Estedad-Black',
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xff171732),
                                  height: 1.2307692307692308,
                                ),
                                textAlign: TextAlign.right,
                              ),

                              // Adobe XD layer: 'world-wide-web-icon…' (shape)
                              Padding(
                                padding: const EdgeInsets.all(8.0),

                                child: new Icon(
                                  Icons.video_library,
                                  color: Colors.grey,
                                ),

//                                    child:  new Icon(
//                                      Icons.chat,
//                                      color: Colors.grey,
//
//                                    ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ):Container(),
                    ( _cType =="trader")?  Container(
                      width: MediaQuery.of(context).size.width,
                      height: .2,
                      color: Colors.grey,
                    ):Container(),







                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            new MaterialPageRoute(
                                builder: (context) => HomeScreen(
                                )));

                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Icon(
                            Icons.keyboard_arrow_left,
                            color: const Color(0xff171732),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Text(
                                'محادثاتي',
                                style: TextStyle(
//                                      fontFamily: 'Estedad-Black',
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xff171732),
                                  height: 1.2307692307692308,
                                ),
                                textAlign: TextAlign.right,
                              ),

                              // Adobe XD layer: 'world-wide-web-icon…' (shape)
                              Padding(
                                padding: const EdgeInsets.all(8.0),

                                child: new Icon(
                                  Icons.chat,
                                  color: Colors.grey,
                                ),

//                                    child:  new Icon(
//                                      Icons.chat,
//                                      color: Colors.grey,
//
//                                    ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: .2,
                      color: Colors.grey,
                    ),
                    InkWell(
                      onTap: () {
                        if (_userId != null) {
                          Navigator.push(
                              context,
                              new MaterialPageRoute(
                                  builder: (context) => PersonalPage()));
                        } else {
                          Navigator.push(
                              context,
                              new MaterialPageRoute(
                                  builder: (context) => Splash()));
                        }
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Icon(
                            Icons.keyboard_arrow_left,
                            color: const Color(0xff171732),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Text(
                                'الصفحه الشخصية',
                                style: TextStyle(
//                                      fontFamily: 'Estedad-Black',
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xff171732),
                                  height: 1.2307692307692308,
                                ),
                                textAlign: TextAlign.right,
                              ),

                              // Adobe XD layer: 'world-wide-web-icon…' (shape)
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: new Icon(
                                  Icons.account_circle,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: .2,
                      color: Colors.grey,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            new MaterialPageRoute(
                                builder: (context) => PrivcyPolicy()));
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Icon(
                            Icons.keyboard_arrow_left,
                            color: const Color(0xff171732),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Text(
                                'سياسه الخصوصيه',
                                style: TextStyle(
//                                      fontFamily: 'Estedad-Black',
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xff171732),
                                  height: 1.2307692307692308,
                                ),
                                textAlign: TextAlign.right,
                              ),

                              // Adobe XD layer: 'world-wide-web-icon…' (shape)
                              Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: new Icon(
                                    Icons.lock,
                                    color: Colors.grey,
                                  ) // Adobe XD layer: 'terms' (shape)
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
//                        Container(
//                          width: MediaQuery.of(context).size.width,
//                          height: .2,
//                          color: Colors.grey,
//                        ),
//                        Row(
//                          mainAxisAlignment: MainAxisAlignment.end,
//                          children: <Widget>[
//                            Text(
//                              'تقييم التطبيق',
//                              style: TextStyle(
////                                fontFamily: 'Estedad-Black',
//                                fontSize: 13,
//                                fontWeight: FontWeight.bold,
//                                color: const Color(0xff171732),
//                                height: 1.2307692307692308,
//                              ),
//                              textAlign: TextAlign.right,
//                            ),
//
//                            // Adobe XD layer: 'world-wide-web-icon…' (shape)
//                            Padding(
//                                padding: const EdgeInsets.all(8.0),
//                                child: new Icon(
//                                  Icons.star,
//                                  color: Colors.grey,
//                                ) // Adobe XD layer: 'terms' (shape)
//                                ),
//                          ],
//                        ),
//                     Container(
//                       width: MediaQuery.of(context).size.width,
//                       height: .2,
//                       color: Colors.grey,
//                     ),
//                     InkWell(
//                       onTap: () {
//                         if (_userId == null) {
//                           Navigator.push(
//                               context,
//                               new MaterialPageRoute(
//                                   builder: (context) => Splash()));
//                         } else {
//                           // Navigator.push(
//                           //     context,
//                           //     new MaterialPageRoute(
//                           //         builder: (context) => SmsForUserPage(
//                           //             SmsForUser(_userId, _cName, "", "",
//                           //                 _cMobile, ""))));
//
//                         }
//                       },
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.end,
//                         children: <Widget>[
//                           Text(
//                             'الشكاوي',
//                             style: TextStyle(
// //                                  fontFamily: 'Estedad-Black',
//                               fontSize: 13,
//                               fontWeight: FontWeight.bold,
//                               color: const Color(0xff171732),
//                               height: 1.2307692307692308,
//                             ),
//                             textAlign: TextAlign.right,
//                           ),
//
//                           // Adobe XD layer: 'world-wide-web-icon…' (shape)
//                           Padding(
//                               padding: const EdgeInsets.all(8.0),
//                               child: new Icon(
//                                 Icons.report,
//                                 color: Colors.grey,
//                               ) // Adobe XD layer: 'terms' (shape)
//                               ),
//                         ],
//                       ),
//                     ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: .2,
                      color: Colors.grey,
                    ),
//                        Row(
//                          mainAxisAlignment: MainAxisAlignment.end,
//                          children: <Widget>[
//                            Text(
//                              'نبذة عن التطبيق',
//                              style: TextStyle(
////                                fontFamily: 'Estedad-Black',
//                                fontSize: 13,
//                                fontWeight: FontWeight.bold,
//                                color: const Color(0xff171732),
//                                height: 1.2307692307692308,
//                              ),
//                              textAlign: TextAlign.right,
//                            ),
//
//                            // Adobe XD layer: 'world-wide-web-icon…' (shape)
//                            Padding(
//                                padding: const EdgeInsets.all(8.0),
//                                child: new Icon(
//                                  Icons.smartphone,
//                                  color: Colors.grey,
//                                ) // Adobe XD layer: 'terms' (shape)
//                                ),
//                          ],
//                        ),
//                        Container(
//                          width: MediaQuery.of(context).size.width,
//                          height: .2,
//                          color: Colors.grey,
//                        ),
                    InkWell(
                      onTap: () {
                        FirebaseAuth.instance.signOut();
                        SessionManager prefs = SessionManager();
                        prefs.setAuthType("");
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Splash()));
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
////                            InkWell(
////                              onTap: () {
////                                print("kkkkkkkkkkkclick");
//                                FirebaseAuth.instance.signOut();
//                                Navigator.of(context).pushNamed('/login');
////
////                              },
////
////                            ),
                          _userId == null
                              ? Text(
                            'تسجيل الدخول',
                            style: TextStyle(
//                                        fontFamily: 'Estedad-Black',
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                              height: 1.2307692307692308,
                            ),
                            textAlign: TextAlign.right,
                          )
                              : Text(
                            'تسجيل خروج',
                            style: TextStyle(
//                                        fontFamily: 'Estedad-Black',
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                              height: 1.2307692307692308,
                            ),
                            textAlign: TextAlign.right,
                          ),

                          // Adobe XD layer: 'world-wide-web-icon…' (shape)
                          Padding(
                              padding: const EdgeInsets.all(8.0),
                              child:
                              _userId == null?
                              Icon(
                                Icons.login,
                                color: Colors.green,
                              ) :
                              Icon(
                                Icons.logout,
                                color: Colors.red,
                              )// Adobe XD layer: 'terms' (shape)
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: .2,
                      color: Colors.grey,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      )
      */
    );
  }

 Widget moreWidget(){
   return SingleChildScrollView(
        child: Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 textDirection: TextDirection.rtl,
                  children: <Widget>[

                  SizedBox(height: 10,),  
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text("حسابي", textAlign: TextAlign.right,
                                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: MyColors.primaryColor),
                      ),
                  ),

                  Divider(thickness: 0.8, height: 0.8,), 
                  ListTile(
                    onTap:(){
                      if (_userId != null) {
                          Navigator.push(
                              context,
                              new MaterialPageRoute(
                                  builder: (context) => PersonalPage()));
                        } else {
                          Navigator.push(
                              context,
                              new MaterialPageRoute(
                                  builder: (context) => Splash()));
                        }
                    },                   
                     title: Text("الصفحة الشخصية", textAlign: TextAlign.right,
                                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                    trailing: Icon(Icons.account_circle, color: Colors.grey,),
                    leading: Icon(Icons.arrow_back_ios, color: Colors.grey, size: 16,),
                  ),
               
               Divider(thickness: 0.8, height: 0.8,),

             ListTile(
                    onTap:(){
                       Navigator.of(context).push(MaterialPageRoute(
                         builder: (_) => MyAdvertisement()
                       ));
                    },                   
                     title: Text("طلباتي", textAlign: TextAlign.right,
                                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                    trailing: Icon(Icons.featured_play_list, color: Colors.grey,),
                    leading: Icon(Icons.arrow_back_ios, color: Colors.grey, size: 16,),
                  ),

                Divider(thickness: 0.8, height: 0.8,),

                  ListTile(
                    onTap:(){
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => FavoritePage()
                      ));
                    },                   
                     title: Text("المفضلة", textAlign: TextAlign.right,
                                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                    trailing: Icon(Icons.favorite, color: Colors.grey,),
                    leading: Icon(Icons.arrow_back_ios, color: Colors.grey, size: 16,),
                  ),

                  Divider(thickness: 0.8, height: 0.8,),

                     ListTile(
                    onTap:(){
                    if (_userId == null) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Splash()));
                        } else {
                           /*
                          Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => MyAdvertisement()));
                                      */

                        }
                    },                   
                     title: Text("تسعيراتي", textAlign: TextAlign.right,
                                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                    trailing: Icon(Icons.monetization_on, color: Colors.grey,),
                    leading: Icon(Icons.arrow_back_ios, color: Colors.grey, size: 16,),
                  ),

                  Divider(thickness: 0.8, height: 0.8,),

                  ( _cType =="trader")?
                  ListTile(
                    onTap:(){
                       
                         if (_userId == null) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Splash()));
                        } else {
                          if (_userId != null && _cType =="trader") {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MyPhotos()));
                          } else {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) =>
                              new CupertinoAlertDialog(
                                title: new Text(
                                  "تنبية",
                                  style: TextStyle(
//                                      fontFamily: 'Estedad-Black',
                                  ),
                                ),
                                content: new Text(
                                  "برجاء تسجيل الدخول اولا",
                                  style: TextStyle(
//                                      fontFamily: 'Estedad-Black',
                                  ),
                                ),
                                actions: [
                                  CupertinoDialogAction(
                                      isDefaultAction: false,
                                      child: new FlatButton(
                                        onPressed: () {
                                          Navigator.pop(context, false);
                                          Navigator.push(
                                              context,
                                              new MaterialPageRoute(
                                                  builder: (context) =>
                                                      Splash()));
                                        },
                                        child: Text(
                                          "موافق",
                                          style: TextStyle(
//                                              fontFamily: 'Estedad-Black',
                                          ),
                                        ),
                                      )),
                                ],
                              ),
                            );
                          }
                        }
                    },                   
                     title: Text("صوري", textAlign: TextAlign.right,
                                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                    trailing: Icon(Icons.image, color: Colors.grey,),
                    leading: Icon(Icons.arrow_back_ios, color: Colors.grey, size: 16,),
                  ) : SizedBox(),
                   
               ( _cType =="trader")?   Divider(thickness: 0.8, height: 0.8,) : SizedBox(),

                                      SizedBox(height: 10,),  
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text("التنبيهات", textAlign: TextAlign.right,
                                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: MyColors.primaryColor),
                      ),
                  ),

                    SizedBox(height: 10,), 

                   Divider(thickness: 0.8, height: 0.8,), 
                   ListTile(
                    onTap:(){
                        Navigator.push(
                                              context,
                                              new MaterialPageRoute(
                                                  builder: (context) => MyAlarms()));
                    },                   
                     title: Text("تنبيهاتي", textAlign: TextAlign.right,
                                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                    trailing: Icon(Icons.notifications, color: Colors.grey,),
                    leading: Icon(Icons.arrow_back_ios, color: Colors.grey, size: 16,),
                  ),

                  Divider(thickness: 0.8, height: 0.8,),
                  ListTile(
                                     
                     title: Text("تفعيل التنبيهات", textAlign: TextAlign.right,
                                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),),
                    subtitle: Text("تلقي جميع التنبيهات على الهاتف", textAlign: TextAlign.right,
                                style: TextStyle(fontSize: 10,),),            
                   
                    trailing: Icon(Icons.notifications_on, color: Colors.grey,),
                    leading: Switch(
                      value: enableNotification,
                      onChanged: (value){
                        setState(() {
                           enableNotification = value;
                        });
                      
                      },
                      activeColor: MyColors.primaryColor,
                    )
                  ),

                  Divider(thickness: 0.8, height: 0.8,),

                                 SizedBox(height: 10,),  
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text("حول التطبيق", textAlign: TextAlign.right,
                                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: MyColors.primaryColor),
                      ),
                  ),

                    SizedBox(height: 10,), 

               Divider(thickness: 0.8, height: 0.8,), 

               ListTile(
                    onTap:(){
                      Navigator.push(
                            context,
                            new MaterialPageRoute(
                                builder: (context) => PrivcyPolicy()));
                    },                   
                     title: Text("سياسة الخصوصية", textAlign: TextAlign.right,
                                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                    trailing: Icon(Icons.privacy_tip, color: Colors.grey,),
                    leading: Icon(Icons.arrow_back_ios, color: Colors.grey, size: 16,),
                  ),

                  Divider(thickness: 0.8, height: 0.8,),

                   ListTile(
                    onTap:(){

                    },                   
                     title: Text("حول التطبيق", textAlign: TextAlign.right,
                                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                    trailing: Icon(Icons.info, color: Colors.grey,),
                    leading: Icon(Icons.arrow_back_ios, color: Colors.grey, size: 16,),
                  ),

                  Divider(thickness: 0.8, height: 0.8,),

                  SizedBox(height: 10,),
                  FlatButton(
                    onPressed: (){
                      FirebaseAuth.instance.signOut();
                        SessionManager prefs = SessionManager();
                        prefs.setAuthType("");
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Splash()));
                    },
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[

                          _userId == null
                              ? Text(
                            'تسجيل الدخول',
                            style: TextStyle(
//                                        fontFamily: 'Estedad-Black',
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                              height: 1.2307692307692308,
                            ),
                            textAlign: TextAlign.right,
                          )
                              : Text(
                            'تسجيل خروج',
                            style: TextStyle(
//                                        fontFamily: 'Estedad-Black',
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                              height: 1.2307692307692308,
                            ),
                            textAlign: TextAlign.right,
                          ),

                          // Adobe XD layer: 'world-wide-web-icon…' (shape)
                          Padding(
                              padding: const EdgeInsets.all(8.0),
                              child:
                              _userId == null?
                              Icon(
                                Icons.login,
                                color: Colors.green,
                              ) :
                              Icon(
                                Icons.logout,
                                color: Colors.red,
                              )// Adobe XD layer: 'terms' (shape)
                          ),
                        ],
                      ),
                  ),

                  SizedBox(height: 10,),

/*
                    InkWell(
                      onTap: () {
                        FirebaseAuth.instance.signOut();
                        SessionManager prefs = SessionManager();
                        prefs.setAuthType("");
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Splash()));
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[

                          _userId == null
                              ? Text(
                            'تسجيل الدخول',
                            style: TextStyle(
//                                        fontFamily: 'Estedad-Black',
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                              height: 1.2307692307692308,
                            ),
                            textAlign: TextAlign.right,
                          )
                              : Text(
                            'تسجيل خروج',
                            style: TextStyle(
//                                        fontFamily: 'Estedad-Black',
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                              height: 1.2307692307692308,
                            ),
                            textAlign: TextAlign.right,
                          ),

                          // Adobe XD layer: 'world-wide-web-icon…' (shape)
                          Padding(
                              padding: const EdgeInsets.all(8.0),
                              child:
                              _userId == null?
                              Icon(
                                Icons.login,
                                color: Colors.green,
                              ) :
                              Icon(
                                Icons.logout,
                                color: Colors.red,
                              )// Adobe XD layer: 'terms' (shape)
                          ),
                        ],
                      ),
                    ),
                    */
                  ],
                ),
   );
 }


}
