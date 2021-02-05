import 'dart:io';

import 'package:adobe_xd/gradient_xd_transform.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
//import 'package:intl/intl.dart';

//import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:priceme/ChatRoom/widget/const.dart';
import 'package:priceme/Videos/addVideo.dart';
import 'package:priceme/Videos/allvideos.dart';

import 'package:priceme/classes/FaultsClass.dart';
import 'package:priceme/classes/SparePartsClass.dart';
import 'package:priceme/classes/SparePartsSizesClass.dart';
import 'package:priceme/screens/homestory.dart';
import 'package:priceme/ui_utile/myColors.dart';
import 'package:priceme/ui_utile/myFonts.dart';
import 'package:shimmer/shimmer.dart';
import 'package:toast/toast.dart';
import 'package:firebase_core/firebase_core.dart';
import 'addadv.dart';

class HomePage extends StatefulWidget {
  //List<String> sparepartsList;
  HomePage();

  @override
  _HomePageState createState() => _HomePageState();
}

//db ref
final fcmReference = FirebaseDatabase.instance.reference().child('Fcm-Token');

class _HomePageState extends State<HomePage> {
  var _videosListController = ScrollController();
  var _faultListController = ScrollController();
  var _sparePartsController = ScrollController();
  String tapedButton = "spareParts";

  //bool faultButtonTapped = true;
  List<SparePartsSizesClass> sparepartsList = [];
  List<SparePartsSizesClass> faultsList = [];
  List<FaultsClass> subfaultsList = [];
  List<FaultsClass> subsparesList = [];

  bool subfaultcheck = false;
  bool subsparescheck = false;
  bool faultcheck = false;
  bool sparescheck = false;
  String mfault = "";
  double sparesize = 100;
  double faultsize = 100;
  double s_f_size = 20;
  double f_f_size = 20;
  int _index = 0;

  bool select_r_c = false;
  String _tempDir;
  String filePath;

  int currentPage_spare = 3;
  int currentPage_fault = 3;
  PageController _pageController_spare;
  PageController _pageController_fault;

  @override
  void initState() {

    _pageController_spare =
        PageController(viewportFraction: 0.3, initialPage: currentPage_spare);
    _pageController_fault =
        PageController(viewportFraction: 0.3, initialPage: currentPage_fault);
    _pageController_spare.addListener(() {
      setState(() {
        currentPage_spare = int.parse(_pageController_spare.page.toStringAsFixed(
            0)); //int.parse( _pageController_spare.page.toStringAsFixed(0));
        //  print("gggg${_pageController_spare.page}");
      });
    });
    _pageController_fault.addListener(() {
      setState(() {
        currentPage_fault =
            int.parse(_pageController_fault.page.toStringAsFixed(0));
      });
    });
    super.initState();

    getSparepartsData();
    getfaultsData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget firebasedata(
      BuildContext context, int index, DocumentSnapshot document) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    AllVideos(document['carrange'], null, null)));
        // _onInstagramStorySwipeClicked();
      },
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Container(
          width: 150,
          height: 150,
//                              decoration: BoxDecoration(
//                                border: new Border.all(
//                                  color: Colors.black,
//                                  width: 1.0,
//                                ),
//                                shape: BoxShape.circle,
//                              ),
          child: Column(
            children: [
              Container(
                height: 160,
                width: 160,
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
                    image: document['imgurl'] == null
                        ? AssetImage("assets/images/ic_background.png")
                        : NetworkImage(document['imgurl']),
                    fit: BoxFit.fill,
                  ),
                  shape: BoxShape.circle,
                ),
              ),
              Expanded(
                child: Text(
                  document['ctitle'] == null
                      ? "بدون عنوان"
                      : document['ctitle'],
                  style: TextStyle(color: Colors.red, fontSize: 15),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),

    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
        // appBar: AppBar(
        // title: const Text('AppBar Demo'),),
        backgroundColor: const Color(0xffffffff),
        body: homeScreen()



        );
  }

  Widget homeScreen() {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
        colors: [
          MyColors.darkPrimaryColor,
          MyColors.primaryColor,
          MyColors.lightPrimaryColor,
        ],
        // stops: [0.1, 0.8,0.6],
      )),
      child: ListView(
        shrinkWrap: true,
        children: [
          SizedBox(
            height: 20,
          ),
          Container(
            margin: EdgeInsets.only(right: 10),
            height: 222,
            child: StreamBuilder(
              stream: Firestore.instance
                  .collection('videos')
                  .orderBy('seens', descending: true)
                  .limit(8) //.where("cproblemtype", isEqualTo:"قطع غيار")
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                      child: Text(
                        "لا يوجد بيانات...",
                      ));
                }

                return Directionality(
                    textDirection: TextDirection.rtl,
                    child: ListView.builder(
                        //reverse: true,

                        physics: BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        // controller: _controller,
                        itemCount: snapshot.data.documents.length,
                        itemBuilder: (context, index) {
                          return videoItemWidget(
                              context, index, snapshot.data.documents[index]);
                        }));
              },
            ),
          ),
          SizedBox(
            height: 10,
          ),
         Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(32),
                      topRight: Radius.circular(32))),
              child: Column(
                children: [
                  SizedBox(height: 20),
                  Container(
                    height: 50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      textDirection: TextDirection.rtl,
                      children: [
                        SizedBox(
                          width: 20,
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              //   faultButtonTapped = false;
                              tapedButton = "spareParts";
                            });
                          },
                          child: Card(
                              elevation: 8,
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(8)),
                              ),
                              child: Container(
                                height: 40,
                                width: 100,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    gradient: tapedButton == "spareParts"
                                        ? LinearGradient(
                                            begin: Alignment.topRight,
                                            end: Alignment.bottomLeft,
                                            colors: [
                                              MyColors.darkPrimaryColor,
                                              MyColors.primaryColor,
                                              MyColors.lightPrimaryColor,
                                            ],
                                            // stops: [0.1, 0.8,0.6],
                                          )
                                        : null,
                                    color: tapedButton == "spareParts"
                                        ? null
                                        : const Color(0xffbfc3c3)),
                                child: Center(
                                    child: Text("قطع الغيار",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: MyFonts.primaryFont))),
                              )),
                        ),
                        SizedBox(
                          width: 8,
                        ),
                       InkWell(
                          onTap: () {
                            setState(() {
                              //faultButtonTapped = true;
                              tapedButton = "faults";
                            });
                          },
                          child: Card(
                              elevation: 8,
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(8)),
                              ),
                              child: Container(
                                height: 40,
                                width: 100,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    gradient: tapedButton == "faults"
                                        ? LinearGradient(
                                            begin: Alignment.topRight,
                                            end: Alignment.bottomLeft,
                                            colors: [
                                              MyColors.darkPrimaryColor,
                                              MyColors.primaryColor,
                                              MyColors.lightPrimaryColor,
                                            ],
                                            // stops: [0.1, 0.8,0.6],
                                          )
                                        : null,
                                    color: tapedButton == "faults"
                                        ? null
                                        : const Color(0xffbfc3c3)),
                                child: Center(
                                    child: Text("الأعطال",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: MyFonts.primaryFont))),
                              )),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                    height: 150,
                    margin: EdgeInsets.only(right: 10),
                    child: sparepartsList.length == 0
                        ? categoriesLoadingWidget()
                        : //// display loading screen while loading data
                        Directionality(
                          textDirection: TextDirection.rtl,
                          child: ListView.builder(
                              physics: BouncingScrollPhysics(),
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              itemCount: tapedButton == "spareParts"
                                  ? sparepartsList.length
                                  : faultsList.length,
                              controller: tapedButton == "spareParts"
                                  ? _sparePartsController
                                  : _faultListController,
                              itemBuilder: (context, index) {
                                return categoryItem(index);
                              }),
                        )

                  )
                ],
              ),
            ),

        ],
      ),
    );
  }

  Widget videoItemWidget(
      BuildContext context, int index, DocumentSnapshot document) {
    return InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      HomeStory(document['seens'])));

          // Navigator.push(
          //     context,
          //     MaterialPageRoute(
          //         builder: (context) =>
          //             AllVideos(document['carrange'], null, null)));
        },
        child: Container(
            height: 210,
            width: 110,
            child: Column(
              children: [
                Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                      borderRadius: const BorderRadius.all(Radius.circular(18)),
                      side: BorderSide(color: Colors.grey[400], width: 1)),
                  child: Container(
                      height: 170,
                      width: 110,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18),
                        color: Colors.grey[400]

                      ),
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(18),
                          child:
                          document['imgurl'] == null
                              ? AssetImage(
                                  "assets/images/ic_background.png",
                                )
                              :
                          CachedNetworkImage(
                            placeholder: (context, url) => Container(
                              child: Image.asset(
                                "assets/images/ic_logo2.png",
                                width: 250.0,
                                height: 350.0,
                                fit: BoxFit.contain,color: Colors.orange,
                              ),
                              width:100.0,
                              height: 100.0,
                              padding: EdgeInsets.all(70.0),
                              decoration: BoxDecoration(
                                color: greyColor2,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(8.0),
                                ),
                              ),
                            ),
                            errorWidget: (context, url, error) => Material(
                              child: Image.asset(
                                "assets/images/ic_logo2.png",
                                width: 200.0,
                                height: 200.0,
                                fit: BoxFit.cover,color: Colors.orange,
                              ),
                              borderRadius: BorderRadius.all(
                                Radius.circular(8.0),
                              ),
                              clipBehavior: Clip.hardEdge,
                            ),
                            imageUrl:  document['imgurl'] ,
                            width: 250.0,
                            height: 350.0,
                            fit: BoxFit.cover,
                          ),
                          // Image.network(
                          //         document['imgurl'],
                          //         fit: BoxFit.cover,
                          //       )
                      )),
                ),

                Container(
                  width: 96,
                  margin: EdgeInsets.only(right: 4, left: 4),
                  child: Center(
                    child: Text(
                        document['ctitle'] == null
                            ? "بدون عنوان"
                            :
                        document['ctitle'],
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        textAlign: TextAlign.center,
                        textDirection: TextDirection.rtl,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            fontFamily: MyFonts.primaryFont)),
                  )
                )


              ],
            )));
  }

  Widget categoryItem(int index) {
    return InkWell(
        onTap: () {
          setState(() {
            mfault = faultsList[index].sName;
          });

          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => tapedButton == "spareParts"
                      ? AddAdv("قطع غيار", sparepartsList[index].sName,
                          sparepartsList[index].sid)
                      : AddAdv("اعطال", faultsList[index].sName,
                          faultsList[index].sid)));
        },
        child: Card(
          elevation: 6,
          shape: RoundedRectangleBorder(
              borderRadius: const BorderRadius.all(Radius.circular(18)),
              side: BorderSide(color: Colors.grey[400], width: 1)),
          child: Container(

            height: 150,
            width: 150,
            child: Stack(
              children: [
                Container(
                  height: double.infinity,
                   width: double.infinity,
                   decoration: BoxDecoration(
                     borderRadius: BorderRadius.circular(18)
                   ),
                     
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(18),
                      child: new Image.network(
                        tapedButton == "spareParts"
                            ? sparepartsList[index].surl
                            : faultsList[index].surl,
                        fit: BoxFit.cover,
                      ),
                    )),
                Positioned(
                  bottom: 0,
                  child: Container(
                    height: 30,
                    width: 150,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(18),
                          bottomRight: Radius.circular(18)),
                      color: Colors.black.withOpacity(0.7),
                    ),
                    child: Center(
                      child: Text(
                          tapedButton == "spareParts"
                              ? sparepartsList[index].sName
                              : faultsList[index].sName,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              fontFamily: MyFonts.primaryFont)),
                    ),
                  ),
                )
              ],
            ),
          ),
        ));
  }

  Widget categoriesLoadingWidget() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[200],
      highlightColor: Colors.white,
      child: Row(
        children: [
          Container(
            height: 150,
            width: 150,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.grey[200],
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Expanded(
              child: Container(
            height: 150,
            width: 150,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.grey[200],
            ),
          )),
        ],
      ),
    );
  }

  // _onInstagramStorySwipeClicked() {
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //       builder: (context) => InstagramStorySwipe(
  //         children: <Widget>[
  //           Column(
  //             children: [
  //               Container(
  //                 color: Colors.redAccent,
  //               ),
  //               Container(
  //                 color: Colors.green,
  //               ),
  //               Container(
  //                 color: Colors.brown,
  //               ),
  //               Container(
  //                 color: Colors.yellow,
  //               ),
  //             ],
  //           ),
  //
  //         ],
  //       ),
  //     ),
  //   );
  // }

  _backFromStoriesAlert() {
    showDialog(
      context: context,
      child: SimpleDialog(
        title: Text(
          "User have looked stories and closed them.",
          style: TextStyle(fontWeight: FontWeight.normal, fontSize: 18.0),
        ),
        children: <Widget>[
          SimpleDialogOption(
            child: Text("Dismiss"),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  void getSparepartsData() {
    setState(() {
      final SparePartsReference = Firestore.instance;

      SparePartsReference.collection("spareparts")
          .getDocuments()
          .then((QuerySnapshot snapshot) {
        snapshot.documents.forEach((sparepart) {
          SparePartsSizesClass spc = SparePartsSizesClass(
            sparepart.data['sid'],
            sparepart.data['sName'],
            sparepart.data['surl'],
            100.0,
            false,
          );
          setState(() {
            sparepartsList.add(spc);
            print(sparepartsList.length.toString() + "llll");
          });
        });
      });
    });
  }

  void getfaultsData() {
    setState(() {
      final SparePartsReference = Firestore.instance;

      SparePartsReference.collection("faults")
          .getDocuments()
          .then((QuerySnapshot snapshot) {
        snapshot.documents.forEach((sparepart) {
          SparePartsSizesClass spc = SparePartsSizesClass(
            sparepart.data['sid'],
            sparepart.data['sName'],
            sparepart.data['surl'],
            100.0,
            false,
          );
          setState(() {
            faultsList.add(spc);
            // print(sparepartsList.length.toString() + "llll");
          });
        });
      });
    });
  }




  /* this function contains the code of the previous design before change
  ** currently it's not used
  */
//  Widget previousWidget(){
//     return
//       Container(
//         width: MediaQuery.of(context).size.width,
//         height: MediaQuery.of(context).size.height,
//         child: ListView(
//           physics: BouncingScrollPhysics(),
//           //mainAxisAlignment: MainAxisAlignment.start,
//           children: <Widget>[
//             // FlutterLinkPreview(
//             //   url: "https://firebasestorage.googleapis.com/v0/b/priceme-49386.appspot.com/o/video%2F2020-09-16%2011%3A10%3A44.350865.mp4?alt=media&token=836d436f-db07-424f-ab10-a872138330d9",
//             //   bodyStyle: TextStyle(
//             //     fontSize: 18.0,
//             //   ),
//             //   titleStyle: TextStyle(
//             //     fontSize: 20.0,
//             //     fontWeight: FontWeight.bold,
//             //   ),
//             //   showMultimedia: true,
//             //   builder: (info) {
//             //     if (info is WebInfo) {
//             //       return SizedBox(
//             //         height: 350,
//             //         child: Card(
//             //           shape: RoundedRectangleBorder(
//             //               borderRadius: BorderRadius.circular(20.0)),
//             //           clipBehavior: Clip.antiAlias,
//             //           child: Column(
//             //             crossAxisAlignment: CrossAxisAlignment.start,
//             //             children: [
//             //               if (info.image != null)
//             //                 Expanded(
//             //                     child: Image.network(
//             //                       info.image,
//             //                       width: double.maxFinite,
//             //                       fit: BoxFit.cover,
//             //                     )),
//             //               Padding(
//             //                 padding:
//             //                 const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0),
//             //                 child: Text(
//             //                   info.title,
//             //                   style: TextStyle(
//             //                     fontSize: 20.0,
//             //                     fontWeight: FontWeight.bold,
//             //                   ),
//             //                 ),
//             //               ),
//             //               if (info.description != null)
//             //                 Padding(
//             //                   padding: const EdgeInsets.all(16.0),
//             //                   child: Text(info.description),
//             //                 ),
//             //             ],
//             //           ),
//             //         ),
//             //       );
//             //     }
//             //     if (info is WebImageInfo) {
//             //       return SizedBox(
//             //         height: 350,
//             //         child: Card(
//             //           shape: RoundedRectangleBorder(
//             //               borderRadius: BorderRadius.circular(20.0)),
//             //           clipBehavior: Clip.antiAlias,
//             //           child: Image.network(
//             //             info.image,
//             //             fit: BoxFit.cover,
//             //             width: double.maxFinite,
//             //           ),
//             //         ),
//             //       );
//             //     } else if (info is WebVideoInfo) {
//             //       return SizedBox(
//             //         height: 350,
//             //         child: Card(
//             //           shape: RoundedRectangleBorder(
//             //               borderRadius: BorderRadius.circular(20.0)),
//             //           clipBehavior: Clip.antiAlias,
//             //           child: Image.network(
//             //             info.image,
//             //             fit: BoxFit.cover,
//             //             width: double.maxFinite,
//             //           ),
//             //         ),
//             //       );
//             //     }
//             //     return Container();
//             //   },
//             // ),
//             Container(
//               height: 190,
//               child: StreamBuilder(
//                 stream: Firestore.instance
//                     .collection('videos')
//                     .orderBy('seens', descending: true)
//                     .limit(5) //.where("cproblemtype", isEqualTo:"قطع غيار")
//                     .snapshots(),
//                 builder: (context, snapshot) {
//                   if (!snapshot.hasData) {
//                     return Center(
//                         child: Text(
//                           "Loading..",
//                         ));
//                   }
//
//                   return new ListView.builder(
//                       reverse: true,
//                       physics: BouncingScrollPhysics(),
//                       scrollDirection: Axis.horizontal,
//                       shrinkWrap: true,
//                       // controller: _controller,
//                       itemCount: snapshot.data.documents.length,
//                       itemBuilder: (context, index) {
//                         return firebasedata(
//                             context, index, snapshot.data.documents[index]);
//                       });
//                 },
//               ),
//             ),
//             Container(
//               width: MediaQuery.of(context).size.width,
//               height: 5,
//               color: Colors.grey[200],
//             ),
//             Container(height: 4,),
//             select_r_c?Container() : Container(
//               height: 220,
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   InkWell(
//                     onTap: () {
//                       setState(() {
//                         select_r_c=true;
//                         if(!sparescheck){
//                           sparescheck=!sparescheck;
//
//                           if(sparescheck){
//                             faultcheck=false;
//                             subfaultcheck=false;
//                             faultsize=50;sparesize=100;
//                             f_f_size=10;s_f_size=20;
//                           }}
//                       });
//                     },
//                     child: Container(
//                       height:sparesize,
//                       width: sparesize,
//                       child: Center(
//                         child: Text(
//                           "قطع غيار",
//                           style: TextStyle(
//                               color:sparescheck? Colors.red:Colors.white,
//                               fontSize: s_f_size
//                           ),textAlign: TextAlign.center,
//
//                         ),
//                       ),
//                       decoration: BoxDecoration(
//                         gradient: RadialGradient(
//                           center: Alignment(-0.93, 0.0),
//                           radius: 1.092,
//                           colors: [
//                             const Color(0xffff2121).withOpacity(.6),
//                             const Color(0xffff5423).withOpacity(.6),
//                             const Color(0xffff7024).withOpacity(.6),
//                             const Color(0xffff904a).withOpacity(.6),
//                           ],
//                           stops: [0.0, 0.562, 0.867, 1.0],
//                           transform: GradientXDTransform(1.0, 0.0, 0.0, 1.837, 0.0,
//                               -0.419, Alignment(-0.93, 0.0)),
//                         ),
//
//                         border: new Border.all(
//                           color:sparescheck? Colors.red:Colors.black,
//                           width: 1.0,
//                         ),
//                         shape: BoxShape.circle,
//                       ),
//                     ),
//                   ),
//                   InkWell(
//                     onTap: () {
//                       setState(() {
//                         select_r_c=true;
//
//                         if(!faultcheck){
//                           faultcheck=!faultcheck;
//                           if(faultcheck){sparescheck=false;subsparescheck=false;
//                           faultsize=100;sparesize=50;
//                           f_f_size=20;s_f_size=10;
//                           }}
//                       });
//                     },
//                     child: Container(
//                       height:faultsize,
//                       width: faultsize,
//                       child: Center(
//                         child: Text(
//                           "اعطال", style: TextStyle(color:faultcheck? Colors.red:Colors.white,fontSize: f_f_size
//                         ),textAlign: TextAlign.center,
//
//                         ),
//                       ),
//                       decoration: BoxDecoration(
//                         gradient:  RadialGradient(
//                           center: Alignment(-0.93, 0.0),
//                           radius: 1.092,
//                           colors: [
//                             const Color(0xffff2121).withOpacity(.6),
//                             const Color(0xffff5423).withOpacity(.6),
//                             const Color(0xffff7024).withOpacity(.6),
//                             const Color(0xffff904a).withOpacity(.6),
//                           ],
//                           stops: [0.0, 0.562, 0.867, 1.0],
//                           transform: GradientXDTransform(1.0, 0.0, 0.0, 1.837, 0.0,
//                               -0.419, Alignment(-0.93, 0.0)),
//                         ),
//
//
//                         border: new Border.all(
//                           color: faultcheck? Colors.red:Colors.black,
//                           width: 1.0,
//                         ),
//                         shape: BoxShape.circle,
//                       ),
//                     ),
//                   ),
//
//                 ],
//               ),
//             ),
//             select_r_c? Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 InkWell(
//                   onTap: () {
//                     setState(() {
//                       if(!sparescheck){
//                         sparescheck=!sparescheck;
//                         if(sparescheck){faultcheck=false;subfaultcheck=false;
//                         faultsize=50;sparesize=100;
//                         f_f_size=10;s_f_size=20;
//                         }}
//                     });
//                   },
//                   //   double sparesize=100;
//                   // double faultsize=100;
//                   child: Container(
//                     height:sparesize,
//                     width: sparesize,
//                     child: Center(
//                       child: Text(
//                         "قطع غيار",
//                         style: TextStyle(
//                           color:sparescheck? Colors.red:Colors.white,
//                           fontSize: s_f_size,
//                         ),textAlign: TextAlign.center,
//
//                       ),
//                     ),
//                     decoration: BoxDecoration(
//                       gradient:sparescheck? RadialGradient(
//                         center: Alignment(-0.93, 0.0),
//                         radius: 1.092,
//                         colors: [
//                           const Color(0xffff2121).withOpacity(.6),
//                           const Color(0xffff5423).withOpacity(.6),
//                           const Color(0xffff7024).withOpacity(.6),
//                           const Color(0xffff904a).withOpacity(.6),
//                         ],
//                         stops: [0.0, 0.562, 0.867, 1.0],
//                         transform: GradientXDTransform(1.0, 0.0, 0.0, 1.837, 0.0,
//                             -0.419, Alignment(-0.93, 0.0)),
//                       ): RadialGradient(
//                         center: Alignment(-0.93, 0.0),
//                         radius: 1.092,
//                         colors: [
//                           const Color(0x42000000).withOpacity(.6),
//                           const Color(0x42000000).withOpacity(.6),
//                           const Color(0x42000000).withOpacity(.6),
//                           const Color(0x42000000).withOpacity(.6),
//
//                         ],
//                         stops: [0.0, 0.562, 0.867, 1.0],
//                         transform: GradientXDTransform(1.0, 0.0, 0.0, 1.837, 0.0,
//                             -0.419, Alignment(-0.93, 0.0)),
//                       ),
//
//                       border: new Border.all(
//                         color:sparescheck? Colors.red:Colors.black,
//                         width: 1.0,
//                       ),
//                       shape: BoxShape.circle,
//                     ),
//                   ),
//                 ),
//                 InkWell(
//                   onTap: () {
//                     setState(() {
//                       if(!faultcheck){
//                         faultcheck=!faultcheck;
//                         if(faultcheck){sparescheck=false;subsparescheck=false;
//                         faultsize=100;sparesize=50;
//                         f_f_size=20;s_f_size=10;
//                         }}
//
//                     });
//                   },
//                   child: Container(
//                     height:faultsize,
//                     width: faultsize,
//                     child: Center(
//                       child: Text(
//                         "اعطال", style: TextStyle(color:faultcheck? Colors.red:Colors.white,fontSize: f_f_size
//                       ),textAlign: TextAlign.center,
//
//                       ),
//                     ),
//                     decoration: BoxDecoration(
//                       gradient: faultcheck? RadialGradient(
//                         center: Alignment(-0.93, 0.0),
//                         radius: 1.092,
//                         colors: [
//                           const Color(0xffff2121).withOpacity(.6),
//                           const Color(0xffff5423).withOpacity(.6),
//                           const Color(0xffff7024).withOpacity(.6),
//                           const Color(0xffff904a).withOpacity(.6),
//                         ],
//                         stops: [0.0, 0.562, 0.867, 1.0],
//                         transform: GradientXDTransform(1.0, 0.0, 0.0, 1.837, 0.0,
//                             -0.419, Alignment(-0.93, 0.0)),
//                       ): RadialGradient(
//                         center: Alignment(-0.93, 0.0),
//                         radius: 1.092,
//                         colors: [
//                           const Color(0x42000000).withOpacity(.6),
//                           const Color(0x42000000).withOpacity(.6),
//                           const Color(0x42000000).withOpacity(.6),
//                           const Color(0x42000000).withOpacity(.6),
//                         ],
//                         stops: [0.0, 0.562, 0.867, 1.0],
//                         transform: GradientXDTransform(1.0, 0.0, 0.0, 1.837, 0.0,
//                             -0.419, Alignment(-0.93, 0.0)),
//                       ),
//                       border: new Border.all(
//                         color: faultcheck? Colors.red:Colors.black,
//                         width: 1.0,
//                       ),
//                       shape: BoxShape.circle,
//                     ),
//                   ),
//                 ),
//
//               ],
//             ):Container() ,
//
//             sparescheck? Padding(
//               padding: const EdgeInsets.only(top: 10),
//               child: Container(
//                 width: MediaQuery.of(context).size.width,
//                 height: 40.0,
//                 decoration: BoxDecoration(
//                   gradient: RadialGradient(
//                     center: Alignment(-0.93, 0.0),
//                     radius: 1.092,
//                     colors: [
//                       const Color(0xffff2121).withOpacity(.6),
//                       const Color(0xffff5423).withOpacity(.6),
//                       const Color(0xffff7024).withOpacity(.6),
//                       const Color(0xffff904a).withOpacity(.6),
//                     ],
//                     stops: [0.0, 0.562, 0.867, 1.0],
//                     transform: GradientXDTransform(1.0, 0.0, 0.0, 1.837, 0.0,
//                         -0.419, Alignment(-0.93, 0.0)),
//                   ),
// //                color: Colors.orange,
//                 ),
//                 child: Text(
//                   "قطع غيار",
//                   style: TextStyle(color: Colors.black, fontSize: 20),
//                   textAlign: TextAlign.center,
//                 ),
//               ),
//             ):Container(),
//             // sparescheck? SizedBox(
//             //   height: 10,
//             // ):Container(),
//             sparescheck? Container(
//                 height: 250,
//                 child: sparepartsList.length == 0
//                     ? new Text("برجاء الإنتظار")
//                     :Stack(
//                   children: [
//                     PageView.builder(
//                       itemCount: sparepartsList.length ,
//                       controller: _pageController_spare,
//                       onPageChanged: (int i) => setState(() => _index = i),
//                       itemBuilder: (BuildContext ctxt,int index) {
//                         return Transform.scale(
//                           scale: index == _index ?1.2 : 0.7,
//                           child: InkWell(
//                             onTap: () {
//                               setState(() {
//                                 mfault = sparepartsList[index].sName;
//                                 sparepartsList[index].ssizecheck =
//                                 !sparepartsList[index].ssizecheck;
//                                 if (sparepartsList[index].ssizecheck) {
//                                   setState(() {
//                                     //   sparepartsList[index].ssize = 120;
//                                     subsparescheck = true;
//                                   });
//                                 } else {
//                                   setState(() {
//                                     //   sparepartsList[index].ssize = 100;
//                                     subsparescheck = false;
//                                   });
//                                 }
//                               });
//                               Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                       builder: (context) => AddAdv("قطع غيار", sparepartsList[index].sName, sparepartsList[index].sid)));
//
//                               // for (var i = 0; i < sparepartsList.length; i++) {
//                               //   if (i != index)
//                               //     setState(() {
//                               //       setState(() {
//                               //         sparepartsList[i].ssize = 100;
//                               //       });
//                               //     });
//                               // }
//                               //
//                               // setState(() {
//                               //   final SparePartsReference = Firestore.instance;
//                               //   subsparesList.clear();
//                               //
//                               //   SparePartsReference.collection("subspares")
//                               //       .document(sparepartsList[index].sid)
//                               //       .collection("subsparesid")
//                               //       .getDocuments()
//                               //       .then((QuerySnapshot snapshot) {
//                               //     snapshot.documents.forEach((fault) {
//                               //       FaultsClass fp = FaultsClass(
//                               //         fault.data['fid'],
//                               //         fault.data['fName'],
//                               //         fault.data['fsubId'],
//                               //         fault.data['fsubName'],
//                               //         fault.data['fsubDesc'],
//                               //         fault.data['fsubUrl'],
//                               //       );
//                               //       setState(() {
//                               //         subsparesList.add(fp);
//                               //         // print(sparepartsList.length.toString() + "llll");
//                               //       });
//                               //     });
//                               //   }).whenComplete(() {
//                               //     setState(() {});
//                               //   });
//                               // });
//                             },
//                             child: Padding(
//                               padding: const EdgeInsets.only(top:25.0),
//                               child: Container(
//                                 // width: 110,
//                                 // height: 110,
// //                              decoration: BoxDecoration(
// //                                border: new Border.all(
// //                                  color: Colors.black,
// //                                  width: 1.0,
// //                                ),
// //                                shape: BoxShape.circle,
// //                              ),
//                                 child: Column(
//                                   children: [
//                                     Container(
//                                       height: sparepartsList[index].ssize,
//                                       width: sparepartsList[index].ssize,
//                                       // child: Text(
//                                       //   sparepartsList[index].sName, style: TextStyle(color: Colors.red,fontSize: 20
//                                       // ),textAlign: TextAlign.center,
//                                       //
//                                       // ),
//                                       decoration: BoxDecoration(
//                                         border: new Border.all(
//                                           color: Colors.black,
//                                           width: 1.0,
//                                         ),
//                                         image: DecorationImage(
//                                           image: NetworkImage(
//                                               sparepartsList[index].surl),
//                                           fit: BoxFit.fill,
//                                         ),
//                                         shape: BoxShape.circle,
//                                       ),
//                                     ),
//                                     Expanded(
//                                       child: Text(
//                                         sparepartsList[index].sName,
//                                         style: TextStyle(
//                                             color: Colors.red, fontSize: 15),
//                                         textAlign: TextAlign.center,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ),
//                         );
//                       },
//
// //                 new ListView.builder(
// //                         //  controller: _depcontroller,
// //                         physics: BouncingScrollPhysics(),
// //                         scrollDirection: Axis.horizontal,
// //                         reverse: true,
// //                         itemCount: sparepartsList.length,
// //                         itemBuilder: (BuildContext ctxt, int index) {
// //                           return InkWell(
// //                             onTap: () {
// //                               setState(() {
// //                                 mfault = sparepartsList[index].sName;
// //                                 sparepartsList[index].ssizecheck =
// //                                     !sparepartsList[index].ssizecheck;
// //                                 if (sparepartsList[index].ssizecheck) {
// //                                   setState(() {
// //                                     sparepartsList[index].ssize = 100;
// //                                     subsparescheck = true;
// //                                   });
// //                                 } else {
// //                                   setState(() {
// //                                     sparepartsList[index].ssize = 75;
// //                                     subsparescheck = false;
// //                                   });
// //                                 }
// //                               });
// //                               for (var i = 0; i < sparepartsList.length; i++) {
// //                                 if (i != index)
// //                                   setState(() {
// //                                     setState(() {
// //                                       sparepartsList[i].ssize = 75;
// //                                     });
// //                                   });
// //                               }
// //
// //                               setState(() {
// //                                 final SparePartsReference = Firestore.instance;
// //                                 subsparesList.clear();
// //
// //                                 SparePartsReference.collection("subspares")
// //                                     .document(sparepartsList[index].sid)
// //                                     .collection("subsparesid")
// //                                     .getDocuments()
// //                                     .then((QuerySnapshot snapshot) {
// //                                   snapshot.documents.forEach((fault) {
// //                                     FaultsClass fp = FaultsClass(
// //                                       fault.data['fid'],
// //                                       fault.data['fName'],
// //                                       fault.data['fsubId'],
// //                                       fault.data['fsubName'],
// //                                       fault.data['fsubDesc'],
// //                                       fault.data['fsubUrl'],
// //                                     );
// //                                     setState(() {
// //                                       subsparesList.add(fp);
// //                                       // print(sparepartsList.length.toString() + "llll");
// //                                     });
// //                                   });
// //                                 }).whenComplete(() {
// //                                   setState(() {});
// //                                 });
// //                               });
// //                               // Navigator.push(
// //                               //     context,
// //                               //     MaterialPageRoute(
// //                               //         builder: (context) => AddAdv(widget.sparepartsList,"قطع غيار",mfault, sparepartsList[index].sName)));
// //                             },
// //                             child: Container(
// //                               width: 110,
// //                               height: 110,
// // //                              decoration: BoxDecoration(
// // //                                border: new Border.all(
// // //                                  color: Colors.black,
// // //                                  width: 1.0,
// // //                                ),
// // //                                shape: BoxShape.circle,
// // //                              ),
// //                               child: Column(
// //                                 children: [
// //                                   Container(
// //                                     height: sparepartsList[index].ssize,
// //                                     width: sparepartsList[index].ssize,
// //                                     // child: Text(
// //                                     //   sparepartsList[index].sName, style: TextStyle(color: Colors.red,fontSize: 20
// //                                     // ),textAlign: TextAlign.center,
// //                                     //
// //                                     // ),
// //                                     decoration: BoxDecoration(
// //                                       border: new Border.all(
// //                                         color: Colors.black,
// //                                         width: 1.0,
// //                                       ),
// //                                       image: DecorationImage(
// //                                         image: NetworkImage(
// //                                             sparepartsList[index].surl),
// //                                         fit: BoxFit.fill,
// //                                       ),
// //                                       shape: BoxShape.circle,
// //                                     ),
// //                                   ),
// //                                   Expanded(
// //                                     child: Text(
// //                                       sparepartsList[index].sName,
// //                                       style: TextStyle(
// //                                           color: Colors.red, fontSize: 15),
// //                                       textAlign: TextAlign.center,
// //                                     ),
// //                                   ),
// //                                 ],
// //                               ),
// //                             ),
// //                           );
// //                         }),
//                     ),
//                     Center(
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           IconButton(
//                             icon: Icon(Icons.arrow_back_ios_outlined),
//                             onPressed: () {
//                               setState(() {
//                                 if(currentPage_spare>0){
//                                   currentPage_spare--;
//                                   print("ggg$currentPage_spare");
//                                   _pageController_spare.animateToPage(currentPage_spare, duration: const Duration(milliseconds: 500), curve: Curves.easeInSine,);
//
//                                 }
//                               });
//                             },
//                           ),
//                           IconButton(
//                             icon: Icon(Icons.arrow_forward_ios),
//                             onPressed: () {
//                               setState(() {
//                                 if(currentPage_spare<sparepartsList.length-1) {
//                                   currentPage_spare++;
//                                   print("ggg$currentPage_spare");
//
//                                   _pageController_spare.animateToPage(
//                                     currentPage_spare,
//                                     duration: const Duration(milliseconds: 500),
//                                     curve: Curves.easeInSine,);
//                                 }  });
//                             },
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 )):Container(),
//
//             faultcheck?SizedBox(
//               height: 10,
//             ):Container(),
//             faultcheck? Container(
//               width: MediaQuery.of(context).size.width,
//               height: 40.0,
//               decoration: BoxDecoration(
//                 gradient: RadialGradient(
//                   center: Alignment(-0.93, 0.0),
//                   radius: 1.092,
//                   colors: [
//                     const Color(0xffff2121).withOpacity(.6),
//                     const Color(0xffff5423).withOpacity(.6),
//                     const Color(0xffff7024).withOpacity(.6),
//                     const Color(0xffff904a).withOpacity(.6),
//                   ],
//                   stops: [0.0, 0.562, 0.867, 1.0],
//                   transform: GradientXDTransform(
//                       1.0, 0.0, 0.0, 1.837, 0.0, -0.419, Alignment(-0.93, 0.0)),
//                 ),
//               ),
//               child: Text(
//                 "الاعطال",
//                 style: TextStyle(color: Colors.black, fontSize: 20),
//                 textAlign: TextAlign.center,
//               ),
//             ):Container(),
//             faultcheck?SizedBox(
//               height: 10,
//             ):Container(),
//             faultcheck? Container(
//               height: 250,
//               child: Expanded(
//                   child: Center(
//                       child: faultsList.length == 0
//                           ? new Text("برجاء الإنتظار")
//                           :Stack(
//                         children: [
//                           PageView.builder(
//                             // controller: _pageController_fault,
//                             itemCount: faultsList.length ,
//                             controller: _pageController_fault,
//                             onPageChanged: (int i) => setState(() => _index = i),
//                             itemBuilder: (BuildContext ctxt,int index) {
//                               return Transform.scale(
//                                 scale: index == _index ?1.2 : 0.7,
//                                 child: InkWell(
//                                   onTap: () {
//                                     setState(() {
//                                       mfault = faultsList[index].sName;
//
//                                       faultsList[index].ssizecheck =
//                                       !faultsList[index].ssizecheck;
//                                       if (faultsList[index].ssizecheck) {
//                                         // faultsList[index].ssize = 100;
//                                         subfaultcheck = true;
//                                       } else {
//                                         // faultsList[index].ssize = 75;
//                                         subfaultcheck = false;
//                                       }
//                                     });
//                                     Navigator.push(
//                                         context,
//                                         MaterialPageRoute(
//                                             builder: (context) => AddAdv("اعطال", faultsList[index].sName, faultsList[index].sid)));
//
//                                   },
//                                   child: Padding(
//                                     padding: const EdgeInsets.only(top:25.0),
//                                     child: Container(
//                                       // width: 110,
//                                       // height: 110,
// //                              decoration: BoxDecoration(
// //                                border: new Border.all(
// //                                  color: Colors.black,
// //                                  width: 1.0,
// //                                ),
// //                                shape: BoxShape.rectangle,
// //                              ),
//                                       child: Column(
//                                         children: [
//                                           Container(
//                                             height:
//                                             faultsList[index].ssize,
//                                             width:
//                                             faultsList[index].ssize,
//                                             // child: Text(
//                                             //   sparepartsList[index].sName, style: TextStyle(color: Colors.red,fontSize: 20
//                                             // ),textAlign: TextAlign.center,
//                                             //
//                                             // ),
//                                             decoration: BoxDecoration(
//                                               border: new Border.all(
//                                                 color: Colors.black,
//                                                 width: 1.0,
//                                               ),
//                                               image: DecorationImage(
//                                                 image: NetworkImage(
//                                                     faultsList[index]
//                                                         .surl),
//                                                 fit: BoxFit.fill,
//                                               ),
//                                               shape: BoxShape.circle,
//                                             ),
//                                           ),
//                                           Expanded(
//                                             child: Text(
//                                               faultsList[index].sName,
//                                               style: TextStyle(
//                                                   color: Colors.red,
//                                                   fontSize: 15),
//                                               textAlign: TextAlign.center,
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               );
//                             },
//
// //                 new ListView.builder(
// //                         //  controller: _depcontroller,
// //                         physics: BouncingScrollPhysics(),
// //                         scrollDirection: Axis.horizontal,
// //                         reverse: true,
// //                         itemCount: sparepartsList.length,
// //                         itemBuilder: (BuildContext ctxt, int index) {
// //                           return InkWell(
// //                             onTap: () {
// //                               setState(() {
// //                                 mfault = sparepartsList[index].sName;
// //                                 sparepartsList[index].ssizecheck =
// //                                     !sparepartsList[index].ssizecheck;
// //                                 if (sparepartsList[index].ssizecheck) {
// //                                   setState(() {
// //                                     sparepartsList[index].ssize = 100;
// //                                     subsparescheck = true;
// //                                   });
// //                                 } else {
// //                                   setState(() {
// //                                     sparepartsList[index].ssize = 75;
// //                                     subsparescheck = false;
// //                                   });
// //                                 }
// //                               });
// //                               for (var i = 0; i < sparepartsList.length; i++) {
// //                                 if (i != index)
// //                                   setState(() {
// //                                     setState(() {
// //                                       sparepartsList[i].ssize = 75;
// //                                     });
// //                                   });
// //                               }
// //
// //                               setState(() {
// //                                 final SparePartsReference = Firestore.instance;
// //                                 subsparesList.clear();
// //
// //                                 SparePartsReference.collection("subspares")
// //                                     .document(sparepartsList[index].sid)
// //                                     .collection("subsparesid")
// //                                     .getDocuments()
// //                                     .then((QuerySnapshot snapshot) {
// //                                   snapshot.documents.forEach((fault) {
// //                                     FaultsClass fp = FaultsClass(
// //                                       fault.data['fid'],
// //                                       fault.data['fName'],
// //                                       fault.data['fsubId'],
// //                                       fault.data['fsubName'],
// //                                       fault.data['fsubDesc'],
// //                                       fault.data['fsubUrl'],
// //                                     );
// //                                     setState(() {
// //                                       subsparesList.add(fp);
// //                                       // print(sparepartsList.length.toString() + "llll");
// //                                     });
// //                                   });
// //                                 }).whenComplete(() {
// //                                   setState(() {});
// //                                 });
// //                               });
// //                               // Navigator.push(
// //                               //     context,
// //                               //     MaterialPageRoute(
// //                               //         builder: (context) => AddAdv(widget.sparepartsList,"قطع غيار",mfault, sparepartsList[index].sName)));
// //                             },
// //                             child: Container(
// //                               width: 110,
// //                               height: 110,
// // //                              decoration: BoxDecoration(
// // //                                border: new Border.all(
// // //                                  color: Colors.black,
// // //                                  width: 1.0,
// // //                                ),
// // //                                shape: BoxShape.circle,
// // //                              ),
// //                               child: Column(
// //                                 children: [
// //                                   Container(
// //                                     height: sparepartsList[index].ssize,
// //                                     width: sparepartsList[index].ssize,
// //                                     // child: Text(
// //                                     //   sparepartsList[index].sName, style: TextStyle(color: Colors.red,fontSize: 20
// //                                     // ),textAlign: TextAlign.center,
// //                                     //
// //                                     // ),
// //                                     decoration: BoxDecoration(
// //                                       border: new Border.all(
// //                                         color: Colors.black,
// //                                         width: 1.0,
// //                                       ),
// //                                       image: DecorationImage(
// //                                         image: NetworkImage(
// //                                             sparepartsList[index].surl),
// //                                         fit: BoxFit.fill,
// //                                       ),
// //                                       shape: BoxShape.circle,
// //                                     ),
// //                                   ),
// //                                   Expanded(
// //                                     child: Text(
// //                                       sparepartsList[index].sName,
// //                                       style: TextStyle(
// //                                           color: Colors.red, fontSize: 15),
// //                                       textAlign: TextAlign.center,
// //                                     ),
// //                                   ),
// //                                 ],
// //                               ),
// //                             ),
// //                           );
// //                         }),
//                           ),
//                           Center(
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 IconButton(
//                                   icon: Icon(Icons.arrow_back_ios_outlined),
//                                   onPressed: () {
//                                     setState(() {
//                                       if(currentPage_fault>0){
//                                         currentPage_fault--;
//                                         // print("ggg$currentPage_spare");
//                                         _pageController_fault.animateToPage(currentPage_fault, duration: const Duration(milliseconds: 500), curve: Curves.easeInSine,);
//
//                                       }
//                                     });
//                                   },
//                                 ),
//                                 IconButton(
//                                   icon: Icon(Icons.arrow_forward_ios),
//                                   onPressed: () {
//                                     setState(() {
//                                       if(currentPage_fault<faultsList.length-1) {
//                                         currentPage_fault++;
//                                         //print("ggg$currentPage_spare");
//
//                                         _pageController_fault.animateToPage(
//                                           currentPage_fault,
//                                           duration: const Duration(milliseconds: 500),
//                                           curve: Curves.easeInSine,);
//                                       }  });
//                                   },
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       )
//
//                   )),
//             ):Container(),
//
//           ],
//         ),
//       );
//
//
//
//  }
}
