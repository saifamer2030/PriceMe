
import 'package:adobe_xd/gradient_xd_transform.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:priceme/classes/sharedpreftype.dart';
import 'package:priceme/screens/alladvertisement.dart';
import 'package:priceme/screens/cur_loc.dart';
import 'package:priceme/screens/network_connection.dart';
import 'package:priceme/ui_utile/myColors.dart';
import 'dart:io';
import 'package:toast/toast.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:math' as Math;

import '../FragmentNavigation.dart';


class SignUpEmailUser extends StatefulWidget {
  List<String> faultsList = [];
  List<String> sparesList = [];
  SignUpEmailUser();
  @override
  _SignUpEmailUserState createState() => _SignUpEmailUserState();
}

class _SignUpEmailUserState extends State<SignUpEmailUser> {
  bool _load1 = false;
  String url1;
  String imagepathes = '';
  List<String> urlList = [];
  List<String> selectedcars=[];
  List<String> _typearray=["تاجر صيانة","تاجر قطع"];
  List<Asset> images = List<Asset>();
  String _error = 'No Error Dectected';
  var _formKey = GlobalKey<FormState>();
  LatLng fromPlace, toPlace ;
  String fromPlaceLat , fromPlaceLng , fPlaceName ;
  Map <String , dynamic > sendData = Map();
  String workshoptype;

  //var _typearray = DefConstants.countriesArray;

  final userdatabaseReference =
  FirebaseDatabase.instance.reference().child("coiffuredata");

  final double _minimumPadding = 5.0;


  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmpasswordController = TextEditingController();


  @override
  void initState() {
    super.initState();


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
      body: SafeArea(
              child: Container(
          /*
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
          */
          child: Stack(
            children: <Widget>[
              Form(
                key: _formKey,
                child: Padding(
                    padding: EdgeInsets.all(_minimumPadding * 2),
                    child: ListView(
                      physics: BouncingScrollPhysics(),
                      children: <Widget>[
                      /*
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
                        */
                        //getImageAsset(),
                       
                        Padding(
                          padding: EdgeInsets.only(
                              top: _minimumPadding  * 8, bottom: _minimumPadding),
                          child: Center(
                            child: Text(
                              "إنشاء حساب جديد",
                              style: TextStyle(
                                  color: MyColors.thirdColor,
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
                                fontSize: 12,
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
                                  prefixIcon: Icon(Icons.alternate_email, color: Colors.grey,),
                                  labelText: 'البريد الإلكترونى',
                                  //hintText: 'Name',
                                  labelStyle: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w600),
                                  errorStyle: TextStyle(
                                      color: Colors.red, fontSize: 12.0),
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
                                style: TextStyle(color: Colors.black),
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
                                   prefixIcon: Icon(Icons.lock, color: Colors.grey,),
                                  //hintText: 'Name',
                                  labelStyle: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w600),
                                  errorStyle: TextStyle(
                                      color: Colors.red, fontSize: 12.0),
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
                                style:TextStyle(color: Colors.black),
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
                                   prefixIcon: Icon(Icons.check_circle, color: Colors.grey,),
                                  //hintText: 'Name',
                                  labelStyle: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w600),
                                  errorStyle: TextStyle(
                                      color: Colors.red, fontSize: 12.0),
                                  // border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0))
                                ),
                              ),
                            )),
                        SizedBox(
                          height: _minimumPadding,
                          width: _minimumPadding,
                        ),



                        Padding(
                          padding: EdgeInsets.only(top: 28, bottom: 14, right: 10, left: 10),
                          child: RaisedButton(

                            padding: EdgeInsets.zero,
                            shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                            onPressed: () async {
                              if (_formKey.currentState.validate()) {
                                try {
                                  final result = await InternetAddress.lookup('google.com');
                                  if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
                                    _uploaddata();

                                    setState(() {
                                      _load1 = true;
                                    });
                                  }
                                } on SocketException catch (_) {
                                  //  print('not connected');
                                  Toast.show("برجاء مراجعة الاتصال بالشبكة",context,duration: Toast.LENGTH_LONG,gravity:  Toast.BOTTOM);

                                }
                            }else{}},
                            child:  Container(

                              height: 46.0,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.0),
                               
                                color: MyColors.thirdColor
                              /*
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
*/

                              ),
                              child: Center(
                                child: Text(
                                  'تسجيل',
                                  style: TextStyle(

                                    fontSize: 14,
                                    color: const Color(0xffffffff),
                                    fontWeight: FontWeight.bold
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                        ),

                      ],
                    )),
              ),


              Positioned(
                  top: 22,
                  right: 20,
                  child:
                   IconButton(
                    onPressed: (){
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.arrow_forward,)),
              ),

              new Align(
                child: loadingIndicator, alignment: FractionalOffset.center,),

            ],
          ),
        ),
      ),
    );
  }

  void _uploaddata() {
    //print("kkk"+urlList[0].toString());

    FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: emailController.text,
      password: passwordController.text,
    ).then((signedInUser) {
      print("kkk"+signedInUser.toString());

      adduser(signedInUser.user);
    }).catchError((e) {
      Toast.show(e,context,duration: Toast.LENGTH_LONG,gravity:  Toast.BOTTOM);
      //  print(e);
    });

  }
  void adduser( signedInUser) {
    print("kkk"+signedInUser.uid);
    DateTime now = DateTime.now();
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
    int arrange = int.parse('${now.year}${b}${c}${d}${e}');
    Firestore.instance.collection('users').document(signedInUser.uid).setData({
      'carrange': arrange,
      'uid': signedInUser.uid,
      'cType': "user",
      'email':  emailController.text,
       'name': signedInUser.displayName,
      'phone': signedInUser.phoneNumber,
       'photourl': signedInUser.photoUrl,
    }).whenComplete(() {
      SessionManager prefs =  SessionManager();
      prefs.setAuthType("user");
      DocumentReference documentReference = Firestore.instance
          .collection('Alarm')
          .document("hp8aCGZfS8WLXTnGaUXsOIWZRot1")
          .collection('Alarmid')
          .document();
      documentReference.setData({
        'ownerId': signedInUser.uid,
        'traderid':"hp8aCGZfS8WLXTnGaUXsOIWZRot1",
        'advID': "",
        'alarmid': documentReference.documentID,
        'cdate': now.toString(),
        'tradname': "",
        'ownername':emailController.text,
        'price': "",
        'rate': "",
        'arrange': int.parse("${now.year.toString()}${b}${c}${d}${e}"),
        'cType': "userlogin",
        'photo': signedInUser.photoUrl,

      });
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => FragmentPriceMe()));
    });
  }


}
