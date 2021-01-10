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
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:path_provider/path_provider.dart';
import 'package:priceme/Splash.dart';
import 'package:priceme/Videos/EditVideo.dart';
import 'package:priceme/Videos/addVideo.dart';

import 'package:priceme/classes/FaultsClass.dart';
import 'package:priceme/classes/SparePartsClass.dart';
import 'package:priceme/classes/SparePartsSizesClass.dart';
import 'package:toast/toast.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:priceme/ui_utile/myColors.dart';

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
        builder: (context) => Splash(), maintainState: false))

        : setState(() {_userId = user.uid;

        }));
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
                Icons.video_call,
                size: 32,
                color: Colors.white,
              ),
            ),
          )
        )

      )
      ,

      backgroundColor: const Color(0xffffffff),
      body: Container(
        width: width,
        height: height,
        child:
        StreamBuilder(
          stream: Firestore.instance
              .collection('videos').where("cuserId", isEqualTo:_userId)
              .orderBy('carrange',
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
                      return videoTile(
                          context, index, snapshot.data.documents[index]);
                    },
                    staggeredTileBuilder: (index) =>
                        StaggeredTile.count(1, index.isEven ? 1.2 : 1.8)),
              ),
            );
          },
        ),

      ),
    );
  }

  Widget videoTile(
      BuildContext context, int index, DocumentSnapshot document) {

    return   InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => AllVideos(document['carrange'],document['cdepart'],_userId)));

      },
      child: Padding(
        padding: const EdgeInsets.all(1.0),
        child: Stack(
          children: [
            Container(
              //   height:350,
              decoration: BoxDecoration(
                border: new Border.all(
                  color: Colors.white,
                  width: 0,
                ),
                image: document['imgurl'] == null?DecorationImage(
                  image: AssetImage("assets/images/ic_background.png" ),
                  fit: BoxFit.cover,
                ):DecorationImage(
                  image:  NetworkImage(
                      document['imgurl']              ),

                  fit: BoxFit.fill,
                ),
                borderRadius: BorderRadius.circular(0.0),
              ),
            ),



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






 /////////////////// this function is not used

  Widget firebasedata(
      BuildContext context, int index, DocumentSnapshot document) {

    return   InkWell(
      onTap: () {
Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => AllVideos(document['carrange'],document['cdepart'],_userId)));

      },
      child: Padding(
        padding: const EdgeInsets.all(0.0),
        child: Stack(
          children: [
            Container(
            //  height: 200,
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
