import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:priceme/ChatRoom/widget/home.dart';
import 'package:priceme/Videos/videotabs1.dart';
import 'package:priceme/screens/MorePriceMe.dart';
import 'package:priceme/screens/ProfileAdv.dart';
import 'package:priceme/screens/addRequestPage.dart';
import 'package:priceme/screens/addadv.dart';
import 'package:priceme/screens/addoffer.dart';
import 'package:priceme/screens/addrent.dart';
import 'package:priceme/screens/advertisements.dart';
import 'package:priceme/screens/advertismenttabs.dart';
import 'package:priceme/screens/alladvertisement.dart';
import 'package:priceme/screens/alloffers.dart';
import 'package:priceme/screens/allrents.dart';
import 'package:priceme/screens/blockscreen.dart';
import 'package:priceme/screens/homepage.dart';
import 'package:priceme/screens/marketPage.dart';
import 'package:priceme/screens/myadvertisement.dart';
import 'package:priceme/screens/myalarms.dart';
import 'package:priceme/screens/myoffers.dart';
import 'package:priceme/screens/myrents.dart';
import 'package:priceme/Videos/collapsing_tab.dart';
import 'package:priceme/ui_utile/myColors.dart';
//import 'file:///F:/android%20train/applications/1%20a%20flutter%20projects/priceme/priceMe20201010/PriceMe/lib/Videos/collapsing_tab.dart';

import 'Videos/allvideos.dart';
import 'Videos/photosvideocomercial1.dart';
import 'classes/ModelClass.dart';
import 'classes/SparePartsClass.dart';

class FragmentPriceMe extends StatefulWidget {
  FragmentPriceMe();

  @override
  _FragmentPriceMeState createState() => _FragmentPriceMeState();
}

class _FragmentPriceMeState extends State<FragmentPriceMe> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  String token;
  int _currentIndex = 3; // to keep track of active tab index
//  List<Widget> _children() => [
  String _userId;bool block=false;
  final List<Widget> _screens = [
    MorePriceMe(),
    //MyAlarms(),
    HomeScreen(),
   // HomePage(),
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
      print("kkkk1$block$_userId");
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
        print("token: $token");
      });
      var userQuery = Firestore.instance
          .collection('users')
          .where('uid', isEqualTo:  user.uid)
          .limit(1);
      userQuery.getDocuments().then((data) {
        print("kkkk2${data.documents.length}$_userId");

        if (data.documents.length > 0) {
          setState(() {
            block = data.documents[0].data['block'];
            print("kkkk$block$_userId");
            if(block==null){block=false;}
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
                      
                      fontWeight: FontWeight.bold),
                )),
            BottomNavigationBarItem(
                icon: 
                Stack(children: <Widget>[
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
                      //fontFamily: MyFonts.fontFamily,
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
          fixedColor: MyColors.primaryColor,
          //const Color(0xff15494A),
          unselectedItemColor: Colors.grey,
        ),

        // BottomAppBar(
        //   shape: CircularNotchedRectangle(),
        //   notchMargin: 10,
        //   child: Container(
        //     height: 68,
        //     child: Row(
        //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //       children: <Widget>[
        //         Container(
        //           width: MediaQuery.of(context).size.width/5,
        //           child: MaterialButton(
        //             minWidth: 40,
        //             onPressed: () {
        //               print("kkkkkkkkk");
        //               setState(() {
        //                 currentScreen =
        //                     MorePriceMe(); // if user taps on this dashboard tab will be active
        //                 currentTab = 0;
        //               });
        //             },
        //             child: Column(
        //               mainAxisAlignment: MainAxisAlignment.center,
        //               children: <Widget>[
        //                 Icon(
        //                   Icons.settings,
        //                   color: currentTab == 0
        //                       ? const Color(0xff15494A)
        //                       : Colors.grey,
        //                 ),
        //                 Text(
        //                   'إعدادات',
        //                   style: TextStyle(
        //                     // fontSize: 10,
        //                     color: currentTab == 0
        //                         ? const Color(0xff15494A)
        //                         : Colors.grey,
        //                   ),
        //                 ),
        //               ],
        //             ),
        //           ),
        //         ),
        //         Container(
        //           width: MediaQuery.of(context).size.width/5,
        //           child: MaterialButton(
        //             minWidth: 40,
        //             onPressed: () {
        //               setState(() {
        //                 currentScreen =
        //                     MyAlarms(); // if user taps on this dashboard tab will be active
        //                 currentTab = 1;
        //               });
        //             },
        //             child: Column(
        //               mainAxisAlignment: MainAxisAlignment.center,
        //               children: <Widget>[
        //                 Icon(
        //                   Icons.notifications_active,
        //                   color: currentTab == 1
        //                       ? const Color(0xff15494A)
        //                       : Colors.grey,
        //                 ),
        //                 Text(
        //                   'التنبيهات',
        //                   style: TextStyle(
        //                     // fontSize: 10,
        //                     color: currentTab == 1
        //                         ? const Color(0xff15494A)
        //                         : Colors.grey,
        //                   ),
        //                 ),
        //               ],
        //             ),
        //           ),
        //         ),
        //         Container(
        //           width: MediaQuery.of(context).size.width/5,
        //           child: MaterialButton(
        //             minWidth: 40,
        //             onPressed: () {
        //               print("kkkkkkkkk");
        //               setState(() {
        //                 currentScreen =
        //                     HomePage(); // if user taps on this dashboard tab will be active
        //                 currentTab = 2;
        //               });
        //             },
        //             child: Column(
        //               mainAxisAlignment: MainAxisAlignment.center,
        //               children: <Widget>[
        //                 Icon(
        //                   Icons.home,
        //                   color: currentTab == 2
        //                       ? const Color(0xff15494A)
        //                       : Colors.grey,
        //                 ),
        //                 Text(
        //                   'الرئيسية',
        //                   style: TextStyle(
        //                     // fontSize: 10,
        //                     color: currentTab == 2
        //                         ? const Color(0xff15494A)
        //                         : Colors.grey,
        //                   ),
        //                 ),
        //               ],
        //             ),
        //           ),
        //         ),
        //         Container(
        //           width: MediaQuery.of(context).size.width/5,
        //           child: MaterialButton(
        //             minWidth: 40,
        //             onPressed: () {
        //               setState(() {
        //                 currentScreen =
        //                     CollapsingTab(); // if user taps on this dashboard tab will be active
        //                 currentTab = 3;
        //               });
        //             },
        //             child: Column(
        //               mainAxisAlignment: MainAxisAlignment.center,
        //               children: <Widget>[
        //                 Icon(
        //                   Icons.video_library,
        //                   color: currentTab == 3
        //                       ? const Color(0xff15494A)
        //                       : Colors.grey,
        //                 ),
        //                 Text(
        //                   'الفيديوهات',
        //                   style: TextStyle(
        //                     // fontSize: 10,
        //                     color: currentTab == 3
        //                         ? const Color(0xff15494A)
        //                         : Colors.grey,
        //                   ),
        //                 ),
        //               ],
        //             ),
        //           ),
        //         ),
        //         Container(
        //           width: MediaQuery.of(context).size.width/5,
        //           child: MaterialButton(
        //             minWidth: 40,
        //             onPressed: () {
        //               setState(() {
        //                 currentScreen =  AdvertismentTabs();    /*HomePage()*/ // if user taps on this dashboard tab will be active
        //                 currentTab = 4;
        //               });
        //             },
        //             child: Column(
        //               mainAxisAlignment: MainAxisAlignment.center,
        //               children: <Widget>[
        //                 Icon(
        //                   Icons.history,
        //                   color: currentTab == 4
        //                       ? const Color(0xff15494A)
        //                       : Colors.grey,
        //                 ),
        //                 Text(
        //                   'الطلبات',
        //                   style: TextStyle(
        //                     // fontSize: 10,
        //                     color: currentTab ==4
        //                         ? const Color(0xff15494A)
        //                         : Colors.grey,
        //                   ),
        //                 ),
        //               ],
        //             ),
        //           ),
        //         )
        //
        //       ],
        //     ),
        //   ),
        // ),
      ),
    );
  }
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
            heroTag: "unique3",
            child: Container(
              width: 60,
              height: 60,
              child: Icon(
                Icons.add,
//                size: 40,
              ),
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xffff2121),
                      const Color(0xffff5423),
                      const Color(0xffff7024),
                      const Color(0xffff904a)
                    ],
                  )),
            ),
            onPressed: () {

              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => HomePage()));
              // Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //         builder: (context) => AddAdv("","","")));
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
//        ? FloatingActionButton(
//
////            child: Icon(Icons.add),
//            heroTag: "unique3",
//            onPressed: () {
//              Navigator.push(
//                  context,
//                  MaterialPageRoute(
//                      builder: (context) => AddAdv(widget.sparepartsList,"قطع غيار","", widget.sparepartsList[0])));
////        FirebaseAuth.instance.currentUser().then((user) => user == null
////            ? Navigator.of(context, rootNavigator: false).push(
////            MaterialPageRoute(
////                builder: (context) => LoginScreen2(widget.regionlist),
////                maintainState: false))
////            : setState(() {
////          var sheetController = showBottomSheet(
////              context: context,
////              builder: (context) =>
////                  BottomSheetWidget(widget.regionlist));
////
////          _showButton(false);
////
////          sheetController.closed.then((value) {
////            _showButton(true);
////          });
////        }));
//            },
//          )
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
