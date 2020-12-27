import 'package:flutter/material.dart';
import 'package:priceme/UserRating/UserRatingPage.dart';
import 'package:priceme/Videos/addVideo.dart';
import 'package:priceme/screens/addadv.dart';
import 'package:priceme/screens/advdetail.dart';
import 'package:priceme/screens/homepage.dart';
import 'package:priceme/screens/myadvertisement.dart';
import 'package:priceme/screens/personalpage.dart';
import 'package:priceme/trader/Fragmenttrader.dart';
import 'package:priceme/trader/Logintrader.dart';
import 'package:priceme/trader/signuptrader.dart';
import 'package:priceme/ui_utile/myFonts.dart';

import 'Splash.dart';
import 'adminscreens/FragmentNavigationadmin.dart';
import 'adminscreens/faultsadmin.dart';
import 'adminscreens/sparepartsadmin.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PriceMe',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: MyFonts.primaryFont
      ),
      home: //Logintrader(),
      Splash(),
      //FragmentTrader()

      // FragmentNavigationAdmin(),//SparePartsAdmin(),//UserRatingPage("6XQuwAo5xPY40LqdnAqL5zqcc1v1"),Splash(),
    );
  }
}


