import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:priceme/screens/addadv.dart';
import 'package:priceme/screens/alladvertisement.dart';
import 'package:priceme/screens/hometest.dart';

import 'classes/ModelClass.dart';
import 'classes/SparePartsClass.dart';

class FragmentPriceMe extends StatefulWidget {
  List<String> regionlist = [];

  FragmentPriceMe(this.regionlist);

  @override ///////
  _FragmentPriceMeState createState() => _FragmentPriceMeState();
}

class _FragmentPriceMeState extends State<FragmentPriceMe> {
  // Properties & Variables needed

  int currentTab = 3; // to keep track of active tab index
//  List<Widget> _children() => [

  List<Widget> screens() => [
    AllAdvertisement(widget.regionlist),
    AllAdvertisement(widget.regionlist),
    AllAdvertisement(widget.regionlist),
    AllAdvertisement(widget.regionlist),
      ]; // to store nested tabs
  final PageStorageBucket bucket = PageStorageBucket();
  final GlobalKey<NavigatorState> navigatorKey =
      new GlobalKey<NavigatorState>();
  Widget currentScreen; // Our first view in viewport
  @override
  void initState() {
    super.initState();
    // Toast.show("kkkkkkkkkkk"+widget.regionlist.toString(),context,duration: Toast.LENGTH_SHORT,gravity:  Toast.BOTTOM);
//print("kkkkkklllllkkkkk"+FragmentSouq1.regionlist.toString());
//    registerNotification();
//    configLocalNotification();
    setState(() {
      currentScreen = AllAdvertisement(widget.regionlist);
    });

//    _currentIndex = widget.selectPage != null ? widget.selectPage : 4;
  }

  @override
  Widget build(BuildContext context) {
    // final List<Widget> children = screens( );

    return Scaffold(
      body: PageStorage(
        child: currentScreen,
        bucket: bucket,
      ),
      key: navigatorKey,
      floatingActionButton: MyFloatingButton(),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 10,
        child: Container(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  MaterialButton(
                    minWidth: 40,
                    onPressed: () {
                      print("kkkkkkkkk");
                      setState(() {
                        currentScreen = AllAdvertisement(widget
                            .regionlist); // if user taps on this dashboard tab will be active
                        currentTab = 0;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.account_circle,
                          color: currentTab == 0
                              ? const Color(0xff15494A)
                              : Colors.grey,
                        ),
                        Text(
                          'حسابي',
                          style: TextStyle(
                            color: currentTab == 0
                                ? const Color(0xff15494A)
                                : Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  MaterialButton(
                    minWidth: 40,
                    onPressed: () {
                      setState(() {
                        currentScreen = AllAdvertisement(widget
                            .regionlist); // if user taps on this dashboard tab will be active
                        currentTab = 2;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.notifications_active,
                          color: currentTab == 2
                              ? const Color(0xff15494A)
                              : Colors.grey,
                        ),
                        Text(
                          'التنبيهات',
                          style: TextStyle(
                            color: currentTab == 2
                                ?  const Color(0xff15494A)
                                : Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              // Right Tab bar icons

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  MaterialButton(
                    minWidth: 40,
                    onPressed: () {
                      setState(() {
                        currentScreen = AllAdvertisement(widget
                            .regionlist); // if user taps on this dashboard tab will be active
                        currentTab = 1;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.video_library,
                          color: currentTab == 1
                              ?  const Color(0xff15494A)
                              : Colors.grey,
                        ),
                        Text(
                          'الفيديوهات',
                          style: TextStyle(
                            color: currentTab == 1
                                ?  const Color(0xff15494A)
                                : Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  MaterialButton(
                    minWidth: 40,
                    onPressed: () {
                      setState(() {
                        currentScreen = AllAdvertisement(widget
                            .regionlist); // if user taps on this dashboard tab will be active
                        currentTab = 3;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.home,
                          color: currentTab == 3
                              ?  const Color(0xff15494A)
                              : Colors.grey,
                        ),
                        Text(
                          'الرئيسية',
                          style: TextStyle(
                            color: currentTab == 3
                                ?  const Color(0xff15494A)
                                : Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

//  void registerNotification() {
//    firebaseMessaging.requestNotificationPermissions();
//
//    firebaseMessaging.configure(onMessage: (Map<String, dynamic> message) {
//      print('onMessage: $message');
//      showNotification(message['notification']);
//      return;
//    }, onResume: (Map<String, dynamic> message) {
//      print('onResume: $message');
//      _serialiseAndNavigate(message);
//      return;
//    },
//        //onBackgroundMessage: myBackgroundMessageHandler,
//        onLaunch: (Map<String, dynamic> message) {
//          print('onLaunch: $message');
//          _serialiseAndNavigate(message);
//          return;
//        });
//  }

//  void configLocalNotification() {
//    var initializationSettingsAndroid =
//    new AndroidInitializationSettings('@drawable/ic_launcher');
//    var initializationSettingsIOS = new IOSInitializationSettings();
//    var initializationSettings = new InitializationSettings(
//        initializationSettingsAndroid, initializationSettingsIOS);
//    flutterLocalNotificationsPlugin.initialize(initializationSettings,
//        onSelectNotification: selectNotification);
//  }

//  void showNotification(message) async {
//    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
//      Platform.isAndroid
//          ? 'com.arabdevelopers.souqnagran'
//          : 'com.arabdevelopers.souqnagran',
//      'NajranGate',
//      'your channel description',
//      playSound: true,
//      enableVibration: true,
//      importance: Importance.Max,
//      priority: Priority.High,
//    );
//    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
//    var platformChannelSpecifics = new NotificationDetails(
//        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
//    await flutterLocalNotificationsPlugin.show(0, message['title'].toString(),
//        message['body'].toString(), platformChannelSpecifics,
//        payload: json.encode(message));
//  }

// ignore: missing_return
//  Future _serialiseAndNavigate(Map<String, dynamic> message) {
//    var notificationData = message['data'];
//    var view = notificationData['view'];
//
//    if (view != null) {
//      // Navigate to the create post view
//      if (view == 'cart_screen') {
//        Navigator.push(
//          context,
//          new MaterialPageRoute(
//              builder: (context) => AllAdvertesmenta(widget.regionlist)),
//        );
//      } else if (view == 'categories_screen') {
//        Navigator.push(
//          context,
//          new MaterialPageRoute(
//              builder: (context) => AllAdvertesmenta(widget.regionlist)),
//        );
//      }
//    }
//  }

//  Future<dynamic> myBackgroundMessageHandler(
//      Map<String, dynamic> message) async {
//    print("_backgroundMessageHandler");
//    if (message.containsKey('data')) {
//      // Handle data message
//      final dynamic data = message['data'];
//      print("_backgroundMessageHandler data: $data");
//    }
//
//    if (message.containsKey('notification')) {
//      // Handle notification message
//      final dynamic notification = message['notification'];
//      print("_backgroundMessageHandler notification: $notification");
//      Fimber.d("=====>myBackgroundMessageHandler $message");
//    }
//    return Future<void>.value();
//  }

//  Future selectNotification(String payload) async {
//    await Navigator.push(
//      context,
//      MaterialPageRoute(
//          builder: (context) => AllAdvertesmenta(widget.regionlist)),
//    );
//
////    if (payload == 'cart') {
////      debugPrint('notification payload: ' + payload);
////
////    }
//  }
}

class MyFloatingButton extends StatefulWidget {


  @override
  _MyFloatingButtonState createState() => _MyFloatingButtonState();
}

class _MyFloatingButtonState extends State<MyFloatingButton> {
  bool _show = true;
  List<String> subfaultsList = [];
  List<ModelClass> faultsList = [];
  List<String> sparepartsList = ['ss','s','d'];
  @override
  Widget build(BuildContext context) {
    return _show
        ? FloatingActionButton(
            backgroundColor: const Color(0xff15494A),
            child: Icon(Icons.add),
            heroTag: "unique3",
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AddAdv(sparepartsList,"قطع غيار","", sparepartsList[0])));

//        FirebaseAuth.instance.currentUser().then((user) => user == null
//            ? Navigator.of(context, rootNavigator: false).push(
//            MaterialPageRoute(
//                builder: (context) => LoginScreen2(widget.regionlist),
//                maintainState: false))
//            : setState(() {
//          var sheetController = showBottomSheet(
//              context: context,
//              builder: (context) =>
//                  BottomSheetWidget(widget.regionlist));
//
//          _showButton(false);
//
//          sheetController.closed.then((value) {
//            _showButton(true);
//          });
//        }));
            },
          )
        : Container();
  }
  void getData() {
    setState(() {
      final SparePartsReference = Firestore.instance;
      SparePartsReference.collection("spareparts")
          .getDocuments()
          .then((QuerySnapshot snapshot) {
        snapshot.documents.forEach((sparepart) {
          SparePartsClass spc = SparePartsClass(
            sparepart.data['sid'],
            sparepart.data['sName'],
            sparepart.data['surl'],
          );
          setState(() {
            sparepartsList.add(sparepart.data['sName']);
            // print(sparepartsList.length.toString() + "llll");
          });
        });
      });
    });

  }
  void _showButton(bool value) {
    setState(() {
      _show = value;
    });
  }
}
