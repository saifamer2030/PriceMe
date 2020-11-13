import 'dart:ui' as prefix0;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:priceme/Videos/allvideos.dart';
import 'package:priceme/Videos/photosvideocomercial.dart';
import 'package:priceme/Videos/photosvideoentertainment.dart';
import 'package:priceme/screens/advertisements.dart';
import 'package:priceme/screens/myadvertisement.dart';




class VideoTabs1 extends StatefulWidget {
  VideoTabs1();
  @override
  _VideoTabs1State createState() => _VideoTabs1State();
}

class _VideoTabs1State extends State<VideoTabs1>  with SingleTickerProviderStateMixin {
  int _currentIndex = 0;  var top = 0.0;
  TabController _tabController;
  PageController _pageController;

  Widget firebasedata(
      BuildContext context, int index, DocumentSnapshot document) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => AllVideos(document['carrange'],null,null)));
        // _onInstagramStorySwipeClicked();
      },
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Stack(
          children: [
            Container(
              height: 200,
              width: 150,
              decoration: BoxDecoration(
                border: new Border.all(
                  color: Colors.black,
                  width: 1,
                ),
                image: document['imgurl'] == null
                    ? DecorationImage(
                  image: AssetImage("assets/images/ic_background.png"),
                  fit: BoxFit.fill,
                )
                    : DecorationImage(
                  image: NetworkImage(document['imgurl']),
                  fit: BoxFit.fill,
                ),
                borderRadius: BorderRadius.circular(9.0),
              ),
            ),
            Positioned(
                top: 90,
                left: 60,
                child: Container(
                  child: Icon(
                    Icons.play_circle_outline,
                    color: Colors.white,
                    size: 35,
                  ),
                )),
            Positioned(
                bottom: 10,
                right: 5,
                child: Container(
                  child: Text( document['ctitle']==null||document['ctitle']==""?"عنوان غير معلوم":document['ctitle']
                    ,style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold),),
                )),
            Positioned(
              top: 5,
              left: 5,
              child: Container(
                height: 50,
                width: 50,
                // child: Text(
                //   sparepartsList[index].sName, style: TextStyle(color: Colors.red,fontSize: 20
                // ),textAlign: TextAlign.center,
                //
                // ),
                decoration: BoxDecoration(
                  border: new Border.all(
                    color: Colors.black,
                    width: 1.0,
                  ),
                  image: DecorationImage(
                    image: NetworkImage(document['cphotourl']==null||document['cphotourl']==""?
                    "https://i.pinimg.com/564x/0c/3b/3a/0c3b3adb1a7530892e55ef36d3be6cb8.jpg"  :document['cphotourl']),
                    fit: BoxFit.fill,
                  ),
                  shape: BoxShape.circle,
                ),
              ),

            ),
          ],
        ),
      ),
    );
  }
  void initState() {
    _tabController = new TabController(length: 2, vsync: this);
    super.initState();
    _pageController = PageController(
      initialPage: 0,
    );
  }

  @override
  Widget build(BuildContext context) {
   // TextStyle textStyle = Theme.of(context).textTheme.subtitle;
    final List<Widget> _children = [
      VidiosPhotoComercial(),
      VidiosPhotoEntertainment(),

    ];

    return  Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                  leading: new Container(),
                  expandedHeight: 250.0,
                  floating: false,
                  pinned: true,
                  flexibleSpace: LayoutBuilder(
                      builder: (BuildContext context, BoxConstraints constraints) {
                        return FlexibleSpaceBar(
                            centerTitle: true,
                            title: Container(
                              height: 20,
                              child: Directionality(
                                textDirection: TextDirection.rtl,
                                child: TabBar(
                                  unselectedLabelColor: Colors.black,
                                  labelColor: Colors.amber,
                                  tabs: [
                                    new Tab(
                                      child: Text(
                                        "ترفيهى",
                                        style: TextStyle(
                                            fontSize: 12,
                                            // fontFamily: MyFonts.fontFamily,
                                          //  fontWeight: FontWeight.bold,
                                            color: Colors.black),
                                      ),
                                    ),
                                    new Tab(
                                      child: Text(
                                        "تجارى",
                                        style: TextStyle(
                                            fontSize: 12,
                                            //fontFamily: MyFonts.fontFamily,
                                           // fontWeight: FontWeight.bold,
                                            color: Colors.black),
                                      ),
                                    ),
                                  ],
                                  controller: _tabController,
                                  indicatorColor: Colors.black,
                                  indicatorSize: TabBarIndicatorSize.tab,
                                ),
                              ),

                              // BottomNavigationBar(
                              //
                              //   fixedColor: Colors.white,
                              //   elevation: 0,
                              //   backgroundColor: Colors.white,
                              //   type: BottomNavigationBarType.fixed,
                              //   onTap: onTabTapped,
                              //   currentIndex: _currentIndex,
                              //   items: [
                              //     BottomNavigationBarItem(
                              //       icon: Icon(Icons.person,color: Colors.black,size: 0,),
                              //       title: Text('تجاري'),
                              //     ),
                              //     BottomNavigationBarItem(
                              //       icon: Icon(Icons.apps,color: Colors.black,size: 0,),
                              //       title: Text('ترفيهي'),
                              //     ),
                              //   ],
                              // ),
                            ),
                            background: Padding(
                              padding: const EdgeInsets.only(top:20.0,bottom:50),
                              child: Container(
                                //color: Colors.white,
                               // height: 100,
                                child: StreamBuilder(
                                  stream: Firestore.instance
                                      .collection('videos')
                                      .orderBy('seens', descending: true)
                                      .limit(5) //.where("cproblemtype", isEqualTo:"قطع غيار")
                                      .snapshots(),
                                  builder: (context, snapshot) {
                                    if (!snapshot.hasData) {
                                      return Center(
                                          child: Text(
                                            "Loading..",
                                          ));
                                    }

                                    return new ListView.builder(
                                        reverse: true,
                                        physics: BouncingScrollPhysics(),
                                        scrollDirection: Axis.horizontal,
                                        shrinkWrap: true,
                                        // controller: _controller,
                                        itemCount: snapshot.data.documents.length,
                                        itemBuilder: (context, index) {
                                          return firebasedata(
                                              context, index, snapshot.data.documents[index]);
                                        });
                                  },
                                ),
                              ),
                            ),
                        );
                      })),
            ];
          },
          body:  TabBarView(
          physics: NeverScrollableScrollPhysics(),
          children: [
            VidiosPhotoEntertainment(),
            VidiosPhotoComercial(),

          ],
          controller: _tabController,
        ),
          // _children[_currentIndex],
        ));


 //      Scaffold(
 //      body:
 //      CustomScrollView(
 //        slivers: <Widget>[
 //          SliverAppBar(
 //            pinned: true,
 //            floating: false,
 //            expandedHeight: 250.0,
 //            flexibleSpace: FlexibleSpaceBar(
 //              title: Container(
 //                width: MediaQuery.of(context).size.width ,
 //                height: 40,
 //              //  color:Color(0xff15494A) ,
 //                child: Center(
 //                  child: BottomNavigationBar(
 //
 // fixedColor: Colors.white,
 //                  elevation: 0,
 //                  backgroundColor: Colors.teal,
 //                    type: BottomNavigationBarType.fixed,
 //                    onTap: onTabTapped,
 //                    currentIndex: _currentIndex,
 //                    items: [
 //                      BottomNavigationBarItem(
 //                        icon: Icon(Icons.person,color: Colors.black,size: 0,),
 //                        title: Text('تجاري'),
 //                      ),
 //                      BottomNavigationBarItem(
 //                        icon: Icon(Icons.apps,color: Colors.black,size: 0,),
 //                        title: Text('ترفيهي'),
 //                      ),
 //                    ],
 //                  ),
 //                ),
 //              ),
 //
 //              background: Column(
 //                children: [
 //                  Padding(
 //                    padding: const EdgeInsets.only(top:20.0),
 //                    child: Container(
 //                      //color: Colors.white,
 //                      height: 180,
 //                      child: StreamBuilder(
 //                        stream: Firestore.instance
 //                            .collection('videos')
 //                            .orderBy('seens', descending: true)
 //                            .limit(5) //.where("cproblemtype", isEqualTo:"قطع غيار")
 //                            .snapshots(),
 //                        builder: (context, snapshot) {
 //                          if (!snapshot.hasData) {
 //                            return Center(
 //                                child: Text(
 //                                  "Loading..",
 //                                ));
 //                          }
 //
 //                          return new ListView.builder(
 //                              reverse: true,
 //                              physics: BouncingScrollPhysics(),
 //                              scrollDirection: Axis.horizontal,
 //                              shrinkWrap: true,
 //                              // controller: _controller,
 //                              itemCount: snapshot.data.documents.length,
 //                              itemBuilder: (context, index) {
 //                                return firebasedata(
 //                                    context, index, snapshot.data.documents[index]);
 //                              });
 //                        },
 //                      ),
 //                    ),
 //                  ),
 //
 //                ],
 //              ),
 //
 //
 //            ),
 //
 //
 //            // leading: Container(
 //            //   height: 210,
 //            //   child: StreamBuilder(
 //            //     stream: Firestore.instance
 //            //         .collection('videos')
 //            //         .orderBy('seens', descending: true)
 //            //         .limit(5) //.where("cproblemtype", isEqualTo:"قطع غيار")
 //            //         .snapshots(),
 //            //     builder: (context, snapshot) {
 //            //       if (!snapshot.hasData) {
 //            //         return Center(
 //            //             child: Text(
 //            //               "Loading..",
 //            //             ));
 //            //       }
 //            //
 //            //       return new ListView.builder(
 //            //           reverse: true,
 //            //           physics: BouncingScrollPhysics(),
 //            //           scrollDirection: Axis.horizontal,
 //            //           shrinkWrap: true,
 //            //           // controller: _controller,
 //            //           itemCount: snapshot.data.documents.length,
 //            //           itemBuilder: (context, index) {
 //            //             return firebasedata(
 //            //                 context, index, snapshot.data.documents[index]);
 //            //           });
 //            //     },
 //            //   ),
 //            // ),
 //
 //          ),
 //        SliverFillRemaining(
 //      child:  _children[_currentIndex],
 //        ),
 //
 //    ],
 //      )  );
  }
  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}
