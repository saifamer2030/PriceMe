
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:priceme/Splash.dart';
import 'package:priceme/classes/AdvClass.dart';
import 'package:priceme/screens/editadv.dart';
import 'package:toast/toast.dart';

import 'advdetail.dart';

class MyAdvertisementTrade extends StatefulWidget {
  MyAdvertisementTrade();
  @override
  _MyAdvertisementTradeState createState() => _MyAdvertisementTradeState();
}

class _MyAdvertisementTradeState extends State<MyAdvertisementTrade> {
  List<AdvClass> advlist = [];
  bool _load = false;
  String _userId="";
  List<String> _imageUrls;


  @override
  void initState() {
    super.initState();

    FirebaseAuth.instance.currentUser().then((user) => user == null
        ? Navigator.of(context, rootNavigator: false).push(MaterialPageRoute(
        builder: (context) => Splash(), maintainState: false))

        : setState(() {_userId = user.uid;}));
  }

  final double _minimumPadding = 5.0;
  var _controller = ScrollController();


  @override
  Widget build(BuildContext context) {
    Widget loadingIndicator = _load
        ? new Container(
      child: SpinKitCircle(color: Colors.black),
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
            heroTag: "unique9",
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
      body: StreamBuilder(
        stream: Firestore.instance.collection('advertisments').orderBy('carrangetrade', descending: true)//.where("cproblemtype", isEqualTo:"قطع غيار")
            .where("tradeidselected", isEqualTo:_userId).snapshots(),
        //print an integer every 2secs, 10 times
        builder: (context, snapshot) {
          if (snapshot.data?.documents == null || !snapshot.hasData)
            return Center(child: Text("لا يوجد بيانات...",));
          return Container(
            child: ListView(
              shrinkWrap: true,
              children: <Widget>[
                Container(
                    padding: EdgeInsets.all(10),
                    child: SingleChildScrollView(
                      child: GridView.builder(
                        physics: ScrollPhysics(),
                        shrinkWrap: true,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 6,
                          childAspectRatio: MediaQuery.of(context).size.width /
                              (MediaQuery.of(context).size.height*1),
                        ),
                        itemCount:snapshot.data.documents.length,
                        itemBuilder: (BuildContext context, int index) {
                          return firebasedata(context,index, snapshot.data.documents[index]);
                        },
                      ),
                    ))
              ],
            ),
          );

        },
      ),
    );
  }

  Widget firebasedata(BuildContext context,int index, DocumentSnapshot document) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Card(
        shape: new RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4.0)),
        //borderOnForeground: true,
        elevation: 10.0,
        margin: EdgeInsets.only(right: 1, left: 1, bottom: 2),
        child: InkWell(
          onTap: () {

            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        AdvDetail(document['userId'], document['advid'])));



          },
          child: Container(
            // height: 1000,
              child: Column(
                children: <Widget>[
                  Stack(
                    children: [
                      Container(
                        height: 200,
                        child:  document['curi'] == null
                            ? new Image.asset("assets/images/ic_logo2.png",
                        )
                            : new Image.network(
                          document['curi'],
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        top: 0,
                        left: 0,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(2.0),
                            color:const Color(0xff444460),
                          ),
                          child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child:  Text(
                                document['cproblemtype'].toString(),
                                textDirection: TextDirection.rtl,
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
//                                          fontFamily: 'Estedad-Black',
                                    fontStyle: FontStyle.normal),
                              )
                          ),

                        ),
                      ),
                      Positioned(
                        top: 0,
                        right: 0,
                        child: Container(
                            width: 100,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(2.0),
                              color:Colors.black54,
                            ),
                            child:  Padding(
                              padding: const EdgeInsets.only(right: 5),
                              child: Text(
                                "منذ: ${ document['cdate'].toString()}",
                                textDirection: TextDirection.rtl,
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
//                                  fontFamily: 'Estedad-Black',
                                    fontStyle: FontStyle.normal),
                              ),
                            )

                        ),
                      ),

                    ],
                  ),

                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text(
                      document['ctitle'].toString(),
                      textDirection: TextDirection.rtl,
                      textAlign: TextAlign.right,
                      style: TextStyle(
                          color: Colors.green,
//                                  fontFamily: 'Estedad-Black',
                          fontWeight: FontWeight.bold,
                          fontSize: 15.0,
                          fontStyle: FontStyle.normal),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[


                     Text(
                        "${document['subfault']}",
                        textDirection: TextDirection.rtl,
                        textAlign: TextAlign.right,
                        style: TextStyle(
//                                      fontFamily: 'Estedad-Black',
                            fontSize: 10.0,
                            fontStyle: FontStyle.normal),
                      ),
                      new Icon(
                        Icons.directions_car,
                        color: Colors.black,
                        size: 15,
                      ),
                    ],
                  ),
                ],
              )),
        ),
      ),
    );
  }

}
