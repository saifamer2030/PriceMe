import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:priceme/classes/SparePartsClass.dart';
import 'package:priceme/classes/sharedpreftype.dart';
import 'package:priceme/screens/network_connection.dart';
import 'package:priceme/trader/signuptrader.dart';
import 'package:toast/toast.dart';

class MyLogIn extends StatefulWidget {
  @override
  _MyLogInState createState() => _MyLogInState();
}

class _MyLogInState extends State<MyLogIn> {
  final userdatabaseReference =
      FirebaseDatabase.instance.reference().child("coiffuredata");

  bool _load = false;
  var _formKey1 = GlobalKey<FormState>();
  List<String> faultsList = [];

  final double _minimumPadding = 5.0;

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Widget loadingIndicator = _load
        ? new Container(
      child: SpinKitCircle(color: const Color(0xff171732),),
          )
        : new Container();
    TextStyle textStyle = Theme.of(context).textTheme.subtitle;

    return Scaffold(
      body: Container(
        child: Stack(
          children: <Widget>[
            Form(
              key: _formKey1,
              child: Padding(
                  padding: EdgeInsets.all(_minimumPadding * 2),
                  child: ListView(
                    physics: BouncingScrollPhysics(),
                    children: <Widget>[
                     // getImageAsset(),
                      Padding(
                        padding: EdgeInsets.only(bottom: _minimumPadding),
                        child: Text(
                          " تسجيل الدخول",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                          padding: EdgeInsets.only(
                              top: _minimumPadding, bottom: _minimumPadding),
                          child: Container(
                            width: 250,
                            child: Material(
                                elevation: 5.0,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                                color: Theme.of(context).accentColor,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: new Icon(
                                        Icons.person,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(10.0),
                                            bottomRight: Radius.circular(10.0)),
                                      ),
                                      width: 300,
                                      height: 60,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8),
                                        child: TextFormField(
                                          keyboardType:
                                              TextInputType.emailAddress,
                                          style: textStyle,
                                          textDirection: TextDirection.ltr,
                                          controller: _emailController,
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
                                            border: InputBorder.none,
                                            hintText: 'البريد الإالكترونى',
                                            fillColor: Colors.white,
                                            filled: true,
                                            errorStyle: TextStyle(
                                                color: Colors.black,
                                                fontSize: 15.0),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                )),
                          )),
                      Padding(
                          padding: EdgeInsets.only(
                              top: _minimumPadding, bottom: _minimumPadding),
                          child: Container(
                            width: 250,
                            child: Material(
                                elevation: 5.0,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                                color: Theme.of(context).accentColor,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: new Icon(
                                        Icons.lock,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(10.0),
                                            bottomRight: Radius.circular(10.0)),
                                      ),
                                      width: 300,
                                      height: 60,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8),
                                        child: TextFormField(
                                          // textAlign: TextAlign.right,
                                          obscureText: true,
                                          keyboardType: TextInputType.text,
                                          style: textStyle,
                                          textDirection: TextDirection.ltr,
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
                                            border: InputBorder.none,
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
                                  ],
                                )),
                          )),
                      Padding(
                          padding: EdgeInsets.only(
                              top: _minimumPadding, bottom: _minimumPadding),
                          child: FlatButton(
                            onPressed: () {
                              ResetPasswordDialog();
                              //FirebaseAuth.instance.sendPasswordResetEmail(email: _emailController.text);
                            },
                            child: Text(
                              "هل نسيت كلمة السر؟",
                              textDirection: TextDirection.ltr,
                              style:
                                  TextStyle(color: Colors.white, fontSize: 15),
                            ),
                          )),
                      Padding(
                        padding: EdgeInsets.only(
                            top: _minimumPadding, bottom: _minimumPadding),
                        child: Container(
//                          decoration: BoxDecoration(
//                              borderRadius: BorderRadius.circular(50),
//                              border: Border.all(color: Colors.black, width: 4)),
                          height: 50.0,
                          child: Material(
                            borderRadius: BorderRadius.circular(20.0),
                            shadowColor: const Color(0xffF4E41E),
                            color: Theme.of(context).accentColor,
                            elevation: 7.0,
                            child: GestureDetector(
                              onTap: () {
                                if (_formKey1.currentState.validate()) {
                                  _uploaddata();
                                  setState(() {
                                    _load = true;
                                  });
                                }
                              },
                              child: Center(
                                child: Text(
                                  'تسجيل الدخول',
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
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(
                                  top: _minimumPadding,
                                  bottom: _minimumPadding),
                              child: Text(
                                "ــــــــــــــــــــ",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  top: _minimumPadding,
                                  bottom: _minimumPadding),
                              child: Text(
                                "أو",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  top: _minimumPadding,
                                  bottom: _minimumPadding),
                              child: Text(
                                "ــــــــــــــــــــ",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // ),
                      Row(
                        children: <Widget>[
                          Padding(
                              padding: EdgeInsets.only(
                                  top: _minimumPadding,
                                  bottom: _minimumPadding),
                              child: FlatButton(
                                onPressed: () {
                                  final SparePartsReference = Firestore.instance;

                                  SparePartsReference.collection("faults")
                                      .getDocuments()
                                      .then((QuerySnapshot snapshot) {
                                    snapshot.documents.forEach((sparepart) {
                                      SparePartsClass spc = SparePartsClass(
                                        sparepart.data['sid'],
                                        sparepart.data['sName'],
                                        sparepart.data['surl'],
                                      );
                                      setState(() {
                                        faultsList.add(sparepart.data['sName']);
                                       // print(sparepartsList.length.toString() + "llll");
                                      });
                                    });
                                  }).whenComplete(() {

                                    Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                    builder: (context) => SignUptrader(faultsList)));
                                  });
                                  },
                                child: Text(
                                  "حساب جديد",
                                  style: TextStyle(
                                    color: Colors.orangeAccent,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              )),
                          Padding(
                            padding: EdgeInsets.only(
                                top: _minimumPadding, bottom: _minimumPadding),
                            child: Text(
                              "هل لديك حساب جديد؟",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 20),
                            ),
                          ),
                        ],
                      ),
                    ],
                  )),
            ),
            new Align(
              child: loadingIndicator,
              alignment: FractionalOffset.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget getImageAsset() {
    AssetImage assetImage = AssetImage("assets/images/logo_circle.png");
    Image image = Image(
      image: assetImage,
      width: 125.0,
      height: 125.0,
    );

    return Container(
      child: image,
      margin: EdgeInsets.all(_minimumPadding * 5),
    );
  }

  void _uploaddata() {
//    print("a");
//    Toast.show("a",context,duration: Toast.LENGTH_LONG,gravity:  Toast.BOTTOM);
    FirebaseAuth.instance
        .signInWithEmailAndPassword(
            email: _emailController.text, password: _passwordController.text)
        .then((signedInUser) {
      SessionManager prefs =  SessionManager();
      prefs.setAuthType("trader");
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ConnectionScreen()));
//      userdatabaseReference
//          .child(user.uid)
//          .child("cType")
//          .once()
//          .then((DataSnapshot snapshot) {
//        // print(" ${snapshot.value.toString()}");
//        String usertype = snapshot.value.toString();
//        //Toast.show(" ${snapshot.value.toString()}",context,duration: Toast.LENGTH_LONG,gravity:  Toast.BOTTOM);
//        usertype == 'مستخدم'
//            ? Navigator.of(context).pushReplacementNamed('/userhome')
//            : Navigator.of(context).pushReplacementNamed('/coiffurehome');
//        setState(() {
//          _load = false;
//        });
//      });
      //print(user.uid);
      //Toast.show(user.uid,context,duration: Toast.LENGTH_LONG,gravity:  Toast.BOTTOM);
      // Navigator.of(context).pushReplacementNamed('/userhome');
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
