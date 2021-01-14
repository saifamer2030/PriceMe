import 'package:adobe_xd/gradient_xd_transform.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:priceme/FragmentNavigation.dart';
import 'package:priceme/Splash.dart';
import 'package:priceme/ui_utile/myCustomShape.dart';
import 'package:priceme/ui_utile/myCustomShape3.dart';
import 'package:toast/toast.dart';

import 'RatingClass.dart';

class UserRatingPage extends StatefulWidget {
  UserRatingPage(this.tradeid);

String tradeid;

  @override
  _UserRatingPageState createState() => new _UserRatingPageState();
}

//final mDatabase = FirebaseDatabase.instance.reference();
//
//final ratingReference = FirebaseDatabase.instance.reference().child('Rating');
//final ratingAvrageReference =
//    FirebaseDatabase.instance.reference().child('coiffuredata');
enum SingingCharacter { done, notDone }

class _UserRatingPageState extends State<UserRatingPage> {
  List<Rating> itemsRate;
  var Rate = 0.0;
  var Rate2 = 0.0;
  var Rate3 = 0.0;
  var _averageRating, _totalRate, _totalCust;
  FirebaseAuth _firebaseAuth;
  String _userId;
  SingingCharacter _character = SingingCharacter.done;

  // تعريف الايتم المراد ادخال قيم فيها
  TextEditingController _rateController;
  TextEditingController _commentController;

/////////////// لتهئة الداتا بيز وعرض البيانات فور فتح التطبيق ///////////
  @override
  void initState() {
    super.initState();
    _firebaseAuth = FirebaseAuth.instance;
    getRatingAvrage();
    // ربط الايتم بالقيم
    _rateController = new TextEditingController();
    _commentController = new TextEditingController();
  }

  dynamic data;

  Future<dynamic> getRatingAvrage() async {
    FirebaseAuth.instance.currentUser().then((user) => user == null
        ? Navigator.of(context, rootNavigator: false).push(MaterialPageRoute(
        builder: (context) => Splash(), maintainState: false))
        : setState(() {
      _userId = user.uid;
      var userQuery = Firestore.instance
          .collection('users')
          .where('uid', isEqualTo: widget.tradeid)
          .limit(1);
      userQuery.getDocuments().then((data) {
        if (data.documents.length > 0) {
          setState(() {
            _totalRate = data.documents[0].data['rating']??"0";
            _totalCust = data.documents[0].data['custRate']??0;
            print("###############$_totalRate ------ $_totalCust");
          });
        }
      });
    }));
  }

  /// هذا الفانكشن لغلق الداتا بيز ///
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(

      body: Container(
        width: width,
        height: height,
        decoration: new BoxDecoration(
          image: new DecorationImage(
            image: new AssetImage("assets/images/ic_background.png"),
            fit: BoxFit.cover,
          ),
        ),
        child:

        Column(

          children:[
            CustomPaint(
                size: Size(MediaQuery.of(context).size.width,140), //You can Replace this with your desired WIDTH and HEIGHT
                painter: MyCustomShape(),
                child: Container(
                  height: 140,
                 child: Stack(
                    children: [


                      Positioned(
                          top: 48,
                          right: 20,
                          child:
                          InkWell(
                            onTap: (){
                              Navigator.pop(context);
                            },
                            child: Container(
                              height: 30,
                              width: 30,
                              child: Icon(Icons.arrow_forward, color: Colors.white),
                            ),
                          )

                      ),

                      Positioned(
                        top: 42,
                        child: Container(
                          alignment: Alignment.center,
                          height: 40,
                          width: MediaQuery.of(context).size.width,
                          child: Text(
                            "تقييم معاملة التاجر",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                      ),


                    ],


                  ),
                )
            )
            ,
            Expanded(
              child:  Center(
              child: ListView(
                physics: BouncingScrollPhysics(),
                children: <Widget>[
//              Column(
//                children: <Widget>[
//                  Padding(
//                    padding: const EdgeInsets.all(20.0),
//                    child: Container(
//                      height: 150,
//                      decoration: BoxDecoration(
//                          image: DecorationImage(
//                        fit: BoxFit.cover,
//                        image: new AssetImage("assets/images/ic_logo2.png"),
//                      )),
//                    ),
//                  ),
//                ],
//              ),






                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    textDirection: TextDirection.rtl,
                    children: [
                      Text(
                        "*الاتفاق علي السعر :",
                        textDirection: TextDirection.rtl,
                        style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold),
                      ),

                      SizedBox(width: 10,),
                      Text('تم'),
                      Radio(
                        value: SingingCharacter.done,
                        groupValue: _character,
                        onChanged: (SingingCharacter value) {
                          setState(() {
                            _character = value;
                          });
                        },
                      ),
                      Text('لم يتم'),
                      Radio(
                        value: SingingCharacter.notDone,
                        groupValue: _character,
                        onChanged: (SingingCharacter value) {
                          setState(() {
                            _character = value;
                          });
                        },
                      ),

                    ],
                  ),

                  SizedBox(height: 10,),

                  Center(
                      child: Text(
                        "نوعية الخدمة*",
                        style: TextStyle(
                            fontSize: 12.0, fontWeight: FontWeight.bold),
                      )),

                  SizedBox(height: 8,),
                  Container(

                   padding: EdgeInsets.all(6),
                    margin: EdgeInsets.only(right: 16, left: 16),

                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey),
                            color: Colors.white
                    ),
                    child:  Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      textDirection: TextDirection.rtl,
                      children: [

                        SizedBox(width: 10,),

                        Container(
                            width: 180,

                            child:  RatingBar(
                              textDirection: TextDirection.rtl,
                              initialRating: 0,
                              unratedColor: Colors.grey[500],
                              direction: Axis.horizontal,
                              itemSize: 32,
                              allowHalfRating: true,
                              itemCount: 5,
                              itemPadding: EdgeInsets.symmetric(horizontal: 0.0),
                              itemBuilder: (context, _) => Icon(
                                Icons.star,
                                color: Colors.amber,
//                            size: 15,
                              ),
                              onRatingUpdate: (rating) {
                                print(rating);

                                setState(() {
                                  Rate = rating;
                                });
                              },
                            ),
                          )

                        ,










                        SizedBox(width: 8,),

                        Center(
                          child: Text(
                            Rate == 5.0
                                ? ' أكمل وجه'
                                : ((Rate < 5.0) & (Rate > 3.0))
                                ? 'ممتازة'
                                : ((Rate < 4.0) & (Rate > 2.0))
                                ? 'جيدة جداً'
                                : ((Rate < 3.0) & (Rate > 1.0))
                                ? 'جيدة'
                                : ((Rate < 2.0) & (Rate > 0.0))
                                ? 'سيئة'
                                : 'لا يوجد تقييم',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.orange,
                                fontSize: 10),
                          ),
                        ),


                      ],
                    ),
                  ),


                  SizedBox(height: 16,),

                  Center(
                      child: Text(
                        "الالتزام بالمواعيد*",
                        style: TextStyle(
                            fontSize: 12.0, fontWeight: FontWeight.bold),
                      )),

                  SizedBox(height: 10,),

                  Container(
                    padding: EdgeInsets.all(6),
                    margin: EdgeInsets.only(right: 16, left: 16),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey),
                        color: Colors.white
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      textDirection: TextDirection.rtl,
                      children: [

                        SizedBox(width: 10,),

                        Container(
                          width: 180,

                            child: RatingBar(
                              textDirection: TextDirection.rtl,
                              initialRating: 0,
                              unratedColor: Colors.grey[500],
                              direction: Axis.horizontal,
                              allowHalfRating: true,
                              itemCount: 5,
                              itemSize: 32,
                              itemPadding: EdgeInsets.symmetric(horizontal: 0.0),
                              itemBuilder: (context, _) => Icon(
                                Icons.star,
                                color: Colors.amber,
//                            size: 15,
                              ),
                              onRatingUpdate: (rating) {
                                print(rating);

                                setState(() {
                                  Rate2 = rating;
                                });
                              },
                            ),
                          ),


                        SizedBox(width: 10,),

                        Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Center(
                            child: Text(
                              Rate2 == 5.0
                                  ? ' أكمل وجه'
                                  : ((Rate2 < 5.0) & (Rate2 > 3.0))
                                  ? 'ممتازة'
                                  : ((Rate2 < 4.0) & (Rate2 > 2.0))
                                  ? 'جيدة جداً'
                                  : ((Rate2 < 3.0) & (Rate2 > 1.0))
                                  ? 'جيدة'
                                  : ((Rate2 < 2.0) & (Rate2 > 0.0))
                                  ? 'سيئة'
                                  : 'لا يوجد تقييم',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.orange,
                                  fontSize: 10),
                            ),
                          ),
                        ),


                      ],
                    ),
                  ),


                  SizedBox(height: 16,),

                  Center(
                      child: Text(
                        "المعاملة مع الزبون*",
                        style: TextStyle(
                            fontSize: 12.0, fontWeight: FontWeight.bold),
                      )),
                  SizedBox(height: 10,),

                  Container(
                    padding: EdgeInsets.all(6),
                    margin: EdgeInsets.only(right: 16, left: 16),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey),
                        color: Colors.white
                    ),
                    child:Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      textDirection: TextDirection.rtl,

                      children: [


                        SizedBox(width: 10,),

                        Container(
                          width: 180,
                          child: RatingBar(
                            textDirection: TextDirection.rtl,
                            initialRating: 0,
                            unratedColor: Colors.grey[500],
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            itemCount: 5,
                            itemSize: 32,
                            itemPadding: EdgeInsets.symmetric(horizontal: 0.0),
                            itemBuilder: (context, _) => Icon(
                              Icons.star,
                              color: Colors.amber,
//                            size: 15,
                            ),
                            onRatingUpdate: (rating) {
                              print(rating);

                              setState(() {
                                Rate3 = rating;
                              });
                            },
                          ),
                        ),

                        SizedBox(width: 10),


                        Center(
                          child: Text(
                            Rate3 == 5.0
                                ? ' أكمل وجه'
                                : ((Rate3 < 5.0) & (Rate3 > 3.0))
                                ? 'ممتازة'
                                : ((Rate3 < 4.0) & (Rate3 > 2.0))
                                ? 'جيدة جداً'
                                : ((Rate3 < 3.0) & (Rate3 > 1.0))
                                ? 'جيدة'
                                : ((Rate3 < 2.0) & (Rate3 > 0.0))
                                ? 'سيئة'
                                : 'لا يوجد تقييم',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.orange,
                                fontSize: 10),
                          ),
                        ),



                      ],
                    ),
                  ),




                  Padding(
                    padding: const EdgeInsets.only(
                        top: 20.0, right: 10.0, left: 10.0, bottom: 10.0),
                    child: Center(
                        child:
                        Directionality(
                            textDirection: TextDirection.rtl,
                            child:  TextField(
                              textDirection: TextDirection.rtl,
                              controller: _commentController,
                              onChanged: (value) {},
                              //  controller: controller,
                              decoration: InputDecoration(
                                  labelText: "اكتب تعليقا هنا",
                                  hintText: "اكتب تعليقا هنا",
                                  hintStyle: TextStyle(fontSize: 13),
                                  labelStyle: TextStyle(fontSize: 13),
                                  prefixIcon: Icon(Icons.comment),
                                  border: OutlineInputBorder(
                                      borderRadius:
                                      BorderRadius.all(Radius.circular(10.0)))),
                            )
                        )

                    ),
                  ),



                  Padding(
                    padding: EdgeInsets.only(
                        right: 16, left: 10, bottom: 16),
                    child:
                    RaisedButton(
                        padding: EdgeInsets.zero,
                        shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                        onPressed: ()  {
                          getUser(com: _commentController.text);
                        },
                        child:
                        Container(
                          height: 40,
                          padding: EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            gradient: LinearGradient(
                              begin: Alignment.topRight,
                              end: Alignment.bottomLeft,
                              colors: [
                                const Color(0xfffe7210),
                                const Color(0xffff8b14),
                                const Color(0xffffbc16),
                              ],
                              // stops: [0.1, 0.8,0.6],
                            ),


                          ),
                          child: Center(
                            child: Text(
                              'إرسال التقييم',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        )


                    ),
                  ),
                ],
              ),
            ),)
          ]


        )

      ),
    );
  }

  void getUser({String com}) {
    var allRating = (Rate + Rate2 + Rate3) / 3;
    FirebaseAuth.instance.currentUser().then((user) => user == null
        ? Navigator.of(context, rootNavigator: false).push(MaterialPageRoute(
        builder: (context) => Splash(), maintainState: false))
        : setState(() {
      _userId = user.uid;
      if (user != null && com != "" && Rate != 0.0 && Rate2 != 0.0 && Rate3 != 0.0) {
        DocumentReference documentReference = Firestore.instance
            .collection('Rating')
            .document(widget.tradeid)
            .collection("tradeid")
            .document();
        String ratingid = documentReference.documentID;
        documentReference.setData({
          'Comment': _commentController.text,
          'Rate': allRating.round(),
          'AgreementPrice': (_character.toString().contains("done")
              ? "تم الاتفاق علي السعر"
              : "لم يتم الاتفاق علي السعر"),
        }).whenComplete(() {
          setState(() {
            Firestore.instance
                .collection('users')
                .document(widget.tradeid)
                .updateData({
              'rating': (double.parse(_totalRate) + allRating.round()).toString(),
              'custRate': _totalCust + 1,
            });
            DateTime now = DateTime.now();
            String b = now.month.toString();
            if (b.length < 2) {
              b = "0" + b;
            }
            String c = now.day.toString();
            if (c.length < 2) {
              c = "0" + c;
            }
            String d = now.hour.toString();
            if (d.length < 2) {
              d = "0" + d;
            }
            String e = now.minute.toString();
            if (e.length < 2) {
              e = "0" + e;
            }
            String f = now.second.toString();
            if (f.length < 2) {
              f = "0" + f;
            }

            DocumentReference documentReference = Firestore.instance
                .collection('Alarm')
                .document(widget.tradeid)
                .collection('Alarmid')
                .document();
            documentReference.setData({
              'ownerId': _userId,
              'traderid':widget.tradeid,
              'advID': "",
              'alarmid': documentReference.documentID,
              'cdate': now.toString(),
              'tradname': "_username",
              'ownername': "ownerName",
              'price': _commentController.text,
              'rate':allRating,
              'arrange': int.parse("${now.year.toString()}${b}${c}${d}${e}${f}"),
              'cType': "rating",
            });
            print('############## $allRating ###################');
            Toast.show(
                "تم إرسال تقييمك بنجاح",
                context,
                duration: Toast.LENGTH_LONG,
                gravity: Toast.BOTTOM);
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => FragmentPriceMe()));
          });
        });
      }else{
        Toast.show(
            "برجاء إكمال التقييم",
            context,
            duration: Toast.LENGTH_LONG,
            gravity: Toast.BOTTOM);
      }
    }));
  }
}
