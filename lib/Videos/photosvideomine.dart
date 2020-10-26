import 'dart:io';

import 'package:adobe_xd/gradient_xd_transform.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:path_provider/path_provider.dart';
import 'package:priceme/Videos/EditVideo.dart';
import 'package:priceme/Videos/addVideo.dart';

import 'package:priceme/classes/FaultsClass.dart';
import 'package:priceme/classes/SparePartsClass.dart';
import 'package:priceme/classes/SparePartsSizesClass.dart';
import 'package:priceme/screens/signin.dart';
import 'package:toast/toast.dart';
import 'package:firebase_core/firebase_core.dart';

import 'allvideos.dart';

class VidiosPhotoMine extends StatefulWidget {

  @override
  _VidiosPhotoMineState createState() => _VidiosPhotoMineState();
}

class _VidiosPhotoMineState extends State<VidiosPhotoMine> {

  String filePath,_userId;

  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.currentUser().then((user) => user == null
        ? Navigator.of(context, rootNavigator: false).push(MaterialPageRoute(
        builder: (context) => SignIn(), maintainState: false))

        : setState(() {_userId = user.uid;}));
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
      floatingActionButton: Container(
        height: 30.0,
        width: 30.0,
        child: FittedBox(
          child: FloatingActionButton(
            heroTag: "unique129",
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
                Icons.add,
                //size: 50,
                color: const Color(0xff171732),
              ),
            ),
          ),
        ),
      ),

      backgroundColor: const Color(0xffffffff),
      body: Container(
        width: width,
        height: height,
        child: StreamBuilder(
          stream: Firestore.instance
              .collection('videos').where("cuserId", isEqualTo:_userId)
              .orderBy('carrange',
              descending:
              true)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: Text("Loading..",));
            }

            return new GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount:2,
                ),
                physics: BouncingScrollPhysics(),
                shrinkWrap: true,
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context, index) {
                  return Slidable(
                    child: firebasedata(
                        context, index, snapshot.data.documents[index]),

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
                                  new EditVideo(
                                    snapshot.data.documents[index]["carrange"],
                                    snapshot.data.documents[index]["cId"],
                                    snapshot.data.documents[index]["cuserId"],
                                    snapshot.data.documents[index]["cname"],
                                    snapshot.data.documents[index]["cphotourl"],
                                    snapshot.data.documents[index]["cdate"],
                                    snapshot.data.documents[index]["cdepart"],
                                    snapshot.data.documents[index]["cdetail"],
                                    snapshot.data.documents[index]["curi"],
                                    snapshot.data.documents[index]["imgurl"],
                                    snapshot.data.documents[index]["ctitle"],
                                    snapshot.data.documents[index]["ccar"],
                                    snapshot.data.documents[index]["ccarversion"],
                                    snapshot.data.documents[index]["cyear"],
                                  )),
                           );
                          },
                        ),
                      ),

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
                                              Firestore.instance.collection("videos")
                                                  .document(snapshot.data.documents[index]["cId"])
                                                  .delete().whenComplete(() =>
                                                  setState(() async {
                                                    Navigator.pop(context);
                                                    Toast.show("تم الحذف", context,
                                                        duration: Toast.LENGTH_SHORT,
                                                        gravity: Toast.BOTTOM);

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

                  );


                });
          },
        ),
      ),
    );
  }



  Widget firebasedata(
      BuildContext context, int index, DocumentSnapshot document) {

    return   InkWell(
      onTap: () {
Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => AllVideos(document['carrange'],document['cdepart'])));

      },
      child: Padding(
        padding: const EdgeInsets.all(0.0),
        child: Stack(
          children: [
            Container(
              height: 200,
              decoration: BoxDecoration(
                border: new Border.all(
                  color: Colors.white,
                  width: 0,
                ),
                image: document['imgurl'] == null?DecorationImage(
                  image: AssetImage("assets/images/ic_background.png" ),
                  fit: BoxFit.fill,
                ):DecorationImage(
                  image:  NetworkImage(
                      document['imgurl']              ),

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
                bottom: 5,
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
}
