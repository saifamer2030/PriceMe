
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:priceme/Splash.dart';
import 'package:priceme/Videos/onevideo.dart';
import 'package:priceme/screens/advdetail.dart';
import 'package:priceme/screens/bookingpage.dart';
import 'package:priceme/screens/offerdetail.dart';
import 'package:priceme/screens/rentdetail.dart';

class TradeUserRate extends StatefulWidget {
  String traderid;
  TradeUserRate(this.traderid);
  @override
  _TradeUserRateState createState() => _TradeUserRateState();
}

class _TradeUserRateState extends State<TradeUserRate> {
  //List<AlarmaClass> alarmlist = [];

  //List<String> namelist = [];
  bool _load = false;
  String _userId="";
  final databasealarm = FirebaseDatabase.instance.reference().child("Rating");

  @override
  void initState() {
    super.initState();
    setState(() {
      _load = true;
    });

    FirebaseAuth.instance.currentUser().then((user) => user == null
        ? Navigator.of(context, rootNavigator: false).push(MaterialPageRoute(
        builder: (context) => Splash(), maintainState: false))

        : setState(() {
            _userId = user.uid;

          }));
  }

  final double _minimumPadding = 5.0;
  var _controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    Widget loadingIndicator = _load
        ? new Container(
            child: SpinKitCircle(color: const Color(0xff171732),),
          )
        : new Container();
    TextStyle textStyle = Theme.of(context).textTheme.subtitle;
    return Scaffold(
      backgroundColor: const Color(0xffffffff),
      floatingActionButton: Container(
        height: 30.0,
        width: 30.0,
        child: FittedBox(
          child: FloatingActionButton(
            heroTag: "unique225",

            onPressed: () {
              _controller.animateTo(0.0,
                  curve: Curves.easeInOut, duration: Duration(seconds: 1));
            },
            backgroundColor: Colors.white,
            elevation: 20.0,
            child: Icon(
              Icons.arrow_drop_up,
              size: 50,
              color: const Color(0xff171732),
            ),
          ),
        ),
      ),
      body:Container(
        child: StreamBuilder(
          stream: Firestore.instance
              .collection('Rating').document(widget.traderid).collection('tradeid')
              .orderBy('arrange',
              descending:
              true) //.where("userId", isEqualTo:_userId)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: Text("Loading.."));
            }
            print("mmmm${snapshot.data.documents}");

            return new ListView.builder(
                physics: BouncingScrollPhysics(),
                shrinkWrap: true,
                controller: _controller,
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context, index) {
 print("mmmm${snapshot.data.documents}");
                  return _firebasedata(
                      context, index, snapshot.data.documents[index]);
                });
          },
        ),
      ),
    );
  }

  Widget _firebasedata( BuildContext context, int index,  document) {
    return  Padding(
      padding: const EdgeInsets.only(top: 5.0, right: 5.0, left: 5.0),
      child: Card(
        shape: new RoundedRectangleBorder(
            side: new BorderSide(color: Colors.grey, width: 3.0),
            borderRadius: BorderRadius.circular(10.0)),
        //borderOnForeground: true,
        elevation: 10.0,
        margin: EdgeInsets.all(1),
        child: Container(
            padding: EdgeInsets.all(8),
            child: Container(
                width: 350,
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            document['Comment'],
                            style: TextStyle(
                              color: Colors.blue,
                              fontSize: 15,
                            ),
                            textDirection: TextDirection.rtl,
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            document['AgreementPrice'],
                            style: TextStyle(
                             color: Colors.green,
                              fontSize: 15,
                            ),
                            textDirection: TextDirection.rtl,
                          ),
                          Text(
                            document['date'].toString(),
                            style: TextStyle(
                            //  color: Colors.blue,
                              fontSize: 15,
                            ),
                            textDirection: TextDirection.rtl,
                          ),

                        ],
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          RatingBar(
                            initialRating: document['Rate'],
                            unratedColor: Colors.grey[500],
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            itemCount: 5,
                            itemPadding:
                            EdgeInsets.symmetric(horizontal: 0.0),
                            itemBuilder: (context, _) =>
                                Icon(
                                  Icons.star,
                                  color: Colors.amber,
//                            size: 15,
                                ),
                            onRatingUpdate: null,
                          ),
                          Text(
                            "المجموع",
                            style: TextStyle(
                            //  color: Colors.blue,
                              fontSize: 15,
                            ),
                            textDirection: TextDirection.rtl,
                          ),

                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [

                          RatingBar(
                            initialRating: document['Rate1'],
                            unratedColor: Colors.grey[500],
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            itemCount: 5,
                            itemPadding:
                            EdgeInsets.symmetric(horizontal: 0.0),
                            itemBuilder: (context, _) =>
                                Icon(
                                  Icons.star,
                                  color: Colors.amber,
//                            size: 15,
                                ),
                            onRatingUpdate: null,
                          ),
                          Text(
                            "نوعية الخدمة",
                            style: TextStyle(
                             // color: Colors.blue,
                              fontSize: 15,
                            ),
                            textDirection: TextDirection.rtl,
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [

                          RatingBar(
                            initialRating: document['Rate2'],
                            unratedColor: Colors.grey[500],
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            itemCount: 5,
                            itemPadding:
                            EdgeInsets.symmetric(horizontal: 0.0),
                            itemBuilder: (context, _) =>
                                Icon(
                                  Icons.star,
                                  color: Colors.amber,
//                            size: 15,
                                ),
                            onRatingUpdate: null,
                          ),
                          Text(
                            "الالتزام بالمواعيد",
                            style: TextStyle(
                              // color: Colors.blue,
                              fontSize: 15,
                            ),
                            textDirection: TextDirection.rtl,
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [

                          RatingBar(
                            initialRating: document['Rate3'],
                            unratedColor: Colors.grey[500],
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            itemCount: 5,
                            itemPadding:
                            EdgeInsets.symmetric(horizontal: 0.0),
                            itemBuilder: (context, _) =>
                                Icon(
                                  Icons.star,
                                  color: Colors.amber,
//                            size: 15,
                                ),
                            onRatingUpdate: null,
                          ),
                          Text(
                            "المعاملة مع الزبون",
                            style: TextStyle(
                              // color: Colors.blue,
                              fontSize: 15,
                            ),
                            textDirection: TextDirection.rtl,
                          ),
                        ],
                      ),

                    ],
                  ),
                ))),
      ),
    );
  }
}
