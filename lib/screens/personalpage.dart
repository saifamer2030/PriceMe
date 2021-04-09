import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:priceme/Splash.dart';
import 'package:priceme/classes/SparePartsClass.dart';
import 'package:priceme/screens/cur_loc.dart';
import 'package:priceme/screens/map_view.dart';
import 'package:priceme/ui_utile/myCustomShape3.dart';
import 'package:toast/toast.dart';
import 'package:priceme/ui_utile/myColors.dart';
import 'package:priceme/ui_utile/myCustomShape2.dart';

class PersonalPage extends StatefulWidget {
  PersonalPage();

  @override
  __PersonalPageState createState() => __PersonalPageState();
}

final mDatabase = FirebaseDatabase.instance.reference();

@override
class __PersonalPageState extends State<PersonalPage> {
  final double _minimumPadding = 5.0;
  TextEditingController phoneController;
  TextEditingController nameController;
  TextEditingController emailController;
  TextEditingController workshopnameController;
  FirebaseAuth _firebaseAuth;
  String _cName = "";
  String _cMobile;
  String cType = "";
  String _cEmail = "";
  String provider;
  String _userId;
  String photourl, fPlaceName, worktype, workshopname, traderType;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  var _formKey = GlobalKey<FormState>();
  LatLng fromPlace, toPlace;

  String fromPlaceLat, fromPlaceLng;
  Map<String, dynamic> sendData = Map();
  List<Asset> images = List<Asset>();
  String _error = 'No Error Dectected';
  bool _load2 = false;
  String selectedcars = "";
  List<String> selectedcarslist;

  @override
  void initState() {
    super.initState();

    FirebaseAuth.instance.currentUser().then((user) => user == null
        ? Navigator.of(context, rootNavigator: false).push(MaterialPageRoute(
            builder: (context) => Splash(), maintainState: false))
        : setState(() {
            _userId = user.uid;
            var userQuery = Firestore.instance
                .collection('users')
                .where('uid', isEqualTo: _userId)
                .limit(1);
            userQuery.getDocuments().then((data) {
              if (data.documents.length > 0) {
                setState(() {
                  _cName = data.documents[0].data['name'];
                  _cMobile = data.documents[0].data['phone'];
                  _cEmail = data.documents[0].data['email'];
                  photourl = data.documents[0].data['photourl'];


                  cType = data.documents[0].data['cType'].toString();
                  fromPlaceLat = data.documents[0].data['fromPLat'].toString();
                  fromPlaceLng = data.documents[0].data['fromPLng'].toString();
                  fPlaceName = data.documents[0].data['fPlaceName'].toString();
                  worktype = data.documents[0].data['worktype'].toString();
                  workshopname =
                      data.documents[0].data['workshopname'].toString();
                  traderType = data.documents[0].data['traderType'].toString();
                  selectedcars = data.documents[0].data['selectedcarstring'];
print("eee$cType");
                  selectedcars == null
                      ? selectedcars = ""
                      : selectedcars = selectedcars;
                  selectedcarslist = selectedcars
                      .replaceAll(" ", "")
                      .replaceAll("[", "")
                      .replaceAll("]", "")
                      .split(",");
                  workshopname == null
                      ? workshopname = "اسم محل غير معلوم"
                      : workshopname = workshopname;
                  fPlaceName == null
                      ? fPlaceName = "عنوان غير معلوم"
                      : fPlaceName = fPlaceName;
                  traderType == null
                      ? traderType = "نوع التاجر غير معلوم"
                      : traderType = traderType;
                  worktype == null
                      ? worktype = "نوع العمل غير معلوم"
                      : worktype = worktype;
                  print("hhh$cType///$_userId");

                  // if(_cName==null){_cName=user.displayName??"اسم غير معلوم";}
                  if (_cName == null) {
                    if (user.displayName == null || user.displayName == "") {
                      _cName = "اسم غير معلوم";
                    } else {
                      _cName = user.displayName;
                    }
                  }
                  // print("mmm$_cMobile+++${user.phoneNumber}***");
                  if (_cMobile == null) {
                    if (user.phoneNumber == null || user.phoneNumber == "") {
                      _cMobile = "لا يوجد رقم هاتف بعد";
                    } else {
                      _cMobile = user.phoneNumber;
                    }
                  }
                  //  if(_cEmail==null){_cEmail=user.email??"ايميل غير معلوم";}
                  if (_cEmail == null) {
                    if (user.email == null || user.email == "") {
                      _cEmail = "ايميل غير معلوم";
                    } else {
                      _cEmail = user.email;
                    }
                  }
                  if (photourl == null) {
                    if (user.photoUrl == null || user.photoUrl == "") {
                      photourl = "";
                    } else {
                      photourl = user.photoUrl;
                    }
                  }
                  provider = user.providerData[1].providerId;
                  setState(() {
                    nameController = TextEditingController(text: _cName);
                    phoneController = TextEditingController(text: _cMobile);
                    emailController = TextEditingController(text: _cEmail);
                    workshopnameController =
                        TextEditingController(text: workshopname);
                  });
                });
              }
            });
          }));

    //getUser();
  }

  void onSubmit9(List<String> result) {
    setState(() {
      selectedcarslist.clear();
      selectedcarslist.addAll(result);
    });
    //createRecord(Imageurl.toString());
    Firestore.instance.collection('users').document(_userId).updateData({
      'selectedcarstring': result.toString(),
      'selectedcarslist': result,
    }).then((_) {
      result.clear();
    });
  }

  Future<void> loadAssets() async {
    List<Asset> resultList = List<Asset>();
    String error = 'No Error Dectected';
//print("hhhhhhhhh");
    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 1,
        enableCamera: false,
        selectedAssets: images,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "صورة شخصية"),
        materialOptions: MaterialOptions(
          statusBarColor: "#000000",
          actionBarColor: "#000000",
          actionBarTitle: "سعرلي",
          allViewTitle: "كل الصور",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );
    } on Exception catch (e) {
      error = e.toString();
      // print("hhh$e");
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      images = resultList;
      _error = error;
      _load2 = true;

      uploadpp0();
    });
  }

  Future uploadpp0() async {
    // String url1;
    final StorageReference storageRef =
        FirebaseStorage.instance.ref().child('myimage');
    for (var f in images) {
      var byteData = await f.getByteData(quality: 20);
      DateTime now = DateTime.now();
      final file = File('${(await getTemporaryDirectory()).path}/$f');
      await file.writeAsBytes(byteData.buffer
          .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
      final StorageUploadTask uploadTask =
          storageRef.child('$_userId$now.jpg').putFile(file);
      var Imageurl = await (await uploadTask.onComplete).ref.getDownloadURL();
      //  print("oooo8");
      setState(() {
        //createRecord(Imageurl.toString());
        Firestore.instance.collection('users').document(_userId).updateData({
          "photourl": Imageurl.toString(),
        }).then((_) {
          setState(() {
            photourl = Imageurl.toString();
            _load2 = false;
          });
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget loadingIndicator = _load2
        ? new Container(
            child: SpinKitCircle(
              color: const Color(0xff171732),
            ),
          )
        : new Container();
    return Scaffold(
      key: _scaffoldKey,
      body:
          //previousWidget(loadingIndicator)
          profileScreen(),
    );
  }

  Widget profileScreen() {
    return Column(
      children: [
        Container(
          height: 240,
          child: Stack(
            children: [
              Container(
                height: 210,
                child: CustomPaint(
                  size: Size(MediaQuery.of(context).size.width, 210),
                  //You can Replace this with your desired WIDTH and HEIGHT
                  painter: MyCustomShape2(),
                ),
              ),
              Positioned(
                top: 54,
                right: 26,
                child: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      height: 40,
                      width: 40,
                      child: Center(
                          child: Icon(
                        Icons.arrow_forward,
                        color: Colors.white,
                        size: 30,
                      )),
                    )),
              ),

              Positioned(
                top: 80,
                right: 0,
                left: 0,
                child: Container(
                  width: 132,
                  height: 132,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
              ),


              Positioned(
                top: 85,
                right: 0,
                left: 0,
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    border: Border.all(color: Colors.grey),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 4,
                        blurRadius: 4,
                        offset: Offset(0, 2), // changes position of shadow
                      ),
                    ],
                    image: DecorationImage(
                      image: NetworkImage(photourl == null
                          ? "https://i.pinimg.com/564x/0c/3b/3a/0c3b3adb1a7530892e55ef36d3be6cb8.jpg"
                          : photourl),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 150,
                left: MediaQuery.of(context).size.width / 2 + 32,
                child: InkWell(
                    onTap: () {

                      loadAssets();
                    },
                    child: Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        child: Container(
                            height: 38,
                            width: 38,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.grey,
                            ),
                            child: Center(
                              child: Icon(
                                Icons.add_photo_alternate,
                                color: Colors.white,
                                size: 26,
                              ),
                            )))),
              ),
              Positioned(
                top: 212,
                right: 0,
                left: 0,
                child: Text(
                  _cName != null ? _cName :
                  "إسم المستخدم",
                  textAlign: TextAlign.center,
                  textDirection: TextDirection.rtl,
                  style: TextStyle(fontSize: 12, color: Colors.black),
                ),
              ),
              Positioned(
                  top: 210,
                  left: MediaQuery.of(context).size.width / 2 + 54,
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        showAlertDialogname(context, _cName);
                      });
                    },
                    child: Icon(
                      Icons.mode_edit,
                      color: Colors.grey,
                    ),
                  ))
            ],
          ),
        ),
        Expanded(
          child: ListView(
            shrinkWrap: true,
            children: [
              InkWell(
                onTap: () {

                  if(provider != "phone"){
                    setState(() {
                      showAlertDialogphone(context, _cMobile);
                    });
                  }


                },
                child: Card(
                    elevation: 2,
                    margin: EdgeInsets.only(right: 10, left: 10),
                    child: Container(
                      height: 40,
                      color: Colors.white,
                      child: Row(
                        textDirection: TextDirection.rtl,
                        children: <Widget>[
                          Container(
                              width: 120,
                             // decoration: BoxDecoration(color: Colors.orange[200]),
                              child:
                              CustomPaint(
                                painter: MyCustomShape3(),
                                size: Size(120, 40),
                 child: Center(
                   child: Text(
                     "رقم الهاتف",
                     textDirection: TextDirection.rtl,
                     style: TextStyle(
                         color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                   ),
                 )
    )
                              ),
                          SizedBox(
                            width: 6,
                          ),
                          Expanded(
                            child: Center(
                              child: Text(
                                _cMobile != null ? _cMobile : "غير محدد",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey
                                ),
                              ),
                            ),
                          ),
                          provider == "phone" ?
                              SizedBox()
                              :
                          Icon(
                            Icons.arrow_back_ios,
                            color: Colors.grey[400],
                            size: 20,
                          ) ,
                          SizedBox(
                            width: 12,
                          ),
                        ],
                      ),
                    )),
              ),
              SizedBox(
                height: 10,
              ),
              InkWell(
                onTap: () {
                  if (!(provider == "google.com" || provider == "password")) {
                    setState(() {
                      showAlertDialogemail(context, _cEmail);
                    });
                  }
                },
                child: Card(
                    elevation: 2,
                    margin: EdgeInsets.only(right: 10, left: 10),
                    child: Container(
                      height: 40,
                      color: Colors.white,
                      child: Row(
                        textDirection: TextDirection.rtl,
                        children: <Widget>[
                          Container(
                              width: 120,
                              // decoration: BoxDecoration(color: Colors.orange[200]),
                              child:
                              CustomPaint(
                                  painter: MyCustomShape3(),
                                  size: Size(120, 40),
                                  child: Center(
                                    child: Text(
                                      "البريد الالكتروني",
                                      textDirection: TextDirection.rtl,
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                                    ),
                                  )
                              )
                          ),
                          SizedBox(
                            width: 6,
                          ),
                          Expanded(
                            child: Center(
                              child: Text(
                                _cEmail != null ? _cEmail : "غير محدد",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey
                                ),
                              ),
                            ),
                          ),
                          (provider == "google.com" || provider == "password")
                              ? SizedBox()
                              : Icon(
                                  Icons.arrow_back_ios,
                                  color: Colors.grey[400],
                            size: 20,
                                ),
                          SizedBox(
                            width: 12,
                          ),
                        ],
                      ),
                    )),
              ),
              SizedBox(
                height: 10,
              ),
              (cType == "trader")
                  ? InkWell(
                      onTap: () {
                        setState(() {
                          showAlertDialogworkshopname(context, workshopname);
                        });
                      },
                      child: Card(
                          elevation: 2,
                          margin: EdgeInsets.only(right: 10, left: 10),
                          child: Container(
                            height: 40,
                            color: Colors.white,
                            child: Row(
                              textDirection: TextDirection.rtl,
                              children: <Widget>[
                                Container(
                                    width: 120,
                                    // decoration: BoxDecoration(color: Colors.orange[200]),
                                    child:
                                    CustomPaint(
                                        painter: MyCustomShape3(),
                                        size: Size(120, 40),
                                        child: Center(
                                          child: Text(
                                            "إسم المحل",
                                            textDirection: TextDirection.rtl,
                                            style: TextStyle(
                                                color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                                          ),
                                        )
                                    )
                                ),
                                SizedBox(
                                  width: 2,
                                ),
                                Expanded(
                                  child: Center(
                                    child: Text(
                                      workshopname != null
                                          ? workshopname
                                          : "غير محدد",
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey
                                      ),
                                    ),
                                  ),
                                ),
                                Icon(
                                  Icons.arrow_back_ios,
                                  color: Colors.grey[400],
                                  size: 20,
                                ),
                                SizedBox(
                                  width: 12,
                                ),
                              ],
                            ),
                          )),
                    )
                  : SizedBox(),
              SizedBox(
                height: 10,
              ),
              (cType == "trader")
                  ? InkWell(
                      onTap: () {
                        setState(() {
                          showDialog(
                              context: context,
                              builder: (context) =>
                                  MyForm4(traderType, onSubmit4: onSubmit4));
                        });
                      },
                      child: Card(
                          elevation: 2,
                          margin: EdgeInsets.only(right: 10, left: 10),
                          child: Container(
                            height: 40,
                            color: Colors.white,
                            child: Row(
                              textDirection: TextDirection.rtl,
                              children: <Widget>[
                                Container(
                                    width: 120,
                                    // decoration: BoxDecoration(color: Colors.orange[200]),
                                    child:
                                    CustomPaint(
                                        painter: MyCustomShape3(),
                                        size: Size(120, 40),
                                        child: Center(
                                          child: Text(
                                            "نوع التاجر",
                                            textDirection: TextDirection.rtl,
                                            style: TextStyle(
                                                color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                                          ),
                                        )
                                    )
                                ),
                                SizedBox(
                                  width: 6,
                                ),
                                Expanded(
                                  child: Center(
                                    child: Text(
                                      traderType != null
                                          ? traderType
                                          : "غير محدد",
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey
                                      ),
                                    ),
                                  ),
                                ),
                                Icon(
                                  Icons.arrow_back_ios,
                                  color: Colors.grey[400],
                                  size: 20,
                                ),
                                SizedBox(
                                  width: 12,
                                ),
                              ],
                            ),
                          )),
                    )
                  : SizedBox(),
              SizedBox(
                height: 10,
              ),
              (cType == "trader")
                  ? InkWell(
                      onTap: () {
                        setState(() {
                          showDialog(
                              context: context,
                              builder: (context) => MyForm3(
                                  traderType, worktype,
                                  onSubmit3: onSubmit3));
                          // }
                        });
                      },
                      child: Card(
                          elevation: 2,
                          margin: EdgeInsets.only(right: 10, left: 10),

                          child: Container(
                            height: 40,
                            color: Colors.white,
                            child: Row(
                              textDirection: TextDirection.rtl,
                              children: <Widget>[
                                Container(
                                    width: 120,
                                    // decoration: BoxDecoration(color: Colors.orange[200]),
                                    child:
                                    CustomPaint(
                                        painter: MyCustomShape3(),
                                        size: Size(120, 40),
                                        child: Center(
                                          child: Text(
                                            "نوع العمل",
                                            textDirection: TextDirection.rtl,
                                            style: TextStyle(
                                                color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                                          ),
                                        )
                                    )
                                ),
                                SizedBox(
                                  width: 6,
                                ),
                                Expanded(
                                  child: Center(
                                    child: Text(
                                      worktype != null ? worktype : "غير محدد",
                                      style: TextStyle(
                                        fontSize: 12,
                                          color: Colors.grey
                                      ),
                                    ),
                                  ),
                                ),
                                Icon(
                                  Icons.arrow_back_ios,
                                  color: Colors.grey[400],
                                  size: 20,
                                ),
                                SizedBox(
                                  width: 12,
                                ),
                              ],
                            ),
                          )),
                    )
                  : SizedBox(),
              SizedBox(
                height: 10,
              ),
              (cType == "trader" && traderType == "تاجر قطع")
                  ? InkWell(
                      onTap: () {
                        setState(() {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MyForm9(
                                      selectedcarslist,
                                      onSubmit9: onSubmit9)));
                        });
                      },
                      child: Card(
                          elevation: 2,
                          margin: EdgeInsets.only(right: 10, left: 10),
                          child: Container(
                            height: 40,
                            color: Colors.white,
                            padding: EdgeInsets.all(6),
                            child: Row(
                              textDirection: TextDirection.rtl,
                              children: <Widget>[
                                Container(
                                    width: 100,
                                    decoration:
                                        BoxDecoration(color: Colors.orange[200]),
                                    child: Center(
                                      child: Text(
                                        "نوع السيارات",
                                        textDirection: TextDirection.rtl,
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 12),
                                      ),
                                    )),
                                SizedBox(
                                  width: 6,
                                ),
                                Expanded(
                                  child: Center(
                                    child: Text(
                                      selectedcars != null
                                          ? selectedcarslist.toString()
                                          : "غير محدد",
                                      style: TextStyle(
                                        fontSize: 12,
                                          color: Colors.grey
                                      ),
                                    ),
                                  ),
                                ),
                                Icon(
                                  Icons.arrow_back_ios,
                                  color: Colors.grey[400],
                                  size: 20,
                                ),
                                SizedBox(
                                  width: 6,
                                ),
                              ],
                            ),
                          )),
                    )
                  : SizedBox(),
              SizedBox(
                height: 10,
              ),
    (cType == "user")?Container():   Card(
                elevation: 2,
                margin: EdgeInsets.only(right: 10, left: 10),
                child: Container(
                  height: 108,
                  child: Stack(
                    children: [

                      Positioned(
                        right: 0,
                        child: Container(
                          height: 108,
                          width: 5,
                          color: MyColors.primaryColor.withOpacity(0.5)
                        ),
                      ),
                      Positioned(
                        top: 8,
                        right: 10,
                        child: Container(
                          padding: EdgeInsets.only(top: 8, right: 10),
                          child: Center(
                            child: Text(
                              "العنوان",
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                          top: 8,
                          left: 10,
                          child: InkWell(
                            onTap: () async {
                              sendData = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => CurrentLocation2()),
                              );
                              setState(() {
                                fromPlace = sendData["loc_latLng"];
                                fromPlaceLat = fromPlace.latitude.toString();
                                fromPlaceLng = fromPlace.longitude.toString();
                                fPlaceName = sendData["loc_name"];
                                Firestore.instance
                                    .collection('users')
                                    .document(_userId)
                                    .updateData({
                                  "fromPLat": fromPlaceLat,
                                  "fromPLat": fromPlaceLng,
                                  "fPlaceName": fPlaceName,
                                });
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.only(top: 8, left: 10),
                              child: Center(
                                child: Text(
                                  "تغيير العنوان الحالي",
                                  textDirection: TextDirection.rtl,
                                  style: TextStyle(
                                      color: MyColors.primaryColor,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          )),
                      Positioned(
                        top: 48,
                        right: 16,
                        child: Text(
                          fPlaceName != null ? fPlaceName : "غير محدد",
                          textDirection: TextDirection.rtl,
                          textAlign: TextAlign.right,
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                      ),
                      Positioned(
                          top: 66,
                          left: 14,
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => MapView(
                                          workshopname,
                                          double.parse(fromPlaceLat),
                                          double.parse(fromPlaceLng))));
                            },
                            child: Container(
                              child: Center(
                                child: Text(
                                  "إظهار العنوان على الخريطة",
                                  textDirection: TextDirection.rtl,
                                  style: TextStyle(
                                      color: MyColors.primaryColor,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ))
                    ],
                  ),
                ),
              ),

              SizedBox(
                height: 16,
              ),

              // InkWell(
              //   onTap: () {
              //     // Navigator.pushReplacement(
              //     //     context,
              //     //     MaterialPageRoute(
              //     //         builder: (context) => PrivcyPolicy()));
              //   },
              //   child: Center(
              //     child: Row(
              //       mainAxisAlignment: MainAxisAlignment.center,
              //       children: <Widget>[
              //         Center(
              //           child: Text(
              //             "سياسة الاستخدام",
              //             style: TextStyle(
              //               fontSize: 10,
              //               color: MyColors.secondaryColor,
              //               fontWeight: FontWeight.bold,
              //             ),
              //           ),
              //         ),
              //         Padding(
              //           padding: const EdgeInsets.only(left: 5),
              //           child: Text(
              //             "*",
              //             style: TextStyle(color: Colors.red),
              //           ),
              //         )
              //       ],
              //     ),
              //   ),
              // ),

              SizedBox(
                height: 16,
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget previousWidget(
    Widget loadingIndicator,
  ) {
    return Form(
      child: Padding(
        padding: EdgeInsets.only(
            top: _minimumPadding * 2,
            bottom: _minimumPadding * 2,
            right: _minimumPadding * 2,
            left: _minimumPadding * 2),
        child: ListView(
          children: <Widget>[
            Container(
              height: 70,
              color: const Color(0xff171732).withOpacity(.4),
              child: Center(
                  child: Text(
                "بيانات حسابك الشخصي",
                style: TextStyle(
                    color: const Color(0xff171732),
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              )),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 30, left: 8, right: 8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    height: 200,
                    width: 200,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 180, top: 150),
                      child: InkWell(
                          onTap: () {
                            loadAssets();
                          },
                          child: _load2
                              ? Center(
                                  child: loadingIndicator,
                                )
                              : Icon(
                                  Icons.mode_edit,
                                  color: Colors.red,
                                )),
                    ),
                    decoration: BoxDecoration(
                      border: new Border.all(
                        color: Colors.black,
                        width: 1.0,
                      ),
                      image: DecorationImage(
                        image: NetworkImage(photourl == null
                            ? "https://i.pinimg.com/564x/0c/3b/3a/0c3b3adb1a7530892e55ef36d3be6cb8.jpg"
                            : photourl),
                        fit: BoxFit.fill,
                      ),
                      shape: BoxShape.circle,
                    ),
                  ),
                  Center(child: loadingIndicator),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 5,
                  ),
                  Card(
                    elevation: 2,
                    shadowColor: Colors.blueAccent,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Directionality(
                          textDirection: TextDirection.rtl,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              _cName != null ? _cName : "الاسم",
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: Icon(Icons.person),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: InkWell(
                              onTap: () {
                                setState(() {
                                  showAlertDialogname(context, _cName);
                                });
                              },
                              child: Icon(Icons.mode_edit)),
                        )
                      ],
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: .2,
                    color: Colors.grey,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Card(
                      elevation: 2,
                      shadowColor: Colors.blueAccent,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Directionality(
                            textDirection: TextDirection.rtl,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                _cMobile != null ? _cMobile : "رقم الجوال",
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: Icon(Icons.phone_iphone),
                          ),
                          provider == "phone"
                              ? Container()
                              : Padding(
                                  padding: const EdgeInsets.only(left: 8),
                                  child: InkWell(
                                      onTap: () {
                                        setState(() {
                                          showAlertDialogphone(
                                              context, _cMobile);
                                        });
                                      },
                                      child: Icon(Icons.mode_edit)),
                                )
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: .2,
                    color: Colors.grey,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Card(
                      elevation: 2,
                      shadowColor: Colors.blueAccent,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Directionality(
                            textDirection: TextDirection.rtl,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                _cEmail != null ? _cEmail : "البريد الإلكترونى",
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: Icon(Icons.email),
                          ),
                          (provider == "google.com" || provider == "password")
                              ? Container()
                              : Padding(
                                  padding: const EdgeInsets.only(left: 8),
                                  child: InkWell(
                                      onTap: () {
                                        setState(() {
                                          showAlertDialogemail(
                                              context, _cEmail);
                                        });
                                      },
                                      child: Icon(Icons.mode_edit)),
                                )
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: .2,
                    color: Colors.grey,
                  ),
                  (cType == "trader")
                      ? Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Card(
                            elevation: 2,
                            shadowColor: Colors.blueAccent,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                Directionality(
                                  textDirection: TextDirection.rtl,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      workshopname != null
                                          ? workshopname
                                          : "اسم المحل",
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 8),
                                  child: Icon(Icons.apartment),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 8),
                                  child: InkWell(
                                      onTap: () {
                                        setState(() {
                                          showAlertDialogworkshopname(
                                              context, workshopname);
                                        });
                                      },
                                      child: Icon(Icons.mode_edit)),
                                )
                              ],
                            ),
                          ),
                        )
                      : Container(),
                  (cType == "trader")
                      ? Container(
                          width: MediaQuery.of(context).size.width,
                          height: .2,
                          color: Colors.grey,
                        )
                      : Container(),
                  (cType == "trader")
                      ? Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Card(
                            elevation: 2,
                            shadowColor: Colors.blueAccent,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                Directionality(
                                  textDirection: TextDirection.rtl,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      traderType != null
                                          ? traderType
                                          : "نوع التاجر",
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 8),
                                  child: Icon(Icons.water_damage),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 8),
                                  child: InkWell(
                                      onTap: () {
                                        setState(() {
                                          showDialog(
                                              context: context,
                                              builder: (context) => MyForm4(
                                                  traderType,
                                                  onSubmit4: onSubmit4));
                                        });
                                      },
                                      child: Icon(Icons.mode_edit)),
                                )
                              ],
                            ),
                          ),
                        )
                      : Container(),
                  (cType == "trader")
                      ? Container(
                          width: MediaQuery.of(context).size.width,
                          height: .2,
                          color: Colors.grey,
                        )
                      : Container(),
                  (cType == "trader")
                      ? Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Card(
                            elevation: 2,
                            shadowColor: Colors.blueAccent,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                Directionality(
                                  textDirection: TextDirection.rtl,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      worktype != null ? worktype : "نوع العمل",
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 8),
                                  child: Icon(Icons.settings),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 8),
                                  child: InkWell(
                                      onTap: () {
                                        setState(() {
                                          showDialog(
                                              context: context,
                                              builder: (context) => MyForm3(
                                                  traderType, worktype,
                                                  onSubmit3: onSubmit3));
                                          // }
                                        });
                                      },
                                      child: Icon(Icons.mode_edit)),
                                )
                              ],
                            ),
                          ),
                        )
                      : Container(),
                  (cType == "trader")
                      ? Container(
                          width: MediaQuery.of(context).size.width,
                          height: .2,
                          color: Colors.grey,
                        )
                      : Container(),
                  (cType == "trader" && traderType == "تاجر قطع")
                      ? Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Card(
                            elevation: 2,
                            shadowColor: Colors.blueAccent,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                Directionality(
                                  textDirection: TextDirection.rtl,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      selectedcars != null
                                          ? selectedcarslist.toString()
                                          : "نوع السيارات",
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 8),
                                  child: Icon(Icons.car_repair),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 8),
                                  child: InkWell(
                                      onTap: () {
                                        setState(() {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) => MyForm9(
                                                      selectedcarslist,
                                                      onSubmit9: onSubmit9)));
                                        });
                                      },
                                      child: Icon(Icons.mode_edit)),
                                )
                              ],
                            ),
                          ),
                        )
                      : Container(),
                  (cType == "trader")
                      ? Container(
                          width: MediaQuery.of(context).size.width,
                          height: .2,
                          color: Colors.grey,
                        )
                      : Container(),
                  (cType == "trader")
                      ? InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MapView(
                                        workshopname,
                                        double.parse(fromPlaceLat),
                                        double.parse(fromPlaceLng))));
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Expanded(
                              child: Card(
                                elevation: 2,
                                shadowColor: Colors.blueAccent,
                                child: Container(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: <Widget>[
                                      Directionality(
                                        textDirection: TextDirection.rtl,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Expanded(
                                            child: Text(
                                              fPlaceName != null
                                                  ? fPlaceName
                                                  : "العنوان",
                                              maxLines: 3,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 8),
                                        child: Icon(Icons.location_on_rounded),
                                      ),
                                      Flexible(
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 8),
                                          child: InkWell(
                                              onTap: () async {
                                                sendData = await Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          CurrentLocation2()),
                                                );
                                                setState(() {
                                                  fromPlace =
                                                      sendData["loc_latLng"];
                                                  fromPlaceLat = fromPlace
                                                      .latitude
                                                      .toString();
                                                  fromPlaceLng = fromPlace
                                                      .longitude
                                                      .toString();
                                                  fPlaceName =
                                                      sendData["loc_name"];
                                                  Firestore.instance
                                                      .collection('users')
                                                      .document(_userId)
                                                      .updateData({
                                                    "fromPLat": fromPlaceLat,
                                                    "fromPLat": fromPlaceLng,
                                                    "fPlaceName": fPlaceName,
                                                  });
                                                });
                                              },
                                              child: Icon(Icons.mode_edit)),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                      : Container(),
                  (cType == "trader")
                      ? Container(
                          width: MediaQuery.of(context).size.width,
                          height: .2,
                          color: Colors.grey,
                        )
                      : Container(),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: InkWell(
                onTap: () {
                  // Navigator.pushReplacement(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context) => PrivcyPolicy()));
                },
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Center(
                        child: Text(
                          "سياسة الاستخدام",
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: Text(
                          "*",
                          style: TextStyle(color: Colors.red),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  showAlertDialogname(BuildContext context, name) {
    nameController = TextEditingController(text: name);

    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text(
        "إلغاء",
        style: TextStyle(color: Colors.black),
      ),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = FlatButton(
      child: Text(
        "حفظ",
        style: TextStyle(color: Colors.black),
      ),
      onPressed: () {
        setState(() {
          if (_formKey.currentState.validate()) {
            Firestore.instance
                .collection('users')
                .document(_userId)
                .updateData({
              "name": nameController.text,
            }).then((_) {
              setState(() {
                _cName = nameController.text;
                Navigator.of(context).pop();
              });
            });
          }
        });
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("تغيير الإسم", textDirection: TextDirection.rtl, textAlign: TextAlign.right,
        style: TextStyle(fontSize: 14, color: MyColors.secondaryColor), ),
      content: Form(
        key: _formKey,
        child: Padding(
            padding:
                EdgeInsets.only(top: _minimumPadding, bottom: _minimumPadding),
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: TextFormField(
                textAlign: TextAlign.right,
                keyboardType: TextInputType.text,
                //style: textStyle,
                //textDirection: TextDirection.rtl,
                controller: nameController,
                validator: (String value) {
                  if (value.isEmpty) {
                    return 'برجاء إدخال الاسم';
                  }
                },
                decoration: InputDecoration(
                  labelText: 'الاسم',
                  //hintText: '$name',
                  //labelStyle: textStyle,
                  errorStyle: TextStyle(color: Colors.red, fontSize: 15.0),
                  // border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0))
                ),
              ),
            )),
      ),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  showAlertDialogphone(BuildContext context, phone) {
    phoneController = TextEditingController(text: phone);

    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text(
        "إلغاء",
        style: TextStyle(color: Colors.black),
      ),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = FlatButton(
      child: Text(
        "حفظ",
        style: TextStyle(color: Colors.black),
      ),
      onPressed: () {
        setState(() {
          if (_formKey.currentState.validate()) {
            Firestore.instance
                .collection('users')
                .document(_userId)
                .updateData({
              "phone": phoneController.text,
            }).then((_) {
              setState(() {
                _cMobile = phoneController.text;
                Navigator.of(context).pop();
              });
            });
          }
        });
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("تعديل رقم الهاتف", textDirection: TextDirection.rtl, textAlign: TextAlign.right,
        style: TextStyle(fontSize: 14, color: MyColors.secondaryColor),),
      content: Form(
        key: _formKey,
        child: Padding(
            padding:
                EdgeInsets.only(top: _minimumPadding, bottom: _minimumPadding),
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: TextFormField(
                textAlign: TextAlign.right,
                keyboardType: TextInputType.number,
                //style: textStyle,
                //textDirection: TextDirection.rtl,
                controller: phoneController,
                validator: (String value) {
                  if (value.isEmpty) {
                    return 'برجاء إدخال رقم الهاتف';
                  }
                  if (value.length < 10) {
                    return ' رقم الهاتف غير صحيح';
                  }
                },
                decoration: InputDecoration(
                  labelText: 'رقم الهاتف',
                  //hintText: '$name',
                  //labelStyle: textStyle,
                  errorStyle: TextStyle(color: Colors.red, fontSize: 15.0),
                  // border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0))
                ),
              ),
            )),
      ),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  showAlertDialogemail(BuildContext context, email) {
    emailController = TextEditingController(text: email);

    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text(
        "إلغاء",
        style: TextStyle(color: Colors.black),
      ),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = FlatButton(
      child: Text(
        "حفظ",
        style: TextStyle(color: Colors.black),
      ),
      onPressed: () {
        setState(() {
          if (_formKey.currentState.validate()) {
            Firestore.instance
                .collection('users')
                .document(_userId)
                .updateData({
              "email": emailController.text,
            }).then((_) {
              setState(() {
                _cEmail = emailController.text;
                Navigator.of(context).pop();
              });
            });
          }
        });
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("تعديل البريد الالكتروني" , textDirection: TextDirection.rtl, textAlign: TextAlign.right,
        style: TextStyle(fontSize: 14, color: MyColors.secondaryColor),),
      content: Form(
        key: _formKey,
        child: Padding(
            padding:
                EdgeInsets.only(top: _minimumPadding, bottom: _minimumPadding),
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: TextFormField(
                textAlign: TextAlign.right,
                keyboardType: TextInputType.text,
                //style: textStyle,
                //textDirection: TextDirection.rtl,
                controller: emailController,
                validator: (String value) {
                  if (value.isEmpty) {
                    return 'برجاء إدخال البريد الإلكترونى';
                  }
                },
                decoration: InputDecoration(
                  labelText: 'البريد الإلكترونى',
                  //hintText: '$name',
                  //labelStyle: textStyle,
                  errorStyle: TextStyle(color: Colors.red, fontSize: 15.0),
                  // border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0))
                ),
              ),
            )),
      ),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  showAlertDialogworkshopname(BuildContext context, workshopname1) {
    workshopnameController = TextEditingController(text: workshopname1);

    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text(
        "إلغاء",
        style: TextStyle(color: Colors.black),
      ),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = FlatButton(
      child: Text(
        "حفظ",
        style: TextStyle(color: Colors.black),
      ),
      onPressed: () {
        setState(() {
          if (_formKey.currentState.validate()) {
            Firestore.instance
                .collection('users')
                .document(_userId)
                .updateData({
              "workshopname": workshopnameController.text,
            }).then((_) {
              setState(() {
                workshopname = workshopnameController.text;
                Navigator.of(context).pop();
              });
            });
          }
        });
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("تغيير إسم المحل" , textDirection: TextDirection.rtl, textAlign: TextAlign.right,
        style: TextStyle(fontSize: 14, color: MyColors.secondaryColor),),
      content: Form(
        key: _formKey,
        child: Padding(
            padding:
                EdgeInsets.only(top: _minimumPadding, bottom: _minimumPadding),
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: TextFormField(
                textAlign: TextAlign.right,
                keyboardType: TextInputType.text,
                //style: textStyle,
                //textDirection: TextDirection.rtl,
                controller: workshopnameController,
                validator: (String value) {
                  if (value.isEmpty) {
                    return 'برجاء إدخال اسم المحل';
                  }
                },
                decoration: InputDecoration(
                  labelText: 'اسم المحل',
                  //hintText: '$name',
                  //labelStyle: textStyle,
                  errorStyle: TextStyle(color: Colors.red, fontSize: 15.0),
                  // border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0))
                ),
              ),
            )),
      ),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void onSubmit4(String result) {
    setState(() {
      Firestore.instance.collection('users').document(_userId).updateData({
        "traderType": result,
      }).then((_) {
        setState(() {
          traderType = result;
          Navigator.of(context).pop();
        });
      });
    });
  }

  void onSubmit3(String result) {
    setState(() {
      Firestore.instance.collection('users').document(_userId).updateData({
        "worktype": result,
      }).then((_) {
        setState(() {
          worktype = result;
          Navigator.of(context).pop();
        });
      });
    });
  }
}
///////////////////////////////////

typedef void MyFormCallback3(String result);

class MyForm3 extends StatefulWidget {
  final MyFormCallback3 onSubmit3;
  String quarter11;
  String traderType;

  MyForm3(this.traderType, this.quarter11, {this.onSubmit3});

  @override
  _MyForm3State createState() => _MyForm3State();
}

class _MyForm3State extends State<MyForm3> {
  String _currentValue = '';

  List<String> _buttonOptions = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _currentValue = widget.quarter11;
    print("ssss${widget.traderType}");
    if (widget.traderType == "تاجر صيانة") {
      _buttonOptions.clear();
      Firestore.instance
          .collection("faults")
          .getDocuments()
          .then((QuerySnapshot snapshot) {
        snapshot.documents.forEach((sparepart) {
          SparePartsClass spc = SparePartsClass(
            sparepart.data['sid'],
            sparepart.data['sName'],
            sparepart.data['surl'],
            const Color(0xff8C8C96),
            false,
          );
          setState(() {
            _buttonOptions.add(sparepart.data['sName']);
          });
        });
      });
    } else if (widget.traderType == "تاجر قطع") {
      _buttonOptions.clear();
      Firestore.instance
          .collection("spareparts")
          .getDocuments()
          .then((QuerySnapshot snapshot) {
        snapshot.documents.forEach((sparepart) {
          SparePartsClass spc = SparePartsClass(
            sparepart.data['sid'],
            sparepart.data['sName'],
            sparepart.data['surl'],
            const Color(0xff8C8C96),
            false,
          );
          setState(() {
            _buttonOptions.add(sparepart.data['sName']);
          });
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget cancelButton = FlatButton(
      child: Text(
        "إلغاء",
        style: TextStyle(color: Colors.black),
      ),
      onPressed: () {
        setState(() {
          Navigator.pop(context);
        });
      },
    );
    Widget continueButton = FlatButton(
      child: Text(
        "حفظ",
        style: TextStyle(color: Colors.black),
      ),
      onPressed: () {
        setState(() {
          widget.onSubmit3(_currentValue.toString());
          // Navigator.pop(context);
        });
      },
    );
    return AlertDialog(
      title: Text(
        "نوع التاجر",
        style: TextStyle(fontWeight: FontWeight.bold),
        textDirection: TextDirection.rtl,
      ),
      content: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.9,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: _buttonOptions
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
                        });
                      },
                    ))
                .toList(),
          ),
        ),
      ),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
  }
}

///////////////////////////////////

typedef void MyFormCallback4(String result);

class MyForm4 extends StatefulWidget {
  final MyFormCallback4 onSubmit4;
  String quarter11;

  MyForm4(this.quarter11, {this.onSubmit4});

  @override
  _MyForm4State createState() => _MyForm4State();
}

class _MyForm4State extends State<MyForm4> {
  String _currentValue = '';

  final _buttonOptions = ["تاجر صيانة", "تاجر قطع"];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _currentValue = widget.quarter11;
  }

  @override
  Widget build(BuildContext context) {
    Widget cancelButton = FlatButton(
      child: Text(
        "إلغاء",
        style: TextStyle(color: Colors.black),
      ),
      onPressed: () {
        setState(() {
          Navigator.pop(context);
        });
      },
    );
    Widget continueButton = FlatButton(
      child: Text(
        "حفظ",
        style: TextStyle(color: Colors.black),
      ),
      onPressed: () {
        setState(() {
          widget.onSubmit4(_currentValue.toString());
          // Navigator.pop(context);
        });
      },
    );
    return AlertDialog(
      title: Text(
        "نوع التاجر",
        style: TextStyle(fontWeight: FontWeight.bold),
        textDirection: TextDirection.rtl,
      ),
      content: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.9,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: _buttonOptions
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
                        });
                      },
                    ))
                .toList(),
          ),
        ),
      ),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
  }
}

//////////////////////////////////
typedef void MyFormCallback9(List<String> result);

class MyForm9 extends StatefulWidget {
  final MyFormCallback9 onSubmit9;
  List<String> selectedcars = [];

  MyForm9(this.selectedcars, {this.onSubmit9});

  @override
  _MyForm9State createState() => _MyForm9State();
}

class _MyForm9State extends State<MyForm9> {
  List<String> outputList = [];
  List<String> cartype = [
    "اودي", "أوبل","أنفيتيتي",
    "ايسوزو", "بي-أم-دبليو","بورش", "بوغاتي", "بيجو", "تويوتا","جي-أم-سي",
    "جاكوار",
    "دودج",
    "دايو",
    "رولزرويس",
    "رينو",
    "سكودا",
    "سوزوكي",
    "سوبارو",
    "سيتروين",
    "سيات",
    "شيري",
    "شفروليه",
    "فولكس-فاجن",
    "فيراري",
    "فولفو",
    "فيات",
    "فورد",
    "كيا",
    "كاديلاك",
    "لينكولن",
    "لاند-روفر",
    "لامبورغيني",
    "مرسيدس",
    "مازدا",
    "ميتشيبيشي",

    "ميني-كوبر",

    "نيسان",
    "هوندا",
    "هيونداي"
  ];
  List<bool> checlist = [];

  @override
  void initState() {
    super.initState();
    outputList.clear();
    print("kkk${widget.selectedcars}");
    checlist = List<bool>.generate(
        cartype.length, (k) => widget.selectedcars.contains(cartype[k]));
    for (int i = 0; i < widget.selectedcars.length; i++) {
      outputList.add(widget.selectedcars[i]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff171732),
        centerTitle: true,
        title: Text(
          "اختر انواع السيارات",
          style: TextStyle(fontWeight: FontWeight.bold),
          textDirection: TextDirection.rtl,
        ),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 18.0),
            child: ListView.builder(
              itemCount: cartype.length,
              itemBuilder: (context, i) {
                return CheckboxListTile(
                  //  groupValue: _currentValue,
                  title: Text(
                    cartype[i],
                    textDirection: TextDirection.rtl,
                  ),
                  //  value: value,
                  value: checlist[i],

                  onChanged: (val) {
                    setState(() {
                      checlist[i] = val;
                    });
                    if (val) {
                      setState(() {
                        outputList.add(cartype[i]);
                        // print("hhh${outputList.length}//"+aList[i].title+aList[i].subtitle[j]);
                        // _currentValuesub=aList[i].subtitle[j];
                        //   _currentValuem =aList[i].title;
                      });
                    } else {
                      outputList.removeWhere((item) => item == cartype[i]);
                      // print("hhh${outputList.length}//"+aList[i].title+aList[i].subtitle[j]);

                    }
                  },
                );
              },
            ),
          ),
          Positioned(
            bottom: 5,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                RaisedButton(
                  onPressed: () {
                    widget.onSubmit9(
                        outputList /**_currentValuem.toString() + "," + _currentValuesub.toString()**/);
                    Navigator.pop(context);
                  },
                  child: const Text('حفظ', style: TextStyle(fontSize: 20)),
                ),
                SizedBox(
                  width: 10,
                ),
                RaisedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("الغاء", style: TextStyle(fontSize: 20)),
                ),
              ],
            ),
          )

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
