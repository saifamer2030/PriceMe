import 'dart:io';
import 'dart:ui';

import 'package:adobe_xd/gradient_xd_transform.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

//import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:priceme/ChatRoom/widget/const.dart';
import 'package:priceme/Videos/addVideo.dart';

import 'package:priceme/classes/FaultsClass.dart';
import 'package:priceme/classes/SparePartsClass.dart';
import 'package:priceme/classes/SparePartsSizesClass.dart';
import 'package:priceme/ui_utile/myColors.dart';
import 'package:toast/toast.dart';
import 'package:firebase_core/firebase_core.dart';

import 'allvideos.dart';

class VidiosPhotoComercial1 extends StatefulWidget {

  @override
  _VidiosPhotoComercialState1 createState() => _VidiosPhotoComercialState1();
}

class _VidiosPhotoComercialState1 extends State<VidiosPhotoComercial1> {
  String filtter;
  TextEditingController searchcontroller = TextEditingController();

  String filePath;
  List<String> sortlist = ["الاحدث", "الاكثر شهرة"];
  List<String> carlist =
  ["السيارة",
    "اودي", "أوبل","أنفيتيتي",
    "ايسوزو", "بي-أم-دبليو","بورش", "بوغاتي", "بيجو", "تويوتا","جي-أم-سي",
    "جاكوار",
    "دودج",
    "دايو",
    "رولزرويس",
    "رينو",
    "سكودا",
    "سوزوكي",
    "سوبارو",
    "سيتروين",
    "سيات",
    "شيري",
    "شفروليه",
    "فولكس-فاجن",
    "فيراري",
    "فولفو",
    "فيات",
    "فورد",
    "كيا",
    "كاديلاك",
    "لينكولن",
    "لاند-روفر",
    "لامبورغيني",
    "مرسيدس",
    "مازدا",
    "ميتشيبيشي",

    "ميني-كوبر",

    "نيسان",
    "هوندا",
    "هيونداي"
  ];
  var _sortcurrentItemSelected = '';
  var _carcurrentItemSelected = '';
  String filt;
  bool chechsearch = false;
  bool isSearching = false;

  @override
  void initState() {
    super.initState();
    _sortcurrentItemSelected = sortlist[0];
    _carcurrentItemSelected = carlist[0];
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    //final double itemHeight = (size.height - kToolbarHeight - 24) / 2;
    // final double itemWidth = size.width / 2;
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(

        floatingActionButton:

        Align(
            alignment: Alignment.bottomLeft,
            child:

            Padding(
                padding: EdgeInsets.only(left: 28),
                child: FloatingActionButton(
                  backgroundColor: MyColors.secondaryColor,
                  heroTag: "unique159",
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                AddVideo()));
                  },
                  //backgroundColor: Colors.white,
                  // elevation: 20.0,
                  child: Container(
                    height: 100,
                    child: Icon(
                      Icons.video_call,
                      size: 32,
                      color: Colors.white,
                    ),
                  ),
                )
            )

        )
        ,
        backgroundColor: Colors.white,
        appBar: AppBar(
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
                    ])),
          ),
          title: Text(
            'فيديوهات اصلاح الاعطال',
            style: TextStyle(color: Colors.white,fontSize: 14, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          // actions: <Widget>[
          //   PopupMenuButton<Choice>(
          //     onSelected: onItemMenuPress,
          //     itemBuilder: (BuildContext context) {
          //       return choices.map((Choice choice) {
          //         return PopupMenuItem<Choice>(
          //             value: choice,
          //             child: Row(
          //               children: <Widget>[
          //                 Icon(
          //                   choice.icon,
          //                   color: primaryColor,
          //                 ),
          //                 Container(
          //                   width: 10.0,
          //                 ),
          //                 Text(
          //                   choice.title,
          //                   style: TextStyle(color: primaryColor),
          //                 ),
          //               ],
          //             ));
          //       }).toList();
          //     },
          //   ),
          // ],
        ),

        body: commercialVideosScreen()

        );
  }

  Widget commercialVideosScreen() {
    return Column(
      children: [
        Container(
            height: 46,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey[300]),
                boxShadow: [
                  BoxShadow(
                      blurRadius: 4, color: Colors.grey, offset: Offset(1, 2))
                ]),
            child: Stack(
              children: [
            Positioned(
                    right: 40,
                    left:40,
                    top: 2,
                    child: Container(
                      height: 40,
                      padding: EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(10),
                              bottomRight: Radius.circular(10)),
                          border: Border.all(color: Colors.grey[400])),
                      width: MediaQuery.of(context).size.width - 40,
                      child: Directionality(
                        textDirection: TextDirection.rtl,
                        child: TextField(
                          keyboardType: TextInputType.emailAddress,
                          controller: searchcontroller,
                          onChanged: (value) {
                            setState(() {
                              if(value==""||value.isEmpty||value==null){
                                setState(() {
                                  filtter=null;
                                });

                              }
                              filtter = value;
                            });
                          },
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 12.0,
                          ),
                          textDirection: TextDirection.rtl,
                          decoration: InputDecoration(
                            hintText: "البحث",
                            hintStyle: TextStyle(
                              color: Colors.grey,
                              fontSize: 12.0,
                              fontWeight: FontWeight.bold,
                            ),
                            border: InputBorder.none,
                            labelStyle: TextStyle(
                              color: Colors.black,
                              fontSize: 12.0,
                            ),
                          ),
                        ),
                      ),
                    ))
                  ,
                Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    alignment: Alignment.center,
                    height: 46,
                    width: 46,
                    child: Icon(
                      Icons.search,
                      color: Colors.grey,
                      size: 24,
                    ),
                  ),
                ),
               Align(
                    alignment: Alignment.centerLeft,
                    child: InkWell(
                        onTap: () {
                          setState(() {
                            isSearching = !isSearching;
                          });
                        },
                        child: Container(
                          height: 46,
                          width: 46,
                          alignment: Alignment.center,
                          child: Icon(
                            Icons.filter_list,
                            size: 24,
                            color: isSearching == true
                                ? Colors.deepOrange
                                : Colors.grey,
                          ),
                        )))
              ],
            )),
        isSearching
            ? Container(
          height: 46,
          child: Row(
            textDirection: TextDirection.rtl,
            children: [
              Container(
                  margin: EdgeInsets.only(right: 10),
                  height: 40,
                  // width: 100,
                  child: Card(
                      elevation: 0.0,
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                          side: BorderSide(color: Colors.grey[400])),
                      child: Directionality(
                        textDirection: TextDirection.rtl,
                        child: DropdownButtonHideUnderline(
                            child: ButtonTheme(
                              alignedDropdown: true,
                              child: DropdownButton<String>(
                                items: sortlist.map((String value) {
                                  return new DropdownMenuItem<String>(
                                    value: value,
                                    child: new Text(value),
                                  );
                                }).toList(),
                                value: _sortcurrentItemSelected,
                                onChanged: (String newValueSelected) {
                                  // Your code to execute, when a menu item is selected from dropdown
                                  _onDropDownItemSelectedsort(newValueSelected);
                                },
                                style: new TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w300,
                                    fontFamily: 'Cairo'),
                              ),
                            )),
                      ))),
              Container(
                  margin: EdgeInsets.only(right: 10),
                  height: 40,
                  //width: 100,
                  child: Card(
                      elevation: 0.0,
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                          side: BorderSide(color: Colors.grey[400])),
                      child: Directionality(
                        textDirection: TextDirection.rtl,
                        child: DropdownButtonHideUnderline(
                            child: ButtonTheme(
                              alignedDropdown: true,
                              child: DropdownButton<String>(
                                items: carlist.map((String value) {
                                  return new DropdownMenuItem<String>(
                                    value: value,
                                    child: new Text(value),
                                  );
                                }).toList(),
                                value: _carcurrentItemSelected,
                                onChanged: (String newValueSelected) {
                                  // Your code to execute, when a menu item is selected from dropdown
                                  _onDropDownItemSelectedcar(newValueSelected);
                                },
                                style: new TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w300,
                                    fontFamily: 'Cairo'),
                              ),
                            )),
                      ))),
            ],
          ),
        )
            : SizedBox(),
        SizedBox(
          height: 8,
        ),


        SizedBox(
          height: 8,
        ),
        Expanded(
          child: Container(
            //   width: MediaQuery.of(context).size.width,
            //  height: MediaQuery.of(context).size.height,
            child: StreamBuilder(
              stream: _sortcurrentItemSelected == sortlist[0]
                  ? Firestore.instance
                      .collection('videos')
                     .where("cdepart", isEqualTo: "تجارى")
                  .where("ctitle", isEqualTo: filtter)
                      .where("ccar", isEqualTo: filt)
                      .orderBy('carrange', descending: true)
                      .snapshots()
                  : Firestore.instance
                      .collection('videos')
                     .where("cdepart", isEqualTo: "تجارى")
                  .where("ctitle", isEqualTo: filtter)
                  .where("ccar", isEqualTo: filt)
                      .orderBy('seens', descending: true)
                      .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.data?.documents == null || !snapshot.hasData)
                  return Center(
                      child: Text(
                    "لا يوجد بيانات...",
                  ));
                return Hero(
                  tag: 'imageHero',
                  child: Container(
                    child: StaggeredGridView.countBuilder(
                      padding: EdgeInsets.zero,
                        itemCount: snapshot.data.documents.length,
                        crossAxisCount: 2,
                        itemBuilder: (context, index) {
                          return videoTile(
                              context, index, snapshot.data.documents[index]);
                        },
                        staggeredTileBuilder: (index) =>
                            StaggeredTile.count(1, index.isEven ? 1.2 : 1.8)),
                  ),
                );
              },
            ),

            // StreamBuilder(
            //   stream: _sortcurrentItemSelected==sortlist[0]? Firestore.instance
            //       .collection('videos')
            //       .where("cdepart", isEqualTo:"تجارى")
            //       .where("ccar", isEqualTo:filt)
            //       .orderBy('carrange',
            //       descending:
            //       true)
            //       .snapshots():Firestore.instance
            //       .collection('videos')
            //       .where("cdepart", isEqualTo:"تجارى")
            //       .where("ccar", isEqualTo:filt)
            //       .orderBy('seens',
            //       descending:
            //       true)
            //       .snapshots(),
            //   builder: (context, snapshot) {
            //     if (!snapshot.hasData) {
            //       return Center(child: Text("لا يوجد بيانات...",));
            //     }
            //     print("kkk1$filt");
            //
            //     return new GridView.builder(
            //         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            //             crossAxisCount:2,
            //             //crossAxisCount: (orientation == Orientation.portrait) ? 2 : 3
            //         ),
            //         //add item count depending on your list
            //         //itemCount: list.length,
            //
            //         //added scrolldirection
            //         //reverse: true,
            //         physics: BouncingScrollPhysics(),
            //         shrinkWrap: true,
            //        // controller: _controller,
            //         itemCount: snapshot.data.documents.length,
            //         itemBuilder: (context, index) {
            //           return firebasedata(
            //               context, index, snapshot.data.documents[index]);
            //         });
            //   },
            // ),
          ),
        )
      ],
    );
  }

  void _onDropDownItemSelectedcar(String newValueSelected) {
    print("kkk$newValueSelected");
    if (newValueSelected == "السيارة") {
      setState(() {
        this._carcurrentItemSelected = newValueSelected;
        filt = null;
      });
    } else {
      setState(() {
        this._carcurrentItemSelected = newValueSelected;
        filt = _carcurrentItemSelected;
      });
    }
  }

  void _onDropDownItemSelectedsort(String newValueSelected) {
    setState(() {
      this._sortcurrentItemSelected = newValueSelected;
    });
  }


  Widget videoTile(
      BuildContext context, int index, DocumentSnapshot document) {

    return   InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => AllVideos(document['carrange'],document['cdepart'],null)));

      },
      child: Padding(
        padding: const EdgeInsets.all(1.0),
        child: Stack(
          children: [
            document['imgurl'] ==null?Image.asset(
              "assets/images/ic_logo2.png",
              width: 250.0,
              height: 350.0,
              fit: BoxFit.contain,color: Colors.orange,
            ):
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
              imageUrl:document['imgurl'] ,
              width: 250.0,
              height: 350.0,
              fit: BoxFit.cover,
            ),

            // Container(
            //   //   height: 200,
            //   decoration: BoxDecoration(
            //     border: new Border.all(
            //       color: Colors.white,
            //       width: 0,
            //     ),
            //     image: document['imgurl'] == null
            //         ? DecorationImage(
            //       image: AssetImage("assets/images/ic_background.png"),
            //       fit: BoxFit.fill,
            //     )
            //         : DecorationImage(
            //       image: NetworkImage(document['imgurl']),
            //       fit: BoxFit.fill,
            //     ),
            //     borderRadius: BorderRadius.circular(0.0),
            //   ),
            // ),



            Positioned(
              bottom: 0,
              child: Container(
                height: 46,
                width: MediaQuery.of(context).size.width/2 - 2,
                color: Colors.black.withOpacity(0.2),
              ),
            ),
            Positioned(
              bottom: 8,
              left: 8,
              child: Container(
                height: 26,
                width: 26,
              child:  Material(
                  child: document['cphotourl']!=null
                      ? CachedNetworkImage(
                    placeholder: (context, url) => Container(
                      child: Image.asset(
                        "assets/images/ic_logo2.png",
                        width: 20.0,
                        height: 20.0,
                        fit: BoxFit.contain,color: Colors.orange,
                      ),
                      width:20.0,
                      height: 20.0,
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
                    ),                       imageUrl:document['cphotourl'],
                    width: 20.0,
                    height: 20.0,
                    fit: BoxFit.cover,
                  )
                      : Icon(
                    Icons.account_circle,
                    size: 26.0,
                    color: greyColor,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(25.0)),
                  clipBehavior: Clip.hardEdge,
                ),
                // decoration: BoxDecoration(
                //   border: new Border.all(
                //     color: Colors.black,
                //     width: 1.0,
                //   ),
                //   image: DecorationImage(
                //     image: NetworkImage(document['cphotourl']==null||document['cphotourl']==""?
                //     "https://i.pinimg.com/564x/0c/3b/3a/0c3b3adb1a7530892e55ef36d3be6cb8.jpg"  :document['cphotourl']),
                //     fit: BoxFit.fill,
                //   ),
                //   shape: BoxShape.circle,
                // ),
              ),

            ),

            Positioned(
              bottom: 23,
              right: 10,
              child: Icon(Icons.favorite_border,color: Colors.grey[300], size: 14,),
            ),
            Positioned(
              bottom: 21,
              right: 29,
              child: Container(
                child: Text(
                  "${document['likes']}",
                  style: TextStyle(
                      fontSize: 10,
                      color: Colors.grey[300]

                  ),

                ),
              ),
            ),
            Positioned(
              bottom: 5,
              right: 10,
              child: Icon(Icons.visibility,color: Colors.grey[300], size: 14,),
            ),
            Positioned(
              bottom: 3,
              right: 29,
              child: Container(
                child: Text(
                  "${document['seens']}",
                  style: TextStyle(
                      fontSize: 10,
                      color: Colors.grey[300]

                  ),

                ),
              ),
            )

          ],
        ),
      ),
    );
  }

  Widget firebasedata(
      BuildContext context, int index, DocumentSnapshot document) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => AllVideos(
                    document['carrange'], document['cdepart'], null)));
      },
      child: Padding(
        padding: const EdgeInsets.all(0.0),
        child: Stack(
          children: [
            Container(
              //   height: 200,
              decoration: BoxDecoration(
                border: new Border.all(
                  color: Colors.white,
                  width: 0,
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
                borderRadius: BorderRadius.circular(0.0),
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
                  child: Text(
                    document['ctitle'] == null || document['ctitle'] == ""
                        ? "عنوان غير معلوم"
                        : document['ctitle'],
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold),
                  ),
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
                    image: NetworkImage(document['cphotourl'] == null ||
                            document['cphotourl'] == ""
                        ? "https://i.pinimg.com/564x/0c/3b/3a/0c3b3adb1a7530892e55ef36d3be6cb8.jpg"
                        : document['cphotourl']),
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
}
