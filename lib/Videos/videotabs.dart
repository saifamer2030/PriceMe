import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:priceme/Videos/addVideo.dart';
import 'package:priceme/Videos/photosvideo.dart';
import 'package:priceme/Videos/photosvideocomercial.dart';
import 'package:priceme/Videos/photosvideoentertainment.dart';


class VideoTabs extends StatefulWidget {
  @override
  _VideoTabsState createState() => _VideoTabsState();
}

class _VideoTabsState extends State<VideoTabs> with SingleTickerProviderStateMixin {
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
      ),

      backgroundColor: Colors.white,
      resizeToAvoidBottomPadding: false,
      body: TabBarView(
        physics: NeverScrollableScrollPhysics(),
        children: [
          VidiosPhotoEntertainment(),
          VidiosPhotoComercial(),

        ],
        controller: _tabController,
      ),
      appBar: AppBar(
        elevation: 8,
        backgroundColor:  Colors.orange,
        title: Directionality(
          textDirection: TextDirection.rtl,
          child: TabBar(
            unselectedLabelColor: Colors.white,
            labelColor: Colors.amber,
            tabs: [

              new Tab(
                child: Text(
                  "ترفيهي",
                  style: TextStyle(
                      fontSize: 14,
                     // fontFamily: MyFonts.fontFamily,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
              new Tab(
                child: Text(
                  "تجاري",
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
    );
  }



}
