import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:priceme/Videos/addVideo.dart';
import 'package:priceme/Videos/photosvideocomercial.dart';
import 'package:priceme/Videos/photosvideoentertainment.dart';
import 'package:priceme/classes/SparePartsClass.dart';
import 'package:priceme/screens/advertisements.dart';
import 'package:priceme/screens/myadvertisement.dart';


class AdvertismentTabs extends StatefulWidget {
  @override
  _AdvertismentTabsState createState() => _AdvertismentTabsState();
}

class _AdvertismentTabsState extends State<AdvertismentTabs> with SingleTickerProviderStateMixin {
  TabController _tabController;
  PageController _pageController;
  List<String> mainfaultsList = [];
  List<String> mainsparsList = [];
  String typePressed = "all";

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
            mainsparsList.add(sparepart.data['sName'],);
            // print(sparepartsList.length.toString() + "llll");
          });

        });
      });
    });

  }
  @override
  void initState() {
    super.initState();

    getDatas(); getDataf();
    _tabController = new TabController(length: 2, vsync: this);
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
      backgroundColor: Colors.white,
      resizeToAvoidBottomPadding: false,
      body:
           advertisementsScreen()
/*
      TabBarView(
        physics: NeverScrollableScrollPhysics(),
        children: [
          Advertisements(mainsparsList,mainfaultsList),
          MyAdvertisement(),

        ],
        controller: _tabController,
      ),

*/
/*
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
        title:

        Directionality(
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
                      color: Colors.white),
                ),
              ),
              new Tab(
                child: Text(
                  "طلباتى",
                  style: TextStyle(
                      fontSize: 14,
                      //fontFamily: MyFonts.fontFamily,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
            ],
            controller: _tabController,
            indicatorColor: Colors.white,
            indicatorSize: TabBarIndicatorSize.tab,
          ),
        ),
      ),
*/
    );
  }

  Widget advertisementsScreen(){
    return Column(
      children: [
        SizedBox(
          height: 26,
        ),

        Container(
          height: 30,
          child: Stack(
            children: [

              Align(
                alignment: Alignment.center,
                child: Container(
                  height: 30,
                  width: 160,



                  child: Directionality(
                    textDirection: TextDirection.rtl,
                    child: TabBar(
                      unselectedLabelColor: Colors.grey,
                      labelColor: Colors.deepOrange,
                      tabs: [

                        new Tab(
                          child: Text(
                            " الطلبات ",
                            style: TextStyle(
                              fontSize: 12,
                              // fontFamily: MyFonts.fontFamily,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        new Tab(
                          child: Text(
                            "طلباتى",
                            style: TextStyle(
                              fontSize: 12,
                              //fontFamily: MyFonts.fontFamily,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                      controller: _tabController,
                      indicatorColor: Colors.black,
                      indicatorSize: TabBarIndicatorSize.label,
                    ),
                  ),
                ),
              )

            ],
          ),
        ),

     Expanded(child:
        TabBarView(
          physics: NeverScrollableScrollPhysics(),
          children: [
            Advertisements(),
            MyAdvertisement(),

          ],
          controller: _tabController,
        ) )
        ,

      ],
    );
  }






}
