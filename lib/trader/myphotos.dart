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
import 'package:priceme/Splash.dart';
import 'package:priceme/Videos/addVideo.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:priceme/classes/FaultsClass.dart';
import 'package:priceme/classes/SparePartsClass.dart';
import 'package:priceme/classes/SparePartsSizesClass.dart';
import 'package:priceme/screens/addphoto.dart';
import 'package:priceme/screens/displayphoto.dart';
import 'package:priceme/ui_utile/myColors.dart';
import 'package:toast/toast.dart';
import 'package:firebase_core/firebase_core.dart';

class MyPhotos extends StatefulWidget {
  MyPhotos();

  @override
  _MyPhotosState createState() => _MyPhotosState();
}

class _MyPhotosState extends State<MyPhotos> {

  String filePath,_userId;


  @override
  void initState() {
    super.initState();

    FirebaseAuth.instance.currentUser().then((user) => user == null
        ? Navigator.of(context, rootNavigator: false).push(MaterialPageRoute(
        builder: (context) => Splash(), maintainState: false))
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
    return SafeArea(
          child: Scaffold(
         appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 2,
            centerTitle: true,
            title: Text("صوري", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),),
            automaticallyImplyLeading: false,
            actions: [
              IconButton(
                onPressed: (){
                  Navigator.pop(context);
                },
                icon: Icon(Icons.arrow_forward, color: Colors.grey,),
              ),

              SizedBox(width: 10,),
            ],
           
          ),
        floatingActionButton: FloatingActionButton(
          heroTag: "unique19",
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AddPhoto()));
          },
          backgroundColor: MyColors.primaryColor,
          elevation: 20.0,
          child: Icon(
            Icons.add_photo_alternate,
            size: 30,
            color: Colors.white,
          ),
        ),

        backgroundColor: const Color(0xffffffff),
        body: Container(
          width: width,
          height: height,
          child:
          StreamBuilder(
            stream: Firestore.instance
                    .collection('photos')
                    .orderBy('carrange',
                    descending:
                    true).where("cuserId", isEqualTo:_userId)
                    .snapshots(), //imgColRef.snapshots(includeMetadataChanges: true),
            builder: (context, snapshot) {
              if (snapshot.data?.documents == null || !snapshot.hasData)
                return Center(child: noPictures());

              return Hero(
                tag: 'imageHero',
                child: Container(
                  child: StaggeredGridView.countBuilder(
                      itemCount: snapshot.data.documents.length,
                      crossAxisCount: 2,
      itemBuilder: (context, index) {
                return Slidable(
                  actionPane: SlidableDrawerDismissal(),
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
                                            Firestore.instance.collection("photos")
                                                .document(snapshot.data.documents[index]["cId"])
                                                .delete().whenComplete(() =>
                                                setState(()  {
                                                  Navigator.pop(context);
                                                  Toast.show("تم الحذف", context,
                                                      duration: Toast.LENGTH_SHORT,
                                                      gravity: Toast.BOTTOM);
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              MyPhotos()));
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
                  child: firebasedata(
                      context, index, snapshot.data.documents[index]),
                );
              },
                      staggeredTileBuilder: (index) =>
                          StaggeredTile.count(1, index.isEven ? 1.2 : 1.8)),
                ),
              );
            },
          ),
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
                builder: (context) => DisplayPhoto(document['imgurl'])));

      },
      child: Padding(
        padding: const EdgeInsets.all(0.0),
        child: Stack(
          children: [
            Container(
             // height: 200,
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
                      document['imgurl']
                  ),

                  fit: BoxFit.fill,
                ),
                borderRadius: BorderRadius.circular(0.0),
              ),
            ),
            Positioned(
                bottom: 5,
                right: 5,
                child: Container(
                  color: Colors.black38,
                  child: Text( document['ctitle']==null||document['ctitle']==""?"عنوان غير معلوم":document['ctitle']
                    ,style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold),),
                )),
          ],
        ),
      ),
    );
  }

  Widget noPictures(){
    return Container(
      width: 250,
      height: 254,
      child: Stack(

        children: [
          Opacity(
            opacity: 0.5,
            child: Image.asset("assets/images/no_pictures.png"),
          ),


          Positioned(
            top: 190,
            left: 85,

            child: Text("لا توجد صور", textDirection: TextDirection.rtl,
              style: TextStyle(fontSize: 12, color: MyColors.primaryColor, fontWeight: FontWeight.bold ),),
          ),

          Positioned(
            top: 212,
            left: 20,

            child: Text("لم تقم بإضافة أي صور لحد الآن",
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.center,
              maxLines: 2,
              style: TextStyle(fontSize: 12, color: Colors.grey[600], ),),
          ),
        ],
      ),
    );
  }
}
