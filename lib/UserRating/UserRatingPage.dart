import 'package:adobe_xd/gradient_xd_transform.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:priceme/screens/signin.dart';

import 'RatingClass.dart';

class UserRatingPage extends StatefulWidget {
  UserRatingPage(this.rating);

  final Rating rating;

  @override
  _UserRatingPageState createState() => new _UserRatingPageState();
}

//final mDatabase = FirebaseDatabase.instance.reference();
//
//final ratingReference = FirebaseDatabase.instance.reference().child('Rating');
//final ratingAvrageReference =
//    FirebaseDatabase.instance.reference().child('coiffuredata');

class _UserRatingPageState extends State<UserRatingPage> {
  List<Rating> itemsRate;
  var Rate = 0.0;
  var _averageRating, _totalRate, _totalCust;
  FirebaseAuth _firebaseAuth;
  String _userId;

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
    _rateController = new TextEditingController(text: widget.rating.rate);
    _commentController = new TextEditingController(text: widget.rating.comment);
  }

  dynamic data;

  Future<dynamic> getRatingAvrage() async {
    FirebaseAuth.instance.currentUser().then((user) => user == null
        ? Navigator.of(context, rootNavigator: false).push(MaterialPageRoute(
            builder: (context) => SignIn(), maintainState: false))
        : setState(() {
            _userId = user.uid;
            var userQuery = Firestore.instance
                .collection('users')
                .where('uid', isEqualTo: widget.rating.id)
                .limit(1);
            userQuery.getDocuments().then((data) {
              if (data.documents.length > 0) {
                setState(() {
                  _totalRate = data.documents[0].data['rating'];
                  _totalCust = data.documents[0].data['custRate'];
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
        child: Center(
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
              Padding(
                padding: const EdgeInsets.only(top: 150.0),
                child: Center(
                    child: Text(
                  "تقييمك يدعم تحسين الخدمة",
                  style: TextStyle(fontSize: 20.0),
                )),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: RatingBar(
                    initialRating: 0,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                    itemBuilder: (context, _) => Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    onRatingUpdate: (rating) {
                      print(rating);

                      setState(() {
                        Rate = rating;
                      });
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Center(
                  child: Text("${Rate}"),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    top: 20.0, right: 10.0, left: 10.0, bottom: 10.0),
                child: Center(
                  child: TextField(
                    controller: _commentController,
                    onChanged: (value) {},
                    //  controller: controller,
                    decoration: InputDecoration(
                        labelText: "اكتب تعليق هنا",
                        hintText: "اكتب تعليق هنا",
                        prefixIcon: Icon(Icons.comment),
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)))),
                  ),
                ),
              ),
              Center(
                child: InkWell(
                  onTap: () {
                    getUser(com: _commentController.text);
                  },
                  child: Padding(
                    padding:
                        const EdgeInsets.only(top: 50, left: 20, right: 20),
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
                          'إرسال التقييم',
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
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }



  void getUser({String com}) {
    FirebaseAuth.instance.currentUser().then((user) => user == null
        ? null
        : setState(() {
            _userId = user.uid;
            if (user != null && com != " ") {
              DocumentReference documentReference = Firestore.instance
                  .collection('Rating')
                  .document(widget.rating.id)
                  .collection(_userId)
                  .document();
              String ratingid = documentReference.documentID;
              documentReference.setData({
                'Comment': _commentController.text,
                'Rate': Rate,
              }).whenComplete(() {
                setState(() {
                  Firestore.instance
                      .collection('users')
                      .document(widget.rating.id)
                      .updateData({
                    'rating': (double.parse(_totalRate) + Rate).toString(),
                    'custRate': _totalCust + 1,
                  });
                  Navigator.pop(context);
                });
              });
            }
          }));
  }
}
