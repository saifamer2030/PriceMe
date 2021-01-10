import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:ui' as ui;
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart' as DateFormat;
import 'package:priceme/UserRating/UserRatingPage.dart';
import 'package:priceme/classes/sharedpreftype.dart';
import 'package:priceme/screens/map_view.dart';
import 'package:priceme/ui_utile/myColors.dart';
import 'package:shimmer/shimmer.dart';
import 'package:toast/toast.dart';
import 'package:priceme/ui_utile/myCustomShape.dart';

import '../FragmentNavigation.dart';

class BookingPage extends StatefulWidget {
  String ownerId, traderid, advID, commentid;

  BookingPage(this.ownerId, this.traderid, this.advID, this.commentid);

  @override
  _BookingPageState createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  String bookingdate = "اى موعد";
  String _cNametrade ;
  String _cMobiletrade;
  String cTypetrade = "";
  String _cEmailtrade = "";
  String photourltrade,
      fPlaceNametrade,
      worktypetrade,
      workshopnametrade,
      traderTypetrade;
  String fromPlaceLat, fromPlaceLng;

  final format = DateFormat.DateFormat("yyyy-MM-dd HH:mm");
  int arrange = 0;
  String _cNameowner = "";
  String _cMobileowner;
  String cTypeowner = "";
  String photourlowner;

  String advtitle;

  String advdetails;
  String advprobtype;
  String advdate;

  String commentprice;
  String commentdetails;
  bool _isCheckedtrader = false;
  bool _isCheckedowner = false;
  String _userId;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  Future onSelectNotification(String payload) async {
    if (payload != null) {
      Navigator.push(
          context,
          new MaterialPageRoute(
              builder: (context) => new UserRatingPage(payload)));
    }
  }

  @override
  void initState() {
    super.initState();




    FirebaseAuth.instance.currentUser().then((user) => user == null
        ? setState((){}): setState(() {_userId = user.uid;
       // print("$_userId////${widget.traderid}///${widget.ownerId}");
        }));


    gettraderdata();
    getuserdata();
    getadvdata();
  }

  showNotification(arrange, title, tradename, date, tradeid) async {
    print("sss$arrange");
    ///////////////////local notification/////////////////////notification_1
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    var android = AndroidInitializationSettings('@drawable/ic_logo');
    var ios = IOSInitializationSettings();
    var initSettings = InitializationSettings(android, ios);
    flutterLocalNotificationsPlugin.initialize(
      initSettings,
      onSelectNotification: onSelectNotification,
    );
    DateTime scheduledNotificationDateTime = DateTime.now().add(new Duration(seconds: 3));
    // DateTime scheduledNotificationDateTime =
    //     DateTime.parse(date).add(new Duration(days: 1));
    print("aaa${scheduledNotificationDateTime.toString()}");
    //  DateTime notificationbooking = DateTime.parse('$enddate 23:59:00.000');
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'channelId', 'channelName', 'channelDescription',
        importance: Importance.Max,
        priority: Priority.High /*, ticker: 'ticker'*/);
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    NotificationDetails platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    // print("uuuuuu${widget.events[widget.index].title}");
    await flutterLocalNotificationsPlugin.schedule(
        arrange - 202000000000,
        'تقيم $tradename',
        'ساعدنا فى تقديم خدمة افضل. برجاء الضغط هنا لتقيم $tradename',
        scheduledNotificationDateTime,
        platformChannelSpecifics,
        payload: tradeid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xffffffff),
        body:
        Column(
          children: [

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
                        "صفحة الحجز",
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
              child:
              _cNametrade != null ?

              bookingScreenWidget():
              loadingScreen()
            )

          ],
        )
        );
  }

  Widget bookingScreenWidget() {
    return Container(
      //width: MediaQuery.of(context).size.width,
      // height: MediaQuery.of(context).size.height,
      child: ListView(
        shrinkWrap: true,
        children: [


     Container(
            height: 40,
            alignment: Alignment.center,

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
              "بيانات التاجر",
              style: TextStyle(
                fontSize: 14,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          SizedBox(height: 8,),

          Container(
            margin: EdgeInsets.only(right: 10, left: 10),
            child: Row(
              textDirection: TextDirection.rtl,
              children: [
                Text("الإسم",textDirection: TextDirection.rtl, textAlign: TextAlign.right,  style: TextStyle(fontSize: 12, color: Colors.grey)),
                Expanded(
                  child:
                  Center(
                    child: Text(
                      _cNametrade,
                      style: TextStyle(fontSize: 12, ),
                    )
                  )
                  ,
                )
              ],
            ),
          ),

          SizedBox(height: 4,),

          Container(
            margin: EdgeInsets.only(right: 10, left: 10),
            child: Row(
              textDirection: TextDirection.rtl,
              children: [
                Text("إسم المحل",textDirection: TextDirection.rtl, textAlign: TextAlign.right, style: TextStyle(fontSize: 12, color: Colors.grey)),
                Expanded(
                  child:
                  Center(
                    child: Text(
                      workshopnametrade,
                      style: TextStyle(fontSize: 12, ),
                    )
                  )
                  ,
                )
              ],
            ),
          ),

          SizedBox(height: 4,),

          Container(
            margin: EdgeInsets.only(right: 10, left: 10),
            child: Row(
              textDirection: TextDirection.rtl,
              children: [
                Text("رقم الهاتف",textDirection: TextDirection.rtl, textAlign: TextAlign.right, style: TextStyle(fontSize: 12, color: Colors.grey)),
                Expanded(
                  child:
                  Center(
                      child: Text(
                        _cMobiletrade,
                        style: TextStyle(fontSize: 12, ),
                      )
                  )
                  ,
                )
              ],
            ),
          ),

          SizedBox(height: 4,),

          Container(
            margin: EdgeInsets.only(right: 10, left: 10),
            child: Row(
              textDirection: TextDirection.rtl,
              children: [
                Text("العنوان",textDirection: TextDirection.rtl, textAlign: TextAlign.right, style: TextStyle(fontSize: 12, color: Colors.grey)),
                Expanded(
                  child:
                  Center(
                      child: Text(
                        fPlaceNametrade,
                        style: TextStyle(fontSize: 12, ),
                      )
                  )
                  ,
                )
              ],
            ),
          ),

          SizedBox(height: 4,),

          Container(
            margin: EdgeInsets.only(right: 10, left: 10),
            child: Row(
              textDirection: TextDirection.rtl,
              children: [
                Text("نوع التاجر",textDirection: TextDirection.rtl, textAlign: TextAlign.right, style: TextStyle(fontSize: 12, color: Colors.grey)),
                Expanded(
                  child:
                  Center(
                      child: Text(
                        traderTypetrade,
                        style: TextStyle(fontSize: 12, ),
                      )
                  )
                  ,
                )
              ],
            ),
          ),

          SizedBox(height: 4,),

          Container(
            margin: EdgeInsets.only(right: 10, left: 10),
            child: Row(
              textDirection: TextDirection.rtl,
              children: [
                Text("نوع العمل" ,textDirection: TextDirection.rtl, textAlign: TextAlign.right , style: TextStyle(fontSize: 12, color: Colors.grey)),
                Expanded(
                  child:
                  Center(
                      child: Text(
                        worktypetrade,
                        style: TextStyle(fontSize: 12, ),
                      )
                  )
                  ,
                )
              ],
            ),
          ),

          SizedBox(height: 6,),
          Container(
            alignment: Alignment.centerLeft,
            child:
                InkWell(
                onTap: (){
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MapView(
                              workshopnametrade,
                              double.parse(fromPlaceLat),
                              double.parse(fromPlaceLng))));
                },
    child:  Container(
        width: 184,
        height: 30,

        child: Row(
            children:[
              SizedBox(
                width: 10,
              ),
              //Icon(Icons.arrow_back, color: Colors.orange,),

              SizedBox(
                width: 6,
              ),

              Text("إظهار الموقع على الخريطة", style: TextStyle(color: Colors.orange, fontSize: 12, fontWeight: FontWeight.bold),),
              SizedBox(width: 10,),
              Icon(Icons.location_on, color: Colors.orange, size: 20, ),

            ]

        )
    )
                )

            ,
          ),
          SizedBox(
            height: 16.0,
          ),
          Container(
            height: 40,
            alignment: Alignment.center,
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
              "بيانات المستخدم",
              style: TextStyle(
                fontSize: 14,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(
            height: 8,
          ),
          Container(
              margin: EdgeInsets.only(right: 10, left: 10),
              child: Row(
                textDirection: TextDirection.rtl,
                children: [
                  Icon(
                    Icons.person,
                    color: Colors.grey[400],
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text("$_cNameowner"),
                  Container(
                    width: 20,
                  ),
                ],
              )),
          SizedBox(
            height: 8,
          ),
          Container(
              margin: EdgeInsets.only(right: 10, left: 10),
              alignment: Alignment.centerRight,
              child: Row(
                textDirection: TextDirection.rtl,
                children: [
                  Icon(
                    Icons.phone_android,
                    color: Colors.grey[400],
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text("$_cMobileowner"),
                ],
              )),
          SizedBox(
            height: 10.0,
          ),
          Container(
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
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
              "بيانات الطلب",
              style: TextStyle(
                fontSize: 14,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
              alignment: Alignment.centerRight,
              margin: EdgeInsets.only(right: 10, left: 10),
              child: Row(
                textDirection: TextDirection.rtl,
                children: [
                  Text(
                    "عنوان الطلب",
                    textDirection: TextDirection.rtl,
                    textAlign: TextAlign.right,
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  Expanded(
                      child: Center(
                    child: Text(
                      "$advtitle",
                      textDirection: TextDirection.rtl,
                      textAlign: TextAlign.center,
                    ),
                  ))
                ],
              )),
          Container(
              alignment: Alignment.centerRight,
              margin: EdgeInsets.only(right: 10, left: 10),
              child: Row(
                textDirection: TextDirection.rtl,
                children: [
                  Text(
                    "نوع الطلب",
                    textDirection: TextDirection.rtl,
                    textAlign: TextAlign.right,
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  Expanded(
                      child: Center(
                    child: Text(
                      "$advprobtype",
                      textDirection: TextDirection.rtl,
                      textAlign: TextAlign.center,
                    ),
                  ))
                ],
              )),
          Container(
              alignment: Alignment.centerRight,
              margin: EdgeInsets.only(right: 10, left: 10),
              child: Row(
                textDirection: TextDirection.rtl,
                children: [
                  Text(
                    "تاريخ الطلب:",
                    textDirection: TextDirection.rtl,
                    textAlign: TextAlign.right,
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  Expanded(
                      child: Center(
                    child: Text(
                      "$advdate",
                      textDirection: TextDirection.rtl,
                      textAlign: TextAlign.center,
                    ),
                  ))
                ],
              )),
          Container(
              alignment: Alignment.centerRight,
              margin: EdgeInsets.only(right: 10, left: 10),
              child:
                  Text(
                    "تفاصيل الطلب:",
                    textDirection: TextDirection.rtl,
                    textAlign: TextAlign.right,
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),


               ),

          Container(
            margin: EdgeInsets.only(right: 24, left: 10),
            child: Text(
              advdetails,
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.right,
            )
          )
          ,
          SizedBox(
            height: 16.0,
          ),
          Container(
              height: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
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
                "عرض السعر ",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              )),
          SizedBox(
            height: 16.0,
          ),
          Container(
              margin: EdgeInsets.only(right: 10, left: 10),
              child: Row(
                textDirection: TextDirection.rtl,
                children: [
                  Text(
                    "السعر",
                    textDirection: TextDirection.rtl,
                    textAlign: TextAlign.right,
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  Expanded(
                      child: Center(
                    child: Text(
                      "$commentprice",
                      textDirection: TextDirection.rtl,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.black, fontSize: 12),
                    ),
                  )),
                ],
              )),
          Container(
            margin: EdgeInsets.only(right: 10, left: 10),
            child: Text(
              "التفاصيل:",
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.right,
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ),
          Container(
              margin: EdgeInsets.only(right: 24, left: 10),
              child: Text(
                "$commentdetails",
                textDirection: TextDirection.rtl,
                textAlign: TextAlign.right,
                style: TextStyle(fontSize: 12),
              )),
          SizedBox(
            height: 10.0,
          ),
          Divider(),
          Container(
              height: 40,
              decoration:
                  BoxDecoration(border: Border.all(color: Colors.orange)),
              child: Row(
                textDirection: TextDirection.rtl,
                children: [
                  Container(
                    height: 40,
                    width: 98,
                    child: Center(
                      child: Text("موعد الزيارة",
                          textDirection: TextDirection.rtl,
                          textAlign: TextAlign.right,
                          style: TextStyle(
                              color: Colors.orange,
                              fontSize: 12,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                  Container(
                    height: 40,
                    width: 2,
                    color: Colors.orange,
                  ),
                  Expanded(
                      child: Container(
                    //color: Colors.blue,
                    child: Center(
                      child: Text(
                        '$bookingdate',
                        style: TextStyle(color: Colors.black, fontSize: 12),
                      ),
                    ),
                  )),
                  InkWell(
                    onTap: () {
                      DatePicker.showDateTimePicker(context,
                          showTitleActions: true,
                          minTime: DateTime.now(),
                          maxTime: DateTime(2222, 6, 7), onChanged: (date) {
                        print('change $date');
                      }, onConfirm: (date) {
                        print('confirm $date');
                        setState(() {
                          bookingdate = date.toString();
                        });
                      }, currentTime: DateTime.now(), locale: LocaleType.ar);
                    },
                    child: Container(
                      height: 40,
                      width: 75,
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

                      ),
                      child: Center(
                        child: Text(
                          "حدد الموعد",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ],
              )),
          SizedBox(
            height: 20.0,
          ),


          _userId == widget.ownerId
              ? Container(
                  decoration:
                      BoxDecoration(border: Border.all(color: Colors.orange)),
                  child: CheckboxListTile(
                    title: const Text('تاكيد العميل', style: TextStyle(
                        color: Colors.black
                    )),
                    //subtitle: const Text('A programming blog'),
                    // secondary: const Icon(Icons.person),
                    activeColor: Colors.red,
                    checkColor: Colors.yellow,
                    selected: _isCheckedowner,
                    value: _isCheckedowner,
                    onChanged: (bool value) {
                      setState(() {
                        _isCheckedowner = value;
                      });
                    },
                  ),
                )
              : Container(
                  decoration:
                      BoxDecoration(border: Border.all(color: Colors.orange),

                      ),

                  child: CheckboxListTile(
                    title: const Text('تاكيد العميل',style: TextStyle(
                        color: Colors.black
                    )),
                    //subtitle: const Text('A programming blog'),
                    // secondary: const Icon(Icons.person),
                    activeColor: Colors.red,
                    checkColor: Colors.yellow,
                    selected: _isCheckedowner,
                    value: _isCheckedowner,
                    onChanged: null,
                  ),
                ),
          SizedBox(
            height: 20.0,
          ),
          _userId == widget.traderid
              ? 
          
          Container(
                  decoration:
                      BoxDecoration(border: Border.all(color: Colors.orange)),

                  child:
                  CheckboxListTile(
                 title: const Text('تاكيد التاجر', style: TextStyle(
                   color: Colors.black
                 ),),
                 // subtitle: const Text('A programming blog'),
                 // secondary: const Icon(Icons.person),
                 activeColor: Colors.red,
                 checkColor: Colors.yellow,
                 selected: _isCheckedtrader,
                 value: _isCheckedtrader,
                 onChanged: (bool value) {
                   setState(() {
                     _isCheckedtrader = value;
                   });
                 },
               )
    
                  ,
                )
              : Container(
                  decoration:
                      BoxDecoration(border: Border.all(color: Colors.orange),

                      ),
                  child: CheckboxListTile(
                    title: const Text('تاكيد التاجر', style: TextStyle(
                        color: Colors.black
                    )),
                    // subtitle: const Text('A programming blog'),
                    // secondary: const Icon(Icons.person),
                    activeColor: Colors.red,
                    checkColor: Colors.yellow,
                    selected: _isCheckedtrader,
                    value: _isCheckedtrader,
                    onChanged: null,
                  ),
                ),
          SizedBox(
            height: 26.0,
          ),


          Padding(
            padding: EdgeInsets.only(right: 16, left: 16),
            child: RaisedButton(

                padding: EdgeInsets.zero,
                shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),

                onPressed: () {
                  Firestore.instance
                      .collection("commentsdata")
                      .document(widget.ownerId)
                      .collection(widget.advID)
                      .document(widget.commentid)
                      .updateData({
                    "bookingdate": bookingdate,
                    "ownercheck": _isCheckedowner,
                    "tradercheck": _isCheckedtrader,
                  }).whenComplete(() {
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

                    // String date1 ='${now.year}-${now.month}-${now.day}';// ${now.hour}:${now.minute}:00.000';
                    String date =
                        '${now.year}-${now.month}-${now.day}-${now.hour}-${now.minute}-00';
                    DocumentReference documentReference = Firestore.instance
                        .collection('Alarm')
                        .document(widget.ownerId)
                        .collection('Alarmid')
                        .document(widget.commentid);
                    documentReference.setData({
                      'ownerId': widget.ownerId,
                      'traderid': widget.traderid,
                      'advID': widget.advID,
                      'alarmid': widget.commentid,
                      'cdate': now.toString(),
                      'tradname': _cNametrade,
                      'ownername': _cNameowner,
                      'price': commentprice,
                      'rate': 0,
                      'arrange':
                      int.parse("${now.year.toString()}${b}${c}${d}${e}${f}"),
                      'cType': "book",
                    }).whenComplete(() {
                      DocumentReference documentReference = Firestore.instance
                          .collection('Alarm')
                          .document(widget.traderid)
                          .collection('Alarmid')
                          .document(widget.commentid);
                      documentReference.setData({
                        'ownerId': widget.ownerId,
                        'traderid': widget.traderid,
                        'advID': widget.advID,
                        'alarmid': widget.commentid,
                        'cdate': now.toString(),
                        'tradname': _cNametrade,
                        'ownername': _cNameowner,
                        'price': commentprice,
                        'rate': 0,
                        'arrange': int.parse(
                            "${now.year.toString()}${b}${c}${d}${e}${f}"),
                        'cType': "book",
                      });
                      Toast.show("تم الارسال بنجاح", context,
                          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                    }).whenComplete(() {
                      if (_userId == widget.ownerId) {
                        if (bookingdate == "اى موعد") {
                        } else {
                          showNotification(arrange, advtitle, _cNametrade,
                              bookingdate, widget.traderid);
                        }
                        if (_isCheckedowner) {
                          Firestore.instance
                              .collection('advertisments')
                              .document(widget.advID)
                              .updateData({
                            "tradeidselected": widget.traderid,
                            "carrangetrade": int.parse(
                                "${now.year.toString()}${b}${c}${d}${e}${f}"),
                          });
                        } else {
                          Firestore.instance
                              .collection('advertisments')
                              .document(widget.advID)
                              .updateData({
                            "tradeidselected": null,
                          });
                        }
                      }
                    });
                  });
                },

                child:

                Container(
                  height: 40,

                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
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
                  child: Center(
                    child: Text(
                      'تأكيد',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                )



            )
          ),

          SizedBox(
            height: 10.0,
          ),

        ],
      ),
    );
  }

  Widget loadingScreen(){
    return Shimmer.fromColors( baseColor: Colors.grey[200],
        highlightColor: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          textDirection: TextDirection.rtl,
          children: [
            Container(
                height: 40,

                decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(6))
            ),
            SizedBox(
              height: 10,
            ),
            Container(
                height: 20,
                width: 150,
                decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(6))
            ),
            SizedBox(
              height: 10,
            ),
            Container(
                height: 20,
                width: 150,
                decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(6))
            ),
            SizedBox(
              height: 10,
            ),
            Container(
                height: 20,
                width: 150,
                decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(6))
            ),
            SizedBox(
              height: 10,
            ),
            Container(
                height: 20,
                width: 150,
                decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(6))
            ),
            SizedBox(
              height: 16,
            ),

            Container(
                height: 40,

                decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(6))
            ),

            SizedBox(
              height: 16,
            ),

            Container(
                height: 20,
                width: 150,
                decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(6))
            ),
            SizedBox(
              height: 10,
            ),
            Container(
                height: 20,
                width: 150,
                decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(6))
            ),
            SizedBox(
              height: 10,
            ),
            Container(
                height: 20,
                width: 150,
                decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(6))
            ),
            SizedBox(
              height: 10,
            ),
            Container(
                height: 20,
                width: 150,
                decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(6))
            ),
            SizedBox(
              height: 16,
            ),

           SizedBox(
              height: 10,
            ),

            Expanded(
              child: Container(

                  decoration: BoxDecoration(
                      color: Colors.grey[200],
                     )
              ),
            )


          ],
        )
    );
  }
  void gettraderdata() {
    var userQuery = Firestore.instance
        .collection('users')
        .where('uid', isEqualTo: widget.traderid)
        .limit(1);
    userQuery.getDocuments().then((data) {
      if (data.documents.length > 0) {
        setState(() {
          _cNametrade = data.documents[0].data['name'];
          _cMobiletrade = data.documents[0].data['phone'];
          _cEmailtrade = data.documents[0].data['email'];

          cTypetrade = data.documents[0].data['cType'].toString();
          photourltrade = data.documents[0].data['photourl'].toString();
          fromPlaceLat = data.documents[0].data['fromPLat'].toString();
          fromPlaceLng = data.documents[0].data['fromPLng'].toString();
          fPlaceNametrade = data.documents[0].data['fPlaceName'].toString();
          worktypetrade = data.documents[0].data['worktype'].toString();
          workshopnametrade = data.documents[0].data['workshopname'].toString();
          traderTypetrade = data.documents[0].data['traderType'].toString();

          workshopnametrade == null
              ? workshopnametrade = "اسم محل غير معلوم"
              : workshopnametrade = workshopnametrade;
          fPlaceNametrade == null
              ? fPlaceNametrade = "عنوان غير معلوم"
              : fPlaceNametrade = fPlaceNametrade;
          traderTypetrade == null
              ? traderTypetrade = "نوع التاجر غير معلوم"
              : traderTypetrade = traderTypetrade;
          worktypetrade == null
              ? worktypetrade = "نوع العمل غير معلوم"
              : worktypetrade = worktypetrade;

          if (_cNametrade == null) {
            _cNametrade = "ايميل غير معلوم";
          }
          if (_cMobiletrade == null) {
            _cMobiletrade = "لا يوجد رقم هاتف بعد";
          }
          if (_cEmailtrade == null) {
            _cEmailtrade = "ايميل غير معلوم";
          }
        });
      }
    });
  }

  void getuserdata() {
    var userQuery = Firestore.instance
        .collection('users')
        .where('uid', isEqualTo: widget.ownerId)
        .limit(1);
    userQuery.getDocuments().then((data) {
      if (data.documents.length > 0) {
        setState(() {
          _cNameowner = data.documents[0].data['name'];
          _cMobileowner = data.documents[0].data['phone'];
          cTypeowner = data.documents[0].data['cType'].toString();
          photourlowner = data.documents[0].data['photourl'].toString();

          if (_cNameowner == null) {
            _cNameowner = "ايميل غير معلوم";
          }
          if (_cMobileowner == null) {
            _cMobileowner = "لا يوجد رقم هاتف بعد";
          }
        });
      }
    });
  }

  void getadvdata() {
    var userQuery = Firestore.instance
        .collection('advertisments')
        .where('advid', isEqualTo: widget.advID)
        .limit(1);
    userQuery.getDocuments().then((data) {
      if (data.documents.length > 0) {
        setState(() {
          advtitle = data.documents[0].data['ctitle'];
          advdetails = data.documents[0].data['cdiscribtion'];
          advprobtype = data.documents[0].data['cproblemtype'];
          advdate = data.documents[0].data['cdate'];
          arrange = data.documents[0].data['carrange'];

          if (advtitle == null) {
            advtitle = "عنوان غير معلوم";
          }
          if (advdetails == null) {
            advdetails = "لا يوجد تفاصيل";
          }
          if (advprobtype == null) {
            advprobtype = "لا يوجد تفاصيل";
          }
          if (advdate == null) {
            advdate = "لا يوجد تفاصيل";
          }
          getcommentdata();
        });
      }
    });
  }

  void getcommentdata() {
    //   print("aaa${widget.traderid}///${widget.ownerId}///${widget.advID}///${ widget.commentid}");
    var userQuery = Firestore.instance
        .collection('commentsdata')
        .document(widget.ownerId)
        .collection(widget.advID)
        .where('commentid', isEqualTo: widget.commentid)
        .limit(1);
    userQuery.getDocuments().then((data) {
      if (data.documents.length > 0) {
        setState(() {
          commentprice = data.documents[0].data['price'].toString();
          commentdetails = data.documents[0].data['details'];

          bookingdate = data.documents[0].data['bookingdate'];
          _isCheckedowner = data.documents[0].data['ownercheck'];
          _isCheckedtrader = data.documents[0].data['tradercheck'];

          if (commentprice == null) {
            commentprice = "لا يوجد تفاصيل";
          }
          if (commentdetails == null) {
            commentdetails = "لا يوجد تفاصيل";
          }
          // if(bookingdate==null){bookingdate="لا يوجد تفاصيل";}

          if (_isCheckedowner == null) {
            _isCheckedowner = false;
          }
          if (_isCheckedtrader == null) {
            _isCheckedtrader = false;
          }
          if (DateTime.parse(bookingdate).isAfter(DateTime.now())) {
            if (_userId == widget.ownerId) {
              showNotification(
                  arrange, advtitle, _cNametrade, bookingdate, widget.traderid);

            }
          }
        });
      }
    });
  }

  Widget previousWidget() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: ListView(
        children: [
          Card(
              shape: new RoundedRectangleBorder(
                  side: new BorderSide(color: Colors.grey[400], width: 3.0),
                  borderRadius: BorderRadius.circular(10.0)),
              //borderOnForeground: true,
              elevation: 10.0,
              margin: EdgeInsets.only(right: 1, left: 1, bottom: 2),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MapView(
                              workshopnametrade,
                              double.parse(fromPlaceLat),
                              double.parse(fromPlaceLng))));
                },
                child: Container(
                    height: 180,
                    color: Colors.grey[300],
                    padding: EdgeInsets.all(0),
                    child: Column(
                      children: [
                        Text(
                          "بيانات التاجر",
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text("$_cNametrade:الاسم"),
                            Container(
                              width: 20,
                            ),
                            Icon(Icons.person),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text("$workshopnametrade: اسم المحل"),
                            Container(
                              width: 20,
                            ),
                            Icon(Icons.apartment),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text("$_cMobiletrade:رقم الهاتف"),
                            Container(
                              width: 20,
                            ),
                            Icon(Icons.phone_android),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text("$fPlaceNametrade: العنوان"),
                            Container(
                              width: 20,
                            ),
                            Icon(Icons.location_on_rounded),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text("$traderTypetrade: نوع التاجر"),
                            Container(
                              width: 20,
                            ),
                            Icon(Icons.settings),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text("$worktypetrade: نوع العمل"),
                            Container(
                              width: 20,
                            ),
                            Icon(Icons.settings),
                          ],
                        ),
                      ],
                    )),
              )),
          SizedBox(
            height: 10.0,
          ),
          Card(
              shape: new RoundedRectangleBorder(
                  side: new BorderSide(color: Colors.grey[400], width: 3.0),
                  borderRadius: BorderRadius.circular(10.0)),
              //borderOnForeground: true,
              elevation: 10.0,
              margin: EdgeInsets.only(right: 1, left: 1, bottom: 2),
              child: Container(
                  height: 100,
                  color: Colors.grey[300],
                  padding: EdgeInsets.all(0),
                  child: Column(
                    children: [
                      Text(
                        "بيانات المستخدم",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text("$_cNameowner:الاسم"),
                          Container(
                            width: 20,
                          ),
                          Icon(Icons.person),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text("$_cMobileowner:رقم الهاتف"),
                          Container(
                            width: 20,
                          ),
                          Icon(Icons.phone_android),
                        ],
                      ),
                    ],
                  ))),
          SizedBox(
            height: 10.0,
          ),
          Card(
              shape: new RoundedRectangleBorder(
                  side: new BorderSide(color: Colors.grey[400], width: 3.0),
                  borderRadius: BorderRadius.circular(10.0)),
              //borderOnForeground: true,
              elevation: 10.0,
              margin: EdgeInsets.only(right: 1, left: 1, bottom: 2),
              child: Container(
                  height: 150,
                  color: Colors.grey[300],
                  padding: EdgeInsets.all(0),
                  child: Column(
                    children: [
                      Text(
                        "بيانات الطلب",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text("عنوان الطلب:$advtitle"),
                          Container(
                            width: 20,
                          ),
                          Icon(Icons.web),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text("نوع الطلب:$advprobtype"),
                          Container(
                            width: 20,
                          ),
                          Icon(Icons.web),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text("تاريخ الطلب:$advdate"),
                          Container(
                            width: 20,
                          ),
                          Icon(Icons.person),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text("تفاصيل الطلب:$advdetails"),
                          Container(
                            width: 20,
                          ),
                          Icon(Icons.web),
                        ],
                      ),
                    ],
                  ))),
          SizedBox(
            height: 10.0,
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
                  child: Column(
                    children: [
                      Text(
                        "عرض سعر ",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text("$commentprice:السعر"),
                          Container(
                            width: 20,
                          ),
                          Icon(Icons.monetization_on),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text("التفاصيل:$commentdetails"),
                          Container(
                            width: 20,
                          ),
                          Icon(Icons.article_outlined),
                        ],
                      ),
                    ],
                  ))),
          SizedBox(
            height: 10.0,
          ),
          Text(
            'موعد الزيارة:$bookingdate',
            style: TextStyle(color: Colors.blue),
          ),
          SizedBox(
            height: 10.0,
          ),
          FlatButton(
              onPressed: () {
                DatePicker.showDateTimePicker(context,
                    showTitleActions: true,
                    minTime: DateTime.now(),
                    maxTime: DateTime(2222, 6, 7), onChanged: (date) {
                  print('change $date');
                }, onConfirm: (date) {
                  print('confirm $date');
                  setState(() {
                    bookingdate = date.toString();
                  });
                }, currentTime: DateTime.now(), locale: LocaleType.ar);
              },
              child: Text(
                'حدد الوقت المناسب',
                style: TextStyle(color: Colors.blue),
              )),
          SizedBox(
            height: 10.0,
          ),
          _userId == widget.ownerId
              ? Container(
                  decoration:
                      BoxDecoration(border: Border.all(color: Colors.teal)),
                  child: CheckboxListTile(
                    title: const Text('تاكيد العميل'),
                    //subtitle: const Text('A programming blog'),
                    // secondary: const Icon(Icons.person),
                    activeColor: Colors.red,
                    checkColor: Colors.yellow,
                    selected: _isCheckedowner,
                    value: _isCheckedowner,
                    onChanged: (bool value) {
                      setState(() {
                        _isCheckedowner = value;
                      });
                    },
                  ),
                )
              : Container(
                  decoration:
                      BoxDecoration(border: Border.all(color: Colors.teal)),
                  child: CheckboxListTile(
                    title: const Text('تاكيد العميل'),
                    //subtitle: const Text('A programming blog'),
                    // secondary: const Icon(Icons.person),
                    activeColor: Colors.red,
                    checkColor: Colors.yellow,
                    selected: _isCheckedowner,
                    value: _isCheckedowner,
                    onChanged: null,
                  ),
                ),
          SizedBox(
            height: 10.0,
          ),
          _userId == widget.traderid
              ? Container(
                  decoration:
                      BoxDecoration(border: Border.all(color: Colors.teal)),
                  child: CheckboxListTile(
                    title: const Text('تاكيد التاجر'),
                    // subtitle: const Text('A programming blog'),
                    // secondary: const Icon(Icons.person),
                    activeColor: Colors.red,
                    checkColor: Colors.yellow,
                    selected: _isCheckedtrader,
                    value: _isCheckedtrader,
                    onChanged: (bool value) {
                      setState(() {
                        _isCheckedtrader = value;
                      });
                    },
                  ),
                )
              : Container(
                  decoration:
                      BoxDecoration(border: Border.all(color: Colors.teal)),
                  child: CheckboxListTile(
                    title: const Text('تاكيد التاجر'),
                    // subtitle: const Text('A programming blog'),
                    // secondary: const Icon(Icons.person),
                    activeColor: Colors.red,
                    checkColor: Colors.yellow,
                    selected: _isCheckedtrader,
                    value: _isCheckedtrader,
                    onChanged: null,
                  ),
                ),
          SizedBox(
            height: 10.0,
          ),
          FlatButton(
              onPressed: () {
                Firestore.instance
                    .collection("commentsdata")
                    .document(widget.ownerId)
                    .collection(widget.advID)
                    .document(widget.commentid)
                    .updateData({
                  "bookingdate": bookingdate,
                  "ownercheck": _isCheckedowner,
                  "tradercheck": _isCheckedtrader,
                }).whenComplete(() {
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

                  // String date1 ='${now.year}-${now.month}-${now.day}';// ${now.hour}:${now.minute}:00.000';
                  String date =
                      '${now.year}-${now.month}-${now.day}-${now.hour}-${now.minute}-00';
                  DocumentReference documentReference = Firestore.instance
                      .collection('Alarm')
                      .document(widget.ownerId)
                      .collection('Alarmid')
                      .document(widget.commentid);
                  documentReference.setData({
                    'ownerId': widget.ownerId,
                    'traderid': widget.traderid,
                    'advID': widget.advID,
                    'alarmid': widget.commentid,
                    'cdate': now.toString(),
                    'tradname': _cNametrade,
                    'ownername': _cNameowner,
                    'price': commentprice,
                    'rate': 0,
                    'arrange':
                        int.parse("${now.year.toString()}${b}${c}${d}${e}${f}"),
                    'cType': "book",
                  }).whenComplete(() {
                    DocumentReference documentReference = Firestore.instance
                        .collection('Alarm')
                        .document(widget.traderid)
                        .collection('Alarmid')
                        .document(widget.commentid);
                    documentReference.setData({
                      'ownerId': widget.ownerId,
                      'traderid': widget.traderid,
                      'advID': widget.advID,
                      'alarmid': widget.commentid,
                      'cdate': now.toString(),
                      'tradname': _cNametrade,
                      'ownername': _cNameowner,
                      'price': commentprice,
                      'rate': 0,
                      'arrange': int.parse(
                          "${now.year.toString()}${b}${c}${d}${e}${f}"),
                      'cType': "book",
                    });
                    Toast.show("تم الارسال بنجاح", context,
                        duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                  }).whenComplete(() {
                    if (_userId == widget.ownerId) {
                      if (bookingdate == "اى موعد") {
                      } else {
                        showNotification(arrange, advtitle, _cNametrade,
                            bookingdate, widget.traderid);
                      }
                      if (_isCheckedowner) {
                        Firestore.instance
                            .collection('advertisments')
                            .document(widget.advID)
                            .updateData({
                          "tradeidselected": widget.traderid,
                          "carrangetrade": int.parse(
                              "${now.year.toString()}${b}${c}${d}${e}${f}"),
                        });
                      } else {
                        Firestore.instance
                            .collection('advertisments')
                            .document(widget.advID)
                            .updateData({
                          "tradeidselected": null,
                        });
                      }
                    }
                  });
                });
              },
              child: Text(
                'تأكيد',
                style: TextStyle(color: Colors.blue),
              )),
        ],
      ),
    );
  }
}
