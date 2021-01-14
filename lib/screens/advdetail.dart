import 'dart:io';
import 'dart:ui';

import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:priceme/UserRating/RatingClass.dart';
import 'package:priceme/UserRating/UserRatingPage.dart';
import 'package:priceme/classes/CommentClass.dart';
import 'package:priceme/classes/SparePartsClass.dart';
import 'package:priceme/screens/advertisements.dart';
import 'package:priceme/screens/traderuserprofile.dart';
import 'package:priceme/ui_utile/myColors.dart';
import 'package:priceme/ui_utile/myFonts.dart';

import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:toast/toast.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shimmer/shimmer.dart';

import 'bookingpage.dart';

class AdvDetail extends StatefulWidget {
  String userId;
  String advid;

  AdvDetail(this.userId, this.advid);

  @override
  _AdvDetailState createState() => _AdvDetailState();
}

class _AdvDetailState extends State<AdvDetail>
    with SingleTickerProviderStateMixin {
  bool bestPriceButtonPressed = true;
  List colors = [
    Colors.red,
    Colors.lime,
    Colors.purple,
    Colors.teal,
    Colors.blue,
    Colors.grey
  ];

  AnimationController _animationController;
  Animation<Color> animation1;
  Animation<Color> animation2;

  var _bestPriceListController = ScrollController();
  var _bestRateListController = ScrollController();
  String _userId;
  String _username, cType;
  String _userphone;
  AudioPlayer audioPlayer = AudioPlayer();
  Duration duration = new Duration();
  Duration position = new Duration();
  double bestprice = 10000000.0;
  double bestrate = 0.0;

  bool isplaying1 = false;
  bool arrangecheck = true;

  String _cWorkshopname = "";

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
  double traderating = 0.0;

  //List<OrderDetailClass> orderlist = [];
  List<CommentClass> commentlist = [];

  //var _controller = ScrollController();

  //AdvNameClass advnNameclass;
  final double _minimumPadding = 5.0;
  bool _load = false;
  TextEditingController _commentController = TextEditingController();
  TextEditingController _commentdetailController = TextEditingController();

  List<String> _imageUrls;

  List<String> mainfaultsList = [];
  List<String> mainsparsList = [];

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
            mainsparsList.add(
              sparepart.data['sName'],
            );
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
    FirebaseAuth.instance.currentUser().then((user) =>
    user == null
        ? _userId = null
        : setState(() {
           _userId = user.uid;

    var userQuery = Firestore.instance
          .collection('users')
          .where('uid', isEqualTo: _userId)
          .limit(1);
      userQuery.getDocuments().then((data) {
        if (data.documents.length > 0) {
          setState(() {
            cType = data.documents[0].data['cType'];
print("ccc$cType");
            _username = data.documents[0].data['name'];
            _userphone = data.documents[0].data['phone'];
            String rating = (data.documents[0].data['rating']);
            int custRate = data.documents[0].data['custRate'];
            if (rating == null) {
              traderating = 0.0;
            } else {
              traderating = double.parse(rating) / custRate;
            }
            // _traderate=data.documents[0].data['rate'];
            // if(_cName==null){_cName=user.displayName??"اسم غير معلوم";}
            if (_username == null) {
              if (user.displayName == null || user.displayName == "") {
                _username = "ايميل غير معلوم";
              } else {
                _username = user.displayName;
              }
            }
            // print("mmm$_cMobile+++${user.phoneNumber}***");
            if (_userphone == null) {
              if (user.phoneNumber == null || user.phoneNumber == "") {
                _userphone = "لا يوجد رقم هاتف بعد";
              } else {
                _userphone = user.phoneNumber;
              }
            }
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
        print("${widget.advid}//mmoo${data.documents.length}");

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
            _cWorkshopname = data.documents[0].data['workshopname'];
            if (_cWorkshopname == null || _cWorkshopname == "") {
              _cWorkshopname = data.documents[0].data['pname'];
            }

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
    commentsReference
        .collection("commentsdata")
        .document(widget.userId)
        .collection(widget.advid)
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((comment) {
        CommentClass cc = CommentClass(
          comment.data['ownerId'],
          comment.data['traderid'],
          comment.data['advID'],
          comment.data['commentid'],
          comment.data['tradname'],
          comment.data['ownername'],
          comment.data['cdate'],
          comment.data['details'],
          comment.data['price'],
          comment.data['rate'],
          comment.data['bookingdate'],
          comment.data['ownercheck'],
          comment.data['tradercheck'],
        );
        setState(() {
          print("ggg${comment.data['rate']}");
          commentlist.add(cc);
          commentlist.sort((c1, c2) => c1.price.compareTo(c2.price));
        });
        if (bestprice > comment.data['price']) {
          setState(() {
            bestprice = comment.data['price'];
          });
        }
        if (bestrate < comment.data['rate']) {
          setState(() {
            bestrate = comment.data['rate'];
          });
        }
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
    TextStyle textStyle = Theme
        .of(context)
        .textTheme
        .subtitle;

    return Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: const Color(0xffffffff),
        body:
        //advDetailWidget()
        //loadingScreen()
        Stack(
          children: [
            ctitle == null ?
            loadingScreen() :
            advDetailWidget(),
            Positioned(
              top: 24,
              child: customAppBar(),
            )
          ],
        ));
  }

  Widget advDetailWidget() {
    return Container(
      height: MediaQuery
          .of(context)
          .size
          .height,
      width: MediaQuery
          .of(context)
          .size
          .width,
      child: SingleChildScrollView(
          child: Container(
            child: Column(
              children: [
                Container(
                  height: 300,
                  color: Colors.blue,
                  child: Stack(
                    children: [
                      Container(
                          height: 300,
                          color: Colors.grey[200],
                          child: Swiper(
                            loop: false,
                            pagination: new SwiperPagination(
                                builder: DotSwiperPaginationBuilder(
                                    color: Colors.grey[200],
                                    activeColor: Colors.orange)),
                            control: new SwiperControl(
                                size: 30, color: Colors.orange),
                            itemCount: _imageUrls.length,
                            itemBuilder: (BuildContext context, int itemIndex) {
                              return Container(
                                height: 300,
                                width: MediaQuery
                                    .of(context)
                                    .size
                                    .width,
                                decoration: BoxDecoration(
                                    image:
                                    DecorationImage(
                                        image: NetworkImage(_imageUrls[itemIndex]),
                                        fit: BoxFit.cover
                                        )
                                    )


                              );
                            },
                          )),
                      Positioned(
                        top: 264,
                        child: Container(
                          height: 36,
                          width: MediaQuery
                              .of(context)
                              .size
                              .width,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20))),
                        ),
                      ),
                      Positioned(
                        top: 264,
                        left: 45,
                        child: Container(
                            height: 2,
                            //  width: MediaQuery.of(context).size.width - 120,

                            child: SliderTheme(
                                data: SliderTheme.of(context).copyWith(
                                  activeTrackColor: Colors.orange,
                                  inactiveTrackColor: Colors.grey[400],
                                  // trackShape: RoundedRectSliderTrackShape(),
                                  trackHeight: 2.0,

                                  thumbShape: RoundSliderThumbShape(
                                      enabledThumbRadius: 6.0),
                                  thumbColor: Colors.redAccent,
                                  //overlayColor: Colors.red.withAlpha(32),
                                  //overlayShape: RoundSliderOverlayShape(overlayRadius: 16.0),
                                  //tickMarkShape: RoundSliderTickMarkShape(),
                                  //activeTickMarkColor: Colors.red[700],
                                  //inactiveTickMarkColor: Colors.red[100],
                                  // valueIndicatorShape: PaddleSliderValueIndicatorShape(),
                                  valueIndicatorColor: Colors.redAccent,
                                  valueIndicatorTextStyle: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                                child: Container(
                                  width: MediaQuery
                                      .of(context)
                                      .size
                                      .width - 85,
                                  child: Slider(
                                      min: 0.0,
                                      value: position.inSeconds.toDouble(),
                                      max: duration.inSeconds.toDouble(),
                                      onChanged: (double value) {
                                        setState(() {
                                          audioPlayer.seek(
                                              new Duration(
                                                  seconds: value.toInt()));
                                          value = value;
                                        });
                                      }),
                                ))),
                      ),
                      Positioned(
                          top: 240,
                          left: 16,
                          child: InkWell(
                              child: Card(
                                color: Colors.lightBlue[400],
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(24)),
                                elevation: 6,
                                child: Container(
                                  height: 44,
                                  width: 44,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(24),
                                      color: Colors.lightBlue[400]),
                                  child: Center(
                                      child: Icon(
                                          isplaying1
                                              ? Icons.pause
                                              : Icons.play_arrow,
                                          size: 26,
                                          color: Colors.white)),
                                ),
                              ),
                              onTap: () async {
                                if (isplaying1) {
                                  var res = await audioPlayer.pause();
                                  if (res == 1) {
                                    setState(() {
                                      isplaying1 = false;
                                    });
                                  }
                                } else {
                                  var res = await audioPlayer.play(caudiourl,
                                      isLocal: true);
                                  if (res == 1) {
                                    setState(() {
                                      isplaying1 = true;
                                    });
                                  }
                                }
                                audioPlayer.onDurationChanged.listen((
                                    Duration dd) {
                                  setState(() {
                                    duration = dd;
                                  });
                                });
                                audioPlayer.onAudioPositionChanged
                                    .listen((Duration dd) {
                                  setState(() {
                                    position = dd;
                                  });
                                });
                              })),
                      Positioned(
                          top: 245,
                          right: 18,
                          child: Container(
                              height: 44,
                              width: 44,
                              child: FloatingActionButton(
                                backgroundColor: Colors.red[400],
                                onPressed: () {
                                  audioPlayer.stop();
                                  setState(() {
                                    isplaying1 = false;
                                    duration = new Duration(seconds: 0);
                                    position = new Duration(seconds: 0);
                                  });
                                },
                                child:
                                Icon(Icons.stop, color: Colors.white, size: 24),
                              ))),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 16, right: 20),
                  child: Row(
                    textDirection: TextDirection.rtl,
                    children: [
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            ctitle,
                            textDirection: TextDirection.rtl,
                            textAlign: TextAlign.right,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                fontFamily: MyFonts.primaryFont),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          cdate,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                              fontWeight: FontWeight.normal,
                              fontFamily: MyFonts.primaryFont),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(right: 20),
                  child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        ownerName != null ? ownerName :
                        "مجهول",
                        textDirection: TextDirection.rtl,
                        textAlign: TextAlign.right,
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            fontFamily: MyFonts.primaryFont),
                      )),
                ),
                Container(
                  margin: EdgeInsets.only(right: 20),
                  child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        cproblemtype,
                        textDirection: TextDirection.rtl,
                        textAlign: TextAlign.right,
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            fontFamily: MyFonts.primaryFont),
                      )),
                ),
                Container(
                  margin: EdgeInsets.only(right: 20),
                  child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        mfault,
                        textDirection: TextDirection.rtl,
                        textAlign: TextAlign.right,
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12,

                            fontWeight: FontWeight.w600,
                            fontFamily: MyFonts.primaryFont),
                      )),
                ),
                SizedBox(height: 20),
                Container(
                  margin: EdgeInsets.only(right: 10, left: 10),
                  height: 1,
                  color: Colors.grey[300],
                ),
                SizedBox(height: 20),
                Container(
                  margin: EdgeInsets.only(right: 20),
                  child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        "الوصف",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            fontFamily: MyFonts.primaryFont),
                      )),
                ),
                SizedBox(height: 10),
                Container(
                  margin: EdgeInsets.only(right: 20, left: 20),
                  child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        cdiscribtion != null ? cdiscribtion :
                        "لا يوجد وصف",
                        textDirection: TextDirection.rtl,
                        textAlign: TextAlign.right,
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: 10,
                            fontWeight: FontWeight.w300,
                            fontFamily: MyFonts.primaryFont),
                      )),
                ),
                SizedBox(height: 16),
                Container(
                    height: 40,
                    padding: EdgeInsets.only(right: 20),
                    alignment: Alignment.centerRight,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        colors: [
                          MyColors.darkPrimaryColor,
                          MyColors.primaryColor,
                          MyColors.lightPrimaryColor,
                        ],
                        // stops: [0.1, 0.8,0.6],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 4,
                          blurRadius: 4,
                          offset: Offset(0, 2), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Text(
                      "معلومات اضافية",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          fontFamily: MyFonts.primaryFont),
                    )),
                SizedBox(height: 16),
                Container(
                  margin: EdgeInsets.only(
                    right: 20,
                    left: 20,
                  ),
                  child: Row(
                    textDirection: TextDirection.rtl,
                    children: [
                      Container(
                        width: 116,
                        child: Text(
                          "إسم السيارة",
                          textDirection: TextDirection.rtl,
                          style: TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              fontFamily: MyFonts.primaryFont),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          ccar,
                          textDirection: TextDirection.rtl,
                          textAlign: TextAlign.right,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              fontFamily: MyFonts.primaryFont),
                        ),
                      )
                    ],
                  ),
                ),

                /*
                Container(
                  margin: EdgeInsets.only(
                    right: 20,
                    left: 20,
                  ),
                  child: Row(
                    textDirection: TextDirection.rtl,
                    children: [
                      Container(
                        width: 116,
                        child: Text(
                          "ماركة السيارة",
                          textDirection: TextDirection.rtl,
                          style: TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              fontFamily: MyFonts.primaryFont),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          "مارسيدس",
                          textDirection: TextDirection.rtl,
                          textAlign: TextAlign.right,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              fontFamily: MyFonts.primaryFont),
                        ),
                      )
                    ],
                  ),
                ),

                */
                Container(
                  margin: EdgeInsets.only(
                    right: 20,
                    left: 20,
                  ),
                  child: Row(
                    textDirection: TextDirection.rtl,
                    children: [
                      Container(
                        width: 116,
                        child: Text(
                          "رقم الإصدار",
                          textDirection: TextDirection.rtl,
                          textAlign: TextAlign.right,
                          style: TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              fontFamily: MyFonts.primaryFont),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          ccarversion,
                          textDirection: TextDirection.rtl,
                          textAlign: TextAlign.right,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              fontFamily: MyFonts.primaryFont),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                    right: 20,
                    left: 20,
                  ),
                  child: Row(
                    textDirection: TextDirection.rtl,
                    children: [
                      Container(
                        width: 116,
                        child: Text(
                          "الطراز",
                          textDirection: TextDirection.rtl,
                          style: TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              fontFamily: MyFonts.primaryFont),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          cmodel,
                          textDirection: TextDirection.rtl,
                          textAlign: TextAlign.right,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              fontFamily: MyFonts.primaryFont),
                        ),
                      )
                    ],
                  ),
                ),
                // Container(
                //   margin: EdgeInsets.only(
                //     right: 20,
                //     left: 20,
                //   ),
                //   child: Row(
                //     textDirection: TextDirection.rtl,
                //     children: [
                //       Container(
                //         width: 116,
                //         child: Text(
                //           "رقم الهاتف",
                //           textDirection: TextDirection.rtl,
                //           style: TextStyle(
                //               color: Colors.grey,
                //               fontSize: 12,
                //               fontWeight: FontWeight.bold,
                //               fontFamily: MyFonts.primaryFont),
                //         ),
                //       ),
                //       Expanded(
                //         child: Text(
                //           "055556566464",
                //           textDirection: TextDirection.rtl,
                //           style: TextStyle(
                //               color: Colors.black,
                //               fontSize: 12,
                //               fontWeight: FontWeight.bold,
                //               fontFamily: MyFonts.primaryFont),
                //         ),
                //       )
                //     ],
                //   ),
                // ),
                SizedBox(height: 16),

                cType == "trader" ?


                Divider(thickness: 2) : SizedBox(),

                cType == "trader" ?
                Container(
                    width: 180,
                    height: 40,
                    margin: EdgeInsets.only(top: 10, bottom: 10),
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6)),
                      onPressed: () {
                        displayBottomSheet();
                      },
                      color: MyColors.secondaryColor,
                      child: Center(
                        child: Text(
                          "أضف عرضك",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              fontFamily: MyFonts.primaryFont),
                        ),
                      ),
                    ))
                    :
                SizedBox(),


                Divider(thickness: 2),
                SizedBox(height: 20),
                Center(
                  child: Card(
                    elevation: 6,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24)),
                    child: Container(
                      height: 48,
                      width: 250,
                      decoration: BoxDecoration(
                        //color: Colors.grey[400],
                          gradient: LinearGradient(
                            begin: Alignment.topRight,
                            end: Alignment.bottomLeft,
                            colors: [
                              MyColors.darkPrimaryColor,
                              MyColors.primaryColor,
                              MyColors.lightPrimaryColor,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(24)),
                      child: Row(
                        textDirection: TextDirection.rtl,
                        children: [
                          InkWell(
                            onTap: () {
                              setState(() {
                                arrangecheck = true;
                                bestPriceButtonPressed = true;
                              });
                              sortprice();
                              setState(() {
                              });

                            },
                            child: Container(
                              alignment: Alignment.center,
                              height: 48,
                              width: 125,
                              decoration: BoxDecoration(
                                  color: bestPriceButtonPressed
                                      ? null
                                      : Colors.grey[400],
                                  borderRadius: bestPriceButtonPressed
                                      ? BorderRadius.only(
                                    bottomRight: Radius.circular(24),
                                    topRight: Radius.circular(24),
                                  )
                                      : BorderRadius.circular(24)),
                              child: Row(
                                textDirection: TextDirection.rtl,
                                children: [
                                  SizedBox(
                                    width: 18,
                                  ),
                                  Icon(
                                    FontAwesomeIcons.dollarSign,
                                    size: 15,
                                    color: Colors.white,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    "أفضل سعر",
                                    textDirection: TextDirection.rtl,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: MyFonts.primaryFont),
                                  )
                                ],
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                arrangecheck = false;
                                bestPriceButtonPressed = false;

                              });
                              sortrate();
                              setState(() {

                              });
                            },
                            child: Container(
                              height: 48,
                              width: 125,
                              decoration: BoxDecoration(
                                  color: !bestPriceButtonPressed
                                      ? null
                                      : Colors.grey[400],
                                  borderRadius: !bestPriceButtonPressed
                                      ? BorderRadius.only(
                                      bottomLeft: Radius.circular(24),
                                      topLeft: Radius.circular(24))
                                      : BorderRadius.circular(24)),
                              child: Row(
                                textDirection: TextDirection.rtl,
                                children: [
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Icon(
                                    Icons.star_border,
                                    size: 18,
                                    color: Colors.white,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    "أفضل تقييم",
                                    textDirection: TextDirection.rtl,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: MyFonts.primaryFont),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  textDirection: TextDirection.rtl,
                  children: [
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      bestPriceButtonPressed ? "أفضل سعر :" : "أفضل تقييم :",
                      textDirection: TextDirection.rtl,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          fontFamily: MyFonts.primaryFont),
                    ),
                    SizedBox(
                      width: 6,
                    ),
                    bestPriceButtonPressed
                        ? Text(
                      "$bestprice",
                      textDirection: TextDirection.rtl,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                          fontWeight: FontWeight.w300,
                          fontFamily: MyFonts.primaryFont),
                    )
                        : Row(
                      textDirection: TextDirection.rtl,
                      children: [
                        Icon(
                          bestrate > 0 ?
                          Icons.star : Icons.star_border,
                          size: 10,
                          color: Colors.orange[700],
                        ),
                        Icon(
                          bestrate > 1 ?
                          Icons.star : Icons.star_border,
                          size: 10,
                          color: Colors.orange[700],
                        ),
                        Icon(
                          bestrate > 2 ?
                          Icons.star : Icons.star_border,
                          size: 10,
                          color: Colors.orange[700],
                        ),
                        Icon(
                          bestrate > 3 ?
                          Icons.star : Icons.star_border,
                          size: 10,
                          color: Colors.orange[700],
                        ),
                        Icon(
                          bestrate > 4 ?
                          Icons.star : Icons.star_border,
                          size: 10,
                          color: Colors.orange[700],
                        )
                      ],
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Container(
                        height: 1,
                        color: Colors.grey[400],
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                    margin: EdgeInsets.only(left: 10, right: 10),
                    child:
                    commentlist.length > 0 ?

                    ListView.builder(
                        physics: BouncingScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        controller: _bestPriceListController,
                        itemCount: commentlist.length,
                        itemBuilder: (context, index) {
                          return offerItemWidget(index);
                        })
                        :
                    Center(
                      child: Text("لا توجد عروض",
                        style: TextStyle(

                            color: Colors.grey,
                            fontSize: 12,
                            fontWeight: FontWeight.w300,
                            fontFamily: MyFonts.primaryFont
                        ),
                      ),
                    )

                ),

                SizedBox(height: 10,)
              ],
            ),
          )),
    );
  }

  Widget customAppBar() {
    return Container(
        padding: EdgeInsets.only(right: 18),
        color: Colors.black.withOpacity(0.45),
        height: 48,
        width: MediaQuery
            .of(context)
            .size
            .width,
        child: Align(
            alignment: Alignment.centerRight,
            child:
            InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(Icons.arrow_forward, size: 24, color: Colors.white),
            )

        ));
  }

  Widget offerItemWidget(int index) {
    return

     InkWell(
       onTap: (){




       },
       child: Card(
         color: ( commentlist[index].ownercheck==null||  commentlist[index].tradercheck==null)?Colors.white:
           ( commentlist[index].ownercheck && commentlist[index].tradercheck)? Colors.black38:Colors.white,
         elevation: 4,
         shape: RoundedRectangleBorder(
             side: BorderSide(color: Colors.grey, width: 1),
             borderRadius: BorderRadius.circular(10)),
         child: Container(
           padding: EdgeInsets.all(10),
           //height: 180,
           width: MediaQuery
               .of(context)
               .size
               .width,
           decoration: BoxDecoration(
               borderRadius: BorderRadius.circular(10)),
           child: Column(
             textDirection: TextDirection.rtl,
             crossAxisAlignment: CrossAxisAlignment.start,
             children: [


               Row(
                 textDirection: TextDirection.rtl,
                 children: [
                   Expanded(
                       child: Container(
                           alignment: Alignment.centerRight,
                           child: Text(
                             commentlist[index].tradname,
                             textDirection: TextDirection.rtl,
                             style: TextStyle(
                                 color: Colors.black,
                                 fontSize: 12,
                                 fontWeight: FontWeight.bold,
                                 fontFamily: MyFonts.primaryFont),
                           ))),
                   ( commentlist[index].ownercheck==null||  commentlist[index].tradercheck==null)?Container():
                   ( commentlist[index].ownercheck && commentlist[index].tradercheck)?  Text(
                    " تم الحجز",
                     textDirection: TextDirection.rtl,
                     style: TextStyle(
                         color: Colors.green,
                         fontSize: 12,
                         fontWeight: FontWeight.bold,
                         fontFamily: MyFonts.primaryFont),
                   ):Container(),
                   (_userId == commentlist[index].traderid || cType == "admin")
                       ?
                   InkWell(
                       onTap: (){
                         displayDeleteOfferDialogue(index);
                       },
                       child: Container(
                         height: 30,
                         width: 30,
                         child: Icon(Icons.delete, color: Colors.red,),
                       )
                   ):
                   SizedBox()
                   ,

                 ],
               ),
               SizedBox(height: 2),
               Row(
                 textDirection: TextDirection.rtl,
                 children: [
                   Icon(
                     commentlist[index].rate> 0 ?
                     Icons.star: Icons.star_border,
                     size: 14,
                     color: Colors.orange[700],
                   ),
                   Icon(
                     commentlist[index].rate> 1 ?
                     Icons.star: Icons.star_border,
                     size: 14,
                     color: Colors.orange[700],
                   ),
                   Icon(
                     commentlist[index].rate> 2 ?
                     Icons.star: Icons.star_border,
                     size: 14,
                     color: Colors.orange[700],
                   ),
                   Icon(
                     commentlist[index].rate> 3 ?
                     Icons.star: Icons.star_border,
                     size: 14,
                     color: Colors.orange[700],
                   ),
                   Icon(
                     commentlist[index].rate> 4 ?
                     Icons.star: Icons.star_border,
                     size: 14,
                     color: Colors.orange[700],
                   ),
                   Expanded(
                       child: Align(
                           alignment: Alignment.centerLeft,
                           child: Container(
                             margin: EdgeInsets.only(left: 8),
                             child: Text(
                               "${commentlist[index].price} ",
                               textDirection: TextDirection.rtl,
                               style: TextStyle(
                                   color: Colors.orange,
                                   fontSize: 12,
                                   fontWeight: FontWeight.bold,
                                   fontFamily: MyFonts.primaryFont),
                             ),
                           )
                       )
                   )
                 ],
               ),
               Text(
                 commentlist[index].cdate,
                 textDirection: TextDirection.rtl,
                 textAlign: TextAlign.right,
                 style: TextStyle(
                     color: Colors.black,
                     fontSize: 12,
                     fontWeight: FontWeight.w300,
                     fontFamily: MyFonts.primaryFont),
               ),
               SizedBox(
                 height: 10,
               ),
               Text(
                 commentlist[index].details,
                 textDirection: TextDirection.rtl,
                 textAlign: TextAlign.right,
                 maxLines: 4,
                 overflow: TextOverflow.ellipsis,
                 style: TextStyle(
                     color: Colors.grey,
                     fontSize: 12,
                     fontWeight: FontWeight.w300,
                     fontFamily: MyFonts.primaryFont),
               ),

               Divider(),

             (_userId == commentlist[index].ownerId || _userId == commentlist[index].traderid)?
               Container(
                 height: 40,
                 child: Row(
                   textDirection: TextDirection.rtl,
                   children: [
                     Expanded(
                         child:

                         InkWell(
                             onTap: (){
                               Navigator.push(
                                   context,
                                   MaterialPageRoute(
                                       builder: (context) =>
                                           BookingPage(
                                               commentlist[index].ownerId,
                                               commentlist[index].traderid,
                                               commentlist[index].advID,
                                               commentlist[index].commentid))
                               );
                             },
                             child: Container(
                               alignment: Alignment.center,
                               height: 40,
                               child:

                               Text(
                                 "تأكيد",
                                 textDirection: TextDirection.rtl,
                                 textAlign: TextAlign.center,
                                 style: TextStyle(
                                   color: Colors.green,

                                 ),

                               ),
                             )
                         )
                     ),
                     Container(
                       width: 0.5,
                       height: 40,
                       color: Colors.grey[400].withOpacity(0.7),
                     ) ,
                     Expanded(
                         child:
                         InkWell(
                             onTap: (){
                               Navigator.push(
                                   context,
                                   MaterialPageRoute(
                                       builder: (context) =>
                                           TraderUserProlile(
                                               commentlist[index].traderid)));
                             },
                             child: Container(
                               height: 40,
                               alignment: Alignment.center,
                               child: Text(
                                 "مراسلة",
                                 textDirection: TextDirection.rtl,
                                 textAlign: TextAlign.center,
                                 style: TextStyle(
                                   color: Colors.orange,


                                 ),
                               ),
                             )
                         )
                     ),

                   ],
                 ),
               ):
               SizedBox()
             ],
           ),
         ),
       )
     )


    ;
  }

  void displayBottomSheet() {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(16), topLeft: Radius.circular(16))),
        context: context,
        isScrollControlled: true,
        builder: (BuildContext bc) {
          return Container(
              padding: EdgeInsets.only(
                  bottom: MediaQuery
                      .of(context)
                      .viewInsets
                      .bottom,
                  right: 10,
                  left: 10,
                  top: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(16),
                    topLeft: Radius.circular(16)),
                color: Colors.grey[300],
              ),
              child: SingleChildScrollView(
                child: Column(
                  textDirection: TextDirection.rtl,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    SizedBox(
                      height: 16,
                    ),
                    Container(

                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey, width: 1),
                          color: Colors.white),
                      child:

                      Directionality(
                        textDirection: TextDirection.rtl,
                        child: TextFormField(
                          textAlignVertical: TextAlignVertical.top,
                          maxLines: 2,
                          controller:
                          _commentdetailController,
                          validator: (String value) {
                            if ((value.isEmpty)) {
                              return 'برجاء كتابة وصف لحل المشكلة اولا';
                            }
                          },
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 14.0,
                              fontFamily: MyFonts.primaryFont),
                          textDirection: TextDirection.rtl,
                          decoration: InputDecoration(
                            errorStyle: TextStyle(
                                color: Colors.red,
                                fontSize: 15.0),
                            contentPadding: EdgeInsets.all(10),
                            hintText: "حل المشكلة",
                            hintStyle: TextStyle(
                                color: Colors.grey,
                                fontSize: 12.0,
                                fontWeight: FontWeight.w300,
                                fontFamily: MyFonts.primaryFont),
                            border: InputBorder.none,
                            labelStyle: TextStyle(
                                color: Colors.black,
                                fontSize: 12.0,
                                fontFamily: MyFonts.primaryFont),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(

                      alignment: Alignment.topRight,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey, width: 1),
                          color: Colors.white),
                      child: Directionality(
                        textDirection: TextDirection.rtl,
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          controller:
                          _commentController,
                          validator: (String value) {
                            if ((value.isEmpty)) {
                              return 'برجاء كتابة السعر اولا';
                            }
                          },
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 14.0,
                              fontFamily: MyFonts.primaryFont),
                          textDirection: TextDirection.rtl,

                          decoration: InputDecoration(
                            errorStyle: TextStyle(
                                color: Colors.red,
                                fontSize: 15.0),
                            contentPadding: EdgeInsets.all(10),
                            hintText: "السعر",
                            hintStyle: TextStyle(
                                color: Colors.grey,
                                fontSize: 12.0,
                                fontWeight: FontWeight.w300,
                                fontFamily: MyFonts.primaryFont),
                            border: InputBorder.none,
                            labelStyle: TextStyle(
                                color: Colors.black,
                                fontSize: 12.0,
                                fontFamily: MyFonts.primaryFont),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Center(
                        child: Container(
                          height: 36,
                          width: 150,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              color: MyColors.secondaryColor),
                          child: RaisedButton(
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            onPressed: () async {
                              createRecord();
//                               if (_formKey1.currentState.validate()) {
//                                 try {
//                                   final result =
//                                       await InternetAddress.lookup(
//                                       'google.com');
//                                   if (result.isNotEmpty &&
//                                       result[0]
//                                           .rawAddress
//                                           .isNotEmpty) {
//                                     print("iiii");
//
//                                   }
//                                 } on SocketException catch (_) {
//                                   //  print('not connected');
//                                   Toast.show(
//                                       "انت غير متصل بشبكة إنترنت",
//                                       context,
//                                       duration: Toast.LENGTH_LONG,
//                                       gravity: Toast.BOTTOM);
//                                 }
//
// //                                                setState(() {
// //                                                  _load2 = true;
// //                                                });
//
//                               }
                            },
                            color: MyColors.secondaryColor,
                            child: Center(
                              child: Text(
                                'أضف عرضك الآن',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: MyFonts.primaryFont),
                              ),
                            ),
                          ),
                        )),
                    SizedBox(
                      height: 20,
                    )
                  ],
                ),
              ));
        });
  }



/////// make a loading screen animation
  Widget loadingScreen() {
    return Container(
      padding: EdgeInsets.all(10),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[200],
        highlightColor: Colors.white,
        child: Column(
          textDirection: TextDirection.rtl,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 20,
            ),
            Container(
              width: double.infinity,
              height: 220,
              decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10)),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              width: 150,
              height: 24,
              decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8)),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              width: 100,
              height: 24,
              decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8)),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              width: 92,
              height: 24,
              decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8)),
            ),
            SizedBox(
              height: 16,
            ),
            Container(
              width: 86,
              height: 24,
              decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8)),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              width: double.infinity,
              height: 20,
              decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(6)),
            ),
            SizedBox(
              height: 8,
            ),
            Container(
              width: double.infinity,
              height: 20,
              decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(6)),
            ),
            SizedBox(
              height: 8,
            ),
            Container(
              width: double.infinity,
              height: 20,
              decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(6)),
            ),
            SizedBox(
              height: 18,
            ),
            Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(6)),
                ))
          ],
        ),
      ),
    );
  }


  void displayDeleteOfferDialogue(int index){
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
                            .traderid ||
                        cType == "admin") {
                      Firestore.instance
                          .collection(
                          "commentsdata")
                          .document(widget.userId)
                          .collection(commentlist[index].advID)
                          .document(
                          commentlist[index]
                              .commentid)
                          .delete()
                          .whenComplete(() {
                        setState(() {
                          commentlist
                              .removeAt(index);
                        });
                        Toast.show(
                            "حذفنا تعليقك", context,
                            duration:
                            Toast.LENGTH_SHORT,
                            gravity: Toast.BOTTOM);
                      }).then((value) =>
                          Navigator.pop(
                              context));
                    } else {
                      Toast.show(
                          "هذا ليس تعليقك", context,
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
  }

  void createRecord() {
    //print("iiii{_commentdetailController.text}//{_commentController.text}");

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
      DocumentReference documentReference = Firestore.instance
          .collection('commentsdata')
          .document(widget.userId)
          .collection(widget.advid)
          .document();
      String commentid = documentReference.documentID;
      String price;
      if (_commentController.text.contains('.')) {
        price = _commentController.text;
      } else {
        price = "${_commentController.text}.0";
      }
      print("iiii${_commentdetailController.text}//$price");
      documentReference.setData({
        'ownerId': widget.userId,
        'traderid': _userId,
        'advID': widget.advid,
        'commentid': commentid,
        'cdate': now.toString(),
        'tradname': _username,
        'ownername': ownerName,
        'details': _commentdetailController.text,
        'price': double.parse(price),
        'rate': traderating,
      }).whenComplete(() {
        // Toast.show("ارسالنا تعليقك ", context,
        //     duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        CommentClass commentclass = new CommentClass(
          widget.userId,
          _userId,
          widget.advid,
          commentid,
          _username,
          ownerName,
          now.toString(),
          _commentdetailController.text,
          double.parse(price),
          traderating,
          "", false,false
        );
        setState(() {
          commentlist.insert(0, commentclass);
// aaa(commentlist);
          _commentdetailController.text = "";
          _commentController.text = "";
          if (bestprice > double.parse(price)) {
            setState(() {
              bestprice = double.parse(price);
            });
          }
          print("iiii0");

          if (bestrate < traderating) {
            setState(() {
              bestrate = traderating;
            });
          }
          //      var cursor = (5/commentlist.length)* _controller.position.maxScrollExtent;//specific item
// print("iiii1");
          // _controller.animateTo(
          //   // NEW
          //   _controller.position.maxScrollExtent * 2, // NEW
          //   duration: const Duration(milliseconds: 500), // NEW
          //   curve: Curves.ease, // NEW
          // );
        });
      //  print("iiii2");

        DocumentReference documentReference = Firestore.instance
            .collection('Alarm')
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
          'cType': "advcomment",
        }).whenComplete(() {
          print("iiii3");

          Toast.show("تم التعليق بنجاح", context,
              duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        });
        Navigator.pop(context);


        //  _controller.animateTo(0.0,curve: Curves.easeInOut, duration: Duration(seconds: 1));
      }).catchError((e) {
        Toast.show(e, context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      //  print("iiii$e");
        setState(() {
          //  _load2 = false;
        });
      });
    });
  }

  Widget _firebasedata(index,
      length,
      ownerId,
      traderid,
      advID,
      commentid,
      tradname,
      ownername,
      cdate,
      details,
      price,
      rate,) {
    return Padding(
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    (_userId == commentlist[index].traderid || cType == "admin")
                        ? Container(
                      width: 50,
                      child: FlatButton(
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
                                                  .traderid ||
                                              cType == "admin") {
                                            Firestore.instance
                                                .collection(
                                                "commentsdata")
                                                .document(widget.userId)
                                                .collection(advID)
                                                .document(
                                                commentlist[index]
                                                    .commentid)
                                                .delete()
                                                .whenComplete(() {
                                              setState(() {
                                                commentlist
                                                    .removeAt(index);
                                              });
                                              Toast.show(
                                                  "حذفنا تعليقك", context,
                                                  duration:
                                                  Toast.LENGTH_SHORT,
                                                  gravity: Toast.BOTTOM);
                                            }).then((value) =>
                                                Navigator.pop(
                                                    context));
                                          } else {
                                            Toast.show(
                                                "هذا ليس تعليقك", context,
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
                      ),
                    )
                        : Container(),
                    Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Row(
                            /**
                                ownerId,
                                traderid,
                                advID,
                                commentid,
                                tradname,
                                ownername,
                                cdate,
                                details,
                                price,
                             **/
                            children: <Widget>[
                              (_userId == ownerId || _userId == traderid)
                                  ? FlatButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              BookingPage(
                                                  ownerId,
                                                  traderid,
                                                  advID,
                                                  commentid)));
                                },
                                child: Text(
                                  "تاكيد",
                                  style: TextStyle(
                                    color: Colors.green,
                                    fontSize: 15,
                                  ),
                                  textDirection: TextDirection.ltr,
                                ),
                              )
                                  : Container(),
                              (_userId == ownerId || _userId == traderid)
                                  ? FlatButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              TraderUserProlile(
                                                  traderid)));
                                },
                                child: Text(
                                  "مراسلة",
                                  style: TextStyle(
                                    color: Colors.deepOrange,
                                    fontSize: 15,
                                  ),
                                  textDirection: TextDirection.ltr,
                                ),
                              )
                                  : Container(),
                              Column(
                                children: [
                                  Text(
                                    tradname,
                                    style: TextStyle(
                                      color: Colors.blue,
                                      fontSize: 15,
                                    ),
                                    textDirection: TextDirection.rtl,
                                  ),
                                  RatingBar(
                                    initialRating: rate,
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
                                ],
                              ),
                              Icon(
                                Icons.person,
                                size: 25,
                                color: Colors.black,
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: [
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
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 2.0, right: 0.0, bottom: 2, left: 2.0),
                          child: Align(
                              alignment: Alignment.topRight,
                              child: Text(
                                details.toString(),
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
    );
  }

  sortprice() {
    setState(() {
      List<CommentClass> commentlist1 = [];
      commentlist1.addAll(commentlist);
      commentlist.clear();
      for (var c in commentlist1) {
        setState(() {
          commentlist.add(c);
          commentlist.sort((c1, c2) => c1.price.compareTo(c2.price));
        });
      }
    });
  }

  sortrate() {
    setState(() {
      List<CommentClass> commentlist1 = [];
      commentlist1.addAll(commentlist);
      commentlist.clear();
      for (var c in commentlist1) {
        setState(() {
          commentlist.add(c);
          commentlist.sort((c2, c1) => c1.rate.compareTo(c2.rate));
        });
      }
    });
  }

  Future<void> _makePhoneCall(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }


  ////////////////////////////////////////////////Previous widgets ///////////////////////////////
  Widget previousWidget() {
    return Form(
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
                        margin:
                        new EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
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
                      itemBuilder: (BuildContext context, int index) {
                        return Image.network(_imageUrls[index],
                            fit: BoxFit.fill, loadingBuilder:
                                (BuildContext context, Widget child,
                                ImageChunkEvent loadingProgress) {
                              if (loadingProgress == null) return child;
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
                    side: new BorderSide(color: Colors.grey[400], width: 3.0),
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
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15.0,
                                  fontStyle: FontStyle.normal),
                            ),
                          ),
                        ),
//                           Positioned(
//                             top: 55,
//                             right: 5,
//                             child: Row(
//                               children: [
//                                 Text("الاعطال:$subfault",
//                                   textDirection:
//                                   TextDirection.rtl,
//                                   textAlign:
//                                   TextAlign.right,
//                                   style: TextStyle(
//                                       color: const Color(
//                                           0xff171732),
//                                       fontSize: 15.0,
// //                                                      fontFamily: 'Gamja Flower',
//                                       fontStyle: FontStyle
//                                           .normal),
//                                 ),
//                                 Icon(
//                                   Icons.person,
//                                   color: const Color(0xff171732),
//                                 ),
//
//                               ],
//                             ),
//                           ),
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
                                  padding:
                                  const EdgeInsets.only(top: 8.0),
                                  child: _cWorkshopname == null
                                      ? Text("اسم غير معلوم")
                                      : Text(
                                    "المالك: ${_cWorkshopname}",
                                    textDirection:
                                    TextDirection.rtl,
                                    textAlign: TextAlign.right,
                                    style: TextStyle(
                                        fontSize: 15.0,
                                        color:
                                        const Color(0xff171732),
                                        fontStyle:
                                        FontStyle.normal),
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
                          top: 55,
                          right: 5,
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Row(
                              children: <Widget>[
                                Text(
                                  "الاعطال:$subfault",
                                  textDirection: TextDirection.rtl,
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                      fontSize: 15.0,
                                      color: const Color(0xff171732),
//                                                      fontFamily:
//                                                          'Gamja Flower',
                                      fontStyle: FontStyle.normal),
                                ),
                                Icon(
                                  Icons.car_repair,
                                  color: const Color(0xff171732),
                                ),
                              ],
                            ),
                          ),
                        ),

//                           Positioned(
//                             top: 55,
//                             right: 5,
//                             child: Padding(
//                               padding: const EdgeInsets.all(5.0),
//                               child: Row(
//                                 children: <Widget>[
//                                   Text("الاعطال:$subfault",
//                                     textDirection:
//                                     TextDirection.rtl,
//                                     textAlign:
//                                     TextAlign.right,
//                                     style: TextStyle(
//                                         color: const Color(
//                                             0xff171732),
//                                         fontSize: 15.0,
// //                                                      fontFamily: 'Gamja Flower',
//                                         fontStyle: FontStyle
//                                             .normal),
//                                   ),
//
//                                   Icon(
//                                     Icons.person,
//                                     color: const Color(0xff171732),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                           Positioned(
//                             top: 45,
//                             right: 5,
//                             child: Padding(
//                               padding: const EdgeInsets.all(5.0),
//                               child: Row(
//                                 children: <Widget>[
//                                   fPlaceName == null
//                                       ? Container()
//                                       : Padding(
//                                     padding: const EdgeInsets.only(
//                                         top: 8.0),
//                                     child: Text(
//                                       fPlaceName,
//                                       textDirection:
//                                       TextDirection.rtl,
//                                       textAlign: TextAlign.right,
//                                       style: TextStyle(
//                                           fontSize: 15.0,
//                                           color: const Color(
//                                               0xff171732),
// //                                                      fontFamily:
// //                                                          'Gamja Flower',
//                                           fontStyle:
//                                           FontStyle.normal),
//                                     ),
//                                   ),
//                                   Icon(
//                                     Icons.location_on,
//                                     color: const Color(0xff171732),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
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
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text(
                                  "${cdiscribtion}",
                                  textDirection: TextDirection.rtl,
                                  //minFontSize: 8,
                                  maxLines: 3,
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                      fontSize: 15.0,
//                                                          fontFamily:
//                                                              'Gamja Flower',
                                      fontStyle: FontStyle.normal),
                                ),
                              ),
                            ),
                          ),
                          /** Icon(
                              Icons.calendar_today,
                              color: Colors.grey,
                              ),**/
                        ),
                        cType == "admin"
                            ? Positioned(
                          top: 70,
                          left: 5,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              height: 25,
                              child: IconButton(
                                icon: Icon(
                                  Icons.delete,
                                  size: 50,
                                ),
                                color: Colors.red,
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) =>
                                    new CupertinoAlertDialog(
                                      title: new Text("تنبية"),
                                      content:
                                      new Text("تبغي تحذف اعلانك؟"),
                                      actions: [
                                        CupertinoDialogAction(
                                            isDefaultAction: false,
                                            child: new FlatButton(
                                              onPressed: () {
                                                setState(() {
                                                  Firestore.instance
                                                      .collection(
                                                      "advertisments")
                                                      .document(
                                                      widget.advid)
                                                      .delete()
                                                      .whenComplete(() =>
                                                      setState(
                                                              () async {
                                                            Navigator.pop(
                                                                context);
                                                            Toast.show(
                                                                "تم الحذف",
                                                                context,
                                                                duration:
                                                                Toast
                                                                    .LENGTH_SHORT,
                                                                gravity: Toast
                                                                    .BOTTOM);

                                                            Navigator
                                                                .pushReplacement(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder: (
                                                                        context) =>
                                                                        Advertisements(
                                                                            mainsparsList,
                                                                            mainfaultsList)));
                                                          }));
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
                                },
                              ),
                            ),
                          ),
                          /** Icon(
                              Icons.calendar_today,
                              color: Colors.grey,
                              ),**/
                        )
                            : Container(),
                      ],
                    )),
              ),
              SizedBox(
                height: 10.0,
              ),
              bestprice == 10000000.0
                  ? Container()
                  : Card(
                shape: new RoundedRectangleBorder(
                    side: new BorderSide(
                        color: Colors.green[400], width: 3.0),
                    borderRadius: BorderRadius.circular(10.0)),
                //borderOnForeground: true,
                elevation: 10.0,
                margin: EdgeInsets.only(right: 100, left: 100, bottom: 2),
                child: Container(
                    height: 30,
                    color: Colors.green[300],
                    padding: EdgeInsets.all(0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Text(
                          "${bestprice}",
                          textDirection: TextDirection.rtl,
                          //minFontSize: 8,
                          maxLines: 3,
                          textAlign: TextAlign.right,
                          style: TextStyle(
                              fontSize: 25.0,
                              fontStyle: FontStyle.normal),
                        ),
                        Text(
                          "افضل سعر:",
                          textDirection: TextDirection.rtl,
                          //minFontSize: 8,
                          maxLines: 3,
                          textAlign: TextAlign.right,
                          style: TextStyle(
                              fontSize: 15.0,
//                                                          fontFamily:
//                                                              'Gamja Flower',
                              fontStyle: FontStyle.normal),
                        ),
                      ],
                    )),
              ),

              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: <Widget>[
              //     IconButton(
              //         icon: Icon(isplaying1 ? Icons.pause:Icons.play_arrow),
              //         iconSize: 30.0,
              //         color: isplaying1? Colors.orange:Colors.black,
              //         onPressed: (){
              //           if(isplaying1){
              //             musicPlayer.pause();
              //
              //             setState(() {
              //               isplaying1=false;
              //             });
              //           }
              //           else{
              //             setState(() {
              //               isplaying1=true;
              //             });
              //
              //             musicPlayer.play(MusicItem(
              //               trackName:"تسجيل صوتى",// widget.song_name,
              //               albumName: mfault,
              //               artistName: ownerName,//widget.artist_name,
              //               url: caudiourl,
              //               coverUrl:_imageUrls[0],// widget.image_url,
              //               duration: Duration(seconds: 60),
              //             ));
              //           }
              //         }),
              //
              //     SizedBox(
              //       width: 10.0,
              //     ),
              //     IconButton(
              //         icon: Icon(
              //           Icons.stop,
              //         ),
              //         color: isplaying1?Colors.black:Colors.orange,
              //         iconSize: 30.0,
              //         onPressed: (){
              //           musicPlayer.stop();
              //           setState(() {
              //             isplaying1=false;
              //           });
              //         }
              //     ),
              //
              //   ],
              // ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  IconButton(
                      icon: Icon(isplaying1 ? Icons.pause : Icons.play_arrow),
                      iconSize: 30.0,
                      color: isplaying1 ? Colors.orange : Colors.black,
                      onPressed: () async {
                        if (isplaying1) {
                          var res = await audioPlayer.pause();
                          if (res == 1) {
                            setState(() {
                              isplaying1 = false;
                            });
                          }
                        } else {
                          var res =
                          await audioPlayer.play(caudiourl, isLocal: true);
                          if (res == 1) {
                            setState(() {
                              isplaying1 = true;
                            });
                          }
                        }
                        audioPlayer.onDurationChanged.listen((Duration dd) {
                          setState(() {
                            duration = dd;
                          });
                        });
                        audioPlayer.onAudioPositionChanged
                            .listen((Duration dd) {
                          setState(() {
                            position = dd;
                          });
                        });
                      }),
                  SizedBox(
                    width: 0.0,
                  ),
                  IconButton(
                      icon: Icon(
                        Icons.stop,
                      ),
                      color: isplaying1 ? Colors.black : Colors.orange,
                      iconSize: 30.0,
                      onPressed: () {
                        audioPlayer.stop();
                        setState(() {
                          isplaying1 = false;
                          duration = new Duration(seconds: 0);
                          position = new Duration(seconds: 0);
                        });
                      }),
                  Flexible(
                    child: Slider.adaptive(
                        min: 0.0,
                        value: position.inSeconds.toDouble(),
                        max: duration.inSeconds.toDouble(),
                        activeColor: Colors.black,
                        inactiveColor: Colors.orange,
                        onChanged: (double value) {
                          setState(() {
                            audioPlayer
                                .seek(new Duration(seconds: value.toInt()));
                            value = value;
                          });
                        }),
                  ),
                ],
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
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            new Text(
                              "افضل تقييم",
                              style: TextStyle(
                                color: const Color(0xff171732),
                                fontSize: 10,
                              ),
                            ),
                            Icon(
                              Icons.stars,
                              color: const Color(0xff171732),
                            ),
                          ],
                        ),
                        textColor: const Color(0xff171732),
                        color: arrangecheck ? Colors.grey[100] : Colors.amber,
                        onPressed: () {
                          setState(() {
                            arrangecheck = false;
                          });
                          sortrate();
                        },

//
                        shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(10.0)),
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
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            new Text(
                              "افضل سعر",
                              style: TextStyle(
                                color: const Color(0xff171732),
                                fontSize: 10,
                              ),
                            ),
                            Icon(
                              Icons.monetization_on,
                              color: const Color(0xff171732),
                            ),
                          ],
                        ),
                        textColor: const Color(0xff171732),
                        color: arrangecheck ? Colors.amber : Colors.grey[100],

                        onPressed: () {
                          setState(() {
                            arrangecheck = true;
                          });
                          sortprice();
                        },
//
                        shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(10.0)),
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
                    side: new BorderSide(color: Colors.grey[400], width: 3.0),
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
                                  itemBuilder: (BuildContext ctxt, int index) {
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
                                        commentlist[index].details,
                                        commentlist[index].price,
                                        commentlist[index].rate,
                                      ),
                                    );
                                  }),
                            )),
                        (cType == "trader")
                            ?
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Row(
                            children: <Widget>[
                              Flexible(
                                child: Row(
                                  children: [
                                    Container(
                                      width: 200,
                                      height: 60,
                                      child: Padding(
                                        padding:
                                        const EdgeInsets.all(1.0),
                                        child: Card(
                                          elevation: 0.0,
                                          color: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius.circular(5),
                                          ),
                                          child: Directionality(
                                            textDirection:
                                            TextDirection.rtl,
                                            child: TextFormField(
                                              textAlign: TextAlign.right,
                                              keyboardType:
                                              TextInputType.text,
                                              textDirection:
                                              TextDirection.rtl,
                                              controller:
                                              _commentdetailController,
                                              validator: (String value) {
                                                if ((value.isEmpty)) {
                                                  return 'ابشر .. لكن اكتب  الاول طال عمرك';
                                                }
                                              },

                                              onChanged: (value) {},
                                              //  controller: controller,
                                              decoration: InputDecoration(
                                                  errorStyle: TextStyle(
                                                      color: Colors.red,
                                                      fontSize: 15.0),
                                                  labelText: "حل المشكلة",
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
                                    Container(
                                      width: 100,
                                      height: 60,
                                      child: Padding(
                                        padding:
                                        const EdgeInsets.all(1.0),
                                        child: Card(
                                          elevation: 0.0,
                                          color: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius.circular(5),
                                          ),
                                          child: Directionality(
                                            textDirection:
                                            TextDirection.rtl,
                                            child: TextFormField(
                                              textAlign: TextAlign.right,
                                              keyboardType:
                                              TextInputType.number,
                                              textDirection:
                                              TextDirection.rtl,
                                              controller:
                                              _commentController,
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
                                                  labelText: "السعر",
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
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.add_comment,
                                  color: Colors.grey,
                                ),
                                tooltip: 'Increase volume by 10',
                                onPressed: () async {
                                  if (_formKey1.currentState.validate()) {
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
                                          "انت غير متصل بشبكة إنترنت",
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
//                                 InkWell(
//                                   onTap: () async {
//                                     if (_formKey1.currentState
//                                         .validate()) {
//                                       try {
//                                         final result =
//                                             await InternetAddress.lookup(
//                                                 'google.com');
//                                         if (result.isNotEmpty &&
//                                             result[0]
//                                                 .rawAddress
//                                                 .isNotEmpty) {
//                                           createRecord();
//                                         }
//                                       } on SocketException catch (_) {
//                                         //  print('not connected');
//                                         Toast.show(
//                                             "انت غير متصل بشبكة إنترنت طال عمرك",
//                                             context,
//                                             duration: Toast.LENGTH_LONG,
//                                             gravity: Toast.BOTTOM);
//                                       }
//
// //                                                setState(() {
// //                                                  _load2 = true;
// //                                                });
//
//                                     }
//                                   },
//                                   child: Icon(
//                                     Icons.add_comment,
//                                     color: Colors.grey,
//                                   ),
//                                 ),
                            ],
                          ),
                        )
                            : Container(),
                      ],
                    )),
              ),
            ],
          )),
    );
  }
}
