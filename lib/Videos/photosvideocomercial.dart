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
  List<String> sortlist = ["الاحدث","الاكثر شهرة"];
  List<String> carlist = ["السيارة","هونداى","فيات","تويوتا"];
  var _sortcurrentItemSelected = '';
  var _carcurrentItemSelected = '';
  String filt;

  @override
  void initState() {
    super.initState();
    _sortcurrentItemSelected=sortlist[0];
    _carcurrentItemSelected=carlist[0];

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
      body: ListView(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: 50,width: 150,
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Card(
                    elevation: 0.0,
                    color: const Color(0xff171732),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: DropdownButtonHideUnderline(
                        child: ButtonTheme(
                          alignedDropdown: true,
                          child: DropdownButton<String>(
                            items: sortlist
                                .map((String value) {
                              return new DropdownMenuItem<String>(
                                value: value,
                                child: new Text(value),
                              );
                            }).toList(),
                            value: _sortcurrentItemSelected,
                            onChanged: (String newValueSelected) {
                              // Your code to execute, when a menu item is selected from dropdown
                              _onDropDownItemSelectedsort(
                                  newValueSelected);
                            },
                            style: new TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        )),
                  ),
                ),
              ),
              Container(
                height: 50,width: 150,
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Card(
                    elevation: 0.0,
                    color: const Color(0xff171732),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: DropdownButtonHideUnderline(
                        child: ButtonTheme(
                          alignedDropdown: true,
                          child: DropdownButton<String>(
                            items: carlist
                                .map((String value) {
                              return new DropdownMenuItem<String>(
                                value: value,
                                child: new Text(value),
                              );
                            }).toList(),
                            value: _carcurrentItemSelected,
                            onChanged: (String newValueSelected) {
                              // Your code to execute, when a menu item is selected from dropdown
                              _onDropDownItemSelectedcar(
                                  newValueSelected);
                            },
                            style: new TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        )),
                  ),
                ),
              ),

            ],
          ),

          Container(
            width: width,
            height: height,
            child: StreamBuilder(
              stream: _sortcurrentItemSelected==sortlist[0]? Firestore.instance
                  .collection('videos')
                  .where("cdepart", isEqualTo:"تجارى")
                  .where("ccar", isEqualTo:filt)
                  .orderBy('carrange',
                  descending:
                  true)
                  .snapshots():Firestore.instance
                  .collection('videos')
                  .where("cdepart", isEqualTo:"تجارى")
                  .where("ccar", isEqualTo:filt)
                  .orderBy('seens',
                  descending:
                  true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: Text("لا يوجد بيانات...",));
                }
                print("kkk1$filt");

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
        ],
      ),
    );
  }

  void _onDropDownItemSelectedcar(String newValueSelected) {
    print("kkk$newValueSelected");
      if(newValueSelected=="السيارة"){
        setState(() {
          this._carcurrentItemSelected = newValueSelected;
          filt=null;
        });
      }else{
        setState(() {
          this._carcurrentItemSelected = newValueSelected;
          filt=_carcurrentItemSelected;
        });
      }
  }

  void _onDropDownItemSelectedsort(String newValueSelected) {
    setState(() {
      this._sortcurrentItemSelected = newValueSelected;

    });
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
