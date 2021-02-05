import 'dart:ui' as prefix0;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:priceme/ChatRoom/widget/const.dart';
import 'package:priceme/Videos/photosvideotrader.dart';
import 'package:priceme/screens/traderinfoinuser.dart';
import 'package:priceme/screens/tradeuserrate.dart';
import 'package:priceme/trader/tradephotos.dart';


class TraderUserProlile extends StatefulWidget {
  String ownerId;
  String traderid;
  TraderUserProlile(this.ownerId,this.traderid);


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
      TraderInfoInUser(widget.ownerId,widget.traderid),
      VidiosPhotoTrader(widget.traderid),
      TradePhotos(widget.traderid),
      TradeUserRate(widget.traderid),
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
                padding: const EdgeInsets.only(top:28.0, left: 5),
                child: Text(
                  name==null?"": name,textAlign: TextAlign.center,),
              ),
              background: photourl==null?Container(
//                      width: _controller.value,
//                      height: _controller.value,
              //  height: 150.0,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/ic_logo2.png'),
                    fit: BoxFit.contain,
                  ),
                ),
              ):
              CachedNetworkImage(
                placeholder: (context, url) => Container(
                  child: Image.asset(
                    "assets/images/ic_logo2.png",
                    width: 150.0,
                    height: 150.0,
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
                    height: 300,
                    width: MediaQuery
                        .of(context)
                        .size
                        .width,
                    fit: BoxFit.cover,color: Colors.orange,
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(8.0),
                  ),
                  clipBehavior: Clip.hardEdge,
                ),
                imageUrl:photourl,
                height: 300,
                width: MediaQuery
                    .of(context)
                    .size
                    .width,
                fit: BoxFit.cover,
              ),

              // Image.network(photourl==null?"":photourl/**_imageUrls==null?"":_imageUrls[0]==null?"":_imageUrls[0]**/,fit: BoxFit.cover,),


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
                BottomNavigationBarItem(
                  icon: Icon(Icons.star,color: Colors.black),
                  title: Text('التقيم'),
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
