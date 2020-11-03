import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:priceme/Splash.dart';
import 'package:toast/toast.dart';

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
  FirebaseAuth _firebaseAuth;
  String _cName = "";
  String _cMobile;
  String _cType = "";
  String _cEmail="";
  String provider;
  String _userId;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  var _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    FirebaseAuth.instance.currentUser().then((user) => user == null
        ? Navigator.of(context, rootNavigator: false).push(MaterialPageRoute(
        builder: (context) => Splash(), maintainState: false))
        : setState(() {_userId = user.uid;
    var userQuery = Firestore.instance.collection('users').where('uid', isEqualTo: _userId).limit(1);
    userQuery.getDocuments().then((data){
      if (data.documents.length > 0){
        setState(() {
          _cName = data.documents[0].data['name'];
          _cMobile = data.documents[0].data['phone'];
          _cEmail=data.documents[0].data['email'];
         // if(_cName==null){_cName=user.displayName??"اسم غير معلوم";}
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
          provider=user.providerData[1].providerId;
          setState(() {
            nameController = TextEditingController(text: _cName);
            phoneController = TextEditingController(text: _cMobile);
            emailController = TextEditingController(text: _cEmail);

          });
        });
      }
    });
    }));


    //getUser();
  }



  @override
  Widget build(BuildContext context) {
    bool checkingFlight = false;
    bool success = false;

    return Scaffold(
      key: _scaffoldKey,
      body: Form(
        child: Padding(
          padding: EdgeInsets.only(
              top: _minimumPadding * 23,
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
                                  _cMobile != null
                                      ? _cMobile
                                      : "رقم الجوال",
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: Icon(Icons.phone_iphone),
                            ),
                            provider=="phone"?Container():  Padding(
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
                                  _cEmail != null
                                      ? _cEmail
                                      : "البريد الإلكترونى",
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: Icon(Icons.email),
                            ),
                            provider=="google.com"?Container(): Padding(
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
                    // Padding(
                    //   padding: const EdgeInsets.only(top: 10),
                    //   child: Card(
                    //     elevation: 2,
                    //     shadowColor: Colors.blueAccent,
                    //     child: Row(
                    //       mainAxisAlignment: MainAxisAlignment.end,
                    //       children: <Widget>[
                    //         InkWell(
                    //             onTap: () {
                    //               return showInSnackBar(
                    //                   "يجب الافصاح عن نوع حسابك");
                    //             },
                    //             child: Icon(Icons.help)),
                    //         Directionality(
                    //           textDirection: TextDirection.rtl,
                    //           child: Padding(
                    //             padding: const EdgeInsets.all(8.0),
                    //             child: Text(
                    //               _cType != null ? _cType : "النوع",
                    //             ),
                    //           ),
                    //         ),
                    //         Padding(
                    //           padding: const EdgeInsets.only(right: 8),
                    //           child: Icon(Icons.title),
                    //         ),
                    //         InkWell(
                    //           onTap: () {
                    //             setState(() {
                    //               showDialog(
                    //                   context: context,
                    //                   builder: (context) => MyForm4(_cType,
                    //                       onSubmit4: onSubmit4));
                    //             });
                    //           },
                    //           child: Padding(
                    //             padding: const EdgeInsets.only(left: 8),
                    //             child: Icon(Icons.mode_edit),
                    //           ),
                    //         )
                    //       ],
                    //     ),
                    //   ),
                    // ),
                    // Container(
                    //   width: MediaQuery.of(context).size.width,
                    //   height: .2,
                    //   color: Colors.grey,
                    // ),
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(top: 100, left: 50, right: 50),
                child: SheetButton(),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: InkWell(
                  onTap: (){
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
                          child: Text("إتفاقية الاستخدام",style: TextStyle(
                            fontSize: 10,
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 5),
                          child: Text("*",style: TextStyle(color: Colors.red),),
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void showInSnackBar(String value) {
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: Row(
        children: <Widget>[
          Icon(
            Icons.live_help,
            color: Colors.yellow,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: new Text(
              value,
              style: TextStyle(color: Colors.redAccent),
            ),
          ),
        ],
      ),
    ));
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
      title: Text("تأكيد"),
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
      title: Text("تأكيد"),
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
      title: Text("تأكيد"),
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

  void onSubmit4(String result) {
//    print(result);
//    Toast.show("${result}", context,
//        duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    setState(() {
      final userdatabaseReference =
          FirebaseDatabase.instance.reference().child("userdata");
      userdatabaseReference.child(_userId).update({
        "cType": result,
      }).then((_) {
        setState(() {
          _cType = result;
          //   Navigator.of(context).pop();
        });
      });
    });
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

  final _buttonOptions = [
    'محل',
    'مقر',
    'معرض',
    'فرد',
  ];

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
          Navigator.pop(context);
          widget.onSubmit4(_currentValue.toString());
        });
      },
    );
    return AlertDialog(
      title: Text(
        "النوع",
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

class DecoratedTextField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      alignment: Alignment.center,
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        decoration:
            InputDecoration.collapsed(hintText: 'Enter your reference number'),
      ),
    );
  }
}

class SheetButton extends StatefulWidget {
  SheetButton();

  _SheetButtonState createState() => _SheetButtonState();
}

class _SheetButtonState extends State<SheetButton> {
  bool checkingFlight = false;
  bool success = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return !checkingFlight
        ? MaterialButton(
            key: _scaffoldKey,
            color: const Color(0xff171732),
            onPressed: () async {
              setState(() {
                checkingFlight = true;
              });

              await Future.delayed(Duration(seconds: 2));

              setState(() {
                success = true;

              });

              await Future.delayed(Duration(seconds: 1));

              // Navigator.pushReplacement(
              //     context,
              //     MaterialPageRoute(
              //         builder: (context) => FragmentSouq1(widget.regionlist)));
//              return showInSnackBar("تم تحديث حسابك");
            },
            child: Text(
              'تحديث',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          )
        : !success
            ? CircularProgressIndicator()
            : Icon(
                Icons.check,
                size: 100,
                color: Colors.green,
              );
  }

  void showInSnackBar(String value) {
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: new Text(
        value,
        style: TextStyle(color: const Color(0xffffffff)),
      ),
    ));
  }
}
