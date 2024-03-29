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

class VidiosPhotoComercial extends StatefulWidget {

  bool enableFilter;
  VidiosPhotoComercial(this.enableFilter);

  @override
  _VidiosPhotoComercialState createState() => _VidiosPhotoComercialState();
}

class _VidiosPhotoComercialState extends State<VidiosPhotoComercial> {

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
  bool enableFilter = false;

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

        /*
        floatingActionButton: Container(

        child: FloatingActionButton(
          heroTag: "unique55",
          onPressed: () {
            setState(() {
              chechsearch=!chechsearch;
            });
          },
          backgroundColor: Colors.orange,
          elevation: 20.0,
          child: Icon(
            Icons.search,
            size: 30,
            color: const Color(0xff171732),
          ),
        ),
      ),
      */
        backgroundColor: Colors.white,
        body: commercialVideosScreen()

        /*
      ListView(
        children: [

          /*
          chechsearch?   Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: 50,width: 150,
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Card(
                    elevation: 0.0,
                    color: const Color(0xff171732),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: DropdownButtonHideUnderline(
                        child: ButtonTheme(
                          alignedDropdown: true,
                          child: DropdownButton<String>(
                            items: sortlist
                                .map((String value) {
                              return new DropdownMenuItem<String>(
                                value: value,
                                child: new Text(value),
                              );
                            }).toList(),
                            value: _sortcurrentItemSelected,
                            onChanged: (String newValueSelected) {
                              // Your code to execute, when a menu item is selected from dropdown
                              _onDropDownItemSelectedsort(
                                  newValueSelected);
                            },
                            style: new TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        )),
                  ),
                ),
              ),
              Container(
                height: 50,width: 150,
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Card(
                    elevation: 0.0,
                    color: const Color(0xff171732),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: DropdownButtonHideUnderline(
                        child: ButtonTheme(
                          alignedDropdown: true,
                          child: DropdownButton<String>(
                            items: carlist
                                .map((String value) {
                              return new DropdownMenuItem<String>(
                                value: value,
                                child: new Text(value),
                              );
                            }).toList(),
                            value: _carcurrentItemSelected,
                            onChanged: (String newValueSelected) {
                              // Your code to execute, when a menu item is selected from dropdown
                              _onDropDownItemSelectedcar(
                                  newValueSelected);
                            },
                            style: new TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        )),
                  ),
                ),
              ),

            ],
          ):Container(),

          */
          Container(
            height: 48,
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
                          side: BorderSide(color: Colors.grey[400])
                      ),
                      child:
                      Directionality(
                        textDirection: TextDirection.rtl,
                      child: DropdownButtonHideUnderline(
                          child: ButtonTheme(
                            alignedDropdown: true,
                            child: DropdownButton<String>(
                              items: sortlist
                                  .map((String value) {
                                return new DropdownMenuItem<String>(
                                  value: value,
                                  child: new Text(value),
                                );
                              }).toList(),
                              value: _sortcurrentItemSelected,
                              onChanged: (String newValueSelected) {
                                // Your code to execute, when a menu item is selected from dropdown
                                _onDropDownItemSelectedsort(
                                    newValueSelected);
                              },
                              style: new TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                                fontWeight: FontWeight.w300,
                                fontFamily: 'Cairo'
                              ),
                            ),
                          )),
                      )

                    )
                ),
                Container(
                    margin: EdgeInsets.only(right: 10),
                    height: 40,
                    //width: 100,
                    child: Card(
                      elevation: 0.0,
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                        side: BorderSide(color: Colors.grey[400])
                      ),
                      child:

                      Directionality(
                        textDirection: TextDirection.rtl,
                       child: DropdownButtonHideUnderline(
                           child: ButtonTheme(
                             alignedDropdown: true,
                             child: DropdownButton<String>(
                               items: carlist
                                   .map((String value) {
                                 return new DropdownMenuItem<String>(
                                   value: value,
                                   child: new Text(value),
                                 );
                               }).toList(),
                               value: _carcurrentItemSelected,
                               onChanged: (String newValueSelected) {
                                 // Your code to execute, when a menu item is selected from dropdown
                                 _onDropDownItemSelectedcar(
                                     newValueSelected);
                               },
                               style: new TextStyle(
                                 color: Colors.grey,
                                   fontSize: 12,
                                   fontWeight: FontWeight.w300,
                                   fontFamily: 'Cairo'
                               ),
                             ),
                           )),
    )

                    )
                  ),



              ],
            )
          ),
          SizedBox(height: 10,),

          Container(
            width: width,
            height: height,
            child:
            StreamBuilder(
                stream: _sortcurrentItemSelected==sortlist[0]? Firestore.instance
                    .collection('videos')
                    .where("cdepart", isEqualTo:"تجارى")
                    .where("ccar", isEqualTo:filt)
                    .orderBy('carrange',
                    descending:
                    true)
                    .snapshots():Firestore.instance
                    .collection('videos')
                    .where("cdepart", isEqualTo:"تجارى")
                    .where("ccar", isEqualTo:filt)
                    .orderBy('seens',
                    descending:
                    true)
                    .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.data?.documents == null || !snapshot.hasData)
                  return Center(child: Text("لا يوجد بيانات...",));
                return Hero(
                  tag: 'imageHero',
                  child: Container(
                    child: StaggeredGridView.countBuilder(
                        itemCount: snapshot.data.documents.length,
                        crossAxisCount: 2,
                        itemBuilder: (context, index) {
                          return firebasedata(
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
        ],
      ),

    */
        );
  }

  Widget commercialVideosScreen() {
    return Column(
      children: [

        widget.enableFilter?
        Container(
            height: 48,
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
            )):
        SizedBox(),


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
                      .where("ccar", isEqualTo: filt)
                      .orderBy('carrange', descending: true)
                      .snapshots()
                  : Firestore.instance
                      .collection('videos')
                      .where("cdepart", isEqualTo: "تجارى")
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
