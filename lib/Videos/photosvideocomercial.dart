import 'dart:io';

import 'package:adobe_xd/gradient_xd_transform.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:path_provider/path_provider.dart';
import 'package:priceme/Videos/addVideo.dart';

import 'package:priceme/classes/FaultsClass.dart';
import 'package:priceme/classes/SparePartsClass.dart';
import 'package:priceme/classes/SparePartsSizesClass.dart';
import 'package:toast/toast.dart';
import 'package:firebase_core/firebase_core.dart';

import 'allvideos.dart';

class VidiosPhotoComercial extends StatefulWidget {
  VidiosPhotoComercial();

  @override
  _VidiosPhotoComercialState createState() => _VidiosPhotoComercialState();
}

class _VidiosPhotoComercialState extends State<VidiosPhotoComercial> {

  String filePath;

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
      // appBar: AppBar(
      // title: const Text('AppBar Demo'),),
      backgroundColor: const Color(0xffffffff),
      body: Container(
        width: width,
        height: height,
        child: StreamBuilder(
          stream: Firestore.instance
              .collection('videos').where("cdepart", isEqualTo:"تجارى")
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
                    //crossAxisCount: (orientation == Orientation.portrait) ? 2 : 3
                ),
                //add item count depending on your list
                //itemCount: list.length,

                //added scrolldirection
                //reverse: true,
                physics: BouncingScrollPhysics(),
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
                  child: Text( document['cname']==null||document['cname']==""?"اسم غير معلوم":document['cname']
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
