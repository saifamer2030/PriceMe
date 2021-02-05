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
import 'package:path_provider/path_provider.dart';
import 'package:priceme/ChatRoom/widget/const.dart';
import 'package:priceme/Splash.dart';
import 'package:priceme/Videos/addVideo.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:priceme/classes/FaultsClass.dart';
import 'package:priceme/classes/SparePartsClass.dart';
import 'package:priceme/classes/SparePartsSizesClass.dart';
import 'package:priceme/screens/addphoto.dart';
import 'package:priceme/screens/displayphoto.dart';
import 'package:toast/toast.dart';
import 'package:firebase_core/firebase_core.dart';

class TradePhotos extends StatefulWidget {
  String traderid;
  TradePhotos(this.traderid);

  @override
  _TradePhotosState createState() => _TradePhotosState();
}

class _TradePhotosState extends State<TradePhotos> {

  String filePath,_userId;


  @override
  void initState() {
    super.initState();

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
                  true).where("cuserId", isEqualTo:widget.traderid)
                  .snapshots(), //imgColRef.snapshots(includeMetadataChanges: true),
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
                  imageUrl: document['imgurl'] ,
                  width: 250.0,
                  height: 350.0,
                  fit: BoxFit.cover,
                ),
                // DecorationImage(
                //   image:  NetworkImage(
                //       document['imgurl']
                //   ),
                //
                //   fit: BoxFit.fill,
                // ),
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
}
