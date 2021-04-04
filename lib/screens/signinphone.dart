import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:priceme/classes/sharedpreftype.dart';
import 'package:toast/toast.dart';
import 'package:priceme/ui_utile/myColors.dart';

import '../FragmentNavigation.dart';


class SignInPhone extends StatefulWidget {
  List<String> regionlist = [];

  SignInPhone();

  @override
  _SignInPhoneState createState() => _SignInPhoneState();
}

class _SignInPhoneState extends State<SignInPhone> {
  var _formKey = GlobalKey<FormState>();
  final double _minimumPadding = 5.0;


  TextEditingController _phoneController = TextEditingController();
  TextEditingController _codeController = TextEditingController();

//  var _initpassword = '';
//  var _initpasswordconf = '';
  bool _load = false;

//  final userdatabaseReference =
//  FirebaseDatabase.instance.reference().child("userdata");

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget loadingIndicator = _load
        ? new Container(
            child: SpinKitCircle(
              color: const Color(0xffff5423),
            ),
          )
        : new Container();
    TextStyle textStyle = Theme.of(context).textTheme.subtitle;

    return Scaffold(
      backgroundColor: const Color(0xffffffff),
      body: SafeArea(
              child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
     /*   decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment(1.38, -0.81),
              end: Alignment(-1.38, 0.67),
              colors: [const Color(0xff008D95), const Color(0xff15494A)],
              stops: [0.0, 1.0],
            ),
          ),
          */
          child: Stack(
            children: <Widget>[

              Positioned(
                top: 22,
                right: 20,
                child: IconButton(
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.arrow_forward, )),
              ),  
              Form(
                key: _formKey,
                child: Padding(
                    padding: EdgeInsets.only(
                        top: _minimumPadding * 40,
                        bottom: _minimumPadding * 2,
                        right: _minimumPadding * 2,
                        left: _minimumPadding * 2),
                    child: ListView(
                      physics: BouncingScrollPhysics(),
                      children: <Widget>[

                        Center(
                          child: Text("تسجيل الدخول برقم الهاتف", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                        ),

                        SizedBox(height: 20 ),   
                        Padding(
                            padding: EdgeInsets.only(
                                top: _minimumPadding, bottom: _minimumPadding,right: _minimumPadding,left: _minimumPadding),
                            child: Container(
                              decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14.0),
                         
                          ),
                              child: Directionality(
                                textDirection: TextDirection.rtl,
                                child: TextFormField(
                                  
                                  //style: TextStyle(fontSize: 22.0, color: Colors.red),
                                  textAlign: TextAlign.right,
                                  keyboardType: TextInputType.number,
                                  //style: textStyle,
                                  //textDirection: TextDirection.rtl,
                                  controller: _phoneController,
                                  validator: (String value) {
                                    if (value.isEmpty) {
                                      return "برجاء إدخال رقم الهاتف"; //Translations.of(context).translate('please_enter_the_phone_number');
                                    }
                                    if (value.length < 9) {
                                      return "رقم هاتف غير صحيح"; //Translations.of(context).translate('phone_number_is_incorrect');
                                    }
                                  },
                                 // autofocus: false,
                                  style: textStyle,
                                  decoration: InputDecoration(
                                    isDense: true,
                                    
                                    filled: true,
                                    fillColor: Colors.white,
                                    hintText: 'رقم الهاتف',
                                    hintStyle: TextStyle(fontSize: 12),
                                    prefixIcon:Icon(Icons.phone_android),
                                     border: new OutlineInputBorder(
                                    borderRadius: const BorderRadius.all(
                                      const Radius.circular(14.0),
                                    ),
                                    
                                  ),
                                   errorStyle: TextStyle(
                                      color: Colors.red,
                                      fontSize: 12.0),
                                    contentPadding:
                                    const EdgeInsets.only(left: 10.0, bottom: 6.0, top:6.0),


                                  
                                  ),
                                ),
                              ),
                            )),
                        Padding(
                          padding: const EdgeInsets.only(top: 30, right: 10, left: 10, bottom: 16),
                          child: Container(
                            width: 300 /*MediaQuery.of(context).size.width*/,
                            height: 45,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(9.0),
                              color: MyColors.thirdColor
                            ),
                            child: new InkWell(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  new Text("دخول",style: TextStyle(color: Colors.white),),
                                  SizedBox(
                                    height: _minimumPadding,
                                    width: _minimumPadding,
                                  ),
                                  Icon(
                                    Icons.check,
                                    color: Colors.white,
                                  ),
                                ],
                              ),


                              onTap: () async {
                                if (_formKey.currentState.validate()) {
                                  try {
                                    final result = await InternetAddress.lookup(
                                        'google.com');
                                    if (result.isNotEmpty &&
                                        result[0].rawAddress.isNotEmpty) {
                                      //  print('connected');
                                      loginUserphone(
                                          _phoneController.text.trim(), context);
                                      setState(() {
                                        _load = true;
                                      });
                                    }
                                  } on SocketException catch (_) {
                                    //  print('not connected');
                                    Toast.show(
                                        "برجاء مراجعة الاتصال بالشبكة", context,
                                        duration: Toast.LENGTH_LONG,
                                        gravity: Toast.BOTTOM);
                                  }
                                  //loginUserphone(_phoneController.text.trim(), context);

                                } else
                                  print('correct');
                              },
//
                            ),
                          ),
                        ),
                      ],
                    )),
              ),
              new Align(
                child: loadingIndicator,
                alignment: FractionalOffset.center,
              ),
              // new Align(child: loadingIndicator,alignment: FractionalOffset.center,),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> loginUserphone(String phone, BuildContext context) async {
    FirebaseAuth _auth = FirebaseAuth.instance;

    _auth.verifyPhoneNumber(
        phoneNumber: "+966$phone",
      // phoneNumber: "+2$phone",
        timeout: Duration(seconds: 60),
        verificationCompleted: (AuthCredential credential) async {
          Navigator.of(context).pop();

          AuthResult result = await _auth.signInWithCredential(credential);
          print(result.user.photoUrl.toString()+"////"+result.user.displayName.toString()+"/////"+result.user.phoneNumber.toString()+"/////"+result.user.email.toString());
          //createRecord(result.user.uid);
          updateuser(result.user);


          //FirebaseUser user = result.user;
          // Navigator.of(context).pushReplacementNamed('/fragmentsouq');

//          if(user != null){
//            Navigator.push(context, MaterialPageRoute(
//                builder: (context) => HomeScreen(user: user,)
//            ));
//          }else{
//            print("Error");
//          }

          //This callback would gets called when verification is done auto maticlly
        },
        verificationFailed: (AuthException exception) {
          print(exception);
        },
        codeSent: (String verificationId, [int forceResendingToken]) {
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) {
                return AlertDialog(
                  title: Column(
                    children: <Widget>[
                      Container(
                        width: 50.0,
                        height: 50.0,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            alignment: Alignment.center,
                            matchTextDirection: true,
                            repeat: ImageRepeat.noRepeat,
                            image: AssetImage(
                                "assets/images/ic_confirmephone.png"),
                          ),
                          borderRadius: BorderRadius.circular(21.0),
                          //color: const Color(0xff4fc3f7),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5.0),
                        child: Text("تحقق من الكود المرسل؟"),
                      ),
                    ],
                  ),
//                  AssetImage("assets/logowhite.png"),
//Text("Give the code?"),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Container(
                        color: Colors.grey[300],
                        width: 150,
                        child: TextField(
                          keyboardType: TextInputType.number,
                          controller: _codeController,
                        ),
                      ),
                    ],
                  ),
                  actions: <Widget>[
                    FlatButton(
                      child: Text("تأكيد"),
                      textColor: Colors.white,
                      color: Colors.black,
                      onPressed: () async {
                        print("kkkjjj");
                        final code = _codeController.text.trim();
                        AuthCredential credential =
                            PhoneAuthProvider.getCredential(
                                verificationId: verificationId, smsCode: code);

                        AuthResult result =
                            await _auth.signInWithCredential(credential);
                        UserUpdateInfo _updateData= new UserUpdateInfo();
                        _updateData.displayName = "اسم غير معلوم";
                        _updateData.photoUrl = "https://www.google.com/url?sa=i&url=https%3A%2F%2Fpngriver.com%2Fdownload-man-logo-png-image-65037-for-designing-projects-112142%2F&psig=AOvVaw08MEE3CePA5GnPN5EAba79&ust=1598431934776000&source=images&cd=vfe&ved=0CAIQjRxqFwoTCODhxZL9tesCFQAAAAAdAAAAABAJ";

                        await result.user.updateProfile(_updateData);
                        await result.user.reload();
                        print(result.user.photoUrl.toString()+"////"+result.user.displayName.toString()+"/////"+result.user.phoneNumber.toString()+"/////"+result.user.email.toString());
                        //createRecord(result.user.uid);
                        updateuser(result.user);
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => FragmentPriceMe()));
                        //FirebaseUser user = result.user;
                        //createRecord(result.user.uid);
                        // Navigator.of(context).pushReplacementNamed('/fragmentsouq');
                      },
                    )
                  ],
                );
              });
        },
        codeAutoRetrievalTimeout: null);
  }
  void adduser(FirebaseUser signedInUser) {
    print("kkk"+signedInUser.uid);
    Firestore.instance.collection('users').document(signedInUser.uid).setData({
      'uid': signedInUser.uid,
      'email': signedInUser.email,
      'name': signedInUser.displayName,
      'phone': signedInUser.phoneNumber,
      'photourl': signedInUser.photoUrl,
      "provider": signedInUser.providerData[1].providerId,
      'cType': "trader",

    });
    void updateuser(FirebaseUser signedInUser) {
      Firestore.instance.collection('users')
          .document(signedInUser.uid)
          .updateData({
        'cType': "user",
      });
    }
//        .whenComplete(() {
//      Navigator.push(
//          context,
//          MaterialPageRoute(
//              builder: (context) => Home(4)));
//    });
  }
  void updateuser(FirebaseUser signedInUser) {
    SessionManager prefs =  SessionManager();
    prefs.setAuthType("user");
    Firestore.instance.collection('users')
        .document(signedInUser.uid)
        .updateData({
      'cType': "user",
      'uid':signedInUser.uid,
      'phone':_phoneController.text,
    }).then((value) {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => FragmentPriceMe()));
    }).catchError((e){
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
      Firestore.instance.collection('users')
          .document(signedInUser.uid)
          .setData({
        'carrange': arrange,
        'cType': "user",
        'uid':signedInUser.uid,
        'phone':_phoneController.text,
        'email':  signedInUser.email,
        'name': signedInUser.displayName,
        'photourl': signedInUser.photoUrl,

      }).then((value) {
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
          'ownername':signedInUser.displayName,
          'price': "",
          'rate': "",
          'arrange': int.parse("${now.year.toString()}${b}${c}${d}${e}"),
          'cType': "userlogin",
        });
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => FragmentPriceMe()));
      });
    });
  }
  /**void createRecord(signedInUserid) {
    setState(() {
      _load = false;
    });
    final userdatabaseReference =
        FirebaseDatabase.instance.reference().child("userdata");


    if ("cPhone" != null) {
      userdatabaseReference.child(signedInUserid).update({
        "cPhone": _phoneController.text,
      }).then((_) {
        setState(() {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => FragmentSouq1(widget.regionlist)));
        });
      });
    } else {
      userdatabaseReference.child(signedInUserid).update({
        "cPhone": _phoneController.text,
        'rating': "0",
        'custRate': 0,
      }).then((_) {
        setState(() {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => FragmentSouq1(widget.regionlist)));
        });
      });
    }
  }**/
}
