
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:priceme/Splash.dart';
import 'package:priceme/classes/AdvClass.dart';
import 'package:priceme/screens/editadv.dart';
import 'package:toast/toast.dart';

import 'advdetail.dart';

class MyAdvertisement extends StatefulWidget {
  MyAdvertisement();
  @override
  _MyAdvertisementState createState() => _MyAdvertisementState();
}

class _MyAdvertisementState extends State<MyAdvertisement> {
  List<AdvClass> advlist = [];
  bool _load = false;
  String _userId="";
  List<String> _imageUrls;


  @override
  void initState() {
    super.initState();

    FirebaseAuth.instance.currentUser().then((user) => user == null
        ? Navigator.of(context, rootNavigator: false).push(MaterialPageRoute(
        builder: (context) => Splash(), maintainState: false))

        : setState(() {_userId = user.uid;}));
  }




  final double _minimumPadding = 5.0;
  var _controller = ScrollController();


  @override
  Widget build(BuildContext context) {
    Widget loadingIndicator = _load
        ? new Container(
      child: SpinKitCircle(color: Colors.black),
    )
        : new Container();
    TextStyle textStyle = Theme.of(context).textTheme.subtitle;
    return Scaffold(
      backgroundColor: const Color(0xffffffff),
      floatingActionButton: Container(
        height: 30.0,
        width: 30.0,
        child: FittedBox(
          child: FloatingActionButton(
            heroTag: "unique9",
            onPressed: () {
              _controller.animateTo(0.0,
                  curve: Curves.easeInOut, duration: Duration(seconds: 1));
            },
            backgroundColor: Colors.white,
            elevation: 20.0,
            child: Icon(
              Icons.arrow_drop_up,
              size: 50,
              color: const Color(0xff171732),
            ),
          ),
        ),
      ),
      body: StreamBuilder(
        stream: Firestore.instance.collection('advertisments').orderBy('carrange', descending: true)//.where("cproblemtype", isEqualTo:"قطع غيار")
            .where("userId", isEqualTo:_userId).snapshots(),
        //print an integer every 2secs, 10 times
        builder: (context, snapshot) {
          if (snapshot.data?.documents == null || !snapshot.hasData)
            return Center(child: Text("لا يوجد بيانات...",));
          return Container(
            child: ListView(
              shrinkWrap: true,
              children: <Widget>[
                Container(
                    padding: EdgeInsets.all(10),
                    child: SingleChildScrollView(
                      child: GridView.builder(
                        physics: ScrollPhysics(),
                        shrinkWrap: true,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 6,
                          childAspectRatio: MediaQuery.of(context).size.width /
                              (MediaQuery.of(context).size.height*0.6),
                        ),
                        itemCount:snapshot.data.documents.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Slidable(
                              actionPane: SlidableDrawerDismissal(),
                              secondaryActions: <Widget>[
                                Container(
                                  padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                                  child: IconSlideAction(
                                    caption: 'تعديل',
                                    color: Colors.green,
                                    icon: Icons.edit,
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        new MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                            new EditAdv(
                                              index,
                                              snapshot.data.documents.length,
                                              snapshot.data.documents[index]["carrange"],
                                              snapshot.data.documents[index]["advid"],
                                              snapshot.data.documents[index]["cNew"],
                                              snapshot.data.documents[index]["caudiourl"],
                                              snapshot.data.documents[index]["cbody"],
                                              snapshot.data.documents[index]["ccar"],
                                              snapshot.data.documents[index]["ccarversion"],
                                              snapshot.data.documents[index]["cdate"],
                                              snapshot.data.documents[index]["cdiscribtion"],
                                              snapshot.data.documents[index]["cimagelist"],
                                              snapshot.data.documents[index]["cmodel"],
                                              snapshot.data.documents[index]["cproblemtype"],
                                              snapshot.data.documents[index]["ctitle"],
                                              snapshot.data.documents[index]["curi"],
                                              snapshot.data.documents[index]["mfault"],
                                              snapshot.data.documents[index]["pname"],
                                              snapshot.data.documents[index]["pphone"],
                                              snapshot.data.documents[index]["sparepart"],
                                              snapshot.data.documents[index]["subfault"],
                                              snapshot.data.documents[index]["userId"],
                                            )),
                                      );
                                    },
                                  ),
                                )
                              ],
                              actions: <Widget>[
                                Container(
                                    padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                                    child: IconSlideAction(
                                      caption: 'Delete',
                                      color: Colors.red,
                                      icon: Icons.delete,
                                      onTap: () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) =>
                                          new CupertinoAlertDialog(
                                            title: new Text("تنبية"),
                                            content: new Text("تبغي تحذف اعلانك؟"),
                                            actions: [
                                              CupertinoDialogAction(
                                                  isDefaultAction: false,
                                                  child: new FlatButton(
                                                    onPressed: () {

                                                      setState(() {
                                                        Firestore.instance.collection("advertisments")
                                                            .document(snapshot.data.documents[index]["advid"])
                                                            .delete().whenComplete(() =>
                                                            setState(() async {
                                                              Navigator.pop(context);
                                                              Toast.show("تم الحذف", context,
                                                                  duration: Toast.LENGTH_SHORT,
                                                                  gravity: Toast.BOTTOM);
                                                              _imageUrls = snapshot.data.documents[index]["cimagelist"]
                                                                  .replaceAll(" ", "")
                                                                  .replaceAll("[", "")
                                                                  .replaceAll("]", "")
                                                                  .split(",");

                                                              for(String imge in _imageUrls){

                                                                final StorageReference storageRef =
                                                                await FirebaseStorage.instance.getReferenceFromUrl(imge);
                                                                //   print("hhhhhhhhhhhhhhh${storageRef.path}");
                                                                await storageRef.delete().whenComplete(() {
                                                                });
                                                              }
                                                              this.reassemble();
                                                            }));
                                                      });
                                                    }
                                                    ,
                                                    child: Text("موافق"),
                                                  )),
                                              CupertinoDialogAction(
                                                  isDefaultAction: false,
                                                  child: new FlatButton(
                                                    onPressed: () =>
                                                        Navigator.pop(context),
                                                    child: Text("إلغاء"),
                                                  )),
                                            ],
                                          ),
                                        );
                                      },
                                    )),
                              ],
                              child: myAdvItemWidget(context, snapshot.data.documents[index]));
                        },
                      ),
                    ))
              ],
            ),
          );

          // return Hero(
          //   tag: 'imageHero2',
          //   child: Container(
          //     child: StaggeredGridView.countBuilder(
          //         itemCount: snapshot.data.documents.length,
          //         crossAxisCount: 2,
          //         itemBuilder: (context, index) {
          //           return  Slidable(
          //             actionPane: SlidableDrawerDismissal(),
          //             secondaryActions: <Widget>[
          //               Container(
          //                 padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
          //                 child: IconSlideAction(
          //                   caption: 'تعديل',
          //                   color: Colors.green,
          //                   icon: Icons.edit,
          //                   onTap: () {
          //                     Navigator.push(
          //                       context,
          //                       new MaterialPageRoute(
          //                           builder: (BuildContext context) =>
          //                           new EditAdv(
          //                             index,
          //                             snapshot.data.documents.length,
          //                             snapshot.data.documents[index]["carrange"],
          //                             snapshot.data.documents[index]["advid"],
          //                             snapshot.data.documents[index]["cNew"],
          //                             snapshot.data.documents[index]["caudiourl"],
          //                             snapshot.data.documents[index]["cbody"],
          //                             snapshot.data.documents[index]["ccar"],
          //                             snapshot.data.documents[index]["ccarversion"],
          //                             snapshot.data.documents[index]["cdate"],
          //                             snapshot.data.documents[index]["cdiscribtion"],
          //                             snapshot.data.documents[index]["cimagelist"],
          //                             snapshot.data.documents[index]["cmodel"],
          //                             snapshot.data.documents[index]["cproblemtype"],
          //                             snapshot.data.documents[index]["ctitle"],
          //                             snapshot.data.documents[index]["curi"],
          //                             snapshot.data.documents[index]["mfault"],
          //                             snapshot.data.documents[index]["pname"],
          //                             snapshot.data.documents[index]["pphone"],
          //                             snapshot.data.documents[index]["sparepart"],
          //                             snapshot.data.documents[index]["subfault"],
          //                             snapshot.data.documents[index]["userId"],
          //                             snapshot.data.documents[index]["fPlaceName"],
          //                             snapshot.data.documents[index]["fromPLat"],
          //                             snapshot.data.documents[index]["fromPLng"],
          //                           )),
          //                     );
          //                   },
          //                 ),
          //               )
          //
          //             ],
          //             actions: <Widget>[
          //               Container(
          //                   padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
          //                   child: IconSlideAction(
          //                     caption: 'Delete',
          //                     color: Colors.red,
          //                     icon: Icons.delete,
          //                     onTap: () {
          //                       showDialog(
          //                         context: context,
          //                         builder: (BuildContext context) =>
          //                         new CupertinoAlertDialog(
          //                           title: new Text("تنبية"),
          //                           content: new Text("تبغي تحذف اعلانك؟"),
          //                           actions: [
          //                             CupertinoDialogAction(
          //                                 isDefaultAction: false,
          //                                 child: new FlatButton(
          //                                   onPressed: () {
          //
          //                                     setState(() {
          //                                       Firestore.instance.collection("advertisments")
          //                                           .document(snapshot.data.documents[index]["advid"])
          //                                           .delete().whenComplete(() =>
          //                                           setState(() async {
          //                                             Navigator.pop(context);
          //                                             Toast.show("تم الحذف", context,
          //                                                 duration: Toast.LENGTH_SHORT,
          //                                                 gravity: Toast.BOTTOM);
          //                                             _imageUrls = snapshot.data.documents[index]["cimagelist"]
          //                                                 .replaceAll(" ", "")
          //                                                 .replaceAll("[", "")
          //                                                 .replaceAll("]", "")
          //                                                 .split(",");
          //
          //                                             for(String imge in _imageUrls){
          //
          //                                               final StorageReference storageRef =
          //                                               await FirebaseStorage.instance.getReferenceFromUrl(imge);
          //                                               //   print("hhhhhhhhhhhhhhh${storageRef.path}");
          //                                               await storageRef.delete().whenComplete(() {
          //                                               });
          //                                             }
          //                                             this.reassemble();
          //                                           }));
          //                                     });
          //                                   }
          //                                   ,
          //                                   child: Text("موافق"),
          //                                 )),
          //                             CupertinoDialogAction(
          //                                 isDefaultAction: false,
          //                                 child: new FlatButton(
          //                                   onPressed: () =>
          //                                       Navigator.pop(context),
          //                                   child: Text("إلغاء"),
          //                                 )),
          //                           ],
          //                         ),
          //                       );
          //                     },
          //                   )),
          //             ],
          //
          //           );
          //         },
          //         staggeredTileBuilder: (index) =>
          //             StaggeredTile.count(1, index.isEven ? 1.2 : 1.8)),
          //   ),
          // );
          // return new ListView.builder(
          //     physics: BouncingScrollPhysics(),
          //     shrinkWrap: true,
          //     controller: _controller,
          //     itemCount: snapshot.data.documents.length,
          //     itemBuilder: (context, index) {
          //       return  Slidable(
          //           actionPane: SlidableDrawerDismissal(),
          //       child:firebasedata(context,index, snapshot.data.documents[index]),
          //         secondaryActions: <Widget>[
          //           Container(
          //             padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
          //             child: IconSlideAction(
          //               caption: 'تعديل',
          //               color: Colors.green,
          //               icon: Icons.edit,
          //               onTap: () {
          //                 Navigator.push(
          //                   context,
          //                   new MaterialPageRoute(
          //                       builder: (BuildContext context) =>
          //                       new EditAdv(
          //                         index,
          //                         snapshot.data.documents.length,
          //                         snapshot.data.documents[index]["carrange"],
          //                         snapshot.data.documents[index]["advid"],
          //                         snapshot.data.documents[index]["cNew"],
          //                         snapshot.data.documents[index]["caudiourl"],
          //                         snapshot.data.documents[index]["cbody"],
          //                         snapshot.data.documents[index]["ccar"],
          //                         snapshot.data.documents[index]["ccarversion"],
          //                         snapshot.data.documents[index]["cdate"],
          //                         snapshot.data.documents[index]["cdiscribtion"],
          //                         snapshot.data.documents[index]["cimagelist"],
          //                         snapshot.data.documents[index]["cmodel"],
          //                         snapshot.data.documents[index]["cproblemtype"],
          //                         snapshot.data.documents[index]["ctitle"],
          //                         snapshot.data.documents[index]["curi"],
          //                         snapshot.data.documents[index]["mfault"],
          //                         snapshot.data.documents[index]["pname"],
          //                         snapshot.data.documents[index]["pphone"],
          //                         snapshot.data.documents[index]["sparepart"],
          //                         snapshot.data.documents[index]["subfault"],
          //                         snapshot.data.documents[index]["userId"],
          //                         snapshot.data.documents[index]["fPlaceName"],
          //                         snapshot.data.documents[index]["fromPLat"],
          //                         snapshot.data.documents[index]["fromPLng"],
          //                       )),
          //                 );
          //               },
          //             ),
          //           )
          //
          //         ],
          //         actions: <Widget>[
          //           Container(
          //               padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
          //               child: IconSlideAction(
          //                 caption: 'Delete',
          //                 color: Colors.red,
          //                 icon: Icons.delete,
          //                 onTap: () {
          //                   showDialog(
          //                     context: context,
          //                     builder: (BuildContext context) =>
          //                     new CupertinoAlertDialog(
          //                       title: new Text("تنبية"),
          //                       content: new Text("تبغي تحذف اعلانك؟"),
          //                       actions: [
          //                         CupertinoDialogAction(
          //                             isDefaultAction: false,
          //                             child: new FlatButton(
          //                               onPressed: () {
          //
          //                                     setState(() {
          //                                       Firestore.instance.collection("advertisments")
          //                                           .document(snapshot.data.documents[index]["advid"])
          //                                           .delete().whenComplete(() =>
          //                                       setState(() async {
          //                                         Navigator.pop(context);
          //                                         Toast.show("تم الحذف", context,
          //                                             duration: Toast.LENGTH_SHORT,
          //                                             gravity: Toast.BOTTOM);
          //                                         _imageUrls = snapshot.data.documents[index]["cimagelist"]
          //                                             .replaceAll(" ", "")
          //                                             .replaceAll("[", "")
          //                                             .replaceAll("]", "")
          //                                             .split(",");
          //
          //                                         for(String imge in _imageUrls){
          //
          //                                           final StorageReference storageRef =
          //                                           await FirebaseStorage.instance.getReferenceFromUrl(imge);
          //                                           //   print("hhhhhhhhhhhhhhh${storageRef.path}");
          //                                           await storageRef.delete().whenComplete(() {
          //                                           });
          //                                         }
          //                                         this.reassemble();
          //                                       }));
          //                                     });
          //                               }
          //                               ,
          //                               child: Text("موافق"),
          //                             )),
          //                         CupertinoDialogAction(
          //                             isDefaultAction: false,
          //                             child: new FlatButton(
          //                               onPressed: () =>
          //                                   Navigator.pop(context),
          //                               child: Text("إلغاء"),
          //                             )),
          //                       ],
          //                     ),
          //                   );
          //                 },
          //               )),
          //         ],
          //
          //       );
          //     });
        },
      ),
    );
  }



  Widget myAdvItemWidget(
      BuildContext context, DocumentSnapshot document) {
    return Card(
      shape: new RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(color: Colors.grey)),

      //borderOnForeground: true,
      elevation: 10.0,
      margin: EdgeInsets.only(right: 1, left: 1, bottom: 2),
      child: InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      AdvDetail(document['userId'], document['advid'])));
        },
        child: Container(
          // height: 1000,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
            child:
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              textDirection: TextDirection.rtl,
              children: [
                Expanded(child:
                Container(
                  width: double.infinity,
                  child: Stack(
                    children: [
                      Container(
                          height: double.infinity,
                          width: double.infinity,

                          child: ClipRRect(
                            borderRadius: BorderRadius.only(topRight: Radius.circular(10), topLeft: Radius.circular(10)),
                            child: document['curi'] == null
                                ? new Image.asset(
                              "assets/images/ic_logo2.png",
                            )
                                : new Image.network(
                              document['curi']

                              ,
                              fit: BoxFit.cover,
                            ),
                          )),
                      Positioned(
                        right: 0,
                        child: Container(
                          width: 66,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius:
                            BorderRadius.only(topRight: Radius.circular(10)),
                            color: Colors.black.withOpacity(0.6),
                          ),
                          child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Text(
                                document['cproblemtype'].toString(),
                                textDirection: TextDirection.rtl,
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
//                                          fontFamily: 'Estedad-Black',
                                    fontStyle: FontStyle.normal),
                              )),
                        ),
                      ),



                    ],
                  ),
                )),

                Container(
                  padding: EdgeInsets.only(right: 10, left: 10),
                  child: Text(
                    document['ctitle'].toString(),
                    textDirection: TextDirection.rtl,
                    textAlign: TextAlign.right,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 10.0,
                        fontStyle: FontStyle.normal),
                  ),
                ),

                Container(
                  padding: EdgeInsets.only(right: 10, left: 10),
                  child: Text(
                    document['pname'] != null && document['pname'].toString().length > 0? document['pname'].toString():
                    "مجهول",
                    textDirection: TextDirection.rtl,
                    textAlign: TextAlign.right,
                    style: TextStyle(
                        color: Colors.grey,
//                                  fontFamily: 'Estedad-Black',
                        fontWeight: FontWeight.normal,
                        fontSize: 8,
                        fontStyle: FontStyle.normal),
                  ),
                ),
                SizedBox(height: 10,)


              ],
            )


        ),
      ),
    );
  }


  ///////////////////////////////////////// Previous widgets ///////////////////////////////

  Widget firebasedata(BuildContext context,int index, DocumentSnapshot document) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Card(
        shape: new RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4.0)),
        //borderOnForeground: true,
        elevation: 10.0,
        margin: EdgeInsets.only(right: 1, left: 1, bottom: 2),
        child: InkWell(
          onTap: () {

            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        AdvDetail(document['userId'], document['advid'])));



          },
          child: Container(
            // height: 1000,
              child: Column(
                children: <Widget>[
                  Stack(
                    children: [
                      Container(
                        height: 200,
                        child:  document['curi'] == null
                            ? new Image.asset("assets/images/ic_logo2.png",
                        )
                            : new Image.network(
                          document['curi'],
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        top: 0,
                        left: 0,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(2.0),
                            color:const Color(0xff444460),
                          ),
                          child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child:  Text(
                                document['cproblemtype'].toString(),
                                textDirection: TextDirection.rtl,
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
//                                          fontFamily: 'Estedad-Black',
                                    fontStyle: FontStyle.normal),
                              )
                          ),

                        ),
                      ),
                      Positioned(
                        top: 0,
                        right: 0,
                        child: Container(
                            width: 100,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(2.0),
                              color:Colors.black54,
                            ),
                            child:  Padding(
                              padding: const EdgeInsets.only(right: 5),
                              child: Text(
                                "منذ: ${ document['cdate'].toString()}",
                                textDirection: TextDirection.rtl,
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
//                                  fontFamily: 'Estedad-Black',
                                    fontStyle: FontStyle.normal),
                              ),
                            )

                        ),
                      ),

                    ],
                  ),

                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text(
                      document['ctitle'].toString(),
                      textDirection: TextDirection.rtl,
                      textAlign: TextAlign.right,
                      style: TextStyle(
                          color: Colors.green,
//                                  fontFamily: 'Estedad-Black',
                          fontWeight: FontWeight.bold,
                          fontSize: 15.0,
                          fontStyle: FontStyle.normal),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[


                      Text(
                        "${document['subfault']}",
                        textDirection: TextDirection.rtl,
                        textAlign: TextAlign.right,
                        style: TextStyle(
//                                      fontFamily: 'Estedad-Black',
                            fontSize: 10.0,
                            fontStyle: FontStyle.normal),
                      ),
                      new Icon(
                        Icons.directions_car,
                        color: Colors.black,
                        size: 15,
                      ),
                    ],
                  ),
                ],
              )),
        ),
      ),
    );
  }

}
