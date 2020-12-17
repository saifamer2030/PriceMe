import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:priceme/Videos/videotabs1.dart';
import 'package:priceme/adminscreens/faultsadmin.dart';
import 'package:priceme/adminscreens/sparepartsadmin.dart';
import 'package:priceme/screens/MorePriceMe.dart';
import 'package:priceme/screens/ProfileAdv.dart';
import 'package:priceme/screens/addadv.dart';
import 'package:priceme/screens/addoffer.dart';
import 'package:priceme/screens/addrent.dart';
import 'package:priceme/screens/advertismenttabs.dart';
import 'package:priceme/screens/alladvertisement.dart';
import 'package:priceme/screens/alloffers.dart';
import 'package:priceme/screens/allrents.dart';
import 'package:priceme/screens/homepage.dart';
import 'package:priceme/screens/myadvertisement.dart';
import 'package:priceme/screens/myalarms.dart';
import 'package:priceme/screens/myoffers.dart';
import 'package:priceme/screens/myrents.dart';
import 'file:///F:/android%20train/applications/1%20a%20flutter%20projects/priceme/priceMe20201010/PriceMe/lib/Videos/collapsing_tab.dart';

class FragmentNavigationAdmin extends StatefulWidget {
  FragmentNavigationAdmin();

  @override
  _FragmentNavigationAdminState createState() => _FragmentNavigationAdminState();
}

class _FragmentNavigationAdminState extends State<FragmentNavigationAdmin> {
  // Properties & Variables needed
  // List<String> subfaultsList = [];
  // List<ModelClass> faultsList = [];
  // List<String> sparepartsList = [];

  int _currentIndex = 0; // to keep track of active tab index
//  List<Widget> _children() => [

  final List<Widget> _screens = [
    MorePriceMe(),
    SparePartsAdmin(),
    FaultsAdmin(),
    CollapsingTab(),
    AdvertismentTabs(),
      ]; // to store nested tabs
  final PageStorageBucket bucket = PageStorageBucket();
  final GlobalKey<NavigatorState> navigatorKey =
      new GlobalKey<NavigatorState>();
  Widget currentScreen; // Our first view in viewport
  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    // final List<Widget> children = screens( );

    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        showUnselectedLabels: true,
        items: [
          BottomNavigationBarItem(
              icon: Icon(
                Icons.settings,
              ),
              title: Text(
                "الاعدادات",
                style: TextStyle(
                    fontSize: 12,
                    //fontFamily: MyFonts.fontFamily,
                    fontWeight: FontWeight.bold),
              )),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.car_rental,
              ),
              title: Text(
                "القطع",
                style: TextStyle(
                    fontSize: 12,
                    //fontFamily: MyFonts.fontFamily,
                    fontWeight: FontWeight.bold),
              )),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.car_repair,
              ),
              title: Text(
                "الاعطال",
                style: TextStyle(
                    fontSize: 12,
                    //fontFamily: MyFonts.fontFamily,
                    fontWeight: FontWeight.bold),
              )),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.video_library,
              ),
              title: Text(
                "الفيديوهات",
                style: TextStyle(
                    fontSize: 12,
                    //fontFamily: MyFonts.fontFamily,
                    fontWeight: FontWeight.bold),
              )),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.history,
              ),
              title: Text(
                "الطلبات",
                style: TextStyle(
                    fontSize: 12,
                    //fontFamily: MyFonts.fontFamily,
                    fontWeight: FontWeight.bold),
              )),
        ],
        currentIndex: _currentIndex,
        onTap: (int index) => _onItemTapped(index),
        type: BottomNavigationBarType.fixed,
        fixedColor:  const Color(0xff15494A),
        unselectedItemColor: Colors.grey,
      ),


    );
  }
  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}
