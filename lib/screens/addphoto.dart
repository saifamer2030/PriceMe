import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
// import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
import 'package:flutter_video_compress/flutter_video_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:priceme/classes/ModelClass.dart';
import 'package:priceme/trader/myphotos.dart';
import 'package:toast/toast.dart';

import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:persian_number_utility/persian_number_utility.dart';

import 'package:path_provider/path_provider.dart';
import 'dart:math' as Math;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'dart:io';
import 'dart:async';
import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import '../Splash.dart';

class AddPhoto extends StatefulWidget {
  AddPhoto();

  @override
  _AddPhotoState createState() => _AddPhotoState();
}

class _AddPhotoState extends State<AddPhoto> {
  final double _minimumPadding = 5.0;
  var _formKey = GlobalKey<FormState>();
  bool _load2 = false;
  String _userId;

  TextEditingController _titleController = TextEditingController();
  var _departcurrentItemSelected = '';
  String imgurl;
  List<Asset> images = List<Asset>();
  String _error = 'No Error Dectected';
  @override
  void initState() {
    super.initState();

    FirebaseAuth.instance.currentUser().then((user) => user == null
        ? Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => Splash()))
        : setState(() {_userId = user.uid;
    }));

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
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "طلب"),
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
    });
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
        backgroundColor: const Color(0xffffffff),
        body: Stack(
          children: <Widget>[
            Form(
                key: _formKey,
                child: Padding(
                  padding: EdgeInsets.only(
                      top: _minimumPadding * 15,
                      bottom: _minimumPadding * 2,
                      right: _minimumPadding * 2,
                      left: _minimumPadding * 2),
                  child: ListView(
                    physics: BouncingScrollPhysics(),
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          InkWell(
                            onTap: () async {
                              loadAssets();
                            },
                            child: Center(
                              child: Container(
                                width: 200,
                                height: 150,
                                color: Colors.grey[300],
                                child:Padding(
                                  padding: const EdgeInsets.only(top: 25.0),
                                  child: Column(
                                    children: <Widget>[
                                      Padding(
                                         padding:
                                         const EdgeInsets.all( 0.0),
                                         child: Icon(
                                           Icons.add_photo_alternate,
                                           color: Colors.grey,
                                           size: 70,
                                         ),
                                       ),
                                      Padding(
                                        padding:
                                        const EdgeInsets.only(top: 10.0),
                                        child: images.length==0?Icon(
                                          Icons.add_circle,
                                          color: Colors.grey,
                                        ):Icon(
                                          Icons.check_circle,
                                          color: Colors.green,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),

                          SizedBox(
                            height: _minimumPadding,
                            width: _minimumPadding,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(
                                      right: 10, left: 10),
                                  child: Text(
                                    "عنوان الصورة",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
//                                      fontFamily: 'Estedad-Black',
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      right: 10, left: 10),
                                  child: Icon(
                                    Icons.rate_review,
                                    color: const Color(0xff171732),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: _minimumPadding,
                            width: _minimumPadding,
                          ),
                          Container(
                            height: 80,
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Card(
                                elevation: 0.0,
                                color: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Directionality(
                                  textDirection: TextDirection.rtl,
                                  child: TextFormField(
                                    textAlign: TextAlign.right,
                                    keyboardType: TextInputType.text,
                                    textDirection: TextDirection.rtl,
                                    controller: _titleController,
                                    validator: (String value) {
                                      if ((value.isEmpty)) {
                                        return "اكتب عنوان الصورة";
                                      }
                                    },
                                    decoration: InputDecoration(
                                        errorStyle: TextStyle(
                                            color: Colors.red, fontSize: 15.0),
                                        labelText: "ادخل عنوان الفيديو....",
                                        hintText: "ادخل عنوان الفيديو....",
                                        border: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5.0)))),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: 50,
                          ),
                          Container(
                            /*MediaQuery.of(context).size.width*/

                            height: 46,
                            child: new RaisedButton(
                              padding: EdgeInsets.zero,
                              child:

                              Container(
                                  height: 46,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  gradient: LinearGradient(
                                    begin: Alignment.topRight,
                                    end: Alignment.bottomLeft,
                                    colors: [
                                      const Color(0xfffe7210),
                                      const Color(0xffff8b14),
                                      const Color(0xffffbc16),
                                    ],
                                    // stops: [0.1, 0.8,0.6],
                                  ),


                                ),
                                child:  Row(
                                  mainAxisAlignment: MainAxisAlignment.center,

                                  children: <Widget>[
                                    new Text(
                                      "إضافة",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
//                                      fontFamily: 'Estedad-Black',
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: Icon(
                                        Icons.check,
                                        color: Colors.white,
                                      ),
                                    ),

                                  ],
                                )
                              )
                             ,
                              textColor: Colors.white,
                              color: const Color(0xff171732),
                              onPressed: () async {
                                if (_formKey.currentState.validate()) {
                                  if (images.length > 0 ) {
                                    try {
                                      final result =
                                          await InternetAddress.lookup(
                                              'google.com');
                                      if (result.isNotEmpty &&
                                          result[0].rawAddress.isNotEmpty) {
                                        print("mmmmm1");

                                        uploadpp0();
                                        //uploadToFirebase();

                                        setState(() {
                                          _load2 = true;
                                        });
                                      }
                                    } on SocketException catch (_) {
                                      Toast.show(
                                          "انت غير متصل بشبكة إنترنت",
                                          context,
                                          duration: Toast.LENGTH_LONG,
                                          gravity: Toast.BOTTOM);
                                    }
                                  } else {
                                    Toast.show(
                                        "ضيف صورة علي الاقل",
                                        context,
                                        duration: Toast.LENGTH_SHORT,
                                        gravity: Toast.BOTTOM);
                                  }
                                }
                              },
                              shape: new RoundedRectangleBorder(
                                  borderRadius:
                                      new BorderRadius.circular(10.0)),
                            ),
                          ),

                        ],
                      ),
                    ],
                  ),
                )),
            new Align(
              child: loadingIndicator,
              alignment: FractionalOffset.center,
            ),
          ],
        ));
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
        createRecord(Imageurl.toString());

      });

    }

    Toast.show("تم تحميل الصور", context,
        duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
    setState(() {
      _load2 = true;
    });
  }

  void createRecord(url1) {
    print("mmmmm4");
    FirebaseAuth.instance.currentUser().then((user) => user == null
        ? null
        : setState(() {
      _userId = user.uid;
      DateTime now = DateTime.now();
      String date =
          '${now.year}-${now.month}-${now.day}-${now.hour}-${now.minute}-00-000';

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
      String date1 = '${now.year}-${b}-${c} ${d}:${e}:00';
      int arrange = int.parse('${now.year}${b}${c}${d}${e}');

      DocumentReference documentReference =
      Firestore.instance.collection('photos').document();
      documentReference.setData({
        'cId': documentReference.documentID,
        'carrange': arrange,
        'cuserId': _userId,
        'imgurl': url1,
        'cdate': date1,
        'ctitle': _titleController.text,
      }).whenComplete(() {
        setState(() {
          _load2 = false;
          _titleController.text = "";
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => MyPhotos()));
        });
      }).catchError((e) {

        setState(() {
          _load2 = false;
        });
      });
    }));
  }

  showAlertDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) => new CupertinoAlertDialog(
                title: new Text("تهاننا"),
                content: new Text("تم نشر الصورة"),
                actions: [
                  CupertinoDialogAction(
                    isDefaultAction: false,
                    child: new FlatButton(
                      child: Text("تم"),
                      onPressed: () {
                        Navigator.pop(context);

                      },
                    ),
                  )
                ]));
  }


}

