import 'package:adobe_xd/gradient_xd_transform.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'package:priceme/classes/FaultsClass.dart';
import 'package:priceme/classes/SparePartsClass.dart';
import 'package:priceme/classes/SparePartsSizesClass.dart';
import 'package:social_media_widgets/instagram_story_swipe.dart';
import 'package:toast/toast.dart';
import 'package:firebase_core/firebase_core.dart';
import 'addadv.dart';
import 'hometest.dart';

class HomePage extends StatefulWidget {
  //List<String> sparepartsList;
  HomePage();

  @override
  _HomePageState createState() => _HomePageState();
}

//db ref
final fcmReference = FirebaseDatabase.instance.reference().child('Fcm-Token');

class _HomePageState extends State<HomePage> {
  List<SparePartsSizesClass> sparepartsList = [];
  List<SparePartsSizesClass> faultsList = [];
  List<FaultsClass> subfaultsList = [];
  List<FaultsClass> subsparesList = [];

  bool subfaultcheck = false;
  bool subsparescheck = false;

  String mfault = "";

  bool _load = false;

  @override
  void initState() {
    super.initState();
    getSparepartsData();
    getfaultsData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      // appBar: AppBar(
      // title: const Text('AppBar Demo'),),
      backgroundColor: const Color(0xffffffff),
      body: Container(
        width: width,
        height: height,
//        decoration: new BoxDecoration(
//          image: new DecorationImage(
//            image: new AssetImage("assets/images/ic_background.png"),
//            fit: BoxFit.cover,
//          ),
//        ),
        child: ListView(
          physics: BouncingScrollPhysics(),
          //mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 7),
              child: Expanded(
                child: Container(
                  width: 100,
                  height: 200,
                  child: ListView(
                    reverse: true,
                    physics: BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    children: [
                      InkWell(
                        onTap: () {
                          _onInstagramStorySwipeClicked();
                        },
                        child: Container(
                          width: 100,
                          height: 200,
                          decoration: BoxDecoration(
                            border: new Border.all(
                              color: Colors.black,
                              width: 3,
                            ),
                            image: DecorationImage(
                              image: NetworkImage(
                                  "https://firebasestorage.googleapis.com/v0/b/souqnagran-49abe.appspot.com/o/PhotoChating%2Fimg_1595263302880.jpg?alt=media&token=0cfa7d1c-8e98-4ef0-aeb4-6befd8cbe203"),
                              fit: BoxFit.fill,
                            ),
                            borderRadius: BorderRadius.circular(9.0),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 40.0,
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment(-0.93, 0.0),
                    radius: 1.092,
                    colors: [
                      const Color(0xffff2121),
                      const Color(0xffff5423),
                      const Color(0xffff7024),
                      const Color(0xffff904a)
                    ],
                    stops: [0.0, 0.562, 0.867, 1.0],
                    transform: GradientXDTransform(1.0, 0.0, 0.0, 1.837, 0.0,
                        -0.419, Alignment(-0.93, 0.0)),
                  ),
//                color: Colors.orange,
                ),
                child: Text(
                  "قطع غيار",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              height: 150,
              child: Expanded(
                  child: Center(
                child: sparepartsList.length == 0
                    ? new Text("برجاء الإنتظار")
                    : new ListView.builder(
                        //  controller: _depcontroller,
                        physics: BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        reverse: true,
                        itemCount: sparepartsList.length,
                        itemBuilder: (BuildContext ctxt, int index) {
                          return InkWell(
                            onTap: () {
                              setState(() {
                                mfault = sparepartsList[index].sName;
                                sparepartsList[index].ssizecheck =
                                    !sparepartsList[index].ssizecheck;
                                if (sparepartsList[index].ssizecheck) {
                                  setState(() {
                                    sparepartsList[index].ssize = 100;
                                    subsparescheck = true;
                                  });
                                } else {
                                  setState(() {
                                    sparepartsList[index].ssize = 75;
                                    subsparescheck = false;
                                  });
                                }
                              });
                              for (var i = 0; i < sparepartsList.length; i++) {
                                if (i != index)
                                  setState(() {
                                    setState(() {
                                      sparepartsList[i].ssize = 75;
                                    });
                                  });
                              }

                              setState(() {
                                final SparePartsReference = Firestore.instance;
                                subsparesList.clear();

                                SparePartsReference.collection("subspares")
                                    .document(sparepartsList[index].sid)
                                    .collection("subsparesid")
                                    .getDocuments()
                                    .then((QuerySnapshot snapshot) {
                                  snapshot.documents.forEach((fault) {
                                    FaultsClass fp = FaultsClass(
                                      fault.data['fid'],
                                      fault.data['fName'],
                                      fault.data['fsubId'],
                                      fault.data['fsubName'],
                                      fault.data['fsubDesc'],
                                      fault.data['fsubUrl'],
                                    );
                                    setState(() {
                                      subsparesList.add(fp);
                                      // print(sparepartsList.length.toString() + "llll");
                                    });
                                  });
                                }).whenComplete(() {
                                  setState(() {});
                                });
                              });
                              // Navigator.push(
                              //     context,
                              //     MaterialPageRoute(
                              //         builder: (context) => AddAdv(widget.sparepartsList,"قطع غيار",mfault, sparepartsList[index].sName)));
                            },
                            child: Container(
                              width: 100,
                              height: 100,
                              child: Column(
                                children: [
                                  Container(
                                    height: sparepartsList[index].ssize,
                                    width: sparepartsList[index].ssize,
                                    // child: Text(
                                    //   sparepartsList[index].sName, style: TextStyle(color: Colors.red,fontSize: 20
                                    // ),textAlign: TextAlign.center,
                                    //
                                    // ),
                                    decoration: BoxDecoration(
                                      border: new Border.all(
                                        color: Colors.red,
                                        width: 2.5,
                                      ),
                                      image: DecorationImage(
                                        image: NetworkImage(
                                            sparepartsList[index].surl),
                                        fit: BoxFit.fill,
                                      ),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      sparepartsList[index].sName,
                                      style: TextStyle(
                                          color: Colors.red, fontSize: 15),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
              )),
            ),
            subsparescheck
                ? Container(
                    height: 200,
                    child: subsparesList.length == 0
                        ? Center(child: new Text("برجاء الإنتظار"))
                        : Card(
                      color: Colors.white,
                      elevation: 10,
                            shape: new RoundedRectangleBorder(
                                side: new BorderSide(
                                  color: Colors.white,
                                    //color: subfaultsList[index].ccolor,
                                    width: 4.0),
                                borderRadius: BorderRadius.circular(20.0)),
                            child: new ListView.builder(
                                physics: BouncingScrollPhysics(),
                                //scrollDirection: Axis.horizontal,
                                // reverse: true,
                                itemCount: subsparesList.length,
                                itemBuilder: (BuildContext ctxt, int index) {
                                  return InkWell(
                                    child: Container(
//                                        color: departlist1[index].ccolor,
//                                      color: Colors.white,
//                                      shape: new RoundedRectangleBorder(
//                                          side: new BorderSide(
//                                            color: Colors.white,
//                                              //color: subfaultsList[index].ccolor,
//                                              width: 2.0),
//                                          borderRadius:
//                                              BorderRadius.circular(10.0)),
                                      //borderOnForeground: true,

                                      child: InkWell(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) => AddAdv(
                                                      "قطع غيار",
                                                      mfault,
                                                      subsparesList[index]
                                                          .fsubName)));
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(3.0),
                                          child: ListTile(
                                            title: Text(
                                              subsparesList[index].fsubName,
                                              textDirection: TextDirection.rtl,
                                              style: TextStyle(
                                                  fontSize: 18.0,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            subtitle: Text(
                                              subsparesList[index].fsubDesc,
                                              textDirection: TextDirection.rtl,
                                              style: TextStyle(fontSize: 15.0),
                                            ),
                                            leading: Icon(Icons.arrow_back_ios,color: Colors.black,),
                                            trailing: Container(
                                              height: 120.0,
                                              width: 60.0,
                                              decoration: BoxDecoration(
                                                image: DecorationImage(
                                                  image: NetworkImage(
                                                      subsparesList[index]
                                                          .fsubUrl),
                                                  fit: BoxFit.fill,
                                                ),

                                              ),
                                            ),
                                          ),
//                             Container(
//                               child: Row(
//                                 mainAxisAlignment:
//                                 MainAxisAlignment.center,
//                                 children: [
//                                   Container(
//                                     width: 50,
//                                     height: 50,
//                                     child: new Image.network(
//                                       subfaultsList[index].fsubUrl,
//                                       fit: BoxFit.contain,
//                                     ),
//                                   ),
//                                   SizedBox(
//                                     height: 2,
//                                   ),
//                                   Padding(
//                                     padding:
//                                     const EdgeInsets.all(8.0),
//                                     child: Container(
//                                       margin:
//                                       EdgeInsets.only(right: 2),
//                                       child: Center(
//                                         child: Padding(
//                                           padding:
//                                           const EdgeInsets.only(
//                                               top: 5),
//                                           child: Text(
//                                             subfaultsList[index]
//                                                 .fsubName,
//                                             textAlign:
//                                             TextAlign.center,
//                                             style: TextStyle(
//                                               color: const Color(
//                                                   0xff171732),
// //                                                              fontFamily: "Estedad-Black",
//                                               fontWeight:
//                                               FontWeight.bold,
//                                               fontSize: 12,
//                                               height: 0,
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
                                        ),
                                      ),
                                    ),
                                    /**  _firebasedatdepart1(
                            index,
                            departlist1.length,
                            departlist1[index].id,
                            departlist1[index].title,
                            departlist1[index].subtitle,
                            departlist1[index].uri,
                            ),**/
                                  );
                                }),
                          ),
                  )
                : Container(),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 40.0,
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment(-0.93, 0.0),
                  radius: 1.092,
                  colors: [
                    const Color(0xffff2121),
                    const Color(0xffff5423),
                    const Color(0xffff7024),
                    const Color(0xffff904a)
                  ],
                  stops: [0.0, 0.562, 0.867, 1.0],
                  transform: GradientXDTransform(
                      1.0, 0.0, 0.0, 1.837, 0.0, -0.419, Alignment(-0.93, 0.0)),
                ),
              ),
              child: Text(
                "الاعطال",
                style: TextStyle(color: Colors.white, fontSize: 20),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              height: 150,
              child: Expanded(
                  child: Center(
                child: faultsList.length == 0
                    ? new Text("برجاء الإنتظار")
                    : new ListView.builder(
                        //  controller: _depcontroller,
                        physics: BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        reverse: true,
                        itemCount: faultsList.length,
                        itemBuilder: (BuildContext ctxt, int index) {
                          return InkWell(
                            onTap: () {
                              setState(() {
                                mfault = faultsList[index].sName;

                                faultsList[index].ssizecheck =
                                    !faultsList[index].ssizecheck;
                                if (faultsList[index].ssizecheck) {
                                  faultsList[index].ssize = 100;
                                  subfaultcheck = true;
                                } else {
                                  faultsList[index].ssize = 75;
                                  subfaultcheck = false;
                                }
                              });

                              for (var i = 0; i < faultsList.length; i++) {
                                if (i != index)
                                  setState(() {
                                    faultsList[i].ssize = 75;
                                  });
                              }
                              setState(() {
                                final SparePartsReference = Firestore.instance;
                                subfaultsList.clear();

                                SparePartsReference.collection("subfaults")
                                    .document(faultsList[index].sid)
                                    .collection("subfaultid")
                                    .getDocuments()
                                    .then((QuerySnapshot snapshot) {
                                  snapshot.documents.forEach((fault) {
                                    FaultsClass fp = FaultsClass(
                                      fault.data['fid'],
                                      fault.data['fName'],
                                      fault.data['fsubId'],
                                      fault.data['fsubName'],
                                      fault.data['fsubDesc'],
                                      fault.data['fsubUrl'],
                                    );
                                    setState(() {
                                      subfaultsList.add(fp);
                                      // print(sparepartsList.length.toString() + "llll");
                                    });
                                  });
                                }).whenComplete(() {
                                  setState(() {});
                                });
                              });
                            },
                            child: Container(
                              width: 100,
                              height: 100,
                              child: Column(
                                children: [
                                  Container(
                                    height: faultsList[index].ssize,
                                    width: faultsList[index].ssize,
                                    // child: Text(
                                    //   sparepartsList[index].sName, style: TextStyle(color: Colors.red,fontSize: 20
                                    // ),textAlign: TextAlign.center,
                                    //
                                    // ),
                                    decoration: BoxDecoration(
                                      border: new Border.all(
                                        color: Colors.red,
                                        width: 2.5,
                                      ),
                                      image: DecorationImage(
                                        image: NetworkImage(
                                            faultsList[index].surl),
                                        fit: BoxFit.fill,
                                      ),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      faultsList[index].sName,
                                      style: TextStyle(
                                          color: Colors.red, fontSize: 15),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
              )),
            ),
            subfaultcheck
                ? Container(
                    height: 400,
                    child: subfaultsList.length == 0
                        ? Center(child: new Text("برجاء الإنتظار"))
                        : new ListView.builder(
                            physics: BouncingScrollPhysics(),
                            //scrollDirection: Axis.horizontal,
                            // reverse: true,
                            itemCount: subfaultsList.length,
                            itemBuilder: (BuildContext ctxt, int index) {
                              return InkWell(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 5.0, right: 5.0, left: 5.0),
                                  child: Card(
//                                        color: departlist1[index].ccolor,
                                    color: Colors.white,
                                    shape: new RoundedRectangleBorder(
                                        side: new BorderSide(
                                            //color: subfaultsList[index].ccolor,
                                            width: 2.0),
                                        borderRadius:
                                            BorderRadius.circular(10.0)),
                                    //borderOnForeground: true,
                                    elevation: 10.0,
                                    margin: EdgeInsets.all(1),
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => AddAdv(
                                                    "اعطال",
                                                    mfault,
                                                    subfaultsList[index]
                                                        .fsubName)));
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(3.0),
                                        child: ListTile(
                                          title: Text(
                                            subfaultsList[index].fsubName,
                                            textDirection: TextDirection.rtl,
                                            style: TextStyle(
                                                fontSize: 18.0,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          subtitle: Text(
                                            subfaultsList[index].fsubDesc,
                                            textDirection: TextDirection.rtl,
                                            style: TextStyle(fontSize: 15.0),
                                          ),
                                          leading: Icon(Icons.arrow_back_ios),
                                          trailing: Container(
                                            height: 120.0,
                                            width: 60.0,
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                image: NetworkImage(
                                                    subfaultsList[index]
                                                        .fsubUrl),
                                                fit: BoxFit.fill,
                                              ),
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                        ),
//                             Container(
//                               child: Row(
//                                 mainAxisAlignment:
//                                 MainAxisAlignment.center,
//                                 children: [
//                                   Container(
//                                     width: 50,
//                                     height: 50,
//                                     child: new Image.network(
//                                       subfaultsList[index].fsubUrl,
//                                       fit: BoxFit.contain,
//                                     ),
//                                   ),
//                                   SizedBox(
//                                     height: 2,
//                                   ),
//                                   Padding(
//                                     padding:
//                                     const EdgeInsets.all(8.0),
//                                     child: Container(
//                                       margin:
//                                       EdgeInsets.only(right: 2),
//                                       child: Center(
//                                         child: Padding(
//                                           padding:
//                                           const EdgeInsets.only(
//                                               top: 5),
//                                           child: Text(
//                                             subfaultsList[index]
//                                                 .fsubName,
//                                             textAlign:
//                                             TextAlign.center,
//                                             style: TextStyle(
//                                               color: const Color(
//                                                   0xff171732),
// //                                                              fontFamily: "Estedad-Black",
//                                               fontWeight:
//                                               FontWeight.bold,
//                                               fontSize: 12,
//                                               height: 0,
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
                                      ),
                                    ),
                                  ),
                                ),
                                /**  _firebasedatdepart1(
                          index,
                          departlist1.length,
                          departlist1[index].id,
                          departlist1[index].title,
                          departlist1[index].subtitle,
                          departlist1[index].uri,
                          ),**/
                              );
                            }),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }

  _onInstagramStorySwipeClicked() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => InstagramStorySwipe(
          children: <Widget>[
            Container(
              color: Colors.redAccent,
            ),
            Container(
              color: Colors.green,
            ),
            Container(
              color: Colors.brown,
            ),
            Container(
              color: Colors.yellow,
            ),
          ],
        ),
      ),
    );
  }

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
            75.0,
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
            75.0,
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
}
