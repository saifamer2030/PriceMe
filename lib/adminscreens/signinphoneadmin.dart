import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:priceme/classes/sharedpreftype.dart';
import 'package:toast/toast.dart';

import '../FragmentNavigation.dart';
import 'FragmentNavigationadmin.dart';


class SignInPhoneAdmin extends StatefulWidget {
  List<String> regionlist = [];

  SignInPhoneAdmin();

  @override
  _SignInPhoneAdminState createState() => _SignInPhoneAdminState();
}

class _SignInPhoneAdminState extends State<SignInPhoneAdmin> {
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
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment(1.38, -0.81),
            end: Alignment(-1.38, 0.67),
            colors: [const Color(0xff008D95), const Color(0xff15494A)],
            stops: [0.0, 1.0],
          ),
        ),
        child: Stack(
          children: <Widget>[

            Form(
              key: _formKey,
              child: Padding(
                  padding: EdgeInsets.only(
                      top: _minimumPadding * 50,
                      bottom: _minimumPadding * 2,
                      right: _minimumPadding * 2,
                      left: _minimumPadding * 2),
                  child: ListView(
                    physics: BouncingScrollPhysics(),
                    children: <Widget>[
                      Padding(
                          padding: EdgeInsets.only(
                              top: _minimumPadding, bottom: _minimumPadding,right: _minimumPadding,left: _minimumPadding),
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
                                  return "برجاء إدخال رقم الجوال"; //Translations.of(context).translate('please_enter_the_phone_number');
                                }
                                if (value.length < 9) {
                                  return "رقم هاتف غير صحيح"; //Translations.of(context).translate('phone_number_is_incorrect');
                                }
                              },
                              autofocus: false,
                              style: textStyle,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                labelText: "رقم الجوال",
                                //Translations.of(context).translate('telephone_number'),
                                //hintText: 'مثل:512345678',
                                prefixIcon: Padding(
                                  padding: const EdgeInsets.only(right: 10),
                                  child: Icon(Icons.phone_android),
                                ),
                                contentPadding:
                                const EdgeInsets.only(left: 14.0, bottom: 8.0, top: 8.0),
//                                focusedBorder: OutlineInputBorder(
//                                  borderSide: BorderSide(color: Colors.white),
//                                  borderRadius: BorderRadius.circular(5.7),
//                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                  borderRadius: BorderRadius.circular(5.7),
                                ),
                              ),
                            ),
                          )),
                      Padding(
                        padding: const EdgeInsets.all(30.0),
                        child: Container(
                          width: 300 /*MediaQuery.of(context).size.width*/,
                          height: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(9.0),
                            border: Border.all(
                                width: 1.0, color: const Color(0xffff5423)),
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
    );
  }

  Future<bool> loginUserphone(String phone, BuildContext context) async {
    FirebaseAuth _auth = FirebaseAuth.instance;

    _auth.verifyPhoneNumber(
       // phoneNumber: "+966$phone",
        phoneNumber: "+2$phone",
        timeout: Duration(seconds: 60),
        verificationCompleted: (AuthCredential credential) async {
          Navigator.of(context).pop();

          AuthResult result = await _auth.signInWithCredential(credential);
          print(result.user.photoUrl.toString()+"////"+result.user.displayName.toString()+"/////"+result.user.phoneNumber.toString()+"/////"+result.user.email.toString());
          //createRecord(result.user.uid);
          updateuser(result.user);

          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => FragmentNavigationAdmin()));

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
                                builder: (context) => FragmentNavigationAdmin()));
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
      'cType': "admin",

    });
    void updateuser(FirebaseUser signedInUser) {
      Firestore.instance.collection('users')
          .document(signedInUser.uid)
          .updateData({
        'cType': "admin",
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
      'cType': "admin",
    });
  }

}
