import 'dart:io';

import 'package:adobe_xd/gradient_xd_transform.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:priceme/classes/sharedpreftype.dart';
import 'package:priceme/screens/signinphone.dart';
import 'package:priceme/trader/login.dart';
import 'package:toast/toast.dart';

import 'network_connection.dart';


class SignIn extends StatefulWidget {
  SignIn();

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  var _formKey = GlobalKey<FormState>();
  final double _minimumPadding = 5.0;

  TextEditingController _phoneController = TextEditingController();
  TextEditingController _codeController = TextEditingController();

  bool _load = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget loadingIndicator = _load
        ? new Container(
            child: SpinKitCircle(
              color: const Color(0xff5500ff),
            ),
          )
        : new Container();
    TextStyle textStyle = Theme.of(context).textTheme.subtitle;

    return Scaffold(
      backgroundColor: const Color(0xffffffff),
      body: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment(1.38, -0.81),
                end: Alignment(-1.38, 0.67),
                colors: [const Color(0xff001e50), const Color(0xff051631)],
                stops: [0.0, 1.0],
              ),
            ),
            child: ListView(
              children: [

                Padding(
                  padding: const EdgeInsets.only(top: 350,left: 20,right: 20),
                  child: InkWell(

                    onTap: ()  {

                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SignInPhone()));
                    },
                    child: Container(

                      width: 308.0,
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
                          transform: GradientXDTransform(1.0, 0.0, 0.0, 1.837, 0.0,
                              -0.419, Alignment(-0.93, 0.0)),
                        ),
                      ),

                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,

                          children: [

                                            Icon(
                                              Icons.phone_android,
                                              color: Colors.blue[800],size: 40,
                                            ),
                            Text(
                              'تسجيل الدخول بالهاتف',
                              style: TextStyle(
                                fontFamily: 'Helvetica',
                                fontSize: 15,
                                color: const Color(0xffffffff),
                                height: 1,
                              ),
                              textAlign: TextAlign.center,
                            ),

                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20,left: 20,right: 20),
                  child: InkWell(

                    onTap: ()  {
                      setState(() {
                        _load=true;
                      });
signInWithGoogle().whenComplete(() {
    Navigator.of(context).push(
    MaterialPageRoute(
    builder: (context) {
    return ConnectionScreen();
    },
    ),
    );
    });
    },

                    child: Container(
                      width: 308.0,
                      height: 47.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(9.0),
                        border:
                        Border.all(width: 1.0, color: const Color(0xffff5423)),
                      ),
                      child:  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,

                      children: [
                        Image(image: AssetImage("assets/images/google_logo.png"), height: 35.0),

                        Text(
                          'تسجيل الدخول جوجل',
                          style: TextStyle(
                            fontFamily: 'Helvetica',
                            fontSize: 15,
                            color: const Color(0xffffffff),
                            height: 1,
                          ),
                          textAlign: TextAlign.center,
                        ),

                      ],
                    ),

                  ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20,left: 20,right: 20),
                  child: InkWell(

                    onTap: ()  {
setState(() {
  _load=true;
});
                    },
                    child: Container(

                      width: 308.0,
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
                          transform: GradientXDTransform(1.0, 0.0, 0.0, 1.837, 0.0,
                              -0.419, Alignment(-0.93, 0.0)),
                        ),
                      ),

                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,

                        children: [
                          Image(image: AssetImage("assets/images/facebook_logo.png"), height: 50.0),//assets/images/facebook_logo.png

                          Text(
                            'تسجيل الدخول فيس بوك',
                            style: TextStyle(
                              fontFamily: 'Helvetica',
                              fontSize: 15,
                              color: const Color(0xffffffff),
                              height: 1,
                            ),
                            textAlign: TextAlign.center,
                          ),

                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FlatButton(
                   // color: Colors.blue,
                    textColor: Colors.white,
                    disabledColor: Colors.grey,
                    disabledTextColor: Colors.black,
                    padding: EdgeInsets.all(8.0),
                    splashColor: Colors.orangeAccent,
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) {
                            return MyLogIn();}));
                    },
                    child: Text(
                      "هل انت تاجر؟...",
                      style: TextStyle(fontSize: 15.0),
                    ),
                  ),
                )


              ],
            ),


          ),
          new Align(
            child: loadingIndicator, alignment: FractionalOffset.center,),
        ],
      ),
    );
  }

  Future<bool> loginUserphone(String phone, BuildContext context) async {
    FirebaseAuth _auth = FirebaseAuth.instance;

    _auth.verifyPhoneNumber(
        //phoneNumber: "+966$phone",
        phoneNumber: "+2$phone",
        timeout: Duration(seconds: 60),
        verificationCompleted: (AuthCredential credential) async {
          Navigator.of(context).pop();

          AuthResult result = await _auth.signInWithCredential(credential);
         // createRecord(result.user.uid);

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
                        final code = _codeController.text.trim();
                        AuthCredential credential =
                            PhoneAuthProvider.getCredential(
                                verificationId: verificationId, smsCode: code);

                        AuthResult result =
                            await _auth.signInWithCredential(credential);

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
  Future<String> signInWithGoogle() async {

    final FirebaseAuth _auth = FirebaseAuth.instance;
    final GoogleSignIn googleSignIn = GoogleSignIn();

    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
    await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    final AuthResult authResult = await _auth.signInWithCredential(credential);
    final FirebaseUser user = authResult.user;

    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    final FirebaseUser currentUser = await _auth.currentUser();
    assert(user.uid == currentUser.uid);
    print(user.photoUrl.toString()+"////"+user.displayName.toString()+"/////"+user.phoneNumber.toString()+"/////"+user.email.toString());
//    UserUpdateInfo _updateData= new UserUpdateInfo();
//    _updateData.displayName = "ahmed";
//    //_updateData.email = displayName;
//    _updateData.photoUrl = "displayName";
//
//    await user.updateProfile(_updateData);
//    await user.reload();
    updateuser(user);

    return 'signInWithGoogle succeeded: $user';
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
      'cType': "user",

    });
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
    });
  }


}
