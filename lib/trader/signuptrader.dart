
import 'package:adobe_xd/gradient_xd_transform.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:priceme/classes/sharedpreftype.dart';
import 'package:priceme/screens/cur_loc.dart';
import 'package:priceme/screens/network_connection.dart';
import 'dart:io';
import 'package:toast/toast.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:math' as Math;

class SignUptrader extends StatefulWidget {
  List<String> faultsList = [];
  SignUptrader(this.faultsList);
  @override
  _SignUptraderState createState() => _SignUptraderState();
}

class _SignUptraderState extends State<SignUptrader> {
  bool _load1 = false;
  String url1;
  String imagepathes = '';
  List<String> urlList = [];

  List<Asset> images = List<Asset>();
  String _error = 'No Error Dectected';
  var _formKey = GlobalKey<FormState>();
  LatLng fromPlace, toPlace ;
  String fromPlaceLat , fromPlaceLng , fPlaceName ;
  Map <String , dynamic > sendData = Map();


  //var _typearray = DefConstants.countriesArray;

  final userdatabaseReference =
  FirebaseDatabase.instance.reference().child("coiffuredata");

  final double _minimumPadding = 5.0;

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmpasswordController = TextEditingController();
  TextEditingController workshopnameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  //var _typecurrentItemSelected = '';
  var _workcurrentItemSelected = '';


  @override
  void initState() {
    super.initState();

    // _typecurrentItemSelected = _typearray[0];
    _workcurrentItemSelected = widget.faultsList[0];
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
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment(1.38, -0.81),
            end: Alignment(-1.38, 0.67),
            colors: [
              const Color(0xff04939b),
              const Color(0xff008d95),
              const Color(0xff15494a)
            ],
            stops: [0.0, 0.0, 1.0],
          ),
        ),
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
                        padding: const EdgeInsets.only(top: 0),
                        child: Container(
                          height: 170.0,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: const AssetImage('assets/images/ic_logo2.png'),
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                      ),
                      //getImageAsset(),
                      Padding(
                        padding: EdgeInsets.only(
                            top: _minimumPadding, bottom: _minimumPadding),
                        child: Center(
                          child: Text(
                            "إنشاء حساب جديد",
                            style: TextStyle(
                                color: const Color(0xffff904a),
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
                        child: Center(
                          child: Text(
                            "برجاء إدخال المعلومات صحيحة لتجنب أى مسألة قانونية",
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 15,
                              //fontWeight: FontWeight.bold,
                            ),
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
                              style: TextStyle(color: Colors.white),
                              //textDirection: TextDirection.rtl,
                              controller: nameController,
                              validator: (String value) {
                                if (value.isEmpty) {
                                  return 'برجاء ادخال اسم مزود الخدمة';
                                }
                              },
                              decoration: InputDecoration(
                                labelText: 'اسم التاجر',
                                //hintText: 'Name',
                                labelStyle: TextStyle(color: Colors.white),
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
                              keyboardType: TextInputType.emailAddress,
                              style: TextStyle(color: Colors.white),
                              //textDirection: TextDirection.rtl,
                              controller: emailController,
                              validator: (String value) {
                                if (value.isEmpty) {
                                  return 'برجاء إدخال البريد الإلكترونى';
                                }
                                Pattern pattern =
                                    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                                RegExp regex = new RegExp(pattern);
                                if (!regex.hasMatch(value)) {
                                  return 'بريد إلكترونى غير صحيح';
                                }
                              },
                              decoration: InputDecoration(
                                labelText: 'البريد الإلكترونى',
                                //hintText: 'Name',
                                labelStyle: TextStyle(color: Colors.white),
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
                              obscureText: true,
                              textAlign: TextAlign.right,
                              keyboardType: TextInputType.text,
                              style: TextStyle(color: Colors.white),
                              //textDirection: TextDirection.rtl,
                              controller: passwordController,
                              validator: (String value) {
                                if (value.isEmpty) {
                                  return 'برجاء إدخال كلمة السر';
                                }
                                if (value.length < 6) {
                                  return ' كلمة السر لا تقل عن 6';
                                }
                              },
                              decoration: InputDecoration(
                                labelText: 'كلمة السر',
                                //hintText: 'Name',
                                labelStyle: TextStyle(color: Colors.white),
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
                              obscureText: true,
                              textAlign: TextAlign.right,
                              keyboardType: TextInputType.text,
                              style:TextStyle(color: Colors.white),
                              //textDirection: TextDirection.rtl,
                              controller: confirmpasswordController,
                              validator: (String value) {
                                if (value.isEmpty) {
                                  return 'برجاء إدخال تأكيد لكلمة السر';
                                }
                                if (value.length < 6) {
                                  return ' كلمة السر لا تقل عن 6';
                                }
                                if (value != passwordController.text) {
                                  return 'لا تساوى كلمة المرور';
                                }
                              },
                              decoration: InputDecoration(
                                labelText: 'تأكيد كلمة السر',
                                //hintText: 'Name',
                                labelStyle: TextStyle(color: Colors.white),
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
                            top: _minimumPadding * 5, bottom: _minimumPadding),
                        child: Center(
                          child: Text(
                            "معلومات إضافية",
                            style: TextStyle(
                                color:const Color(0xffff904a),
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
                              style:TextStyle(color: Colors.white),
                              //textDirection: TextDirection.rtl,
                              controller: workshopnameController,
                              validator: (String value) {
                                if (value.isEmpty) {
                                  return 'برجاء إدخال اسم المحل';
                                }
                              },
                              decoration: InputDecoration(
                                labelText: 'اسم المحل',
                                //hintText: 'Name',
                                labelStyle: TextStyle(color: Colors.white),
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
                              style: TextStyle(color: Colors.white),
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
                                //hintText: 'Name',
                                labelStyle:TextStyle(color: Colors.white),
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

                      SizedBox(
                        height: _minimumPadding,
                        width: _minimumPadding,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: Text(
                          "العمل",
                          textDirection: TextDirection.rtl,
                          style: TextStyle(
                              color:const Color(0xffff904a),
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
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
                                  items: widget.faultsList.map((String value) {
                                    return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(
                                          value,
                                          style: TextStyle(
                                              color:  const Color(0xffff2121),
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold),
                                        ));
                                  }).toList(),
                                  value: _workcurrentItemSelected,
                                  onChanged: (String newValueSelected) {
                                    // Your code to execute, when a menu item is selected from dropdown
                                    _onDropDownItemSelectedWork(
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
                            top: _minimumPadding * 5, bottom: _minimumPadding),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            InkWell(
                              onTap: (){loadAssets();} ,
                              child: Icon(
                                images.length>0 ? Icons.check_circle : Icons
                                    .add_photo_alternate,
                                color: const Color(0xffff904a),
                                size: 50,
                              ),
                            ),
                            SizedBox(
                              width: 10.0,
                            ),
                            Expanded(
                              child: Text(
                                "يرجى الضغط على الصورة لتحميل صور الاعمال السابقة",
                                textDirection: TextDirection.rtl,
                                style: TextStyle(
                                    color: Colors.white,
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
                                fromPlace = sendData["loc_latLng"];
                                fromPlaceLat = fromPlace.latitude.toString();
                                fromPlaceLng = fromPlace.longitude.toString();
                                fPlaceName = sendData["loc_name"];
                                print("\n\n\n\n\n\n\nfromPlaceLng>>>>"+
                                    fromPlaceLng+fPlaceName+"\n\n\n\n\n\n");

                              } ,
                              child: Icon(
                                fromPlaceLat == null ? Icons.gps_fixed : Icons.check_circle
                                    ,
                                color:   const Color(0xffff904a),
                                size: 50,
                              ),
                            ),
                            SizedBox(
                              width: 10.0,
                            ),
                            Expanded(
                              child: Text(
                                "يرجى الضغط على الصورة لتحديد موقع المحل",
                                textDirection: TextDirection.rtl,
                                style: TextStyle(
                                    color: Colors.white,
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
                      Padding(
                        padding: EdgeInsets.only(
                            top: _minimumPadding, bottom: _minimumPadding),
                        child: Container(
                          height: 50.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(9.0),
                            gradient: RadialGradient(
                              center: Alignment(-0.93, 0.0),
                              radius: 1.092,
                              colors: [
                                const Color(0xffff2121),
                                const Color(0xffff5423),
                                const Color(0xffff7024),
                                const Color(0xffff904a)
                              ],
                              stops: [0.0, 0.562, 0.867, 1.0],
                              transform: GradientXDTransform(1.0, 0.0, 0.0, 1.837,
                                  0.0, -0.419, Alignment(-0.93, 0.0)),
                            ),
                          ),
                            child: GestureDetector(
                              onTap: () async {
                                if (_formKey.currentState.validate()) {

                                  if(fromPlaceLat == null || fromPlaceLng == null ||   fPlaceName == null  ){
                                    Toast.show("برجاء إدخال الموقع",context,duration: Toast.LENGTH_LONG,gravity:  Toast.BOTTOM);
                                  }else{
                                    try {
                                      final result = await InternetAddress.lookup('google.com');
                                      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
                                        uploadpp0();

                                        setState(() {
                                          _load1 = true;
                                        });
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
                                  'تسجيل',
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

//  void _onDropDownItemSelectedType(String newValueSelected) {
//    setState(() {
//      this._typecurrentItemSelected = newValueSelected;
//    });
//  }
  void _onDropDownItemSelectedWork(String newValueSelected) {
    setState(() {
      this._workcurrentItemSelected = newValueSelected;
    });
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
  void _uploaddata(urlList) {
    //print("kkk"+urlList[0].toString());

    FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: emailController.text,
      password: passwordController.text,
    ).then((signedInUser) {
      print("kkk"+signedInUser.toString());

      adduser(signedInUser.user, urlList);
    }).catchError((e) {
      Toast.show(e,context,duration: Toast.LENGTH_LONG,gravity:  Toast.BOTTOM);
      //  print(e);
    });


//    var alertDialog = AlertDialog(
//      title: Text("مبارك"),
//        Toast.show("تم تسجيل الدخول بنجاح",context,duration: Toast.LENGTH_SHORT,gravity:  Toast.BOTTOM);  content: Text("تم الحجز بنجاح"),
//    );
//
//    showDialog(
//        context: context,
//        builder: (BuildContext context) => alertDialog);
  }
  void adduser( signedInUser, urlList) {
    print("kkk"+signedInUser.uid);
    Firestore.instance.collection('users').document(signedInUser.uid).setData({
      'uid': signedInUser.uid,
      'email': emailController.text,
      'name': nameController.text,
      'phone': phoneController.text,
      'photourl': signedInUser.photoUrl,
      'curilist': urlList.toString(),
      "provider": signedInUser.providerData[1].providerId,
      'fromPLat': fromPlaceLat,
      'fromPLng': fromPlaceLng,
      'fPlaceName':fPlaceName,
      'worktype': _workcurrentItemSelected,
      'workshopname': workshopnameController.text,
      'cType': "trader",
    }).whenComplete(() {
      SessionManager prefs =  SessionManager();
      prefs.setAuthType("trader");
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ConnectionScreen()));
    });
  }

  Future uploadpp0() async {
    if (images.length == 0) {
      _uploaddata("");

    } else {
    final StorageReference storageRef =
    FirebaseStorage.instance.ref().child('myimage');
    int i = 0;
    for (var f in images) {
      //  images.forEach((f) async {
      var byteData = await f.getByteData(quality: 50);
//      final String path1 = await getApplicationDocumentsDirectory().path;
//      var file=await getImageFileFromAssets(path);
      // final byteData = await rootBundle.load('$f');
      DateTime now = DateTime.now();
      final file = File('${(await getTemporaryDirectory()).path}/$f');
      await file.writeAsBytes(byteData.buffer
          .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
      final StorageUploadTask uploadTask =
      storageRef.child('$now.jpg').putFile(file);
      var Imageurl = await (await uploadTask.onComplete).ref.getDownloadURL();
      Toast.show("تم تحميل صورة طال عمرك", context,
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
        _uploaddata(urlList);
      }
    }
    setState(() {
      _load1 = true;
    });
  }
  }


}


