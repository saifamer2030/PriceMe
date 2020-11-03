
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:priceme/Splash.dart';
import 'package:priceme/Videos/onevideo.dart';
import 'package:priceme/screens/advdetail.dart';
import 'package:priceme/screens/offerdetail.dart';
import 'package:priceme/screens/rentdetail.dart';

class MyAlarms extends StatefulWidget {

  @override
  _MyAlarmsState createState() => _MyAlarmsState();
}

class _MyAlarmsState extends State<MyAlarms> {
  //List<AlarmaClass> alarmlist = [];

  //List<String> namelist = [];
  bool _load = false;
  String _userId="";
  final databasealarm = FirebaseDatabase.instance.reference().child("Alarm");

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
              .collection('Alarm').document(_userId).collection('Alarmid')
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
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        color: Colors.grey[300],
        shape: new RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4.0)),
        //borderOnForeground: true,
        elevation: 10.0,
        margin: EdgeInsets.only(right: 1, left: 1, bottom: 2),
        child: InkWell(
          onTap: () {
            setState(() {
              if (document['cType'] == "chat") {
                final userdatabaseReference =
                    FirebaseDatabase.instance.reference().child("userdata");
                userdatabaseReference
                    .child(document['wid'])
                    .child("cName")
                    .once()
                    .then((DataSnapshot snapshot5) {
                  setState(() {
                    if (snapshot5.value != null) {
                      setState(() {
                        // Navigator.push(
                        //   context,
                        //   new MaterialPageRoute(
                        //       builder: (BuildContext context) => new ChatPage(
                        //           name: snapshot5.value, uid: document['wid'])),
                        // );
                      });
                    }
                  });
                });
              }
              else if( document['cType'] == "advcomment"){
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            AdvDetail(document['ownerId'], document['advID'])));
              }
              else if( document['cType'] == "offercomment"){
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            OfferDetail(document['ownerId'], document['advID'])));
              }
              else if( document['cType'] == "rentcomment"){
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            RentDetail(document['ownerId'], document['advID'])));
              }
              else if( document['cType'] == "videofav"){
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            OneVideo(document['advID'])));
              }
            });
          },
          child: Container(
            height: 100,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child:document['cType'] == "videofav"
                          ? new Icon(
                              Icons.favorite,
                              color: Colors.black,
                            )
                          : new Icon(
                              Icons.mail_outline,
                              color: Colors.black,
                            ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: document['cType'] == "videofav"
                                    ? Text(
                                        " ${document['tradname']} منحك اعجاب لفيديو ${document['cType']} ",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 13,
                                          //    fontWeight: FontWeight.bold
                                        ),
                                      )
                                    : Text(
                                        " رسالة جديدة من ${document['tradname']}",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 13,
                                          //    fontWeight: FontWeight.bold
                                        ),
                                      ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Text(
                                  " ${document['cdate']}  ",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 13,
                                    //    fontWeight: FontWeight.bold
                                  ),
                                )
                              ),

                            ],
                          ),
                          new Icon(
                            Icons.person,
                            color: Colors.black,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )),
        ),
      ),
    );
  }
}
