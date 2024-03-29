import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:priceme/ChatRoom/widget/home.dart';
import 'package:priceme/Videos/allvideos.dart';
import 'package:priceme/Videos/photosvideocomercial1.dart';
import 'package:priceme/Videos/videotabs1.dart';
import 'package:priceme/classes/ModelClass.dart';
import 'package:priceme/classes/SparePartsClass.dart';
import 'package:priceme/screens/MorePriceMe.dart';
import 'package:priceme/screens/addRequestPage.dart';
import 'package:priceme/screens/addadv.dart';
import 'package:priceme/screens/advertisements.dart';
import 'package:priceme/screens/alladvertisement.dart';
import 'package:priceme/screens/blockscreen.dart';
import 'package:priceme/screens/homepage.dart';
import 'package:priceme/screens/marketPage.dart';
import 'package:priceme/screens/myadvertisement.dart';
import 'package:priceme/screens/myalarms.dart';
import 'package:priceme/Videos/collapsing_tab.dart';
import 'package:priceme/ui_utile/myColors.dart';
//import 'file:///F:/android%20train/applications/1%20a%20flutter%20projects/priceme/priceMe20201010/PriceMe/lib/Videos/collapsing_tab.dart';

class FragmentTrader extends StatefulWidget {

  FragmentTrader();

  @override
  _FragmentTraderState createState() => _FragmentTraderState();
}

class _FragmentTraderState extends State<FragmentTrader> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  String token;
  // Properties & Variables needed
  // List<String> subfaultsList = [];
  // List<ModelClass> faultsList = [];
  // List<String> sparepartsList = [];
  String _userId;
  int _currentIndex=2;

  int currentTab = 4; // to keep track of active tab index
//  List<Widget> _children() => [

  final List<Widget> _screens = [
    MorePriceMe(),
   // MyAlarms(),
    HomeScreen(),
   // Advertisements(),
    MarketPage(),
    Advertisements(),
    AddRequestPage()
      ]; // to store nested tabs
  final PageStorageBucket bucket = PageStorageBucket();
  final GlobalKey<NavigatorState> navigatorKey =
      new GlobalKey<NavigatorState>();
  Widget currentScreen; // Our first view in viewport
  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.currentUser().then((user) => user == null
        ? setState(() {})
        : setState(() {
      _userId = user.uid;
      _firebaseMessaging.getToken().then((value) {
        setState(() {
          token = value;
          Firestore.instance
              .collection('users')
              .document(_userId)
              .updateData({
            "token": token,

          });
        });
      });
      var userQuery = Firestore.instance
          .collection('users')
          .where('uid', isEqualTo: _userId)
          .limit(1);
      userQuery.getDocuments().then((data) {
        if (data.documents.length > 0) {
          setState(() {
          bool  block = data.documents[0].data['block'];

            if( data.documents[0].data['block']==null){block=false;}
            else if(block==true){
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => BlockScreen()));
            }else {}


          });
        }
      });

    }));
  }

  @override
  Widget build(BuildContext context) {
    // final List<Widget> children = screens( );

    return SafeArea(
          child: Scaffold(
        body: _screens[_currentIndex],

        // PageStorage(
        //   child: currentScreen,
        //   bucket: bucket,
        // ),
        // key: navigatorKey,
        // floatingActionButton: MyFloatingButton(sparepartsList),
        //
        // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: BottomNavigationBar(
          showUnselectedLabels: true,
          items: [
            BottomNavigationBarItem(
                icon: Icon(
                 Icons.more_vert,
                ),
                title: Text(
                  "المزيد",
                  style: TextStyle(
                      fontSize: 12,
                      //fontFamily: MyFonts.fontFamily,
                      fontWeight: FontWeight.bold),
                )),
            BottomNavigationBarItem(
                icon:   Stack(children: <Widget>[
                Icon(
                  Icons.chat
                ),
                 Positioned(
                    // draw a red marble
                    top: 0,
                    right: 0,
                    child: Container(
                        height: 11,
                        width: 11,
                       
                        decoration: BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child:  Center(
                               child: Text(
                                "2",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    
                                    color: Colors.white,
                                    fontSize: 7,
                                    fontWeight: FontWeight.bold,
                                   ),
                              ))
                           ))
              ]),
                title: Text(
                  "المحادثة",
                  style: TextStyle(
                      fontSize: 12,
                      //fontFamily: MyFonts.fontFamily,
                      fontWeight: FontWeight.bold),
                )),

            BottomNavigationBarItem(
                icon: Icon(
                  Icons.shopping_cart,
                ),
                title: Text(
                  "التسوق",
                  style: TextStyle(
                      fontSize: 12,
                      //fontFamily: MyFonts.fontFamily,
                      fontWeight: FontWeight.bold),
                )),

            BottomNavigationBarItem(
                icon: Icon(
                   Icons.list_alt,
                ),
                title: Text(
                  "الطلبات",
                  style: TextStyle(
                      fontSize: 12,

                      fontWeight: FontWeight.bold),
                )),

            BottomNavigationBarItem(
                icon: Icon(
                    Icons.add_box
                  ),
                title: Text(
                  "أطلب",
                  style: TextStyle(
                      fontSize: 12,
                      //fontFamily: MyFonts.fontFamily,
                      fontWeight: FontWeight.bold),
                )),
          ],
          currentIndex: _currentIndex,
          onTap: (int index) => _onItemTapped(index),
          type: BottomNavigationBarType.fixed,
       //   fixedColor:  const Color(0xff15494A),
         fixedColor: MyColors.primaryColor,
          unselectedItemColor: Colors.grey,
        ),



        // BottomAppBar(
        //   shape: CircularNotchedRectangle(),
        //   notchMargin: 10,
        //   child: Container(
        //     height: 60,
        //     child: Row(
        //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //       children: <Widget>[
        //         Row(
        //           crossAxisAlignment: CrossAxisAlignment.start,
        //           children: <Widget>[
        //             MaterialButton(
        //               minWidth: 40,
        //               onPressed: () {
        //                 print("kkkkkkkkk");
        //                 setState(() {
        //                   currentScreen = MorePriceMe(); // if user taps on this dashboard tab will be active
        //                   currentTab = 0;
        //                 });
        //               },
        //               child: Column(
        //                 mainAxisAlignment: MainAxisAlignment.center,
        //                 children: <Widget>[
        //                   Icon(
        //                     Icons.account_circle,
        //                     color: currentTab == 0
        //                         ? const Color(0xff15494A)
        //                         : Colors.grey,
        //                   ),
        //                   Text(
        //                     'حسابي',
        //                     style: TextStyle(
        //                       color: currentTab == 0
        //                           ? const Color(0xff15494A)
        //                           : Colors.grey,
        //                     ),
        //                   ),
        //                 ],
        //               ),
        //             ),
        //             MaterialButton(
        //               minWidth: 40,
        //               onPressed: () {
        //                 setState(() {
        //                   currentScreen = MyAlarms(); // if user taps on this dashboard tab will be active
        //                   currentTab = 2;
        //                 });
        //               },
        //               child: Column(
        //                 mainAxisAlignment: MainAxisAlignment.center,
        //                 children: <Widget>[
        //                   Icon(
        //                     Icons.notifications_active,
        //                     color: currentTab == 2
        //                         ? const Color(0xff15494A)
        //                         : Colors.grey,
        //                   ),
        //                   Text(
        //                     'التنبيهات',
        //                     style: TextStyle(
        //                       color: currentTab == 2
        //                           ?  const Color(0xff15494A)
        //                           : Colors.grey,
        //                     ),
        //                   ),
        //                 ],
        //               ),
        //             ),
        //           ],
        //         ),
        //
        //         // Right Tab bar icons
        //
        //         Row(
        //           crossAxisAlignment: CrossAxisAlignment.start,
        //           children: <Widget>[
        //             MaterialButton(
        //               minWidth: 40,
        //               onPressed: () {
        //                 setState(() {
        //                   currentScreen = CollapsingTab(); // if user taps on this dashboard tab will be active
        //                   currentTab = 1;
        //                 });
        //               },
        //               child: Column(
        //                 mainAxisAlignment: MainAxisAlignment.center,
        //                 children: <Widget>[
        //                   Icon(
        //                     Icons.video_library,
        //                     color: currentTab == 1
        //                         ?  const Color(0xff15494A)
        //                         : Colors.grey,
        //                   ),
        //                   Text(
        //                     'الفيديوهات',
        //                     style: TextStyle(
        //                       color: currentTab == 1
        //                           ?  const Color(0xff15494A)
        //                           : Colors.grey,
        //                     ),
        //                   ),
        //                 ],
        //               ),
        //             ),
        //             MaterialButton(
        //               minWidth: 40,
        //               onPressed: () {
        //                 setState(() {
        //                   currentScreen = AllAdvertisement(); // if user taps on this dashboard tab will be active
        //                   currentTab = 3;
        //                 });
        //               },
        //               child: Column(
        //                 mainAxisAlignment: MainAxisAlignment.center,
        //                 children: <Widget>[
        //                   Icon(
        //                     Icons.home,
        //                     color: currentTab == 3
        //                         ?  const Color(0xff15494A)
        //                         : Colors.grey,
        //                   ),
        //                   Text(
        //                     'الرئيسية',
        //                     style: TextStyle(
        //                       color: currentTab == 3
        //                           ?  const Color(0xff15494A)
        //                           : Colors.grey,
        //                     ),
        //                   ),
        //                 ],
        //               ),
        //             )
        //           ],
        //         )
        //       ],
        //     ),
        //   ),
        // ),
      ),
    );
  }
  // void getData() {
  //   setState(() {
  //     final SparePartsReference = Firestore.instance;
  //     SparePartsReference.collection("spareparts")
  //         .getDocuments()
  //         .then((QuerySnapshot snapshot) {
  //       snapshot.documents.forEach((sparepart) {
  //         SparePartsClass spc = SparePartsClass(
  //           sparepart.data['sid'],
  //           sparepart.data['sName'],
  //           sparepart.data['surl'],
  //           const Color(0xff8C8C96),
  //           false,
  //         );
  //         setState(() {
  //           sparepartsList.add(sparepart.data['sName']);
  //           // print(sparepartsList.length.toString() + "llll");
  //         });
  //       });
  //     });
  //   });
  //
  // }
  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}

class MyFloatingButton extends StatefulWidget {

  List<String> sparepartsList;
  MyFloatingButton(this.sparepartsList);
  @override
  _MyFloatingButtonState createState() => _MyFloatingButtonState();
}

class _MyFloatingButtonState extends State<MyFloatingButton> {
  bool _show = true;

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
                      builder: (context) => AddAdv("","","")));
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
  // void getData() {
  //   setState(() {
  //     final SparePartsReference = Firestore.instance;
  //     SparePartsReference.collection("spareparts")
  //         .getDocuments()
  //         .then((QuerySnapshot snapshot) {
  //       snapshot.documents.forEach((sparepart) {
  //         SparePartsClass spc = SparePartsClass(
  //           sparepart.data['sid'],
  //           sparepart.data['sName'],
  //           sparepart.data['surl'],
  //         );
  //         setState(() {
  //           sparepartsList.add(sparepart.data['sName']);
  //           // print(sparepartsList.length.toString() + "llll");
  //         });
  //       });
  //     });
  //   });
  //
  // }
  void _showButton(bool value) {
    setState(() {
      _show = value;
    });
  }
}
