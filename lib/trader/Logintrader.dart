import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:adobe_xd/gradient_xd_transform.dart';
import 'package:priceme/screens/alladvertisement.dart';
import 'package:priceme/screens/network_connection.dart';
import 'package:priceme/trader/signuptrader.dart';
import 'package:toast/toast.dart';

import '../classes/SparePartsClass.dart';
import '../classes/sharedpreftype.dart';

class Logintrader extends StatefulWidget {
  _Logintrader createState() => _Logintrader();
}


class _Logintrader extends State<Logintrader> {


  bool _load = false;
  var _formKey1 = GlobalKey<FormState>();
  List<String> faultsList = [];
  List<String> sparesList = [];

  final double _minimumPadding = 5.0;

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  //
  // @override
  // void initState() {
  //   super.initState();
  //   final FaultReference = Firestore.instance;
  //
  //   FaultReference.collection("faults")
  //       .getDocuments()
  //       .then((QuerySnapshot snapshot) {
  //     snapshot.documents.forEach((fault) {
  //       SparePartsClass spc = SparePartsClass(
  //         fault.data['sid'],
  //         fault.data['sName'],
  //         fault.data['surl'],
  //       );
  //       setState(() {
  //         faultsList.add(fault.data['sName']);
  //         // print(sparepartsList.length.toString() + "llll");
  //       });
  //     });
  //   });
  //   //////////////////////////////
  //   final SparePartsReference = Firestore.instance;
  //
  //   SparePartsReference.collection("spareparts")
  //       .getDocuments()
  //       .then((QuerySnapshot snapshot) {
  //     snapshot.documents.forEach((sparepart) {
  //       SparePartsClass spc = SparePartsClass(
  //         sparepart.data['sid'],
  //         sparepart.data['sName'],
  //         sparepart.data['surl'],
  //       );
  //       setState(() {
  //         sparesList.add(sparepart.data['sName']);
  //         // print(sparepartsList.length.toString() + "llll");
  //       });
  //     });
  //   });
  //
  //
  //
  // }
  @override
  Widget build(BuildContext context) {


    Widget loadingIndicator = _load
        ? new Container(
      child: SpinKitCircle(color: const Color(0xff171732),),
    )
        : new Container();
    TextStyle textStyle = Theme.of(context).textTheme.subtitle;
    return Scaffold(
      backgroundColor: const Color(0xfffafafa),
      body:
      Stack(
        children: [
          Form(
            key: _formKey1,
            child: Container(

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
                  child: ListView(
                    physics: BouncingScrollPhysics(),
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 80),
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
                      Padding(
                        padding: const EdgeInsets.only(top: 50, left: 20, right: 20),
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(13.0),
                            color: const Color(0xffffffff),
                          ),
                          child: TextFormField(
                                 textAlign: TextAlign.right,
                                obscureText: false,
                                keyboardType: TextInputType.emailAddress,
                                style: textStyle,
                                textDirection: TextDirection.rtl,
                                controller: _emailController,
                                validator:(String value) {
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
                                  border: new OutlineInputBorder(
                                    borderRadius: const BorderRadius.all(
                                      const Radius.circular(13.0),
                                    ),
                                  ),
                                  hintText: 'البريد الالكتروني',
                                  fillColor: Colors.white,
                                  filled: true,
                                  errorStyle: TextStyle(
                                      color: Colors.black,
                                      fontSize: 15.0),
                                ),
                              ),

                        ),
                      ),             Padding(
                        padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(13.0),
                            color: const Color(0xffffffff),
                          ),
                          child: TextFormField(
                             textAlign: TextAlign.right,
                            obscureText: true,
                            keyboardType: TextInputType.text,
                            style: textStyle,
                            textDirection: TextDirection.rtl,
                            controller: _passwordController,
                            validator: (String value) {
                              if (value.isEmpty) {
                                return 'برجاء إدخال كلمة السر';
                              }
                              if (value.length < 6) {
                                return ' كلمة السر لا تقل عن 6';
                              }
                            },

                            decoration: InputDecoration(
                              border:  new OutlineInputBorder(
                                borderRadius: const BorderRadius.all(
                                  const Radius.circular(13.0),
                                ),
                              ),
                              hintText: 'كلمة السر',
                              fillColor: Colors.white,
                              filled: true,
                              errorStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15.0),
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: (){
                          if (_formKey1.currentState.validate()) {
                            _uploaddata();
                            setState(() {
                              _load = true;
                            });
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(top: 50, left: 20, right: 20),
                          child: Container(
                            width: 292.0,
                            height: 47.0,
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
                            child: Center(
                              child: Text(
                                'تسجيل الدخول',
                                style: TextStyle(
                                  fontFamily: 'Helvetica',
                                  fontSize: 13,
                                  color: const Color(0xffffffff),
                                  height: 1,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: InkWell(
                          onTap: (){
                            ResetPasswordDialog();

                          },
                          child: Text(
                            'نسيت كلمة السر ؟',
                            style: TextStyle(
                              fontFamily: 'Ubuntu',
                              fontSize: 14,
                              color: const Color(0xffffffff),
                              fontWeight: FontWeight.w300,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: (){
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SignUptrader(faultsList,sparesList)));

                            },
                            child: Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: Text(
                                'حساب جديد',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: const Color(0xff249cd2),
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          Text(
                            'ليس لديك حساب؟',
                            style: TextStyle(
                              fontSize: 13,
                              color: const Color(0xffffffff),
                              fontWeight: FontWeight.w300,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
      new Align(
        child: loadingIndicator,
        alignment: FractionalOffset.center,)
        ],
      ),



    );
  }
  void _uploaddata() {
//    print("a");
//    Toast.show("a",context,duration: Toast.LENGTH_LONG,gravity:  Toast.BOTTOM);
    FirebaseAuth.instance
        .signInWithEmailAndPassword(
        email: _emailController.text, password: _passwordController.text)
        .then((signedInUser) {
      // SessionManager prefs =  SessionManager();
      // prefs.setAuthType("trader");
      Navigator.push(
          context, MaterialPageRoute(builder: (context) =>AllAdvertisement()));

    }).catchError((e) {
      print(e);
      Toast.show(e, context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      setState(() {
        _load = false;
      });
    });
    // print(_emailController.text+"////");
  }

////////////**********ResetPassword**************************
  ResetPasswordDialog() {
    var _resetKey1 = GlobalKey<FormState>();
    TextEditingController _textFieldController = TextEditingController();
    var alertDialog = AlertDialog(
      title: Text('تغير كلمة السر'),
      content: Form(
        key: _resetKey1,
        child: TextFormField(
          keyboardType: TextInputType.emailAddress,
          //style: textStyle,textDirection: TextDirection.ltr,
          controller: _textFieldController,
          //decoration: InputDecoration(hintText: "البريد الإلكترونى"),
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
            hintText: 'البريد الإالكترونى',
            fillColor: Colors.white,
            filled: true,
            errorStyle: TextStyle(color: Colors.red, fontSize: 15.0),
          ),
        ),
      ),
      actions: <Widget>[
        new FlatButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: new Text('إلغاء'),
        ),
        new FlatButton(
          onPressed: () {
            if (_resetKey1.currentState.validate()) {
              FirebaseAuth.instance
                  .sendPasswordResetEmail(email: _textFieldController.text);
              //Form.of(context).save();
              Navigator.pop(context);
              Toast.show("برجاء مراجعة بريدك الإلكترونى", context,
                  duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
            }
          },
          child: new Text('تأكيد'),
        ),
      ],
    );

    showDialog(
        context: context, builder: (BuildContext context) => alertDialog);
  }
}

