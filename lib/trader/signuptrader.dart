
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
import 'package:priceme/screens/alladvertisement.dart';
import 'package:priceme/screens/cur_loc.dart';
import 'package:priceme/screens/network_connection.dart';
import 'package:priceme/ui_utile/myColors.dart';
import 'dart:io';
import 'package:toast/toast.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:math' as Math;

import 'Fragmenttrader.dart';

class SignUptrader extends StatefulWidget {
  List<String> faultsList = [];
  List<String> sparesList = [];
  SignUptrader(this.faultsList,this.sparesList);
  @override
  _SignUptraderState createState() => _SignUptraderState();
}

class _SignUptraderState extends State<SignUptrader> {
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

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmpasswordController = TextEditingController();
  TextEditingController workshopnameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  var _typecurrentItemSelected = '';
  var _faultcurrentItemSelected = '';
 var _sparecurrentItemSelected="";


  @override
  void initState() {
    super.initState();

     _typecurrentItemSelected = _typearray[0];
    _faultcurrentItemSelected =widget.faultsList[0];
    _sparecurrentItemSelected =widget.sparesList[0];
workshoptype=_faultcurrentItemSelected;
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
/*
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
          */
        ),
        child: Stack(
          children: <Widget>[
            Form(
              key: _formKey,
              child: Padding(
                  padding: EdgeInsets.all(10),
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
                            top: _minimumPadding * 8, bottom: _minimumPadding),
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
                              keyboardType: TextInputType.text,
                              style: TextStyle(color: Colors.white),
                              //textDirection: TextDirection.rtl,
                              controller: nameController,
                              validator: (String value) {
                                if (value.isEmpty) {
                                  return 'برجاء ادخال اسم التاجر ';
                                }
                              },
                              decoration: InputDecoration(
                                labelText: 'اسم التاجر',
                                prefixIcon: Icon(Icons.person, color: Colors.grey,),
                                //hintText: 'Name',
                                labelStyle: TextStyle(color: Colors.black, fontSize: 13, fontWeight: FontWeight.w600),
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
                                prefixIcon: Icon(Icons.alternate_email, color: Colors.grey,),
                                //hintText: 'Name',
                                labelStyle: TextStyle(color: Colors.black, fontSize: 13, fontWeight: FontWeight.w600,),
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
                                prefixIcon: Icon(Icons.lock, color: Colors.grey,),
                                //hintText: 'Name',
                                labelStyle: TextStyle(color: Colors.black, fontSize: 13, fontWeight: FontWeight.w600),
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
                                prefixIcon: Icon(Icons.check_box, color: Colors.grey,),
                                //hintText: 'Name',
                                labelStyle: TextStyle(color: Colors.black, fontSize: 13, fontWeight: FontWeight.w600),
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
                            top: _minimumPadding * 2,),
                        child: Text(
                            "معلومات إضافية",
                            textDirection: TextDirection.rtl,
                            style: TextStyle(
                                color:Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                       
                      ),
                      SizedBox(
                        height: _minimumPadding,
                        
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
                                prefixIcon: Icon(Icons.store, color: Colors.grey,),
                                //hintText: 'Name',
                                labelStyle: TextStyle(color: Colors.black, fontSize: 13, fontWeight: FontWeight.w600),
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
                                prefixIcon: Icon(Icons.phone_android, color: Colors.grey,),
                                //hintText: 'Name',
                                labelStyle:TextStyle(color: Colors.black, fontSize: 13, fontWeight: FontWeight.w600),
                                errorStyle: TextStyle(
                                    color: Colors.red, fontSize: 12.0, ),
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
                              color:Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            top: _minimumPadding * 4, bottom: _minimumPadding),
                        child: Container(
                          
                          height: 40.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(width: 1, color: Colors.grey)
                          ),
                          child: Material(
                              borderRadius: BorderRadius.circular(5.0),
                              shadowColor: const Color(0xffdddddd),
                              color:  Colors.white,                  //const Color(0xffe7e7e7),
                              elevation: 2.0,
                              child: Align(
                                alignment: Alignment.centerRight,
                                child:
                                DropdownButtonHideUnderline(
                                  child:DropdownButton<String>(
                                    items: _typearray.map((String value) {
                                      return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(
                                            value,
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600),
                                          ));
                                    }).toList(),
                                    value: _typecurrentItemSelected,
                                    onChanged: (String newValueSelected) {
                                      // Your code to execute, when a menu item is selected from dropdown
                                      _onDropDownItemSelectedtype(
                                          newValueSelected);
                                    },
                                  )
                                )
                                ,
                              )),
                        ),
                      ),
                      SizedBox(
                        height: _minimumPadding,
                        width: _minimumPadding,
                      ),
                      _typecurrentItemSelected== _typearray[0]?Padding(
                         padding: EdgeInsets.only(
                             top: _minimumPadding, bottom: _minimumPadding),
                         child: Container(
                           height: 40.0,
                           decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(width: 1, color: Colors.grey)
                          ),
                         //  width: MediaQuery.of(context).size.width/2.3,
                           child: Material(
                               borderRadius: BorderRadius.circular(5.0),
                               shadowColor: const Color(0xffdddddd),
                               color: Colors.white,
                               elevation: 2.0,
                               child: Align(
                                 alignment: Alignment.centerRight,
                                 child:
                                 DropdownButtonHideUnderline(
                                   child: DropdownButton<String>(
                                     items: widget.faultsList.map((String value) {
                                       return DropdownMenuItem<String>(
                                           value: value,
                                           child: Text(
                                             value,
                                             textAlign: TextAlign.center,
                                             style: TextStyle(
                                                 color:  Colors.black,
                                                 fontSize: 14,
                                                 fontWeight: FontWeight.w600),
                                           ));
                                     }).toList(),
                                     value: _faultcurrentItemSelected,
                                     onChanged: (String newValueSelected) {
                                       // Your code to execute, when a menu item is selected from dropdown
                                       _onDropDownItemSelectedfault(
                                           newValueSelected);
                                     },
                                   )
                                 )
                                 ,
                               )),
                         ),
                       ):Padding(
                        padding: EdgeInsets.only(
                            top: _minimumPadding, bottom: _minimumPadding),
                        child: Container(
                          height: 40.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(width: 1, color: Colors.grey)
                          ),
                          // width: MediaQuery.of(context).size.width/2.3,
                          child:
                          Material(
                            borderRadius: BorderRadius.circular(5.0),
                            shadowColor: const Color(0xffdddddd),
                            color: Colors.white,
                            elevation: 2.0,
                            child:  Align(
                                alignment: Alignment.centerRight,
                                child:
                                DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(

                                    items: widget.sparesList.map((String value) {
                                      return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(
                                            value,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color:  Colors.black,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600),
                                          ));
                                    }).toList(),
                                    value: _sparecurrentItemSelected,
                                    onChanged: (String newValueSelected) {
                                      // Your code to execute, when a menu item is selected from dropdown
                                      _onDropDownItemSelectedspare(
                                          newValueSelected);
                                    },
                                  )
                                )
                                ,
                              ),
                        )
                        ),
                      ),
                      SizedBox(
                        height: _minimumPadding,
                        width: _minimumPadding,
                      ),
                      _typecurrentItemSelected==_typearray[1]?Container(
                      //  height: 40,

                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MyForm4(selectedcars,
                                        onSubmit4: onSubmit4)));

                          },
                          child: Card(
                            elevation: 0.0,
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                              side: BorderSide(width: 1, color: Colors.grey)
                            ),
                            child:
                            Container(
                              height: 40,
                              child: Stack(
                                children: [
                                  Align(alignment: Alignment.center,
                                  child:  Text(
                                        "نوع السيارة",
                                        textDirection: TextDirection.rtl,
                                        style:TextStyle(
                                            color:  Colors.black,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600),
                                      ),


                                  ),

                                  Positioned(
                                    top: 8,
                                    right: 8,
                                    child: Icon(Icons.keyboard_arrow_down),
                                  )
                                ],
                              ),
                            )

                           ,
                          ),
                        ),
                      ):Container(),
                      _typecurrentItemSelected==_typearray[1]? Center(child: Text(selectedcars.toString(),
                        style: TextStyle(color: Colors.white) ,)):Container(),
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
                                setState(() {
                                  fromPlace = sendData["loc_latLng"];
                                  fromPlaceLat = fromPlace.latitude.toString();
                                  fromPlaceLng = fromPlace.longitude.toString();
                                  fPlaceName = sendData["loc_name"];
                                  print("\n\n\n\n\n\n\nfromPlaceLng>>>>"+
                                      fromPlaceLng+fPlaceName+"\n\n\n\n\n\n");
                                });


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
                                    color: Colors.black,
                                    fontSize: 14,
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
                        padding: EdgeInsets.only(top: 18, bottom: 14, right: 10, left: 10),
                        child: RaisedButton(

                          padding: EdgeInsets.zero,
                          shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                          onPressed: () async {
                            if (_formKey.currentState.validate()) {

                              if(fromPlaceLat == null || fromPlaceLng == null ||   fPlaceName == null  ){
                                Toast.show("برجاء إدخال الموقع",context,duration: Toast.LENGTH_LONG,gravity:  Toast.BOTTOM);
                              }else{
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

                                }}

                            } else
                              print('correct');
                          },
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
                top: 24,
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
    );
  }

 void _onDropDownItemSelectedtype(String newValueSelected) {
   setState(() {
     this._typecurrentItemSelected = newValueSelected;
   });
 }
  void _onDropDownItemSelectedfault(String newValueSelected) {
    setState(() {
      this._faultcurrentItemSelected = newValueSelected;
      workshoptype=newValueSelected;
    });
  }
  void _onDropDownItemSelectedspare(String newValueSelected) {
    setState(() {
      this._sparecurrentItemSelected = newValueSelected;
      workshoptype=newValueSelected;

    });
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
    print("kkk"+signedInUser.uid);
    Firestore.instance.collection('users').document(signedInUser.uid).setData({
      'carrange': arrange,
      'uid': signedInUser.uid,
      'email': emailController.text,
      'name': nameController.text,
      'phone': phoneController.text,
      'photourl': signedInUser.photoUrl,
      "provider": signedInUser.providerData[1].providerId,
      'fromPLat': fromPlaceLat,
      'fromPLng': fromPlaceLng,
      'fPlaceName':fPlaceName,
      'worktype': workshoptype,
      'workshopname': workshopnameController.text,
      'cType': "trader",
      'traderType': _typecurrentItemSelected,
      'selectedcarstring': selectedcars.toString(),
      'selectedcarslist': selectedcars,


    }).whenComplete(() {
      SessionManager prefs =  SessionManager();
      prefs.setAuthType("trader");
      DocumentReference documentReference = Firestore.instance
          .collection('Alarm')
          .document("hp8aCGZfS8WLXTnGaUXsOIWZRot1")
          .collection('Alarmid')
          .document();
      documentReference.setData({
        'ownerId':"hp8aCGZfS8WLXTnGaUXsOIWZRot1",
        'traderid':signedInUser.uid,
        'advID': "",
        'alarmid': documentReference.documentID,
        'cdate': now.toString(),
        'tradname': nameController.text,
        'ownername': workshopnameController.text,
        'price': "",
        'rate': "",
        'arrange': int.parse("${now.year.toString()}${b}${c}${d}${e}"),
        'cType': "tradelogin",
      });
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => FragmentTrader()));
    });
  }


  void onSubmit4(List<String> result) {
    setState(() {
      selectedcars.clear();
      selectedcars.addAll(result);
    });
      Toast.show(
          "${selectedcars.toString()}//////", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    result.clear();
  }

}

//////////////////////////////////
typedef void MyFormCallback4(List<String> result);
class MyForm4 extends StatefulWidget {
  final MyFormCallback4 onSubmit4;
  List<String> selectedcars = [];
  MyForm4(this.selectedcars,{this.onSubmit4});
  @override
  _MyForm4State createState() => _MyForm4State();
}
class _MyForm4State extends State<MyForm4> {

  List<String> outputList = [];
  List<String> cartype = [ "اودي",
    "أوبل",
    "أنفيتيتي",
    "إيسوزو فاستر",
    "بي-أم-دبليو",
    "بورش",
    "بوغاتي",
    "بيجو",
    "تيسلا",
    "تويوتا"
    ,"جي-أم-سي",
    "جاكوار",
    "دودج",
    "دايو",
    "رولزرويس",
    "رينو",
    "سكودا",
    "سوزوكي"
    , "سوبارو"
    , "سيتروين",
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
    "هيونداي",

  ];
  List<bool> checlist = [];
  @override
  void initState() {
    super.initState();
    outputList.clear();
    checlist= List<bool>.generate(cartype.length,(k) => widget.selectedcars.contains(cartype[k]));
    for(int i = 0; i < widget.selectedcars.length; i++){
        outputList.add( widget.selectedcars[i]);
    }
    }
  @override
  Widget build(BuildContext context) {

    return  Scaffold(
      appBar: AppBar(
        backgroundColor: MyColors.primaryColor,
        centerTitle:true ,
        automaticallyImplyLeading: false,
        title: Text(
          "اختر انواع السيارات",
          style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
          textDirection: TextDirection.rtl,
        ),
        actions: [
          InkWell(
            onTap: (){
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_forward, color: Colors.white,)
          ),
          SizedBox(width: 24,)
        ],

      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top:18.0),
            child: ListView.builder(
              itemCount:cartype.length,
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
                      checlist[i]=val;
                    });
                    if(val){
                      setState(() {
                        outputList.add( cartype[i]);
                       // print("hhh${outputList.length}//"+aList[i].title+aList[i].subtitle[j]);
                        // _currentValuesub=aList[i].subtitle[j];
                        //   _currentValuem =aList[i].title;
                      });
                    }else{
                      outputList.removeWhere((item) => item ==cartype[i]);
                     // print("hhh${outputList.length}//"+aList[i].title+aList[i].subtitle[j]);

                    }
                  },
                );
              },
            ),
          ),

          Positioned(
            left: 20,
            bottom: 20,
            child: FloatingActionButton(
              heroTag: "submitCars",
              onPressed: (){
                widget.onSubmit4(outputList/**_currentValuem.toString() + "," + _currentValuesub.toString()**/);
                Navigator.pop(context);
              },
              backgroundColor: MyColors.secondaryColor,
              child: Icon(Icons.check, color: Colors.white,),
            ),
          )
    /*
          Positioned(
            bottom: 5,

            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment:MainAxisAlignment.spaceBetween ,
              children: <Widget>[
                RaisedButton(

                  onPressed: () {
                    widget.onSubmit4(outputList/**_currentValuem.toString() + "," + _currentValuesub.toString()**/);
                    Navigator.pop(context);

                  },
                  color: MyColors.primaryColor,
                  child: const Text('حفظ', style: TextStyle(fontSize: 14)),
                ),



              ],
            ),
          )
*/
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

