import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:priceme/Videos/addVideo.dart';
import 'package:priceme/Videos/photosvideocomercial.dart';
import 'package:priceme/Videos/photosvideoentertainment.dart';
import 'package:priceme/screens/advertisements.dart';
import 'package:priceme/screens/myadvertisement.dart';


class AdvertismentTabs extends StatefulWidget {
  @override
  _AdvertismentTabsState createState() => _AdvertismentTabsState();
}

class _AdvertismentTabsState extends State<AdvertismentTabs> with SingleTickerProviderStateMixin {
  TabController _tabController;
  PageController _pageController;


  @override
  void initState() {
    _tabController = new TabController(length: 2, vsync: this);
    super.initState();
    _pageController = PageController(
      initialPage: 0,
    );
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton:  FloatingActionButton(
        heroTag: "uniqu03",
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
                  builder: (context) => AddVideo()));

        },
      ),

      backgroundColor: Colors.white,
      resizeToAvoidBottomPadding: false,
      body: TabBarView(
        physics: NeverScrollableScrollPhysics(),
        children: [
          Advertisements(),
          MyAdvertisement(),

        ],
        controller: _tabController,
      ),
      appBar: AppBar(
        leading: new Container(),
        elevation: 8,
        flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: <Color>[
                    const Color(0xffff2121),
                    const Color(0xffff5423),
                    const Color(0xffff7024),
                    const Color(0xffff904a),
                  ])
          ),
        ),
        title: Directionality(
          textDirection: TextDirection.rtl,
          child: TabBar(
            unselectedLabelColor: Colors.black,
            labelColor: Colors.amber,
            tabs: [

              new Tab(
                child: Text(
                  "الطلبات",
                  style: TextStyle(
                      fontSize: 14,
                     // fontFamily: MyFonts.fontFamily,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ),
              new Tab(
                child: Text(
                  "تسعيراتى",
                  style: TextStyle(
                      fontSize: 14,
                      //fontFamily: MyFonts.fontFamily,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ),
            ],
            controller: _tabController,
            indicatorColor: Colors.black,
            indicatorSize: TabBarIndicatorSize.tab,
          ),
        ),
      ),
    );
  }



}
