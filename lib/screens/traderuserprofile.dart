import 'dart:ui' as prefix0;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:priceme/Videos/photosvideotrader.dart';
import 'package:priceme/screens/traderinfoinuser.dart';
import 'package:priceme/trader/tradephotos.dart';


class TraderUserProlile extends StatefulWidget {
  String traderid;
  TraderUserProlile(this.traderid);


  @override
  _TraderUserProlileState createState() => _TraderUserProlileState();
}

class _TraderUserProlileState extends State<TraderUserProlile> {
  String email,name,phone,photourl,curilist,fromPLat,fromPLng,fPlaceName,worktype,
      workshopname,cType,traderType;
 int _currentIndex=0;
  List<String> _imageUrls=[];
  @override
  void initState() {
    super.initState();
    var userQuery = Firestore.instance.collection('users').where('uid', isEqualTo: widget.traderid).limit(1);
    userQuery.getDocuments().then((data){
      if (data.documents.length > 0){
        setState(() {
          cType = data.documents[0].data['cType'];
          name = data.documents[0].data['name'];
          phone = data.documents[0].data['phone'];
          photourl = data.documents[0].data['photourl'];
          curilist = data.documents[0].data['curilist'];
          fromPLat = data.documents[0].data['fromPLat'];
          fromPLng = data.documents[0].data['fromPLng'];
          fPlaceName = data.documents[0].data['fPlaceName'];
          worktype = data.documents[0].data['worktype'];
          workshopname = data.documents[0].data['workshopname'];
          traderType = data.documents[0].data['traderType'];
          _imageUrls = curilist
              .replaceAll(" ", "")
              .replaceAll("[", "")
              .replaceAll("]", "")
              .split(",");
        });
      }
    });



  }



  @override
  Widget build(BuildContext context) {
    final List<Widget> _children = [
      TraderInfoInUser(widget.traderid),
      VidiosPhotoTrader(widget.traderid),
      TradePhotos(widget.traderid),
    ];
    return Scaffold(
      body:
      CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            pinned: true,
            floating: false,
            expandedHeight: 300.0,
            flexibleSpace: FlexibleSpaceBar(
              title:  Padding(
                padding: const EdgeInsets.only(top:28.0, left: 170),
                child: Text(
                  name==null?"": name,textAlign: TextAlign.center,),
              ),
              background: Image.network(photourl==null?"":photourl/**_imageUrls==null?"":_imageUrls[0]==null?"":_imageUrls[0]**/,fit: BoxFit.cover,),


            ),
          ),
        SliverFillRemaining(
      child:  Column(
          children: <Widget>[
            BottomNavigationBar(
//fixedColor: const Color(0xffF1AB37),
              type: BottomNavigationBarType.fixed,
              onTap: onTabTapped,
              currentIndex: _currentIndex,
              items: [
                BottomNavigationBarItem(
                  icon: Icon(Icons.person,color: Colors.black,),
                  title: Text('المعلومات'),
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.apps,color: Colors.black),
                  title: Text('الفيديوهات'),
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.local_offer,color: Colors.black),
                  title: Text('الصور'),
                ),
              ],
            ),
             Expanded(child: _children[_currentIndex]),
//            Container(
//              color: Colors.red,
//               // child: _children[_currentIndex],
//            ),
          ],
        ),
        ),

    ],
      )  );
  }
  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}
