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

class VidiosPhoto extends StatefulWidget {
  VidiosPhoto();

  @override
  _VidiosPhotoState createState() => _VidiosPhotoState();
}

class _VidiosPhotoState extends State<VidiosPhoto> {

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
      floatingActionButton:  FloatingActionButton(
        heroTag: "uniqu03",
        child: Container(
          width: 60,
          height: 60,
          child: Icon(
            Icons.add,
//                size: 40,
          ),
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  const Color(0xffff2121),
                  const Color(0xffff5423),
                  const Color(0xffff7024),
                  const Color(0xffff904a)
                ],
              )),
        ),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AddVideo()));
//        FirebaseAuth.instance.currentUser().then((user) => user == null
//            ? Navigator.of(context, rootNavigator: false).push(
//            MaterialPageRoute(
//                builder: (context) => LoginScreen2(widget.regionlist),
//                maintainState: false))
//            : setState(() {
//          var sheetController = showBottomSheet(
//              context: context,
//              builder: (context) =>
//                  BottomSheetWidget(widget.regionlist));
//
//          _showButton(false);
//
//          sheetController.closed.then((value) {
//            _showButton(true);
//          });
//        }));
        },
      ),
      // appBar: AppBar(
      // title: const Text('AppBar Demo'),),
      backgroundColor: const Color(0xffffffff),
      body: Container(
        width: width,
        height: height,
        child: StreamBuilder(
          stream: Firestore.instance
              .collection('videos')
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
                builder: (context) => AllVideos(document['carrange'])));

      },
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Container(
          height: 200,
          decoration: BoxDecoration(
            border: new Border.all(
              color: Colors.black,
              width: 3,
            ),
            image: document['imgurl'] == null?DecorationImage(
              image: AssetImage("assets/images/ic_background.png" ),
              fit: BoxFit.fill,
            ):DecorationImage(
              image:  NetworkImage(
                  document['imgurl']              ),

              fit: BoxFit.fill,
            ),
            borderRadius: BorderRadius.circular(9.0),
          ),
        ),
      ),
    );
  }
}
