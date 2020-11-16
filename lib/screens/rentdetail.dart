import 'dart:async';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:priceme/UserRating/RatingClass.dart';
import 'package:priceme/UserRating/UserRatingPage.dart';
import 'package:priceme/classes/CommentClass.dart';
import 'package:priceme/classes/CommentClassString.dart';
import 'package:priceme/screens/allrents.dart';
import 'package:priceme/screens/map_view.dart';

import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:toast/toast.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class RentDetail extends StatefulWidget {
  String userId;
  String advid;

  RentDetail(this.userId, this.advid);

  @override
  _RentDetailState createState() => _RentDetailState();
}

class _RentDetailState extends State<RentDetail> {
  String _userId;
  String _username,cType;
  String _userphone;
  AudioPlayer audioPlayer = AudioPlayer();
  Duration duration= new Duration();
  Duration position= new Duration();

  Completer<GoogleMapController> _mapcontroller = Completer();
  Set<Marker> markers = Set();
  List<Marker> _markers = <Marker>[];

  bool isplaying1 = false;
  bool arrangecheck = true;


  String cdate;
  String cdiscribtion;
  String curi;
  String cimagelist;
  String cproblemtype;
  bool cpublished;
  String ccar;
  String ccarversion;
  String cyear;
  int carrange;
   String ccolor;
   String cmotion;
  String cprice;
  String ctitle;
  String fromPLat;
  String fromPLng;
  String fPlaceName;
 //String cNew;
  String ownerName;
  String ownerPhone;
  String _cWorkshopname;

  var _formKey1 = GlobalKey<FormState>();
  var refreshKey = GlobalKey<RefreshIndicatorState>();
  Future<void> _launched;
  var _controller = ScrollController();
  bool favcheck = false;
  double  traderating=0.0;
  //List<OrderDetailClass> orderlist = [];
  List<CommentClassString> commentlist = [];

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
        cType = data.documents[0].data['cType'];
          _username = data.documents[0].data['name'];
          _userphone = data.documents[0].data['phone'];
        String  rating =(data.documents[0].data['rating']) ;
        int  custRate = data.documents[0].data['custRate'];
        if(rating==null){traderating=0.0;}else{
          traderating= double.parse(rating)/custRate;
        }
          // _traderate=data.documents[0].data['rate'];
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
          .collection('rents')
          .where('userId', isEqualTo: widget.userId)
          .where('offerid', isEqualTo: widget.advid)
          .limit(1);
      userQuery.getDocuments().then((data) {
        print("${ widget.advid}//mmoo${data.documents.length}");

        if (data.documents.length > 0) {
          setState(() {
            cdate = data.documents[0].data['cdate'];
            cdiscribtion = data.documents[0].data['cdiscribtion'];
            curi = data.documents[0].data['curi'];
            cimagelist = data.documents[0].data['cimagelist'];
            cproblemtype = data.documents[0].data['cproblemtype'];
             ccar = data.documents[0].data['ccar'];
            cpublished = data.documents[0].data['cpublished'];
             ccarversion = data.documents[0].data['ccarversion'];
            cyear = data.documents[0].data['cyear'];
             ccolor = data.documents[0].data['color'];

            cprice = data.documents[0].data['price'];

            ctitle = data.documents[0].data['ctitle'];
            fromPLat = data.documents[0].data['fromPLat'];
            fromPLng = data.documents[0].data['fromPLng'];
            fPlaceName = data.documents[0].data['fPlaceName'];
             cmotion = data.documents[0].data['cmotion'];
            ownerName = data.documents[0].data['pname'];
            ownerPhone = data.documents[0].data['pphone'];
            _cWorkshopname=data.documents[0].data['workshopname'];
            if(_cWorkshopname==null||_cWorkshopname==""){_cWorkshopname=data.documents[0].data['pname'];}

            _imageUrls = cimagelist
                .replaceAll(" ", "")
                .replaceAll("[", "")
                .replaceAll("]", "")
                .split(",");
          });
        }
      });
    });
    commentlist.clear();
    final commentsReference = Firestore.instance;
    commentsReference.collection("commentsrentdata").document(widget.userId).collection(widget.advid)
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((comment) {

        CommentClassString cc = CommentClassString(
          comment.data['ownerId'],
          comment.data['traderid'],
          comment.data['advID'],
          comment.data['commentid'],

          comment.data['tradname'],
          comment.data['ownername'],
          comment.data['cdate'],
          comment.data['comment'],
          comment.data['rate'],
          comment.data['carrange'],

        );
        setState(() {
          commentlist.add(cc);
          commentlist.sort((c1, c2) =>c2.carrange.compareTo(c1.carrange));});


      });
    });
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
                      height: 210,
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
                            top: 20,
                            right: 5,
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Row(
                                children: <Widget>[
                                  _cWorkshopname == null
                                      ? Text("")
                                      : Padding(
                                    padding: const EdgeInsets.only(
                                        top: 8.0),
                                    child: _cWorkshopname == null
                                        ? Text("اسم غير معلوم")
                                        : Text(
                                      "المالك: ${_cWorkshopname}",
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
                                  ccar == null
                                      ? Container()
                                      : Padding(
                                    padding: const EdgeInsets.only(
                                        top: 8.0),
                                    child: Text("$ccar - $ccarversion - $cyear"
                                      ,
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
                                    Icons.directions_car,
                                    color: const Color(0xff171732),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            top: 70,
                            right: 5,
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Row(
                                children: <Widget>[
                                  ccolor == null
                                      ? Container()
                                      : Padding(
                                    padding: const EdgeInsets.only(
                                        top: 8.0),
                                    child: Text(
                                      "اللون: $ccolor - نوع الحركة: $cmotion",
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
                                    Icons.directions_car,
                                    color: const Color(0xff171732),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            top: 95,
                            right: 5,
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Row(
                                children: <Widget>[
                                  cprice == null
                                      ? Container()
                                      : Padding(
                                    padding: const EdgeInsets.only(
                                        top: 8.0),
                                    child: Text(
                                      "السعر بالدينار الاردني: $cprice ",
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
                                    Icons.monetization_on,
                                    color: const Color(0xff171732),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            top: 120,
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
                          Positioned(
                            top: 140,
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
                        cType=="admin"?  Positioned(
                            top: 70,
                            left: 5,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                height: 25,
                                child: IconButton(
                                  icon: Icon(Icons.delete,size:50 ,),
                                  color: Colors.red,
                                  onPressed: () {
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

                                                  setState(() {
                                                    Firestore.instance.collection("rents")
                                                        .document(widget.advid)
                                                        .delete().whenComplete(() =>
                                                        setState(() async {
                                                          Navigator.pop(context);
                                                          Toast.show("تم الحذف", context,
                                                              duration: Toast.LENGTH_SHORT,
                                                              gravity: Toast.BOTTOM);
                                                          Navigator.pushReplacement(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder: (context) => AllRents()));
                                                        }));
                                                  });
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
                                ),),
                            ),
                            /** Icon(
                                Icons.calendar_today,
                                color: Colors.grey,
                                ),**/
                          ):Container(),

                        ],
                      )),
                ),
                SizedBox(height: 10.0,),
//                 bestprice==10000000.0?Container():Card(
//                   shape: new RoundedRectangleBorder(
//                       side: new BorderSide(
//                           color: Colors.green[400], width: 3.0),
//                       borderRadius: BorderRadius.circular(10.0)),
//                   //borderOnForeground: true,
//                   elevation: 10.0,
//                   margin: EdgeInsets.only(right: 100, left: 100, bottom: 2),
//                   child: Container(
//                       height: 30,
//                       color: Colors.green[300],
//                       padding: EdgeInsets.all(0),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                         children: <Widget>[
//                           Text(
//                             "${bestprice}",
//                             textDirection:
//                             TextDirection.rtl,
//                             //minFontSize: 8,
//                             maxLines: 3,
//                             textAlign: TextAlign.right,
//                             style: TextStyle(
//                                 fontSize: 25.0,
//                                 fontStyle:                                FontStyle.normal),
//                           ),
//                           Text(
//                             "افضل سعر:",
//                             textDirection:
//                             TextDirection.rtl,
//                             //minFontSize: 8,
//                             maxLines: 3,
//                             textAlign: TextAlign.right,
//                             style: TextStyle(
//                                 fontSize: 15.0,
// //                                                          fontFamily:
// //                                                              'Gamja Flower',
//                                 fontStyle:
//                                 FontStyle.normal),
//                           ),
//                         ],
//                       )),
//                 ),


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
                           // sortrate();
                            // if (_userId == null) {
                            //   Toast.show(
                            //       "ابشر .. سجل دخول الاول طال عمرك",
                            //       context,
                            //       duration: Toast.LENGTH_LONG,
                            //       gravity: Toast.BOTTOM);
                            // } else {
                            //   // Navigator.push(
                            //   //   context,
                            //   //   new MaterialPageRoute(
                            //   //       builder: (BuildContext context) =>
                            //   //           new ChatPage(
                            //   //               name: widget.cName,
                            //   //               uid: widget.cId)),
                            //   // );
                            // }
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
                                  "برجاء .. تسجيل الدخول اولا",
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
                            "الموقع على الخريطة",
                            style: TextStyle(
                              color: const Color(0xff171732),
                              fontSize: 10,
                            ),
                          ),
                          Icon(
                            Icons.location_on,
                            color: const Color(0xff171732),
                          ),
                        ],
                      ),
                      textColor: const Color(0xff171732),
                      color: Colors.grey[400],
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    MapView(ctitle, double.parse(fromPLat), double.parse(fromPLng))));
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
                                          commentlist[index].comment,
                                          commentlist[index].rate,
                                        ),

                                      );
                                    }),
                          )),
                          //****************
                          (_userId==null)?Container():  Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Row(
                              children: <Widget>[
                                Container(
                                  width: 300,
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
                                              TextInputType.text,
                                          textDirection:
                                              TextDirection.rtl,
                                          controller: _commentController,
                                          validator: (String value) {
                                            if ((value.isEmpty)) {
                                              return 'كتب التعليق ';
                                            }
                                          },

                                          onChanged: (value) {},
                                          //  controller: controller,
                                          decoration: InputDecoration(
                                              errorStyle: TextStyle(
                                                  color: Colors.red,
                                                  fontSize: 15.0),
                                              labelText: "التعليق",
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
                                IconButton(
                                  icon: Icon(
                                    Icons.add_comment,
                                    color: Colors.grey,
                                  ),
                                  tooltip: 'Increase volume by 10',
                                  onPressed: () async {
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
                                          createRecord();
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

  void createRecord() {
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

    setState(() {
      DateTime now = DateTime.now();
      // String date1 ='${now.year}-${now.month}-${now.day}';// ${now.hour}:${now.minute}:00.000';
      String date =
          '${now.year}-${now.month}-${now.day}-${now.hour}-${now.minute}-00';
      DocumentReference documentReference =
      Firestore.instance.collection('commentsrentdata').document(widget.userId).collection(widget.advid).document();
      String commentid= documentReference.documentID;
      String price;
      documentReference.setData({
        'carrange': int.parse("${now.year.toString()}${b}${c}${d}${e}${f}"),
        'ownerId': widget.userId,
        'traderid': _userId,
        'advID': widget.advid,
        'commentid':commentid,
        'cdate': now.toString(),
        'tradname': _username,
        'ownername': ownerName,
        'comment':_commentController.text,
        'rate':0.0,
      }).whenComplete(() {

        Toast.show("ارسالنا تعليقك طال عمرك", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        CommentClassString commentclass = new CommentClassString(
          widget.userId,
          _userId,
          widget.advid,
          commentid,
          _username,
          ownerName,
          now.toString(),
          _commentController.text,
          0.0,0,
        );
        setState(() {
          commentlist.insert(0, commentclass);
          _commentController.text = "";
        });
        if (_username != widget.userId) {
          DocumentReference documentReference =
          Firestore.instance.collection('Alarm')
              .document(widget.userId)
              .collection('Alarmid')
              .document();
          documentReference.setData({
            'ownerId': widget.userId,
            'traderid': _userId,
            'advID': widget.advid,
            'alarmid': documentReference.documentID,
            'cdate': now.toString(),
            'tradname': _username,
            'ownername': ownerName,
            'price': _commentController.text,
            'rate': traderating,
            'arrange': int.parse("${now.year.toString()}${b}${c}${d}${e}${f}"),
            'cType': "rentcomment",

          }).whenComplete(() {
            Toast.show("تم التعليق بنجاح", context,
                duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
          });
        }
        //  _controller.animateTo(0.0,curve: Curves.easeInOut, duration: Duration(seconds: 1));
      }).catchError((e) {
        Toast.show(e, context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        setState(() {
          //  _load2 = false;
        });
      });
    });

  }

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
                      (_userId == commentlist[index].traderid||cType=="admin")
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
                                                if (_userId == commentlist[index].traderid||cType=="admin") {
                                                  FirebaseDatabase.instance
                                                      .reference()
                                                      .child("commentsrentdata")
                                                      .child(commentlist[index].traderid)
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
                                  price.toString(),
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
