
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:priceme/classes/AdvClass.dart';
import 'package:priceme/screens/signin.dart';

import 'package:toast/toast.dart';

import 'advdetail.dart';

class MyAdvertisement extends StatefulWidget {
  MyAdvertisement();
  @override
  _MyAdvertisementState createState() => _MyAdvertisementState();
}

class _MyAdvertisementState extends State<MyAdvertisement> {
  List<AdvClass> advlist = [];
  bool _load = false;
  String _userId;


  @override
  void initState() {
    super.initState();

    FirebaseAuth.instance.currentUser().then((user) => user == null
        ? Navigator.of(context, rootNavigator: false).push(MaterialPageRoute(
        builder: (context) => SignIn(), maintainState: false))

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
      body: Container(
        child:  StreamBuilder(
          stream: Firestore.instance.collection('advertisments').orderBy('carrange', descending: true)//.where("cproblemtype", isEqualTo:"قطع غيار")
              .where("userId", isEqualTo:_userId).snapshots(),
          //print an integer every 2secs, 10 times
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: Text("Loading.."));
            }
            return new ListView.builder(
                physics: BouncingScrollPhysics(),
                shrinkWrap: true,
                controller: _controller,
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context, index) {
                  return  Slidable(
                      actionPane: SlidableDrawerDismissal(),
                  child:firebasedata(context,index, snapshot.data.documents[index]),
                    actions: <Widget>[
                      Container(
                        padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                        child: IconSlideAction(
                          caption: 'تعديل',
                          color: Colors.green,
                          icon: Icons.edit,
                          onTap: () {
                            // Navigator.push(
                            //   context,
                            //   new MaterialPageRoute(
                            //       builder: (BuildContext context) =>
                            //       new EditAdsForCars(
                            //         index,
                            //         advlist.length,
                            //         advlist[index].cId,
                            //         advlist[index].cdate,
                            //         advlist[index].chead,
                            //         advlist[index].ctitle,
                            //         advlist[index].cdepart,
                            //         advlist[index].cregion,
                            //         advlist[index].cphone,
                            //         advlist[index].cprice,
                            //         advlist[index].cdetail,
                            //         advlist[index].cpublished,
                            //         advlist[index].curi,
                            //         advlist[index].curilist,
                            //         advlist[index].cagekm,
                            //         advlist[index].csale,
                            //         advlist[index].cauto,
                            //         advlist[index].coil,
                            //         advlist[index].cNew,
                            //         advlist[index].cno,
                            //         advlist[index].cname,
                            //         departlist1,
                            //         widget.regionlist,
                            //         advlist[index].cdep11,
                            //         advlist[index].cdep22,
                            //         advlist[index].cmodel,
                            //
                            //       )),
                            // );
                          },
                        ),
                      )
                    ],
                    secondaryActions: <Widget>[
                      Container(
                          padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                          child: IconSlideAction(
                            caption: 'Delete',
                            color: Colors.red,
                            icon: Icons.delete,
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) =>
                                new CupertinoAlertDialog(
                                  title: new Text("تنبية"),
                                  content: new Text("تبغي تحذف اعلانك؟"),
                                  actions: [
                                    CupertinoDialogAction(
                                        isDefaultAction: false,
                                        child: new FlatButton(
                                          onPressed: () {

//                                                 setState(() {
//                                                   FirebaseDatabase.instance.reference()
//                                                       .child("advdata").child(_userId).child(advlist[index].chead)
//                                                       .remove().whenComplete(() =>
//                                                       Toast.show("تم الحذف فى المفضلة", context,
//                                                           duration: Toast.LENGTH_SHORT,
//                                                           gravity: Toast.BOTTOM));
//                                                   setState(() async {
//                                                     advlist.removeAt(index);
//                                                     Navigator.pop(context);
//
//                                                     _imageUrls = advlist[index].curilist
//                                                         .replaceAll(" ", "")
//                                                         .replaceAll("[", "")
//                                                         .replaceAll("]", "")
//                                                         .split(",");
//
// //                                            final StorageReference storageRef =
// //                                            FirebaseStorage.instance.ref().child('myimage');
//                                                     for(String imge in _imageUrls){
//
//                                                       final StorageReference storageRef =
//                                                       await FirebaseStorage.instance.getReferenceFromUrl(imge);
//                                                       //   print("hhhhhhhhhhhhhhh${storageRef.path}");
//                                                       await storageRef.delete().whenComplete(() {
//                                                         // print("hhhhhhhhhhhhhhh$imge");
//                                                       });
//                                                     }
//
//                                                   });
//                                                 });
                                          }
                                          ,
                                          child: Text("موافق"),
                                        )),
                                    CupertinoDialogAction(
                                        isDefaultAction: false,
                                        child: new FlatButton(
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          child: Text("إلغاء"),
                                        )),
                                  ],
                                ),
                              );
                            },
                          )),
                    ],

                  );
                });
          },
        ),
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
              child: Row(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Container(
                        color: Colors.white,
                        child: Stack(
                          children: <Widget>[
                            Center(
                              child: document['curi'] == null
                                  ? new Image.asset("assets/images/ic_logo.png",
                              )
                                  : new Image.network(
                                document['curi'],
                                fit: BoxFit.fitHeight,
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(2.0),
                                color:const Color(0xff444460),
                              ),
                              child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child:  Text(
                                      document['cproblemtype'],
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





                          ],
                        ),
                        width: 100,
                        height: 130,
                      ),
                      Container(
                          width: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(2.0),
                            color:Colors.black12,
                          ),
                          child:  Padding(
                            padding: const EdgeInsets.only(right: 5),
                            child: Text(
                              "منذ: ${ document['cdate']}",
                              textDirection: TextDirection.rtl,
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 10,
//                                  fontFamily: 'Estedad-Black',
                                  fontStyle: FontStyle.normal),
                            ),
                          )

                      ),
                    ],
                  ),
                  Container(
                    height: 130,
                    child: Stack(
                      //alignment: Alignment.bottomCenter,
                      children: <Widget>[
                        Positioned(
                          top: 0,
                          right: 0,
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Text(
                              document['ctitle'],
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
                        ),
                        Positioned(
                          top: 50,
                          right: 0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[

                              SizedBox(
                                height: _minimumPadding,
                                width: _minimumPadding*4,
                              ),

                              SizedBox(
                                height: _minimumPadding,
                                width: _minimumPadding,
                              ),
                              document['mfault'] == ""
                                  ? Text(document['sparepart'])
                                  : Text(
                                "${document['mfault']}-${document['subfault']}",
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
                        ),

                        Positioned(
                          top: 100,
                          right: 0,
                          child: Padding(
                            padding: const EdgeInsets.all(0.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  document['fPlaceName'],
                                  textDirection: TextDirection.rtl,
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
//                                      fontFamily: 'Estedad-Black',
                                      fontSize: 10.0,
                                      fontStyle: FontStyle.normal),
                                ),
                                new Icon(
                                  Icons.location_on,
                                  color: Colors.black,
                                  size: 15,
                                ),

                              ],
                            ),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 10, right: 5, top: 5, bottom: 5),
                              child: Text(
                                "                                                                    ",
                                textDirection: TextDirection.rtl,
                                textAlign: TextAlign.right,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              )),
        ),
      ),
    );
  }
}