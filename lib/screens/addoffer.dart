
import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file/local.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_recorder/flutter_audio_recorder.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:priceme/classes/AClass.dart';
import 'package:priceme/classes/FaultStringClass.dart';
import 'package:priceme/classes/FaultsClass.dart';
import 'package:priceme/classes/ModelClass.dart';
import 'package:priceme/classes/OutputClass.dart';
import 'package:priceme/classes/SparePartsClass.dart';
import 'package:priceme/classes/sharedpreftype.dart';
import 'package:priceme/screens/cur_loc.dart';
import 'package:priceme/screens/network_connection.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:priceme/screens/signin.dart';
import 'dart:io' as io;

import 'package:toast/toast.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:math' as Math;

import '../Splash.dart';

class AddOffer extends StatefulWidget {

  @override
  _AddOfferState createState() => _AddOfferState();
}

class _AddOfferState extends State<AddOffer> {
  bool _load1 = false;
  String url1;
  String imagepathes = '';
  List<String> urlList = [];
  List<String> proplemtype = ["اعطال","قطع غيار"];
  var _probtypecurrentItemSelected = '';


  List<Asset> images = List<Asset>();
  String _error = 'No Error Dectected';
  var _formKey = GlobalKey<FormState>();
  LatLng fromPlace, toPlace ;
  String fromPlaceLat , fromPlaceLng , fPlaceName ;
  Map <String , dynamic > sendData = Map();

String _userId;

  final double _minimumPadding = 5.0;
  String _cName = "";
  String _cMobile;
  String _cEmail="";
  String _cWorkshopname="";

  TextEditingController titleController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController discController = TextEditingController();



  @override
  void initState() {
    super.initState();
    _probtypecurrentItemSelected=proplemtype[0];
    FirebaseAuth.instance.currentUser().then((user) => user == null
        ? Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => Splash()))
        : setState(() {_userId = user.uid;
    var userQuery = Firestore.instance.collection('users').where('uid', isEqualTo: _userId).limit(1);
    userQuery.getDocuments().then((data){
      if (data.documents.length > 0){
        setState(() {
          _cName = data.documents[0].data['name'];
          _cMobile = data.documents[0].data['phone'];
          _cEmail=data.documents[0].data['email'];
           _cWorkshopname=data.documents[0].data['workshopname'];
          // if(_cWorkshopname==null){_cWorkshopname="اسم غير معلوم";}
          if(_cName==null){
            if(user.displayName==null||user.displayName==""){
              _cName="ايميل غير معلوم";
            }else{_cName=user.displayName;}}
          // print("mmm$_cMobile+++${user.phoneNumber}***");
          if(_cMobile==null){
            if(user.phoneNumber==null||user.phoneNumber==""){
              _cMobile="لا يوجد رقم هاتف بعد";
            }else{_cMobile=user.phoneNumber;}}
          //  if(_cEmail==null){_cEmail=user.email??"ايميل غير معلوم";}
          if(_cEmail==null){
            if(user.email==null||user.email==""){
              _cEmail="ايميل غير معلوم";
            }else{_cEmail=user.email;}}

        });
      }
    });
    }));


  }

  @override
  Widget build(BuildContext context) {
    Widget loadingIndicator = _load1
        ? new Container(
      child: SpinKitCircle(color: const Color(0xff171732),),
    )
        : new Container();

    TextStyle textStyle = Theme
        .of(context)
        .textTheme
        .subtitle;

    return Scaffold(
      body: Container(
        child: Stack(
          children: <Widget>[
            Form(
              key: _formKey,
              child: Padding(
                  padding: EdgeInsets.all(_minimumPadding * 2),
                  child: ListView(
                    physics: BouncingScrollPhysics(),
                    children: <Widget>[

                      Padding(
                        padding: EdgeInsets.only(
                            top: _minimumPadding * 5, bottom: _minimumPadding),
                        child: Center(
                          child: Text(
                            "إضافة عرض",
                            style: TextStyle(
                                color: const Color(0xffF1AB37),
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: _minimumPadding,
                        width: _minimumPadding,
                      ),
                      Padding(
                          padding: EdgeInsets.only(
                              top: _minimumPadding, bottom: _minimumPadding),
                          child: Directionality(
                            textDirection: TextDirection.rtl,
                            child: TextFormField(
                              textAlign: TextAlign.right,
                              keyboardType: TextInputType.text,
                              style: textStyle,
                              //textDirection: TextDirection.rtl,
                              controller: titleController,
                              validator: (String value) {
                                if (value.isEmpty) {
                                  return 'برجاء إدخال عنوان';
                                }
                              },
                              decoration: InputDecoration(
                                labelText: 'عنوان العرض',
                                //hintText: 'Name',
                                labelStyle: textStyle,
                                errorStyle: TextStyle(
                                    color: Colors.red, fontSize: 15.0),
                                // border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0))
                              ),
                            ),
                          )),
                      SizedBox(
                        height: _minimumPadding,
                        width: _minimumPadding,
                      ),
                      Padding(
                          padding: EdgeInsets.only(
                              top: _minimumPadding, bottom: _minimumPadding),
                          child: Directionality(
                            textDirection: TextDirection.rtl,
                            child: TextFormField(
                              textAlign: TextAlign.right,
                              keyboardType: TextInputType.number,
                              style: textStyle,
                              //textDirection: TextDirection.rtl,
                              controller: priceController,
                              validator: (String value) {
                                if (value.isEmpty) {
                                  return 'برجاء إدخال السعر';
                                }
                              },
                              decoration: InputDecoration(
                                labelText:  'السعر بالدينار الاردنى',
                                //hintText: 'Name',
                                labelStyle: textStyle,
                                errorStyle: TextStyle(
                                    color: Colors.red, fontSize: 15.0),
                                // border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0))
                              ),
                            ),
                          )),
                      SizedBox(
                        height: _minimumPadding,
                        width: _minimumPadding,
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            top: _minimumPadding, bottom: _minimumPadding),
                        child: Container(
                          height: 40.0,
                          child: Material(
                              borderRadius: BorderRadius.circular(5.0),
                              shadowColor: const Color(0xffdddddd),
                              color: const Color(0xffe7e7e7),
                              elevation: 2.0,
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: DropdownButton<String>(
                                  items: proplemtype.map((String value) {
                                    return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(
                                          value,
                                          style: TextStyle(
                                              color: const Color(0xffF1AB37),
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold),
                                        ));
                                  }).toList(),
                                  value: _probtypecurrentItemSelected,
                                  onChanged: (String newValueSelected) {
                                    // Your code to execute, when a menu item is selected from dropdown
                                    _onDropDownItemSelectedproblem(
                                        newValueSelected);
                                  },
                                ),
                              )),
                        ),
                      ),
            SizedBox(
              height: _minimumPadding,
              width: _minimumPadding,
            ),
                      Padding(
                          padding: EdgeInsets.only(
                              top: _minimumPadding, bottom: _minimumPadding),
                          child: Directionality(
                            textDirection: TextDirection.rtl,
                            child: TextFormField(
                              textAlign: TextAlign.right,
                              keyboardType: TextInputType.text,
                              style: textStyle,
                              //textDirection: TextDirection.rtl,
                              controller: discController,
                              validator: (String value) {
                                if (value.isEmpty) {
                                  return 'برجاء إدخال وصف العرض';
                                }
                              },
                              maxLength: 100,
                              maxLines: 4,
                              decoration: InputDecoration(
                                  contentPadding:
                                  new EdgeInsets.symmetric(
                                      vertical: 100.0),
                                  errorStyle: TextStyle(
                                      color: Colors.red, fontSize: 15.0),
                                  labelText: 'وصف العرض',
                                  hintText: 'وصف العرض',
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(5.0)))),

                            ),
                          )),
                      SizedBox(
                        height: _minimumPadding,
                        width: _minimumPadding,
                      ),

                      SizedBox(
                        height: _minimumPadding,
                        width: _minimumPadding,
                      ),
                      /**
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                                top: _minimumPadding, bottom: _minimumPadding),
                            child: Container(
                              height: 40.0,
                              child: Material(
                                  borderRadius: BorderRadius.circular(5.0),
                                  shadowColor: const Color(0xffdddddd),
                                  color: const Color(0xffe7e7e7),
                                  elevation: 2.0,
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: DropdownButton<String>(
                                      items: indyearlist.map((String value) {
                                        return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(
                                              value,
                                              style: TextStyle(
                                                  color: const Color(0xffF1AB37),
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold),
                                            ));
                                      }).toList(),
                                      value: _indyearcurrentItemSelected,
                                      onChanged: (String newValueSelected) {
                                        // Your code to execute, when a menu item is selected from dropdown
                                        _onDropDownItemSelectedindyear(
                                            newValueSelected);
                                      },
                                    ),
                                  )),
                            ),
                          ),

                          Container(
                            height: 40,
                            color: Colors.grey,
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => MyForm3(
                                            "نوع السيارة",
                                            onSubmit3: onSubmit3)));

//                                    setState(() {
//                                      showDialog(
//                                          context: context,
//                                          builder: (context) => MyForm3(
//                                              widget.department,
//                                              onSubmit3: onSubmit3));
//                                    });
//showBottomSheet();
                              },
                              child: Card(
                                elevation: 0.0,
                                color: const Color(0xff171732),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      "نوع السيارة",
                                      textDirection: TextDirection.rtl,
                                      style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
**/
///////////////////////////////////////

                      SizedBox(
                        height: _minimumPadding,
                        width: _minimumPadding,
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            top: _minimumPadding * 5, bottom: _minimumPadding),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            InkWell(
                              onTap: (){loadAssets();} ,
                              child: Icon(
                                images.length>0 ? Icons.check_circle : Icons
                                    .add_photo_alternate,
                                color: Colors.greenAccent,
                                size: 50,
                              ),
                            ),
                            SizedBox(
                              width: 10.0,
                            ),
                            Expanded(
                              child: Text(
                                "يرجى الضغط على الصورة لتحميل الصور",
                                textDirection: TextDirection.rtl,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Align(
                              alignment: Alignment.topCenter,
                              child: Icon(
                                Icons.star,
                                color: Colors.red,
                                size: 15,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: _minimumPadding,
                        width: _minimumPadding,
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            top: _minimumPadding * 5, bottom: _minimumPadding),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            InkWell(
                              onTap: () async {
                                sendData = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          CurrentLocation2()),
                                );

                                // print("\n\n\n\n\n\n\nfromPlaceLng>>>>"+
                                //     fromPlaceLng+fPlaceName+"\n\n\n\n\n\n");
setState(() {
  fromPlace = sendData["loc_latLng"];
  fromPlaceLat = fromPlace.latitude.toString();
  fromPlaceLng = fromPlace.longitude.toString();
  fPlaceName = sendData["loc_name"];
});
                              } ,
                              child: Icon(
                                fromPlaceLat == null ? Icons.gps_fixed : Icons.check_circle
                                    ,
                                color: Colors.purpleAccent,
                                size: 50,
                              ),
                            ),
                            SizedBox(
                              width: 10.0,
                            ),
                            Expanded(
                              child: Text(
                                "يرجى الضغط على الصورة لتحديد الموقع ",
                                textDirection: TextDirection.rtl,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Align(
                              alignment: Alignment.topCenter,
                              child: Icon(
                                Icons.star,
                                color: Colors.red,
                                size: 15,
                              ),
                            ),

                          ],
                        ),
                      ),
                      SizedBox(
                        height: _minimumPadding,
                        width: _minimumPadding,
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            top: _minimumPadding, bottom: _minimumPadding),
                        child: Container(
                          height: 50.0,
                          child: Material(
                            borderRadius: BorderRadius.circular(20.0),
                            shadowColor: const Color(0xffFCC201),
                            color: const Color(0xffF1AB37),
                            elevation: 3.0,
                            child: GestureDetector(
                              onTap: () async {
                                if (_formKey.currentState.validate()) {

                                  if(images.length == 0||fromPlaceLat==null||fromPlaceLng==null){
                                    Toast.show("برجاء التأكد من إضافة كل البيانات المطلوبة",context,duration: Toast.LENGTH_LONG,gravity:  Toast.BOTTOM);
                                  }else{
                                    try {
                                      final result = await InternetAddress.lookup('google.com');
                                      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
                                        setState(() {
                                          _load1 = true;
                                        });
                                        uploadpp0();


                                      }
                                    } on SocketException catch (_) {
                                      //  print('not connected');
                                      Toast.show("برجاء مراجعة الاتصال بالشبكة",context,duration: Toast.LENGTH_LONG,gravity:  Toast.BOTTOM);

                                    }}

                                } else
                                  print('correct');
                              },
                              child: Center(
                                child: Text(
                                  'الإضافة و النشر',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Montserrat'),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                    ],
                  )),
            ),
            new Align(
              child: loadingIndicator, alignment: FractionalOffset.center,),

          ],
        ),
      ),
    );
  }
  Future uploadpp0() async {
    // String url1;
    final StorageReference storageRef =
    FirebaseStorage.instance.ref().child('myimage');
    int i = 0;
    for(var f in images){
      //  images.forEach((f) async {
      var byteData = await f.getByteData(quality: 50);

      DateTime now = DateTime.now();
      final file = File('${(await getTemporaryDirectory()).path}/$f');
      await file.writeAsBytes(byteData.buffer
          .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
      final StorageUploadTask uploadTask =
      storageRef.child('$now.jpg').putFile(file);
      var Imageurl = await (await uploadTask.onComplete).ref.getDownloadURL();
      Toast.show("تم تحميل صورة ", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
      setState(() {
        url1 = Imageurl.toString();
        urlList.add(url1);
        //  print('URL Is${images.length} ///$url1///$urlList');
        i++;
        // _load2 = false;
      });
      if (i == images.length) {
        // print('gggg${images.length} ///$i');
        createRecord(urlList);
      }
    }
    setState(() {
      _load1 = true;
    });

  }
  void createRecord(urlList) {
    FirebaseAuth.instance.currentUser().then((user) => user == null
        ? null
        : setState(() {
      _userId = user.uid;
      DateTime now = DateTime.now();
      String date =
          '${now.year}-${now.month}-${now.day}-${now.hour}-${now.minute}-00-000';

      String b = now.month.toString();
      if (b.length < 2) {
        b = "0" + b;
      }
      String c = now.day.toString();
      if (c.length < 2) {
        c = "0" + c;
      }
      String d = now.hour.toString();
      if (d.length < 2) {
        d = "0" + d;
      }
      String e = now.minute.toString();
      if (e.length < 2) {
        e = "0" + e;
      }
      String date1 = '${now.year}-${b}-${c} ${d}:${e}:00';
      int arrange = int.parse('${now.year}${b}${c}${d}${e}');
      DocumentReference documentReference =
      Firestore.instance.collection('offers').document();
      documentReference.setData({
        //'timestamp': FieldValue.serverTimestamp(), to arrange data using orderby

        'carrange': arrange,
        'offerid': documentReference.documentID,
        'userId': _userId,
        'cdate': date1,
        'cdiscribtion': discController.text,
        'cpublished': false,
        'curi': urlList[0],
        'cimagelist': urlList.toString(),
        'pphone': _cMobile,
        'pname': _cName,
        'workshopname': _cWorkshopname,

        'price': priceController.text,

        'cproblemtype':_probtypecurrentItemSelected,

        'ctitle': titleController.text,
        'fromPLat': fromPlaceLat,
        'fromPLng': fromPlaceLng,
        'fPlaceName':fPlaceName,


      }).whenComplete(() {
        setState(() {
         // _load2 = false;
          urlList.clear();
          images.clear();
          titleController.text = "";
          discController.text = "";
          priceController.text = "";

          fromPlaceLat=null; fromPlaceLng=null; fPlaceName =null;
            _load1 = false;

        });
      });

    }));
  }


  Future<void> loadAssets() async {
    List<Asset> resultList = List<Asset>();
    String error = 'No Error Dectected';

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 7,
        enableCamera: false,
        selectedAssets: images,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "اعلان"),
        materialOptions: MaterialOptions(
          statusBarColor: "#000000",
          actionBarColor: "#000000",
          actionBarTitle: "price me",
          allViewTitle: "كل الصور",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );
    } on Exception catch (e) {
      error = e.toString();
    }


    if (!mounted) return;

    setState(() {
      images = resultList;
      _error = error;

    });
  }
  void _onDropDownItemSelectedproblem(String newValueSelected) {
    setState(() {
      this._probtypecurrentItemSelected = newValueSelected;
    });
  }

}
