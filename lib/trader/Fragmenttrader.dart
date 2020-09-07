import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:priceme/classes/ModelClass.dart';
import 'package:priceme/classes/SparePartsClass.dart';
import 'package:priceme/screens/MorePriceMe.dart';
import 'package:priceme/screens/addadv.dart';
import 'package:priceme/screens/alladvertisement.dart';
import 'package:priceme/screens/homepage.dart';
import 'package:priceme/screens/hometest.dart';
import 'package:priceme/screens/myadvertisement.dart';

class FragmentTrader extends StatefulWidget {

  FragmentTrader();

  @override
  _FragmentTraderState createState() => _FragmentTraderState();
}

class _FragmentTraderState extends State<FragmentTrader> {
  // Properties & Variables needed
  List<String> subfaultsList = [];
  List<ModelClass> faultsList = [];
  List<String> sparepartsList = [];

  int currentTab = 3; // to keep track of active tab index
//  List<Widget> _children() => [

  List<Widget> screens() => [
    MorePriceMe(),
    MyAdvertisement(),
    MyAdvertisement(),
    AllAdvertisement(),
      ]; // to store nested tabs
  final PageStorageBucket bucket = PageStorageBucket();
  final GlobalKey<NavigatorState> navigatorKey =
      new GlobalKey<NavigatorState>();
  Widget currentScreen; // Our first view in viewport
  @override
  void initState() {
    super.initState();
    getData();
    setState(() {
      currentScreen = AllAdvertisement();
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
      floatingActionButton: MyFloatingButton(sparepartsList),

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
                        currentScreen = MorePriceMe(); // if user taps on this dashboard tab will be active
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
                        currentScreen = MyAdvertisement(); // if user taps on this dashboard tab will be active
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
                        currentScreen = AllAdvertisement(); // if user taps on this dashboard tab will be active
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
                        currentScreen = AllAdvertisement(); // if user taps on this dashboard tab will be active
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
                      builder: (context) => AddAdv(widget.sparepartsList,"قطع غيار","", widget.sparepartsList[0])));
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