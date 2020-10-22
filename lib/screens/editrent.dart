
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
import 'package:priceme/screens/myrents.dart';
import 'package:priceme/screens/network_connection.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:priceme/screens/signin.dart';
import 'dart:io' as io;

import 'package:toast/toast.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:math' as Math;

import '../Splash.dart';

class EditRent extends StatefulWidget {
  int index,length,carrange;
  String cdate,cdiscribtion,cimagelist,cproblemtype,ctitle,curi,fPlaceName,offerid,
      pname,pphone,price,userId,fromPLat,fromPLng,ccar,ccarversion,cmotion,color,cyear,km;

  EditRent(
      this.index,
      this.length,
      this.carrange,
      this.cdate,
      this.cdiscribtion,
      this.cimagelist,
      this.cproblemtype,
      this.ctitle,
      this.curi,
      this.fPlaceName,
      this.fromPLat,
      this.fromPLng,
      this.offerid,
      this.pname,
      this.pphone,
      this.price,
      this.userId,this.ccar,this.ccarversion,this.cmotion,this.color,this.cyear,this.km
      );

  @override
  _EditRentState createState() => _EditRentState();
}

class _EditRentState extends State<EditRent> {
  bool _load1 = false;
  String url1;
  String imagepathes = '';
  List<String> urlList = [];
  List<String> motiontype = ["اوتوماتيك","يدوي"];
  List<String> indyearlist = [];

  var _probtypecurrentItemSelected = '';
  var _motiontypecurrentItemSelected = '';
  var _indyearcurrentItemSelected="";

  String model1;
  String model2;
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
  TextEditingController kmController = TextEditingController();
  TextEditingController colorController = TextEditingController();


  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.ctitle);
    priceController = TextEditingController(text: widget.price);
    discController = TextEditingController(text: widget.cdiscribtion);
     kmController = TextEditingController(text: widget.km);
     colorController = TextEditingController(text: widget.color);

    _motiontypecurrentItemSelected=widget.cmotion;
    model1 = widget.ccar;model2 =widget.ccarversion;
    fromPlaceLat=widget.fromPLat;
    fromPlaceLng=widget.fromPLng;
    fPlaceName=widget.fPlaceName;

    urlList =widget.cimagelist
        .replaceAll(" ", "")
        .replaceAll("[", "")
        .replaceAll("]", "")
        .split(",");

    DateTime now = DateTime.now();
    indyearlist=new List<String>.generate(50, (i) =>  NumberUtility.changeDigit((now.year+1 -i).toString(), NumStrLanguage.English));
    indyearlist[0]=("الموديل");
    _indyearcurrentItemSelected=widget.cyear;
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
          // _cWorkshopname=data.documents[0].data['workshopname'];
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
                            "إضافة سيارة",
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
                                labelText: 'العنوان ',
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
                                labelText: 'السعر بالدينار الاردنى',
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
                              controller: kmController,
                              validator: (String value) {
                                if (value.isEmpty) {
                                  return 'برجاء إدخال الكيلومترات';
                                }
                              },
                              decoration: InputDecoration(
                                labelText: 'عدد الكيلومترات',
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
                              keyboardType: TextInputType.text,
                              style: textStyle,
                              //textDirection: TextDirection.rtl,
                              controller: colorController,
                              validator: (String value) {
                                if (value.isEmpty) {
                                  return 'برجاء إدخال اللون';
                                }
                              },
                              decoration: InputDecoration(
                                labelText: 'اللون',
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
                                  items: motiontype.map((String value) {
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
                                  value: _motiontypecurrentItemSelected,
                                  onChanged: (String newValueSelected) {
                                    // Your code to execute, when a menu item is selected from dropdown
                                    _onDropDownItemSelectedmotion(
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
                                            widget.ccar,widget.ccarversion,
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
                                  return 'برجاء إدخال الوصف ';
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
                                  labelText: 'الوصف ',
                                  hintText: 'الوصف ',
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

                                  if( model1 == null || model2 == null||fromPlaceLat==null||fromPlaceLng==null){
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
                                  'تعديل',
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
    setState(() {
      _load1 = true;
    });
    if (images.length != 0) {
      urlList.clear();
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

    }else{
      if(urlList.length==0){
        Toast.show("برجاء أضافة صورة واحدة على الاقل", context,
            duration: Toast.LENGTH_SHORT,
            gravity: Toast.BOTTOM);
      }else{createRecord(urlList);}
    }

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

      Firestore.instance
          .collection('rents')
          .document(widget.offerid)
          .updateData({
        'carrange': arrange,
        'offerid': widget.offerid,
        'userId': _userId,
        'cdate': date1,
        'cpublished': false,
        'curi': urlList[0],
        'cimagelist': urlList.toString(),
        'pphone': _cMobile,
        'pname': _cName,
        'workshopname': _cWorkshopname,
        'ccar':model1,
        'ccarversion':model2,
        'price': priceController.text,
        'color': colorController.text,
        'km': kmController.text,
        'ctitle': titleController.text,
        'cdiscribtion': discController.text,

        'cproblemtype':_probtypecurrentItemSelected,
        'cmotion':_motiontypecurrentItemSelected,
        'cyear':_indyearcurrentItemSelected,

        'fromPLat': fromPlaceLat,
        'fromPLng': fromPlaceLng,
        'fPlaceName':fPlaceName,


      }).whenComplete(() {
        Navigator.push(
            context,
            new MaterialPageRoute(
                builder: (context) => MyRents()));
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

  void _onDropDownItemSelectedmotion(String newValueSelected) {
    setState(() {
      this._motiontypecurrentItemSelected = newValueSelected;
    });
  }
  void _onDropDownItemSelectedindyear(String newValueSelected) {
    setState(() {
      this._indyearcurrentItemSelected = newValueSelected;
    });
  }
  void onSubmit3(String result) {
    setState(() {
      model1 = result.split(",")[0];
      model2 = result.split(",")[1];
      Toast.show(
          "${result.split(",")[0]}///////${result.split(",")[1]}", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    });
  }

}
//////////////////////////////////
typedef void MyFormCallback3(String result);
class MyForm3 extends StatefulWidget {
  final MyFormCallback3 onSubmit3;
  String model;
  String model1;

  MyForm3(this.model,this.model1, {this.onSubmit3});
  @override
  _MyForm3State createState() => _MyForm3State();
}
class _MyForm3State extends State<MyForm3> {
  String _currentValue = '';
  String _currentValue1 = '';

  List<ModelClass> modelList = [];

  @override
  void initState() {
    super.initState();
    _currentValue = widget.model1;
    modelList = [
      new ModelClass("تويوتا",["كورولا","ياريس"]),
      new ModelClass("هونداى",["اكسينت","اكسيل","ماتريكس"]),
      new ModelClass("فيات",["128","132"]),

    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff171732),
        centerTitle:true ,
        title: Text(
          widget.model,
          style: TextStyle(fontWeight: FontWeight.bold),
          textDirection: TextDirection.rtl,
        ),

      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top:18.0),
            child: ListView.builder(
              itemCount: modelList.length,
              itemBuilder: (context, i) {
                return new ExpansionTile(
                  title: new Text(
                    modelList[i].title,
                    style: new TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic),
                  ),
                  children: <Widget>[
                    Column(
                      // padding: EdgeInsets.all(8.0),
                      children: modelList[i].subtitle
                          .map((value) => RadioListTile(
                        groupValue: _currentValue,
                        title: Text(
                          value,
                          textDirection: TextDirection.rtl,
                        ),
                        value: value,
                        onChanged: (val) {
                          setState(() {
                            debugPrint('VAL = $val');
                            _currentValue = val;
                            _currentValue1 = modelList[i].title;
                            Navigator.pop(context);
                            widget.onSubmit3(_currentValue1.toString() + "," + _currentValue.toString());
                          });
                        },
                      ))
                          .toList(),
                    ),
//              new Column(
//                children:
//                _buildExpandableContent(regionlist[i]),
//              ),
                  ],
                );
              },
            ),
          ),
//          Row(
//            mainAxisAlignment: MainAxisAlignment.spaceAround,
//            children: <Widget>[
//              cancelButton,
//              continueButton,
//            ],
//          )

        ],
      ),
    );
  }
}
////////////////////////////////