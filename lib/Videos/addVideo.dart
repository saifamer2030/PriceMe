import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

// import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
import 'package:flutter_video_compress/flutter_video_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:priceme/classes/ModelClass.dart';
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

class AddVideo extends StatefulWidget {
  AddVideo();

  @override
  _AddVideoState createState() => _AddVideoState();
}

class _AddVideoState extends State<AddVideo> {
  final double _minimumPadding = 5.0;
  var _formKey = GlobalKey<FormState>();
  bool _load2 = false;
  String _userId;
  String dep1;
  String dep2;
  int picno = 0;
  List<String> urlList = [];
  String _cName, _cphotourl, _cType;
  List<String> departlist = ["ترفيهى", "تجارى"];
  File videofile, thumbnailurlfile;
  bool videocheck = false;
  double _value = 0.0;
  TextEditingController _titleController = TextEditingController();
  TextEditingController _detailController = TextEditingController();
  var _departcurrentItemSelected = '';
  String imgurl;
  List<Asset> images = List<Asset>();
  double _currentSliderValue = 0.0;
  int vd = 0;
  List<String> indyearlist = [];
  var _indyearcurrentItemSelected = "";
  String model1;
  String model2;

  @override
  void initState() {
    super.initState();
    _departcurrentItemSelected = departlist[1];
    DateTime now = DateTime.now();
    indyearlist = new List<String>.generate(
        50,
        (i) => NumberUtility.changeDigit(
            (now.year + 1 - i).toString(), NumStrLanguage.English));
    indyearlist[0] = ("الموديل");
    _indyearcurrentItemSelected = indyearlist[0];
    FirebaseAuth.instance.currentUser().then((user) => user == null
        ? Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Splash()))
        : setState(() {
            _userId = user.uid;
            var userQuery = Firestore.instance
                .collection('users')
                .where('uid', isEqualTo: _userId)
                .limit(1);
            userQuery.getDocuments().then((data) {
              if (data.documents.length > 0) {
                setState(() {
                  _cType = data.documents[0].data['cType'];
                  _cName = data.documents[0].data['name'];
                  _cphotourl = data.documents[0].data['photourl'];
                  if (_cphotourl == null) {
                    if (user.photoUrl == null || user.photoUrl == "") {
                      _cphotourl =
                          "https://i.pinimg.com/564x/0c/3b/3a/0c3b3adb1a7530892e55ef36d3be6cb8.jpg";
                    } else {
                      _cphotourl = user.photoUrl;
                    }
                  }
                  if (_cName == null) {
                    if (user.displayName == null || user.displayName == "") {
                      _cName = "اسم غير معلوم";
                    } else {
                      _cName = user.displayName;
                    }
                  }
                });
              }
            });
          }));
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
                              showDialog(
                                context: context,
                                builder: (BuildContext context) =>
                                    new CupertinoAlertDialog(
                                  title: new Text("اختار الفيديو من..."),
                                  content: Column(
                                    children: [
                                      CupertinoDialogAction(
                                          isDefaultAction: false,
                                          child: new FlatButton(
                                            onPressed: () async {
                                              videofile =
                                                  await ImagePicker.pickVideo(
                                                source: ImageSource.gallery,
                                              ).whenComplete(() {
                                                setState(() {
                                                  videocheck = true;

                                                  Future.delayed(
                                                      Duration(seconds: 0),
                                                      () async {
                                                    MediaInfo info =
                                                        await FlutterVideoCompress()
                                                            .getMediaInfo(
                                                                videofile.path)
                                                            .then(
                                                                (value) async {
                                                      print(
                                                          "${(value.duration / 2000).round()}");
                                                      thumbnailurlfile = await FlutterVideoCompress()
                                                          .getThumbnailWithFile(
                                                              videofile.path,
                                                              quality: 50,
                                                              // default(100)
                                                              position: (value
                                                                          .duration /
                                                                      2000)
                                                                  .round() // default(-1)
                                                              );
                                                    });
                                                    Navigator.pop(context);
                                                  });
                                                });
                                              }).catchError((e) {
                                                print("ccccc$e");
                                                Navigator.pop(context);
                                              });
                                            },
                                            child: Text("متصفح الوسائط"),
                                          )),
                                      CupertinoDialogAction(
                                          isDefaultAction: false,
                                          child: new FlatButton(
                                            onPressed: () async {
                                              videofile =
                                                  await ImagePicker.pickVideo(
                                                source: ImageSource.camera,
                                              ).whenComplete(() {
                                                setState(() {
                                                  videocheck = true;

                                                  Future.delayed(
                                                      Duration(seconds: 0),
                                                      () async {
                                                    MediaInfo info =
                                                        await FlutterVideoCompress()
                                                            .getMediaInfo(
                                                                videofile.path)
                                                            .then(
                                                                (value) async {
                                                      print(
                                                          "${(value.duration / 2000).round()}");
                                                      thumbnailurlfile = await FlutterVideoCompress()
                                                          .getThumbnailWithFile(
                                                              videofile.path,
                                                              quality: 50,
                                                              // default(100)
                                                              position: (value
                                                                          .duration /
                                                                      2000)
                                                                  .round() // default(-1)
                                                              );
                                                    });
                                                    Navigator.pop(context);
                                                  });
                                                });
                                              }).catchError((e) {
                                                print("ccccc$e");
                                                Navigator.pop(context);
                                              });
                                            },
                                            child: Text("تصوير كاميرا"),
                                          )),
                                    ],
                                  ),
                                  actions: [
                                    CupertinoDialogAction(
                                        isDefaultAction: false,
                                        child: new FlatButton(
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          child: Text("إلغاء"),
                                        )),
                                  ],
                                ),
                              );
                            },
                            child: Center(
                              child: Container(
                                width: 200,
                                height: 150,
                                color: Colors.grey[300],
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 25.0),
                                  child: Column(
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.all(0.0),
                                        child: Icon(
                                          Icons.video_call,
                                          color: Colors.grey,
                                          size: 70,
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 10.0),
                                        child: !videocheck
                                            ? Icon(
                                                Icons.add_circle,
                                                color: Colors.grey,
                                              )
                                            : Icon(
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
                          // Slider(
                          //   value: _currentSliderValue,
                          //   min: 0,
                          //   max: double.parse("$vd"),
                          //   divisions: 5,
                          //   label: _currentSliderValue.round().toString(),
                          //   onChanged: (double value) {
                          //     setState(() {
                          //       _currentSliderValue = value;
                          //     });
                          //   },
                          // ),
                          // _cType == "trader"
                          //     ? Center(
                          //         child: Container(
                          //           width: 250,
                          //           height: 50,
                          //           child: Padding(
                          //             padding: const EdgeInsets.all(4.0),
                          //             child: Card(
                          //               elevation: 0.0,
                          //               color: const Color(0xff171732),
                          //               shape: RoundedRectangleBorder(
                          //                 borderRadius:
                          //                     BorderRadius.circular(5),
                          //               ),
                          //               child: DropdownButtonHideUnderline(
                          //                   child: ButtonTheme(
                          //                 alignedDropdown: true,
                          //                 child: DropdownButton<String>(
                          //                   items:
                          //                       departlist.map((String value) {
                          //                     return new DropdownMenuItem<
                          //                         String>(
                          //                       value: value,
                          //                       child: new Text(value),
                          //                     );
                          //                   }).toList(),
                          //                   value: _departcurrentItemSelected,
                          //                   onChanged:
                          //                       (String newValueSelected) {
                          //                     // Your code to execute, when a menu item is selected from dropdown
                          //                     _onDropDownItemSelecteddep(
                          //                         newValueSelected);
                          //                   },
                          //                   style: new TextStyle(
                          //                     color: Colors.grey,
                          //                   ),
                          //                 ),
                          //               )),
                          //             ),
                          //           ),
                          //         ),
                          //       )
                          //     : Container(),
                          _departcurrentItemSelected == departlist[1]
                              ? Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(
                                          top: _minimumPadding,
                                          bottom: _minimumPadding),
                                      child: Container(
                                        height: 40.0,
                                        child: Material(
                                            borderRadius:
                                                BorderRadius.circular(5.0),
                                            shadowColor:
                                                const Color(0xffdddddd),
                                            color: const Color(0xffe7e7e7),
                                            elevation: 2.0,
                                            child: Align(
                                              alignment: Alignment.centerRight,
                                              child: DropdownButton<String>(
                                                items: indyearlist
                                                    .map((String value) {
                                                  return DropdownMenuItem<
                                                          String>(
                                                      value: value,
                                                      child: Text(
                                                        value,
                                                        style: TextStyle(
                                                            color: const Color(
                                                                0xffF1AB37),
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ));
                                                }).toList(),
                                                value:
                                                    _indyearcurrentItemSelected,
                                                onChanged:
                                                    (String newValueSelected) {
                                                  // Your code to execute, when a menu item is selected from dropdown
                                                  _onDropDownItemSelectedindyear(
                                                      newValueSelected);
                                                },
                                              ),
                                            )),
                                      ),
                                    ),
                                    Container(
                                      height: 40,
                                      color: Colors.grey,
                                      child: InkWell(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) => MyForm3(
                                                      "نوع السيارة",
                                                      onSubmit3: onSubmit3)));

//                                    setState(() {
//                                      showDialog(
//                                          context: context,
//                                          builder: (context) => MyForm3(
//                                              widget.department,
//                                              onSubmit3: onSubmit3));
//                                    });
//showBottomSheet();
                                        },
                                        child: Card(
                                          elevation: 0.0,
                                          color: const Color(0xff171732),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                          child: Center(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                "نوع السيارة",
                                                textDirection:
                                                    TextDirection.rtl,
                                                style: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              : Container(),
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
                                    "عنوان الفيديو",
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
                                        return "اكتب عنوان الفيديو";
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
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(
                                      right: 10, left: 10),
                                  child: Text(
                                    "تفاصيل الفيديو",
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
                          Container(
                            height: 300,
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
                                    textDirection: TextDirection.rtl,
                                    keyboardType: TextInputType.multiline,
                                    textInputAction: TextInputAction.newline,
                                    controller: _detailController,
                                    validator: (String value) {
                                      if ((value.isEmpty)) {
                                        return "اكتب تفاصيل الفيديو";
                                      }
                                    },
                                    maxLength: 100,
                                    maxLines: 2,
                                    decoration: InputDecoration(
                                        contentPadding:
                                            new EdgeInsets.symmetric(
                                                vertical: 100.0),
                                        errorStyle: TextStyle(
                                            color: Colors.red, fontSize: 15.0),
                                        labelText: "ادخل تفاصيل الفيديو....",
                                        hintText: "ادخل تفاصيل الفيديو....",
                                        border: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5.0)))),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            /*MediaQuery.of(context).size.width*/
                            height: 50,
                            child: new RaisedButton(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(right: 10),
                                    child: Icon(
                                      Icons.check,
                                      color: Colors.white,
                                    ),
                                  ),
                                  new Text(
                                    "إضافة",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
//                                      fontFamily: 'Estedad-Black',
                                    ),
                                  ),
                                ],
                              ),
                              textColor: Colors.white,
                              color: const Color(0xff171732),
                              onPressed: () async {
                                if (_formKey.currentState.validate()) {
                                  if (videofile != null) {
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
                                          "انت غير متصل بشبكة إنترنت ", context,
                                          duration: Toast.LENGTH_LONG,
                                          gravity: Toast.BOTTOM);
                                    }
                                  } else {
                                    Toast.show("يجب اضافة فيديو ", context,
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
            // new Align(
            //   child: loadingIndicator,
            //   alignment: FractionalOffset.center,
            // ),
            _load2
                ? Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Center(
                      child: Card(
                        shape: new RoundedRectangleBorder(
                            side: new BorderSide(
                                color: Colors.grey[400], width: 3.0),
                            borderRadius: BorderRadius.circular(10.0)),
                        //borderOnForeground: true,
                        elevation: 10.0,
                        margin: EdgeInsets.only(right: 1, left: 1, bottom: 2),
                        child: Container(
                          height: 110, //width:100,
                          color: Colors.white,
                          //alignment: Alignment(0, 0),
                          child: Padding(
                            padding: const EdgeInsets.all(28.0),
                            child: Column(
                              children: [
                                LinearPercentIndicator(
                                  animation: _load2,
                                  lineHeight: 20.0,
                                  animationDuration: 30000,
                                  percent: 1,
                                  linearStrokeCap: LinearStrokeCap.roundAll,
                                  progressColor: Colors.green,
                                ),
                                Center(child: Text("جارى تحميل الفيديو")),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                : Container(),
            // Container(
            //   alignment: Alignment(0, 0),
            //   child: Text(
            //     "${this.progress * 100}%",
            //     style: TextStyle(
            //       fontSize: 30,
            //       fontWeight: FontWeight.bold,
            //     ),
            //   ),
            // ),
            // Container(
            //   alignment: Alignment(0.3, 0.5),
            //   child: RaisedButton(
            //       color: Colors.green,
            //       onPressed: () {
            //         final updated = ((this.progress + 0.1).clamp(0.0, 1.0) * 100);
            //         setState(() {
            //           this.progress = updated.round() / 100;
            //         });
            //         print(progress);
            //       },
            //       child: Text(
            //         '+10%',
            //         style: TextStyle(
            //           fontWeight: FontWeight.bold,
            //           color: Colors.white,
            //         ),
            //       )),
            // ),
            // Container(
            //   alignment: Alignment(-0.3, 0.5),
            //   child: RaisedButton(
            //       color: Colors.red,
            //       onPressed: () {
            //         final updated = ((this.progress - 0.1).clamp(0.0, 1.0) * 100);
            //         setState(() {
            //           this.progress = updated.round() / 100;
            //         });
            //         print(progress);
            //       },
            //       child: Text(
            //         '-10%',
            //         style: TextStyle(
            //           fontWeight: FontWeight.bold,
            //           color: Colors.white,
            //         ),
            //       )),
            // ),
          ],
        ));
  }

  void _onDropDownItemSelecteddep(String newValueSelected) {
    setState(() {
      this._departcurrentItemSelected = newValueSelected;
    });
  }

  Future uploadpp0() async {
    print("mmmmm2");

    DateTime now = DateTime.now();
    StorageReference ref =
        FirebaseStorage.instance.ref().child("video").child('$now.mp4');
    StorageUploadTask uploadTask = ref.putFile(videofile);
    var videourl = await (await uploadTask.onComplete).ref.getDownloadURL();
    final String vurl = videourl.toString();

    // Uri downloadUrl = (await uploadTask.onComplete).downloadUrl;
    print(vurl);
    setState(() {
      _load2 = true;
    });

    uploadpp1(vurl);
  }

  Future uploadpp1(vurl) async {
    print("mmmmm3");

    DateTime now = DateTime.now();
    StorageReference ref =
        FirebaseStorage.instance.ref().child("thumbnail").child('$now.jpg');
    StorageUploadTask uploadTask = ref.putFile(thumbnailurlfile);
    var thumbnailurl = await (await uploadTask.onComplete).ref.getDownloadURL();
    final String gurl = thumbnailurl.toString();

    // Uri downloadUrl = (await uploadTask.onComplete).downloadUrl;
    print(gurl);
    setState(() {
      _load2 = true;
    });

    createRecord(vurl, gurl);
  }

  void createRecord(urlvideo, urlgif) {
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
                Firestore.instance.collection('videos').document();
            documentReference.setData({
              'cId': documentReference.documentID,
              'carrange': arrange,
              'cuserId': _userId,
              'cname': _cName,
              'cphotourl': _cphotourl,
              'cdate': date1,
              'ctitle': _titleController.text,
              'cdepart': _departcurrentItemSelected,
              'cdetail': _detailController.text,
              'cpublished': false,
              'curi': urlvideo,
              'likes': 0,
              'seens': 0,
              'imgurl': urlgif,
              'favcheck': false,
              'ccar': model1,
              'ccarversion': model2,
              'cyear': _indyearcurrentItemSelected,
            }).whenComplete(() {
              setState(() {
                _load2 = false;
                urlvideo = "";
                urlgif = "";
                videofile = null;
                _titleController.text = "";
                _detailController.text = "";
                _departcurrentItemSelected = departlist[0];
                videocheck = false;
                model1 = "";
                model2 = "";
                _indyearcurrentItemSelected = indyearlist[0];
              });

              showAlertDialog(context);
            }).catchError((e) {
              setState(() {
                _load2 = false;
              });
            });
          }));
  }

  showAlertDialog(BuildContext context) {
//    // set up the button
//    Widget okButton = FlatButton(
//      child: Text("تم"),
//      onPressed: () {
//        Navigator.push(context,
//            MaterialPageRoute(builder: (context) => AllAdvertesmenta()));
//      },
//    );
//
//    // set up the AlertDialog
//    CupertinoDialogAction alert = CupertinoDialogAction(
//
//      title: Text("تهانناا"),
//      content: Text("إعلانك موجود الحين ضمن شبكة سوق نجران"),
//      actions: [
//        okButton,
//      ],
//    );

    // show the dialog
    showDialog(
        context: context,
        builder: (BuildContext context) => new CupertinoAlertDialog(
                title: new Text("تهاننا"),
                content: new Text("تم نشر الفيديو"),
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

  void _onDropDownItemSelectedindyear(String newValueSelected) {
    setState(() {
      this._indyearcurrentItemSelected = newValueSelected;
    });
  }

  void onSubmit3(String result) {
    setState(() {
      model1 = result.split(",")[0];
      model2 = result.split(",")[1];
      Toast.show(
          "${result.split(",")[0]}///////${result.split(",")[1]}", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    });
  }
}

//////////////////////////////////
typedef void MyFormCallback3(String result);

class MyForm3 extends StatefulWidget {
  final MyFormCallback3 onSubmit3;
  String model;

  MyForm3(this.model, {this.onSubmit3});

  @override
  _MyForm3State createState() => _MyForm3State();
}

class _MyForm3State extends State<MyForm3> {
  String _currentValue = '';
  String _currentValue1 = '';

  List<ModelClass> modelList = [];

  @override
  void initState() {
    super.initState();
    _currentValue = widget.model;
    modelList = [
      //الف
      new ModelClass("اودي", [
        "50",
        "60",
        "72",
        "80",
        "90",
        "100",
        "200",
        "920",
        "4000",
        "5000",
        "A1",
        "A2",
        "A3",
        "A4",
        "A5",
        "A6",
        "A7",
        "A8",
        "allroad quattro",
        "Cabriolet",
        "Coupé",
        "e-tron",
        "F103",
        "Fox",
        "Front",
        "Lunar" "quattro",
        "Pikes Peak quattro",
        "Q",
        "Q2",
        "Q3",
        "Q5",
        "Q7",
        "Q8",
        "Quattro",
        "Quattro S1",
        "RS",
        "S",
        "S1",
        "S2",
        "S3",
        "S4",
        "S5",
        "S6",
        "S7",
        "S8",
        "SQ5",
        "V8"
      ]),
      new ModelClass("أوبل", [
        "اوبل آسترا",
        "اوبل آسترا سيدان",
        "اوبل استرا GTC",
        "اوبل اوميجا"
            "اوبل إنسيغنيا",
        "اوبل انسيغنيا OPC",
        "اوبل فكترا",
        "اوبل كورسا",
        "اوبل ميريفا",
      ]),
      new ModelClass("أنفيتيتي", [
        "انفينيتي إف إكس",
        "إنفينيتي أم",
        "انفينيتي EX35",
        "انفينيتي G35",
        "انفينيتي G37",
        "انفينيتي QX56",
        "إنفينيتي Q50",
        "إنفينيتي QX80",
        "إنفينيتي Q60"
      ]),
      new ModelClass(
          "ايسوزو", ["إيسوزو أوسيس",
        "إيسوزو إم يو", "إيسوزو فاستر"]),
      //باء  ب
      new ModelClass("بي-أم-دبليو", [
        "بي إم دبليو 507",
        "بي إم دبليو إي9",

        "بي إم دبليو آي 3",

        "بي إم دبليو الفئة الأولى",
        "بي إم دبليو الفئة الثالثة",
        "بي إم دبليو الفئة الخامسة",
        "بي إم دبليو الفئة 5 (E28)",
        "بي إم دبليو الفئة السادسة",
        "بي إم دبليو الفئة السابعة",
        "بي إم دبليو الفئة 7 (إي32)",
        "بي إم دبليو الفئة الثامنة",
        "بي إم دبليو آي",
        "بي إم دبليو أم 1",
        "بي إم دبليو أم 3",
        "بي أم دبليو أم 4",
        "بي إم دبليو إم 5",
        "بي إم دبليو أم 6",
        "بي إم دبليو إم رودستر",
        "بي إم دبليو أم كوبيه",


        "بي أم دبليو الفئة أكس",
        "بي إم دبليو إكس1",
        "بي إم دبليو إكس2",
        "بي إم دبليو إكس3",
        "بي إم دبليو إكس4",
        "بي إم دبليو اكس 5 (اف 15)",
        "بي إم دبليو اكس 5 (اي 53)",
        "بي إم دبليو اكس 5 (اي 70)",
        "بي إم دبليو إكس6",
        "بي إم دبليو أكس3 أف25",




        "بي إم دبليو زد 1",
        "بي إم دبليو زد 4 (أي 85)",
        "بي إم دبليو زد 4 (أي 89)",
        "بي إم دبليو زد 8 (أي 52)"
      ]),
      new ModelClass("بورش", [
        "بورش64"
            "بورش 356",
        "بورش 911",
        "بورش 911 (كلاسيك)",
        "بورش 911 جي تي3",
        "بورش 912",
        "بورش 914",
        "بورش 918",
        "بورش 924",
        "بورش 928",
        "بورش 930",
        "بورش 944",
        "بورش 959",
        "بورش 964",
        "بورش 968",
        "بورش 981",
        "بورش 986",
        "بورش 987",
        "بورش 991",
        "بورش 993",
        "بورش 996",
        "بورش 997",
        "بورش باناميرا",
        'بنتلي',
        "بورش بوكستر",
        "بورش كاريرا جي تي",
        "بورش كايان",
        "بورش كايمان",
        "بورش ماكان",
      ]),
      new ModelClass("بوغاتي", [
        "بوغاتي تشيرون",
        "بوغاتي فيرون سوبر سبورت",
        "بوغاتي فيرون غراند سبورت",
        "بوغاتي فيرون"
      ]),
      new ModelClass("بيجو", [
        "بيجو 10",
        "بيجو  81"
            "بيجو 104",
        "بيجو 106",
        "بيجو 107",
        "بيجو 108",
        "بيجو 201",
        "بيجو 202",
        "بيجو 203",
        "بيجو 204",
        "بيجو 205",
        "بيجو 206",
        "بيجو 207",
        "بيجو 208",
        "بيجو 301",
        "بيجو 302",
        "بيجو 304",
        "بيجو 305",
        "بيجو 306",
        "بيجو 307",
        "بيجو 308",
        "بيجو 308 I",
        "بيجو 308 II",
        "بيجو 309",

        "بيجو 401",
        "بيجو 402",
        "بيجو 403",
        "بيجو 404",
        "بيجو 405",
        "بيجو 406",
        "بيجو 407",
        "بيجو 408",
        "بيجو 504",
        "بيجو 505",
        "بيجو 508",
        "بيجو 601",
        "بيجو 604",
        "بيجو 605",
        "بيجو 607",
        "بيجو 1007",
        "بيجو 2008",
        "بيجو 4002",
        "بيجو 4007",
        "بيجو 4008",
        "بيجو 3008",
        "بيجو 5008",

        "بيجو بارتنر",
      ]),
      //ت   تاء
      new ModelClass("تيسلا", ["Model S", 'Model X', 'Model 3', 'رودستر']),
      new ModelClass("تويوتا", [

        "تويوتا 7",
        "تويوتا 86",
        "تويوتا AE86",

        "تويوتا آي كيو",
        "تويوتا آي-ريل",
        "تويوتا آي-سوينج",
        "تويوتا آي-فوت",
        "تويوتا آي-يونت",
        "تويوتا أفالون",
        "تويوتا أفانزا",
        "تويوتا أفينسيس",
        "تويوتا ألفارد",
        "تويوتا أليون",
        "تويوتا أورس",
        "تويوتا أوريون",
        "تويوتا أوريون (إكس في 40)",
        "تويوتا أيجو",
        "تويوتا إف جيه كروزر",
        "تويوتا إم آر 2",
        "تويوتا إنوفا",
        "تويوتا إي كوم",
        "تويوتا إيكو",
        "تويوتا الفئة أ",
        "تويوتا الفئة إس",
        "تويوتا الفئة جي",
        "تويوتا بريفيا",
        "تويوتا بريميو",
        "تويوتا بليزارد",
        "تويوتا بوبليكا",
        "تويوتا بي إم",
        "تويوتا تاكوما",
        "تويوتا تندرا",
        "تويوتا تي100",
        "تويوتا تيرسل",
        "تويوتا 2000جي تي",
        "تويوتا داينا",
        "تويوتا راف 4 اي في",
        "تويوتا راڤ4",
        "تويوتا 4 رنر",

        "تويوتا ستارليت",
        "تويوتا سليكا جي تي-فور",
        "تويوتا سنشري",
        "تويوتا سوارير",
        "تويوتا سوبرا",
        "تويوتا سيكويا",
        "تويوتا سيليكا",
        "تويوتا سيينا",
        "تويوتا فنزا",
        "تويوتا فيرسو",
        "تويوتا فيوس",
        "تويوتا ڤيتز"

            "تويوتا كارينا",
        "تويوتا كالدينا",
        "تويوتا كامري",
        "تويوتا كامري سولارا",
        "تويوتا كراون",
        "تويوتا كريستا",
        "تويوتا كريسيدا",
        "تويوتا كلاسيك",
        "تويوتا كورولا",
        "تويوتا كورولا كروس",
        "تويوتا كورونا",
        "تويوتا كوستر",
        "تويوتا لاند كروزر",
        "تويوتا لاند كروزر برادو",
        "تويوتا مارك 2",
        "تويوتا مارك إكس",
        "تويوتا ميجا كروزر",
        "تويوتا ميراي",
        "تويوتا نوح",
        "تويوتا هايس",
        "تويوتا هايلاندر",
        "تويوتا هايلوكس",
        "تويوتا ويش",
        "تويوتا يارس",
        "تويوتا يارس كروس",
        "تويوتا F3R",
      ]),
//جgem
      new ModelClass("جي-أم-سي", [
        "استرو 95",
        'اراضي',
        'اعصار',
        "الهيكل ف",
        "العام",
        "العميد",
        'المبعوث ',
        "تي",
        "جيم",
        'جيمي ',
        "9500 جلالة",

        "دبليو",
        'رالي',



        'سييرا ',
        'سونوما',
        'سبرينت ',
        'سفاري',
        'سوبربان',
        'شيفروليه كابتيفا',
        "كاباليرو ",
        "كانيون",
        'يوكون',
        'Acadia',
        'Crackerbox',
        'Handi',

        "JH 9500| JH 9500",
        "L-Series/Steel",

        "Syclone",

        'Savana',
        "TopKick",

        'Vandura',
      ]),
      new ModelClass("جاكوار", [
        "أس أس 1",
        "إس إس 90",
        "جاغوار آي-بيس",
        "جاغوار أكس جي",
        "جاغوار إكس إف",
        "جاغوار إكس إي",
        "جاكوار 420",
        "جاكوار أس-تايب",
        "جاكوار أس-تايب ",
        "جاكوار أكس جي (أكس جي40)",
        "جاكوار أكس جي 13",
        "جاكوار أكس جي أس",
        "جاكوار أكس جي220",
        "جاكوار أكس كي140",
        "جاكوار أكس-تايب",
        " جاكوار أي-تايب",
        "جاكوار إس إس 100",
        "جاكوار إف-تايب",
        "جاكوار إكس كيه120",
        "جاكوار إكس كيه150",
        "جاكوار اكس كي",
        "جاكوار دي-تايب",
        "جاكوار سي-تايب",
        "جاكوار مارك",
        "جاكوار مارك 2",
        "جاكوار مارك 4",
        "جاكوار مارك 5",
        "جاكوار مارك 7",
        "جاكوار مارك 8",
        "جاكوار مارك 9",
        "جاكوار مارك إكس",
        "دايملر سوفيريجنبي"
      ]),
      //dal
      new ModelClass("دودج", [
        " تشارجر",
        "جيرني",
        "جنرال لي",
        "رام",
        "رام فان",
        "شالنجر",
        " فايبر",
        "كرافان"



      ]),
      new ModelClass("دايو", [
        "دايو إسبيرو",
        "دايو لاستي",
        "دايو لانوس",
        "دايو نكسيا",
        "دايو نوبيرا"

      ]),
      //r
      new ModelClass("رولزرويس", [
        "رولز رويس داون",
        "رولز رويس رايث ",
        "رولز رويس غوست ",
        "رولز رويس فانتوم",
        "رولز رويس كولينان "
      ]),
      new ModelClass("رينو", [

        "رينو 4",
        "رينو 4cv",
        "رينو 5",
        "رينو 6",
        "رينو 7",
        "رينو 8",
        "رينو 9 ",
        "رينو  11",
        "رينو 12",
        "رينو 14",
        "رينو 15",
        "رينو 16",
        "رينو 17",
        "رينو 15",
        "رينو 18",
        "رينو 19",
        "رينو 20",
        "رينو 21",
        "رينو 25 ",
        "رينو إسباس",
        "رينو إكسبراس ",
        "رينو توينغو",

        "رينو جيفيكاتر",
        "رينو سافران ",

        "رينو سينيك",
        "رينو كليو",
        "ينو كليو 2",
        "رينو كونغو",
        "رينو لوجان",

        "رينو لغونا ",
        "رينو ميجان ",

        "رينو ماستر "
      ]),
      //s
      new ModelClass("سكودا", [
        "اوكتافيا / لورا ",
        " رومستر/ براكتيك ",
        "سكودا رابيد",
        "سكودا فيليشيا"
            "فابيا",
        "سوبرب",
        "يتي",

      ]),
      new ModelClass("سوزوكي", [
        "ألتو",
        "سوزوكي إرتيجا",
        "سوزوكي جيمني",
        "سوزوكي سيليريو",
        "سوزوكي فيتارا",
        "سوزوكي كيو-كونسبت",
        "ماروتي 800",
        "مازدا سبيانو",
        "نيسان موكو"
      ]),
      new ModelClass("سوبارو", [
        "امبريزا",
        "اوتباك",
        "اكسيجا",
        "تريبيكا",
        "تندر",
        "جاستي",
        "فورستر",
        "ليونا",
        "ليجاسي",
        "BRZ",        "Dex"
      ]),
      new ModelClass("سيتروين", [
        "دي إس 3",
        "سيتروين أي إكس",
        "سيتروين إكسارا",
        "سيتروين برلنغو I",
        "سيتروين برلنغو II",
        "سيتروين  ب12",
        "سيتروين تراكشن أفانت",
        "سيتروين جي إس",
        "سيتروين جي تي",
        "سيتروين دي إس",
        "سيتروين زيت إكس",
        "سيتروين ساكسو",
        "سيتروين سي 1",
        "سيتروين سي 2",
        "سيتروين سي 3",
        "سيتروين سي 3 إيركروس",
        "سيتروين سي 3 بيكاسو",
        "سيتروين سي 4",
        "سيتروين سي 4 دبليو آر سي",
        "سيتروين سي 5",
        "سيتروين سي 5 إيركروس",
        "سيتروين سي3 I",
        "سيتروين سي3 II",
        "سيتروين سي3 III",
        "سيتروين سي3 إيركروس ",
        "سيتروين سي4 I",
        "سيتروين سي4 II",
        "سيتروين سي5 I",
        "سيتروين سي5 II",
        "فورد سي 4 كاكتوس"
            "ستروين فيزا",

      ]),
      new ModelClass("سيات", [
        "سيات 124",
        "سيات 124 سبورت",
        "سيات 127",
        "سيات 128",
        "سيات 131",
        "سيات 132",
        "سيات 133",
        "سيات 600",
        "سيات 800",
        "سيات 850",
        "سيات 1200 سبورت",

        "سيات 1400",
        "سيات 1430",
        "سيات 1500",

        "سيات أتيكا",
        "سيات أروسا",
        "سيات ألتيا",
        "سيات ألتيا بروتوتيبو",
        "سيات إب",
        "سيات إكسيو",
        "سيات إنكا",
        "سيات إيبيزا",
        "سيات الهمبرا",
        "سيات بروتو",
        "سيات تانجو",
        "سيات توليدو",
        "سيات توليدو I",
        "سيات توليدو II",
        "سيات توليدو III",
        "سيات توليدو IV",
        "سيات روندا",
        "سيات فورا",
        "سيات فورمولا",
        "سيات كوبرا جي تي",
        "سيات كوردوبا",
        "سيات ليون",
        "سيات ماربيا",
        "سيات مي"
      ]),
      //sh
      new ModelClass("شيري", [
        "شيري أريزو 5",
        "شيري انفى ",
        "شيري تيجو ",
        "شيري فلاوين",
        "شيري كيو كيو 3"

      ]),
      new ModelClass("شفروليه", [
        "150",
        "آفيو",
        "أبلاندر",
        "أوبترا",
        "إبيكا",
        "إكسبرس",
        "إمبالا",
        "تاهو",

        "ديلراي",
        "ديلوكس",
        "سايل",
        "سبارك",
        "سوبربان",
        "سي/كا",
        "شفيل",
        "فليت لاين",
        "فليت ماستر",
        "كابريس",
        "كروز",
        "كمارو",
        "كوبالت",
        "كورسيكا",
        "كورفيت",
        "كورفير",
        "لومينا",
        "مونت كارلو",
        "مونتانا"
      ]),
      //f
      new ModelClass("فولكس-فاجن", [
        'فولكس فاجن أب',
        "فولكس فاجن إكس رابيت",
        "فولكس فاجن جى إل آى",
        "فولكس فاجن ار32",
        "الخنفساء الجديدة",

        "فولكس فاجن باسات",
        "فولكس فاجن بورا",
        "فولكس فاجن باساتCC",
        "فولكس فاجن بولو",
        "فولكس فاجن باراتى",
        "فولكس فاجن بوينتر",
        ' فولكس فاجن توران',
        "فولكس فاجن تيغوان",

        "فولكس فاجن جيتا",
        "فولكس فاجن جولف",
        "فولكس فاجن جى تى آى",



        "فولكس فاجن فايتون",
        'فولكس فاجن فوكس',
        "فولكس فاجن فينتو",

        "فولكس فاجن سيجتار",
        "فولكس فاجن سانتانا",
        'فولكس فاجن شاران',
        "فولكس فاجن شيروكو",


        "فولكس فاجن طوارق",
        "فولكس فاجن كروس فوكس",

        "فولكس فاجن كادي",
        'فولكس فاجن ماجوتان',

        "فولكس فاجن نيو بيتلز",


        "فولكس فاجن EOS"

      ]),
      new ModelClass("فيراري", [
        "فيراري 125 إس",
        "فيراري 159 إس",
        "فيراري 166 إس",
        "فيراري 166 إنتر",
        "فيراري 195 إس",
        "فيراري 195 إنتر",
        "فيراري 212 إكسبورت",
        "فيراري 212 إنتر",
        "فيراري 250",
        "فيراري 250 جي تي أو",
        "فيراري 250 جي تي لوسو",
        "فيراري 275",
        "فيراري 288 دي تي أو",
        "فيراري 308 جي تي بي",
        "فيراري 328",
        "فيراري 330",
        "فيراري 340",
        "فيراري 348",
        "فيراري 360",
        "فيراري 365",
        "فيراري 365 جي تي سي/4",
        "فيراري 375 إم إم",
        "فيراري 400",
        "فيراري 456",
        "فيراري 458 إيطاليا",
        "فيراري 488",
        "فيراري 550",
        "فيراري 575 إم مارانيلو",
        "فيراري 599 جي تي بي فيورانو",
        "فيراري 612 سكاجليتي",
        "فيراري 812 سوبرفاست",
        "فيراري أف إكس إكس كيه",
        "فيراري إف 12 بيرلينيتا",
        "فيراري إف 355",
        "فيراري إف 40",
        "فيراري إف 430",
        "فيراري إف 50",
        "فيراري إف إف",
        "فيراري إف اكس اكس",
        "فيراري أمريكا",

        "فيراري إينزو",
        "فيراري بيرلينيتا بوكسر",
        "فيراري تيستاروسا",
        "فيراري جي تي 4",
        "فيراري دايتونا",
        "فيراري كاليفورنيا",
        "فيراري مونديال",
        "فيراري پي",
        "لافيراري"
      ]),
      new ModelClass("فولفو", [
        "C30",
        "S40,V40",
        "S40",
        "V50",
        "66",
        "V70/V70XC CLASSIC",
        "C70 COUPE",
        "C70 CABRIOLET/مكشوفة",
        "S70",
        "V90",
        "S90"
            "142",
        "144",
        "145",
        "164",
        "242",
        "244",
        "245",
        "262",
        "262C",
        "264",
        "265",
        "240",
        "260",
        "343",
        "345",
        "360 3-D",
        "360 SEDAN",
        "360 5-D",
        "480",
        "440",
        "460",
        "740ستايشن",
        "760 SEDAN",
        "760ستايشن",
        "740 SEDAN",
        "780",

        "850 SEDAN",
        "850 ستايشن",
        "940 SEDAN",
        "940ستايشن",
        "960 SEDAN",
        "960 ستايشن",
        "1800ES"

      ]),
      new ModelClass("فيات", [
        "باندا 30",
        "124",
        " 124 سبايدر 2000",
        "125",
        "126",
        "126 بيس",
        "127",
        "127 سبورت",
        "127 ديزل بانوراما",
        "128",
        "130",
        "131",
        " 131 Racing",
        "132",
        "132 ديزل",
        "133",
        "314/3",
        "418",
        "421",
        "500",
        "باندا750",
        "850",
        "1100",
        "1300",
        "1500",
        "1800",
        "2000",
        "2300",
        "Abarth Volumetrico 131",
        "Argenta,Campagnola Diesel",
        "Argenta SX",
        "Barchetta",
        "Barchetta",
        "Cinquecento Sporting",
        "Cinquecento",
        "Cinquecento" "Sporting",
        "Campagnola",
        "Dino",
        "Linea",
        "Marea",
        "Multipla",
        "Nuova 500",
        "Mirafiori",
        "Regata",

        "Strada",
        "Strada Abarth",
        "Strada 105 TC",
        "Strada Abarth 130 TC",
        "Sedici",
        "Stilo",
        "Seicento",
        "Tempra",
        "Ulysse",
        "X1/9",
        "أونو",
        "أونو توربوie",
        "ايديا",
        "باندا (الجيل الثاني)",
        "باندا4×4 (الجيل الثاني)",
        "باندا Alessi",
        " باندا كروس",
        "باندا 100اتش.بي",
        "برافو (الجيل الثاني)",
        "باندا 4×4",
        "باندا 45 سوبر",
        "باندا 1300دي",
        "برافا",
        "برافو",
        "باليو",
        "بونتو",
        "تيبو",
        "دوبلو",
        "ريتمو",
        "فيورينو ",
        "فيورينو (الجيل الرابع)",
        "فيورينو Qubo (people carrier)"
            "كروما ديزل",
        "كروما",
        "كوبيه",
        "كروما",
        "سوبرميرافيوري",
        "ميرافيوري سبورت"
      ]),
      new ModelClass("فورد", [
        "فورد أف - الجيل الأول",
        "فورد أف - الجيل العاشر",
        "فورد أي ",
        'فورد إسكيب',
        "فورد إف 150",
        "فورد إكسبلورر",
        "فورد إكسبيديشن",
        "فورد إي سيرس",
        "فورد اس-ماكس",
        "فورد اف - الجيل التاسع",
        "فورد اف - الجيل الثالث",
        "فورد اف - الجيل الرابع",
        "فورد اف - الجيل السادس",
        "  فورد اف الجيل الثاني",
        "فورد الفئة أ أ",
        "فورد برونكو",
        "فورد بي ماكس",
        "فورد بينتو",
        "فورد ترانزيت",
        "فورد تورينو",
        "فورد جالكسي",
        "فورد جي تي",
        "فورد جي تي 40",
        "فورد زد اكس 2",
        "فورد سكوربيو",
        "فورد سي-ماكس",
        "فورد غالاكسي",
        "فورد غرانادا",
        "فورد فالكون ",
        "فورد فيوجن",
        "فورد كراون فكتوريا",
        "فورد كوجا",
        "فورد موديل 48",
        "فورد موديل 91",
        "فورد موديل ان",
        "فورد موديل تي",
        "لوتس إيفورا",
        "لوتس كورتينا"
      ]),
      //k
      new ModelClass("كيا", [
        "كيا بيكانتو",
        "كيا تيلورايد",
        "كيا جويس",
        "كيا ريو",
        "كيا سيفيا",
        "كيا سبكترا",
        "كيا سبورتاج",
        "كيا ستنغر",
        "كيا سورنتو",
        "كيا سيراتو",
        "كيا كادينزا",
        "كيا كي5"
      ]),
      new ModelClass("كاديلاك", [

        "Allanté",
        "ATS",
        "ATS-V",
        "BLS",
        "Brougham",
        "CT4",
        "Lyriq",
        "Calais",
        "Catera",
        "Cimarron",
        "Commercial Chassis",
        "Coupe de Ville",
        "CT5",
        "CT6",
        "CT6-V",
        "CTS",
        "CTS-V",
        "Model D",
        "DTS",
        "Eldorado",
        "ELR",
        "Escalade",
        "Fleetwood",
        "Fleetwood" "Brougham",
        "Model Thirty",

        "Northstar LMP",
        "Runabout and Tonneau",
        "Sedan de Ville",
        "Seville",
        "SLS",
        "SRX",
        "STS",
        "STS-V",
        "Series 60",
        "Sixty Special",
        "Series 61",
        "Series 62",
        "Type V-63",
        "Series 65",
        "Series 70",
        "Series 355",
        "Type 51",
        "Type 53",
        "V-12",
        "V-16",
        "XLR",
        "XT4",
        "XT5",
        "XT6",
        "XTS"

      ]),
      //l
      new ModelClass("لينكولن", [
        "Lincoln Navigator",
        "لينكولن MKX",
        "Lincoln MKZ",
        "Lincoln MKT/MKT Town Car",
        "Lincoln MKC",
        "لينكولن كونتينتال"
      ]),
      new ModelClass("لاند-روفر", [
        "لاند روفر ديسكفري سبورت ",
        "لاند روفر رنج روفر سبورت ",
        "لاند روفر LR4",
        "لاند روفر ديفيندر",
        "لاند روفر رنج روفر ",
        "لاند روفر رنج روفر سبورت",
        "لاند روفر رنج روفر إيفوك ",
        "لاند روفر LR2",
        "لاند روفر رنج روفر ",
        "لاند روفر رنج روفر فيلار "
      ]),
      new ModelClass("لامبورغيني", [
        "لامبورغيني افينتادور ",
        "لامبورغيني سيستو إليمينتو ",
        "لامبورغيني غالاردو LP570 4 سبايدر بيرفورمانتي ",
        "لامبورغيني غالاردو LP560 4 ",
        "لامبورغيني غالاردو LP550 2 سبايدر ",
        "لامبورغيني غالاردو LP570 4 سوبر تروفيو سترادالي ",
        "لامبورغيني غالاردو LP570 4 سوبرلاجيرا ",
        "لامبورغيني ريفينتون",
        "لامبورغيني مورسيلاغو LP640"
      ]),
      //m
      new ModelClass("مرسيدس", [
        "مرسيدس بنز الفئة A",
        "مرسيدس بنز الفئة C",
        "مرسيدس بنز الفئة E ",
        "مرسيدس بنز الفئة S ",
        "كوبيه مرسيدس بنز الفئة C ",
        'مرسيدس بنز CLA ',
        "مرسيدس بنز CLC",
        "مرسيدس بنز CLK ",
        "مرسيدس بنز الفئة E كوبيه",
        "مرسيدس بنز CL",
        "مرسيدس بنز CLS",
        "مرسيدس بنز الفئة S كوبيه",
        "مرسيدس بنز الفئة SL",
        "مرسيدس بنز SLC",
        "مرسيدس بنز SLK",
        "مرسيدس بنز SLR",
        "مرسيدس بنز SLS AMG",
        "مرسيدس بنز الفئة G",
        "مرسيدس بنز GLA ",
        "مرسيدس بنز GLC",
        "مرسيدس بنز GLK",
        "مرسيدس بنز GLE",
        "مرسيدس بنز الفئة M",
        "مرسيدس بنز GLS",
        "مرسيدس بنز GL",
        "مرسيدس بنز الفئة X",
        "مرسيدس بنز الفئة B",
        "مرسيدس بنز الفئة R",
        "مرسيدس بنز الفئة V",
        "مرسيدس بنز فانيو"
      ]),
      new ModelClass("مازدا", [
        "مازدا 3",
        "مازدا أر 100",
        "مازدا أر 130",
        "مازدا أر 360",
        "مازدا 929",
        "مازدا أر إكس- 3",
        "مازدا أر إكس-5",
        "مازدا أر إكس-7",
        "مازدا أر إكس-8",
        "مازدا بروتيج",
        "مازدا بروسيد مارف",
        "مازدا بريماسي",
        "مازدا بونغو",
        "مازدا بي تي-50",
        "مازدا تايكي",
        "مازدا تشانتيز",
        "مازدا تيتان",
        "مازدا روادباسير أي بي",
        "مازدا رودستر",
        "مازدا ريفو",
        "مازدا ريوجا",
        "مازدا سبيانو",
        "مازدا سي إكس-3",
        "مازدا سي إكس-5",
        "مازدا سينتيا",
        "مازدا فوراي",
        "مازدا فيريسا",
        "مازدا كابيلا",
        "مازدا كسيدوس 6",
        "مازدا هاكازي كونسيبت"
            "مازدا كيورا",
        "مازدا ناغاري",
        "مازدا هازومي",
      ]),
      new ModelClass("ميتشيبيشي", [
        "ميتسوبيشي آر في آر",
        "ميتسوبيشي آي",
        "ميتسوبيشي أوتلاندر",
        "ميتسوبيشي أي كي",
        "ميتسوبيشي إف تي أو",
        "ميتسوبيشي باجيرو",
        "ميتسوبيشي تريتون",
        "ميتسوبيشي تشالنجر",
        "ميتسوبيشي غالان",
        "ميتسوبيشي لانسر",
        "ميتسوبيشي لانسر إيفوليوشن",
        "ميتسوبيشي ميراج"
      ]),
      new ModelClass("ميني-كوبر",
          ["ميني كلوبمان ", "ميني كشف ", "ميني كنتريمان ", "ميني هاتش"]),
      //n
      new ModelClass("نيسان", [
        "نيسان أرمادا",
        "نيسان ألتيما",
        "نيسان باترول",
        "نيسان تيدا",
        "داتسون قو",
        "نيسان سدرك",
        "نيسان زد",
        "سيلغتي",
        "شاحنة داتسن",
        "نيسان صني",
        "نيسان ماكسيما",
        "نسان ار 382",
        "نيسان 180 إس إكس",
        "نيسان 240 اس اكس",
        "نيسان 300 زد إكس",
        "نيسان 300 سي",
        "نيسان 350 زد",
        "نيسان 370 زد",
        "نيسان أفينير",
        "نيسان أورفان",
        "نيسان أي أكس أيه",
        "نيسان أي دي",
        "نيسان ار 380",
        "نيسان ار 390 جي تي 1",
        "نيسان ار 391",
        "نيسان ار 88 سي",
        "نيسان ار 89 سي",
        "نيسان اس 130",
        "نيسان اس كارجو",
        "نيسان اكس-تريل",
        "نيسان الجراند",
        "نيسان الميرا",
        "نيسان ان اكس",
        "نيسان ان في",
        "نيسان ان في 200",
        "نيسان باث فايندر",
        "نيسان برايري",
        "نيسان برزدنت",
        "نيسان برنسيس رويال",
        "نيسان بريساج",
        "نيسان بريسي",
        "نيسان بريماستار",
        "نيسان بريميرا",
        "نيسان بسارة",
        "نيسان بلاتينا",
        "نيسان بلوبيرد",
        "نيسان بلوبيرد سيلفي",
        "نيسان بولسار",
        "نيسان بي 35",
        "نيسان بي أي-1",
        "نيسان بيفل",
        "نيسان بينتارا",
        "نيسان بينو",
        "نيسان تيتان",
        "نيسان تيرانو II",
        "نيسان تينا",
        "نيسان جوك",
        "نيسان جي تي - ار",
        "نيسان ديزل ار ان",
        "نيسان ديزل يو اي",
        "نيسان راشن",
        "نيسان روجيو",
        "نيسان سكاي لاين",
        "نيسان سنترا",
        "نيسان سيرينا",
        "نيسان سيلفيا",
        "نيسان سيما",
        "نيسان فانيت",
        "نيسان فوجا",
        "نيسان فيجارو",
        "نيسان كارفان",
        "نيسان كاشكاي",
        "نيسان كويست",
        "نيسان كيوب",
        "نيسان لاتيو",
        "نيسان لوريل",
        "نيسان ليف",
        "نيسان ليفينا جينيسس",
        "نيسان مورانو",
        "نيسان ميكرا",
        "نيسان ميكسيم",
        "نيسان نافارا",
        "نيسان نوت",
        "نيسان يوت"
      ]),
      //h
      new ModelClass("هوندا", [
        "هوندا أكورد",
        "هوندا 1300",
        "هوندا إس 2000",
        "هوندا إس 500",
        "هوندا إس 600",
        "هوندا إس 800",
        "هوندا إف آر في",
        "هوندا إل 700",
        "هوندا إن 360",
        "هوندا اليوم",
        "هوندا انتيغرا",
        "هوندا باسبورت",
        "هوندا بالاد",
        "هوندا تي 360",
        "هوندا تي إن 360",
        "هوندا زاد",
        "هوندا سيتي",
        "هوندا سيفيك",
        "هوندا فاموس",
        "هوندا فريد",
        "هوندا فيجور",
        "هوندا كوينت",
        "هوندا لايف"
      ]),
      new ModelClass("هيونداي", [
        "هيونداي i10","هيونداي أكسنت","هيونداي أيرو سيتي","هيونداي إكسيل","هيونداي إلنترا","هيونداي بوني","هيونداي تراجيت","هيونداي توسان","هيونداي تيراكان","هيونداي جيتز","هيونداي جينسس كوبيه","هيونداي جينيسيس","هيونداي سانتافي","هيونداي ستاريكس","هيونداي سوناتا","هيونداي غراندور","هيونداي فيراكروز",
        "هيونداي فيلوستر","هيونداي كوبيه","هيونداي كونا","هيونداي ماتركس"
      ]),
    ];
  }

  @override
  Widget build(BuildContext context) {
//    Widget cancelButton = FlatButton(
//      child: Text(
//        "إلغاء",
//        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
//      ),
//      onPressed: () {
//        setState(() {
//          Navigator.pop(context);
//        });
//      },
//    );
//    Widget continueButton = FlatButton(
//      child: Text(
//        "حفظ",
//        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
//      ),
//      onPressed: () {
//        setState(() {
//          Navigator.pop(context);
//          widget.onSubmit3(_currentValue1.toString() + "," + _currentValue.toString());
//        });
//      },
//    );
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff171732),
        centerTitle: true,
        title: Text(
          widget.model,
          style: TextStyle(fontWeight: FontWeight.bold),
          textDirection: TextDirection.rtl,
        ),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 18.0),
            child: ListView.builder(
              itemCount: modelList.length,
              itemBuilder: (context, i) {
                return new ExpansionTile(
                  title: new Text(
                    modelList[i].title,
                    style: new TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic),
                  ),
                  children: <Widget>[
                    Column(
                      // padding: EdgeInsets.all(8.0),
                      children: modelList[i]
                          .subtitle
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
                                    _currentValue1 = modelList[i].title;
                                    Navigator.pop(context);
                                    widget.onSubmit3(_currentValue1.toString() +
                                        "," +
                                        _currentValue.toString());
                                  });
                                },
                              ))
                          .toList(),
                    ),
//              new Column(
//                children:
//                _buildExpandableContent(regionlist[i]),
//              ),
                  ],
                );
              },
            ),
          ),
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
