import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:priceme/classes/CommentClass.dart';

import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:toast/toast.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class AdvDetail extends StatefulWidget {
  String userId;
  String advid;

  AdvDetail(this.userId, this.advid);

  @override
  _AdvDetailState createState() => _AdvDetailState();
}

class _AdvDetailState extends State<AdvDetail> {
  String _userId;
  String _username;
  String _userphone;

  String cdate;
  String cdiscribtion;
  String cbody;
  String curi;
  String cimagelist;
  String caudiourl;
  String cproblemtype;
  bool cpublished;
  String ccar;
  String ccarversion;
  String cmodel;
  int carrange;
  String mfault;
  String subfault;
  String sparepart;
  String ctitle;
  String fromPLat;
  String fromPLng;
  String fPlaceName;
  String cNew;
  String ownerName;
  String ownerPhone;

  var _formKey1 = GlobalKey<FormState>();
  var refreshKey = GlobalKey<RefreshIndicatorState>();
  Future<void> _launched;
  var _controller = ScrollController();
  bool favcheck = false;

  //List<OrderDetailClass> orderlist = [];
  List<CommentClass> commentlist = [];

  //var _controller = ScrollController();

  //AdvNameClass advnNameclass;
  final double _minimumPadding = 5.0;
  bool _load = false;
  TextEditingController _commentController = TextEditingController();
  List<String> _imageUrls;



  @override
  void initState() {
    super.initState();

    FirebaseAuth.instance.currentUser().then((user) => user == null
        ? _userId=null
        : setState(() {_userId = user.uid;
    var userQuery = Firestore.instance.collection('users').where('uid', isEqualTo: _userId).limit(1);
    userQuery.getDocuments().then((data){
      if (data.documents.length > 0){
        setState(() {
          String _username;
          String _userphone;
          _username = data.documents[0].data['name'];
          _userphone = data.documents[0].data['phone'];
          // if(_cName==null){_cName=user.displayName??"اسم غير معلوم";}
          if(_username==null){
            if(user.displayName==null||user.displayName==""){
              _username="ايميل غير معلوم";
            }else{_username=user.displayName;}}
          // print("mmm$_cMobile+++${user.phoneNumber}***");
          if(_userphone==null){
            if(user.phoneNumber==null||user.phoneNumber==""){
              _userphone="لا يوجد رقم هاتف بعد";
            }else{_userphone=user.phoneNumber;}}

        });
      }
    });
    }));
    setState(() {
      var userQuery = Firestore.instance
          .collection('advertisments')
          .where('userId', isEqualTo: widget.userId)
          .where('advid', isEqualTo: widget.advid)
          .limit(1);
      userQuery.getDocuments().then((data) {
        print("${ widget.advid}//mmoo${data.documents.length}");

        if (data.documents.length > 0) {
          setState(() {
            cdate = data.documents[0].data['cdate'];
            cdiscribtion = data.documents[0].data['cdiscribtion'];
            cbody = data.documents[0].data['cbody'];
            curi = data.documents[0].data['curi'];
            cimagelist = data.documents[0].data['cimagelist'];
            caudiourl = data.documents[0].data['caudiourl'];
            cproblemtype = data.documents[0].data['cproblemtype'];
            ccar = data.documents[0].data['ccar'];
            cpublished = data.documents[0].data['cpublished'];
            ccarversion = data.documents[0].data['ccarversion'];
            cmodel = data.documents[0].data['cmodel'];
            mfault = data.documents[0].data['mfault'];

            subfault = data.documents[0].data['subfault'];
            sparepart = data.documents[0].data['sparepart'];
            ctitle = data.documents[0].data['ctitle'];
            fromPLat = data.documents[0].data['fromPLat'];
            fromPLng = data.documents[0].data['fromPLng'];
            fPlaceName = data.documents[0].data['fPlaceName'];
            cNew = data.documents[0].data['cNew'];
            ownerName = data.documents[0].data['pname'];
            ownerPhone = data.documents[0].data['pphone'];

            _imageUrls = cimagelist
                .replaceAll(" ", "")
                .replaceAll("[", "")
                .replaceAll("]", "")
                .split(",");
          });
        }
      });
    });
//     final userdatabaseReference =
//         FirebaseDatabase.instance.reference().child("userdata");
//     final commentdatabaseReference = FirebaseDatabase.instance
//         .reference()
//         .child("commentsdata")
//         .child(widget.cId)
//         .child(widget.cDateID);
//     commentdatabaseReference.once().then((DataSnapshot snapshot) {
//       var KEYS = snapshot.value.keys;
//       var DATA = snapshot.value;
//       //Toast.show("${snapshot.value.keys}",context,duration: Toast.LENGTH_LONG,gravity:  Toast.BOTTOM);
//
//       commentlist.clear();
//
//       for (var individualkey in KEYS) {
//         // if (!blockList.contains(individualkey) &&user.uid != individualkey) {
//         CommentClass commentclass = new CommentClass(
//           DATA[individualkey]['cId'],
//           DATA[individualkey]['cuserid'],
//           DATA[individualkey]['cdate'],
//           DATA[individualkey]['cheaddate'],
//           DATA[individualkey]['ccoment'],
//           DATA[individualkey]['cname'],
//           DATA[individualkey]['cadvID'],
//         );
//
//         setState(() {
//           commentlist.add(commentclass);
// //              Toast.show("${favchecklist.length}/${coiffurelist.length}",context,duration: Toast.LENGTH_LONG,gravity:  Toast.BOTTOM);
//         });
//         // }
//       }
//     });
//     FirebaseAuth.instance.currentUser().then((user) => user == null
//         ? setState(() {
//             setState(() {
//               favcheck = false;
//             });
//             //_userId = user.uid;
//
//             /////////////////////////////////////
//             final advdatabaseReference =
//                 FirebaseDatabase.instance.reference().child("advdata");
//             // print("kkkkkkkkkkkk${widget.cId}////${widget.cDateID}");
//
//             advdatabaseReference
//                 .child(widget.cId)
//                 .child(widget.cDateID)
//                 .once()
//                 .then((DataSnapshot data1) {
//               var DATA = data1.value;
//               setState(() {
//                 advnNameclass = new AdvNameClass(
//                   DATA['cId'],
//                   DATA['cdate'],
//                   DATA['chead'],
//                   DATA['ctitle'],
//                   DATA['cdepart'],
//                   DATA['cregion'],
//                   DATA['cphone'],
//                   DATA['cprice'],
//                   DATA['cdetail'],
//                   DATA['cpublished'],
//                   DATA['curi'],
//                   DATA['curilist'],
//                   DATA['cagekm'],
//                   DATA['csale'],
//                   ////
//                   DATA['cauto'],
//                   DATA['coil'],
//                   DATA['cNew'],
//                   DATA['cno'],
//                   DATA['cdep11'],
//                   DATA['cdep22'],
//                   DATA['cname'],
//                   DATA['cType'],
//
//                   DATA['carrange'],
//                   DATA['consoome'],
//                   DATA['cmodel'],
//                 );
//                 _imageUrls = DATA['curilist']
//                     .replaceAll(" ", "")
//                     .replaceAll("[", "")
//                     .replaceAll("]", "")
//                     .split(",");
//                 print("kkkkkkkkkkkk${DATA['cname']}");
//               });
//             });
//           })
//         : setState(() {
//             _userId = user.uid;
//             userdatabaseReference
//                 .child(
//                   _userId,
//                 )
//                 .child("cName")
//                 .once()
//                 .then((DataSnapshot snapshot) {
//               setState(() {
//                 if (snapshot.value != null) {
//                   setState(() {
//                     _username = snapshot.value;
//                   });
//                 }
//               });
//             });
//
//             //  Toast.show(_userId,context,duration: Toast.LENGTH_SHORT,gravity:  Toast.BOTTOM);
//
//             final databaseFav =
//                 FirebaseDatabase.instance.reference().child("userFavourits");
//             databaseFav
//                 .child(_userId)
//                 .child(widget.cId + widget.cDateID)
//                 .child("FavChecked")
//                 .once()
//                 .then((DataSnapshot snapshot5) {
//               setState(() {
//                 if (snapshot5.value != null) {
//                   setState(() {
//                     favcheck = snapshot5.value;
//                   });
//                 } else {
//                   setState(() {
//                     favcheck = false;
//                   });
//                 }
//               });
//             });
//             /////////////////////////////////////
//             final advdatabaseReference =
//                 FirebaseDatabase.instance.reference().child("advdata");
//             print("kkkkkkkkkkkk${widget.cId}////${widget.cDateID}");
//
//             advdatabaseReference
//                 .child(widget.cId)
//                 .child(widget.cDateID)
//                 .once()
//                 .then((DataSnapshot data1) {
//               var DATA = data1.value;
//               setState(() {
//                 advnNameclass = new AdvNameClass(
//                   DATA['cId'],
//                   DATA['cdate'],
//                   DATA['chead'],
//                   DATA['ctitle'],
//                   DATA['cdepart'],
//                   DATA['cregion'],
//                   DATA['cphone'],
//                   DATA['cprice'],
//                   DATA['cdetail'],
//                   DATA['cpublished'],
//                   DATA['curi'],
//                   DATA['curilist'],
//                   DATA['cagekm'],
//                   DATA['csale'],
//                   ////
//                   DATA['cauto'],
//                   DATA['coil'],
//                   DATA['cNew'],
//                   DATA['cno'],
//                   DATA['cdep11'],
//                   DATA['cdep22'],
//                   DATA['cname'],
//                   DATA['cType'],
//
//                   DATA['carrange'],
//                   DATA['consoome'],
//                   DATA['cmodel'],
//                 );
//                 _imageUrls = DATA['curilist']
//                     .replaceAll(" ", "")
//                     .replaceAll("[", "")
//                     .replaceAll("]", "")
//                     .split(",");
//                 print("kkkkkkkkkkkk${DATA['cname']}");
//               });
//             });
//           }));
  }

  @override
  Widget build(BuildContext context) {
//    Widget loadingIndicator = _load
//        ? new Container(
//      child: SpinKitCircle(color: Colors.blue),
//    )
//        : new Container();
    TextStyle textStyle = Theme.of(context).textTheme.subtitle;

    return Scaffold(
      backgroundColor: const Color(0xffffffff),
      body: Form(
        key: _formKey1,
        child: Padding(
            padding: EdgeInsets.only(
                top: _minimumPadding * 0,
                bottom: _minimumPadding * 0,
                right: _minimumPadding * 0,
                left: _minimumPadding * 0),
            child: ListView(
              physics: BouncingScrollPhysics(),
              children: <Widget>[
                //getImageAsset(),

                InkWell(
                  onTap: () {
                    // Navigator.push(
                    //     context,
                    //     new MaterialPageRoute(
                    //         builder: (context) =>
                    //             ProfilePhoto(_imageUrls)));
                  },
                  child: Container(
                      //color: Colors.grey[200],
                      width: 300,
                      height: 200,
                      child: _imageUrls == null
                          ? SpinKitThreeBounce(
                              size: 35,
                              color: const Color(0xff171732),
                            )
                          : Swiper(
                              loop: false,
                              duration: 1000,
                              autoplay: true,
                              autoplayDelay: 15000,
                              itemCount: _imageUrls.length,
                              pagination: new SwiperPagination(
                                margin: new EdgeInsets.fromLTRB(
                                    0.0, 0.0, 0.0, 0.0),
                                builder: new DotSwiperPaginationBuilder(
                                    color: Colors.grey,
                                    activeColor: const Color(0xff171732),
                                    size: 8.0,
                                    activeSize: 8.0),
                              ),
                              control: new SwiperControl(),
                              viewportFraction: 1,
                              scale: 0.1,
                              outer: true,
                              itemBuilder:
                                  (BuildContext context, int index) {
                                return Image.network(_imageUrls[index],
                                    fit: BoxFit.fill,
                                    loadingBuilder: (BuildContext context,
                                        Widget child,
                                        ImageChunkEvent loadingProgress) {
                                  if (loadingProgress == null)
                                    return child;
                                  return SpinKitThreeBounce(
                                    color: const Color(0xff171732),
                                    size: 35,
                                  );
                                });
                              },
                            )),
                ),
                Card(
                  shape: new RoundedRectangleBorder(
                      side: new BorderSide(
                          color: Colors.grey[400], width: 3.0),
                      borderRadius: BorderRadius.circular(10.0)),
                  //borderOnForeground: true,
                  elevation: 10.0,
                  margin: EdgeInsets.only(right: 1, left: 1, bottom: 2),
                  child: Container(
                      height: 120,
                      color: Colors.grey[300],
                      padding: EdgeInsets.all(0),
                      child: Stack(
                        alignment: Alignment.bottomCenter,
                        children: <Widget>[
                          Positioned(
                            top: 0,
                            right: 5,
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: ctitle == null
                                  ? Container()
                                  : Text(
                                      "${ctitle}",
                                      textDirection: TextDirection.rtl,
                                      textAlign: TextAlign.right,
                                      style: TextStyle(
                                          color: const Color(0xff171732),
//                                                fontFamily: 'Gamja Flower',
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15.0,
                                          fontStyle: FontStyle.normal),
                                    ),
                            ),
                          ),
                          Positioned(
                            top: 8,
                            left: 5,
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Row(
                                children: <Widget>[
                                  mfault == ""
                                      ? Text(sparepart)
                                      : Padding(
                                          padding: const EdgeInsets.only(
                                              top: 8.0),
                                          child:  Text("$mfault-$subfault"
                                            ,
                                                  textDirection:
                                                      TextDirection.rtl,
                                                  textAlign:
                                                      TextAlign.right,
                                                  style: TextStyle(
                                                      color: const Color(
                                                          0xff171732),
                                                      fontSize: 15.0,
//                                                      fontFamily: 'Gamja Flower',
                                                      fontStyle: FontStyle
                                                          .normal),
                                                ),
                                        ),
                                ],
                              ),
                            ),
                          ),
                                Positioned(
                                  top: 20,
                                  right: 5,
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Row(
                                      children: <Widget>[
                                        ownerName == null
                                            ? Text("")
                                            : Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 8.0),
                                                child: ownerName == null
                                                    ? Text("اسم غير معلوم")
                                                    : Text(
                                                        "المالك: ${ownerName}",
                                                        textDirection:
                                                            TextDirection.rtl,
                                                        textAlign:
                                                            TextAlign.right,
                                                        style: TextStyle(
                                                            fontSize: 15.0,
                                                            color: const Color(
                                                                0xff171732),
//                                                      fontFamily:
//                                                          'Gamja Flower',
                                                            fontStyle: FontStyle
                                                                .normal),
                                                      ),
                                              ),
                                        Icon(
                                          Icons.person,
                                          color: const Color(0xff171732),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                          Positioned(
                            top: 45,
                            right: 5,
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Row(
                                children: <Widget>[
                                  fPlaceName == null
                                      ? Container()
                                      : Padding(
                                          padding: const EdgeInsets.only(
                                              top: 8.0),
                                          child: Text(
                                            fPlaceName,
                                            textDirection:
                                                TextDirection.rtl,
                                            textAlign: TextAlign.right,
                                            style: TextStyle(
                                                fontSize: 15.0,
                                                color: const Color(
                                                    0xff171732),
//                                                      fontFamily:
//                                                          'Gamja Flower',
                                                fontStyle:
                                                    FontStyle.normal),
                                          ),
                                        ),
                                  Icon(
                                    Icons.location_on,
                                    color: const Color(0xff171732),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          /**    Positioned(
                              top: 50,
                              left: 5,
                              child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Row(
                              children: <Widget>[

                              advnNameclass==null?Text(""):
                              Padding(
                              padding: const EdgeInsets.only(top:8.0),
                              child: Text(advnNameclass.cregion,
                              textDirection: TextDirection.rtl,
                              textAlign: TextAlign.right,
                              style: TextStyle(
                              fontSize: 15.0,
                              fontFamily: 'Gamja Flower',
                              fontStyle: FontStyle.normal),
                              ),
                              ),
                              Icon(
                              Icons.location_on,
                              color: Colors.grey,
                              ),
                              ],
                              ),
                              ),
                              ),**/
                          Positioned(
                            top: 70,
                            right: 5,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                height: 25,
                                child: cdiscribtion == null
                                    ? Text("")
                                    : Padding(
                                        padding: const EdgeInsets.only(
                                            top: 8.0),
                                        child: Text(
                                          "${cdiscribtion}",
                                          textDirection:
                                              TextDirection.rtl,
                                          //minFontSize: 8,
                                          maxLines: 3,
                                          textAlign: TextAlign.right,
                                          style: TextStyle(
                                              fontSize: 15.0,
//                                                          fontFamily:
//                                                              'Gamja Flower',
                                              fontStyle:
                                                  FontStyle.normal),
                                        ),
                                      ),
                              ),
                            ),
                            /** Icon(
                                Icons.calendar_today,
                                color: Colors.grey,
                                ),**/
                          ),
                        ],
                      )),
                ),
                _userId == widget.userId
                    ? Container()
//                 Padding(
//                         padding: const EdgeInsets.all(5.0),
//                         child: Container(
//                           width:
//                               300 /*MediaQuery.of(context).size.width*/,
//                           height: 40,
//                           child: new RaisedButton(
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: <Widget>[
//                                 new Text("تمديد الاعلان"),
//                                 Padding(
//                                   padding:
//                                       const EdgeInsets.only(left: 10.0),
//                                   child: Icon(
//                                     Icons.check,
//                                     color: Colors.white,
//                                   ),
//                                 ),
//                               ],
//                             ),
//
//                             textColor: Colors.white,
//                             color: const Color(0xff171732),
//                             onPressed: () {
//                               // DateTime startdate =
//                               //     DateTime.parse(advnNameclass.cdate);
//                               // var newdate =
//                               //     startdate.add(new Duration(days: 14));
//                               // DateTime now = DateTime.now();
//                               // var permissiondate =
//                               //     startdate.add(new Duration(days: 10));
//                               //
//                               // String b = newdate.month.toString();
//                               // if (b.length < 2) {
//                               //   b = "0" + b;
//                               // }
//                               // String c = newdate.day.toString();
//                               // if (c.length < 2) {
//                               //   c = "0" + c;
//                               // }
//                               // String d = newdate.hour.toString();
//                               // if (d.length < 2) {
//                               //   d = "0" + d;
//                               // }
//                               // String e = newdate.minute.toString();
//                               // if (e.length < 2) {
//                               //   e = "0" + e;
//                               // }
//                               // String date1 =
//                               //     '${newdate.year}-${b}-${c} ${d}:${e}:00';
//                               //
//                               // if (_userId == null) {
//                               //   Toast.show(
//                               //       "ابشر .. سجل دخول الاول طال عمرك",
//                               //       context,
//                               //       duration: Toast.LENGTH_LONG,
//                               //       gravity: Toast.BOTTOM);
//                               // } else {
//                               //   if (now.isAfter(permissiondate)) {
//                               //     final advdatabaseReference =
//                               //         FirebaseDatabase.instance
//                               //             .reference()
//                               //             .child("advdata");
//                               //     advdatabaseReference
//                               //         .child(widget.cId)
//                               //         .child(widget.cDateID)
//                               //         .update({
//                               //       "cdate": date1,
//                               //     }).then((_) {
//                               //       setState(() {
//                               //         advnNameclass.cdate = date1;
//                               //         showNotification(
//                               //             date1,
//                               //             advnNameclass.ctitle,
//                               //             advnNameclass.cId,
//                               //             advnNameclass.chead,
//                               //             _username);
//                               //
//                               //         Toast.show("$date1تم التمديد الى ",
//                               //             context,
//                               //             duration: Toast.LENGTH_LONG,
//                               //             gravity: Toast.BOTTOM);
//                               //       });
//                               //     });
//                               //   } else {
//                               //     Toast.show(
//                               //         "يمكنك التجديد بعد مرور 10 ايام من موعد التجديد الاول او انتظار الاشعار",
//                               //         context,
//                               //         duration: Toast.LENGTH_LONG,
//                               //         gravity: Toast.BOTTOM);
//                               //   }
//                               // }
//                             },
// //
//                             shape: new RoundedRectangleBorder(
//                                 borderRadius:
//                                     new BorderRadius.circular(10.0)),
//                           ),
//                         ),
//                       )
                    : Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Container(
                          width:
                              300 /*MediaQuery.of(context).size.width*/,
                          height: 40,
                          child: new RaisedButton(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                new Text("الطلب"),
                                Padding(
                                  padding:
                                      const EdgeInsets.only(left: 10.0),
                                  child: Icon(
                                    Icons.check,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),

                            textColor: Colors.white,
                            color: const Color(0xff171732),
                            onPressed: () {
                              if (_userId == null) {
                                Toast.show(
                                    "ابشر .. سجل دخول الاول طال عمرك",
                                    context,
                                    duration: Toast.LENGTH_LONG,
                                    gravity: Toast.BOTTOM);
                              } else {
                                // Navigator.push(
                                //   context,
                                //   new MaterialPageRoute(
                                //       builder: (BuildContext context) =>
                                //           new ChatPage(
                                //               name: widget.cName,
                                //               uid: widget.cId)),
                                // );
                              }
                            },
//
                            shape: new RoundedRectangleBorder(
                                borderRadius:
                                    new BorderRadius.circular(10.0)),
                          ),
                        ),
                      ),
                SizedBox(
                  height: 2 * _minimumPadding,
                  width: _minimumPadding,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Container(
                        width: 150 /*MediaQuery.of(context).size.width*/,
                        height: 40,
                        child: new RaisedButton(
                          child: Row(
                            mainAxisAlignment:
                                MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              new Text(
                                "تواصل عبر الدردشة",
                                style: TextStyle(
                                  color: const Color(0xff171732),
                                  fontSize: 10,
                                ),
                              ),
                              Icon(
                                Icons.mail_outline,
                                color: const Color(0xff171732),
                              ),
                            ],
                          ),
                          textColor: const Color(0xff171732),
                          color: Colors.grey[400],
                          onPressed: () {
                            if (_userId == null) {
                              Toast.show(
                                  "ابشر .. سجل دخول الاول طال عمرك",
                                  context,
                                  duration: Toast.LENGTH_LONG,
                                  gravity: Toast.BOTTOM);
                            } else {
                              // Navigator.push(
                              //   context,
                              //   new MaterialPageRoute(
                              //       builder: (BuildContext context) =>
                              //           new ChatPage(
                              //               name: widget.cName,
                              //               uid: widget.cId)),
                              // );
                            }
                          },

//
                          shape: new RoundedRectangleBorder(
                              borderRadius:
                                  new BorderRadius.circular(10.0)),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Container(
                        width: 150 /*MediaQuery.of(context).size.width*/,
                        height: 40,
                        child: new RaisedButton(
                          child: Row(
                            mainAxisAlignment:
                                MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              new Text(
                                "تواصل برقم الجوال",
                                style: TextStyle(
                                  color: const Color(0xff171732),
                                  fontSize: 10,
                                ),
                              ),
                              Icon(
                                Icons.phone,
                                color: const Color(0xff171732),
                              ),
                            ],
                          ),
                          textColor: const Color(0xff171732),
                          color: Colors.grey[400],
                          onPressed: () {
                            if (_userId == null) {
                              Toast.show(
                                  "ابشر .. سجل دخول الاول طال عمرك",
                                  context,
                                  duration: Toast.LENGTH_LONG,
                                  gravity: Toast.BOTTOM);
                            } else {
                              if (ownerPhone != null) {
                                _makePhoneCall(
                                    'tel:${ownerPhone}');
                              } else {
                                Toast.show("حاول تاني طال عمرك", context,
                                    duration: Toast.LENGTH_LONG,
                                    gravity: Toast.BOTTOM);
                              }
                            }
                          },
//
                          shape: new RoundedRectangleBorder(
                              borderRadius:
                                  new BorderRadius.circular(10.0)),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 2 * _minimumPadding,
                  width: _minimumPadding,
                ),
                Card(
                  shape: new RoundedRectangleBorder(
                      side: new BorderSide(
                          color: Colors.grey[400], width: 3.0),
                      borderRadius: BorderRadius.circular(10.0)),
                  //borderOnForeground: true,
                  elevation: 10.0,
                  margin: EdgeInsets.only(right: 1, left: 1, bottom: 2),
                  child: Container(
                      height: 330,
                      color: Colors.grey[300],
                      padding: EdgeInsets.all(0),
                      child: Column(
                        //alignment: Alignment.bottomCenter,
                        children: <Widget>[
                          Flexible(
                              child: Center(
                            child: commentlist.length == 0
                                ? new Text(
                                    "لا يوجد تعليق",
                                  )
                                : new ListView.builder(
                                    physics: BouncingScrollPhysics(),
                                    controller: _controller,
                                    // reverse: true,
                                    itemCount: commentlist.length,
                                    itemBuilder:
                                        (BuildContext ctxt, int index) {
                                      return InkWell(
                                        child: _firebasedata(
                                          index,
                                          commentlist.length,
                                          commentlist[index].ownerId,
                                          commentlist[index].traderid,
                                          commentlist[index].advID,
                                          commentlist[index].commentid,
                                          commentlist[index].tradname,
                                          commentlist[index].ownername,
                                          commentlist[index].cdate,
                                          commentlist[index].price,
                                          commentlist[index].rate,
                                        ),

                                      );
                                    }),
                          )),
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Row(
                              children: <Widget>[
                                Container(
                                  width: 320,
                                  height: 60,
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Card(
                                      elevation: 0.0,
                                      color: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(5),
                                      ),
                                      child: Directionality(
                                        textDirection: TextDirection.rtl,
                                        child: TextFormField(
                                          textAlign: TextAlign.right,
                                          keyboardType:
                                              TextInputType.number,
                                          textDirection:
                                              TextDirection.rtl,
                                          controller: _commentController,
                                          validator: (String value) {
                                            if ((value.isEmpty)) {
                                              return 'ابشر .. لكن اكتب السعر الاول طال عمرك';
                                            }
                                          },

                                          onChanged: (value) {},
                                          //  controller: controller,
                                          decoration: InputDecoration(
                                              errorStyle: TextStyle(
                                                  color: Colors.red,
                                                  fontSize: 15.0),
                                              labelText: "السعر بالدينار الاردنى",
                                              // hintText: "التعليق",

//                                prefixIcon: Icon(
//                                  Icons.phone_iphone,
//                                  color: Colors.pinkAccent,
//                                ),
                                              border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(
                                                              5.0)))),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () async {
                                    if (_formKey1.currentState
                                        .validate()) {
                                      try {
                                        final result =
                                            await InternetAddress.lookup(
                                                'google.com');
                                        if (result.isNotEmpty &&
                                            result[0]
                                                .rawAddress
                                                .isNotEmpty) {
                                         // createRecord(_username);
                                        }
                                      } on SocketException catch (_) {
                                        //  print('not connected');
                                        Toast.show(
                                            "انت غير متصل بشبكة إنترنت طال عمرك",
                                            context,
                                            duration: Toast.LENGTH_LONG,
                                            gravity: Toast.BOTTOM);
                                      }

//                                                setState(() {
//                                                  _load2 = true;
//                                                });

                                    }
                                  },
                                  child: Icon(
                                    Icons.add_comment,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )),
                ),
              ],
            )),
      ),
    );
  }

//   void createRecord(_username) {
//     DateTime now = DateTime.now();
//     String b = now.month.toString();
//     if (b.length < 2) {
//       b = "0" + b;
//     }
//     String c = now.day.toString();
//     if (c.length < 2) {
//       c = "0" + c;
//     }
//     String d = now.hour.toString();
//     if (d.length < 2) {
//       d = "0" + d;
//     }
//     String e = now.minute.toString();
//     if (e.length < 2) {
//       e = "0" + e;
//     }
//     String f = now.second.toString();
//     if (f.length < 2) {
//       f = "0" + f;
//     }
//     final databasealarm =
//         FirebaseDatabase.instance.reference().child("Alarm").child(widget.userId);
//     setState(() {
//       DateTime now = DateTime.now();
//
//       // String date1 ='${now.year}-${now.month}-${now.day}';// ${now.hour}:${now.minute}:00.000';
//       String date =
//           '${now.year}-${now.month}-${now.day}-${now.hour}-${now.minute}-00';
//       final commentbaseReference =
//           FirebaseDatabase.instance.reference().child("commentsdata");
//       commentbaseReference
//           .child(widget.userId)
//           .child(widget.advid)
//           .child(_userId + date)
//           .set({
//         'cId': widget.userId,
//         'cuserid': _userId,
//         'cdate': now.toString(),
//         'cheaddate': _userId + date,
//         'ccoment': _commentController.text,
//         'cname': _username == null ? "لا يوجد اسم" : _username,
//         'cadvID': widget.advid,
//       }).whenComplete(() {
//         Toast.show("ارسالنا تعليقك طال عمرك", context,
//             duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
//         CommentClass commentclass = new CommentClass(
//           widget.cId,
//           _userId,
//           now.toString(),
//           _userId + date,
//           _commentController.text,
//           _username == null ? "لا يوجد اسم" : _username,
//           widget.cDateID,
//         );
//         setState(() {
//           commentlist.add(commentclass);
//           _commentController.text = "";
//           //      var cursor = (5/commentlist.length)* _controller.position.maxScrollExtent;//specific item
//
//           _controller.animateTo(
//             // NEW
//             _controller.position.maxScrollExtent * 1.2, // NEW
//             duration: const Duration(milliseconds: 500), // NEW
//             curve: Curves.ease, // NEW
//           );
//         });
//
//         databasealarm.push().set({
//           'alarmid': databasealarm.push().key,
//           'wid': widget.cId,
//           'Name': _username == null ? "لا يوجد اسم" : _username,
//           'cType': "profilecomment",
//           'chead': widget.cDateID,
//           'cDate': "${now.year.toString()}-${b}-${c} ${d}:${e}:${f}",
//           'arrange': int.parse("${now.year.toString()}${b}${c}${d}${e}${f}")
//         }).whenComplete(() {
//           Toast.show("تم التعليق بنجاح", context,
//               duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
// //          CommentClass commentclass =
// //          new CommentClass(
// //            widget.cId,
// //            _userId,
// //            now.toString(),
// //            _userId+date,
// //            _commentController.text,
// //            _username==null?"لا يوجد اسم":_username,
// //            widget.cDateID,
// //
// //          );
// //          setState(() {
// //            commentlist.add(commentclass);
// //            _commentController.text="";
// //            //      var cursor = (5/commentlist.length)* _controller.position.maxScrollExtent;//specific item
// //
// //            _controller.animateTo(                                      // NEW
// //              _controller.position.maxScrollExtent*1.1,                     // NEW
// //              duration: const Duration(milliseconds: 500),                    // NEW
// //              curve: Curves.ease,                                             // NEW
// //            );
// //          });
//         });
//
//         //  _controller.animateTo(0.0,curve: Curves.easeInOut, duration: Duration(seconds: 1));
//       }).catchError((e) {
//         Toast.show(e, context,
//             duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
//         setState(() {
//           //  _load2 = false;
//         });
//       });
//     });
// //    final userdatabaseReference =
// //      FirebaseDatabase.instance.reference().child("userdata");
// //      userdatabaseReference
// //          .child(_userId)
// //          .child("cName")
// //          .once()
// //          .then((DataSnapshot snapshot5) {
// //        setState(() {
// //          if (snapshot5.value != null) {
// //
// //          }
// //        });
// //      });
//
//     // })
//     // );
//   }

  Widget _firebasedata(
    index,
    length,
   ownerId,
   traderid,
   advID,
   commentid,
   tradname,
   ownername,
   cdate,
   price,
   rate,
  ) {
    return Padding(
      padding: const EdgeInsets.only(top: 5.0, right: 5.0, left: 5.0),
      child: Card(
        shape: new RoundedRectangleBorder(
            side: new BorderSide(color: Colors.grey, width: 3.0),
            borderRadius: BorderRadius.circular(10.0)),
        //borderOnForeground: true,
        elevation: 10.0,
        margin: EdgeInsets.all(1),
        child: InkWell(
          onTap: () {},
          child: Container(
              padding: EdgeInsets.all(8),
              child: Container(
                  width: 350,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      _userId == commentlist[index].traderid
                          ? FlatButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      new CupertinoAlertDialog(
                                    title: new Text("تنبية"),
                                    content: new Text("تبغي تحذف تعليقك؟"),
                                    actions: [
                                      CupertinoDialogAction(
                                          isDefaultAction: false,
                                          child: new FlatButton(
                                            onPressed: () {
                                              setState(() {
                                                print("kkkkkkkkkkkk");
                                                if (_userId ==
                                                    commentlist[index]
                                                        .traderid) {
                                                  FirebaseDatabase.instance
                                                      .reference()
                                                      .child("commentsdata")
                                                      .child(widget.userId)
                                                      .child(advID)
                                                      .child(commentlist[index]
                                                          .commentid)
                                                      .remove()
                                                      .whenComplete(() {
                                                    setState(() {
                                                      commentlist
                                                          .removeAt(index);
                                                    });
                                                    Toast.show(
                                                        "حذفنا تعليقك طال عمرك",
                                                        context,
                                                        duration:
                                                            Toast.LENGTH_SHORT,
                                                        gravity: Toast.BOTTOM);
                                                  }).then((value) =>
                                                          Navigator.pop(
                                                              context));
                                                } else {
                                                  Toast.show(
                                                      "هذا مو تعليقك طال عمرك",
                                                      context,
                                                      duration:
                                                          Toast.LENGTH_SHORT,
                                                      gravity: Toast.BOTTOM);
                                                }
                                              });
                                            },
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
                                //ResetPasswordDialog();
                                //FirebaseAuth.instance.sendPasswordResetEmail(email: _emailController.text);
                              },
                              child: Icon(
                                Icons.more_vert,
                                color: Colors.black,
                              ),
                            )
                          : Container(),
                      Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Row(
                              children: <Widget>[
                                Container(
                                  width: 200,
                                  child: Align(
                                      alignment: Alignment.topRight,
                                      child: Text(
                                        tradname,
                                        style: TextStyle(
                                          color: Colors.blue,
                                          fontSize: 15,
                                        ),
                                        textDirection: TextDirection.rtl,
                                      )),
                                ),
                                Icon(
                                  Icons.person,
                                  size: 25,
                                  color: Colors.black,
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 2.0, right: 0.0, bottom: 2, left: 2.0),
                            child: Align(
                                alignment: Alignment.topRight,
                                child: Text(
                                  price,
                                  textDirection: TextDirection.rtl,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                  ),
                                )),
                          ),
                        ],
                      ),
                    ],
                  ))),
        ),
      ),
    );
  }

  Future<void> _makePhoneCall(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
