import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
// import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
import 'package:flutter_video_compress/flutter_video_compress.dart';
import 'package:image_picker/image_picker.dart';
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
  String _cName;
  List<String> departlist = ["ترفيهى","اعمالي"];
  File videofile,thumbnailurlfile;
 bool videocheck=false;
  double _value = 0.0;
  TextEditingController _titleController = TextEditingController();
  TextEditingController _detailController = TextEditingController();
  var _departcurrentItemSelected = '';
  String imgurl;
  List<Asset> images = List<Asset>();
 double _currentSliderValue=0.0;
  int vd=0;
  @override
  void initState() {
    super.initState();
    _departcurrentItemSelected=departlist[0];
    FirebaseAuth.instance.currentUser().then((user) => user == null
        ? Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => Splash()))
        : setState(() {_userId = user.uid;
    var userQuery = Firestore.instance.collection('users').where('uid', isEqualTo: _userId).limit(1);
    userQuery.getDocuments().then((data){
      if (data.documents.length > 0){
        setState(() {
          _cName = data.documents[0].data['name'];

          if(_cName==null){
            if(user.displayName==null||user.displayName==""){
              _cName="ايميل غير معلوم";
            }else{_cName=user.displayName;}}

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

                               videofile =  await ImagePicker.pickVideo(source: ImageSource.gallery,).whenComplete(() => setState(()  {
                                 videocheck=true;

                                 // final FlutterFFmpeg _flutterFFmpeg = new FlutterFFmpeg();
                                 // _flutterFFmpeg
                                 //     .getMediaInformation(videofile.path)
                                 //     .then((info) => print("aaa$info"));

                                 Future.delayed(Duration(seconds: 0), () async {
                                   //  MediaInfo info = await FlutterVideoCompress().compressVideo(
                                   //   videofile.path,
                                   //   quality: VideoQuality.MediumQuality, // default(VideoQuality.DefaultQuality)
                                   //   deleteOrigin: false, // default(false)
                                   // );
                                   //  print("aaa"+ info.file.path+"///"+info.file.toString()+"///"+info.duration.toString()+"///"+ info.path+"//"
                                   //      + info.author+"//"+info.title+"//");
                                    // info.file.path;
                                    // info.duration;
                                    // info.path;
                                    // info.author;
                                    // info.title;
                                   // String thumb = await Thumbnails.getThumbnail(
                                   //     thumbnailFolder: '/SD/DCIM/0/Videos/Thumbnails',
                                   //     videoFile: videofile.path,
                                   //     imageType: ThumbFormat.PNG,
                                   //     quality: 30);
                                   // print('Path to cache folder $thumb');
                                    thumbnailurlfile = await FlutterVideoCompress().getThumbnailWithFile(
                                       videofile.path,
                                       quality: 50, // default(100)
                                       position: 0 // default(-1)
                                   );
                                    // var info = await FlutterVideoInfo().getVideoInfo(videofile.path);
                                    // print("Path**${info.duration}");
                                   // giffile = await FlutterVideoCompress().convertVideoToGif(
                                   //   videofile.path,
                                   //   startTime: 0, // default(0)
                                   //   duration: 1, // default(-1)
                                   //   // endTime: -1 // default(-1)
                                   //
                                   // );

                                    // setState(() {
                                    //   vd= videoduration.inSeconds;
                                    // });
                                    //final videoInfo = FlutterVideoInfo();

                                   /// String videoFilePath = "";



                                 });
                                 // String thumb = await Thumbnails.getThumbnail(
                                 //     thumbnailFolder: '/storage/emulated/0/Videos/Thumbnails',
                                 //     videoFile: videofile.path,
                                 //     imageType: ThumbFormat.PNG,
                                 //     quality: 30);
                                 // print("lll$thumb");

                               })
                               );
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
                                           Icons.video_call,
                                           color: Colors.grey,
                                           size: 70,
                                         ),
                                       ),
                                      Padding(
                                        padding:
                                        const EdgeInsets.only(top: 10.0),
                                        child: !videocheck?Icon(
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
                          Center(
                            child: Container(
                              width: 250,
                              height: 50,
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Card(
                                  elevation: 0.0,
                                  color: const Color(0xff171732),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: DropdownButtonHideUnderline(
                                      child: ButtonTheme(
                                        alignedDropdown: true,
                                        child: DropdownButton<String>(
                                          items: departlist
                                              .map((String value) {
                                            return new DropdownMenuItem<String>(
                                              value: value,
                                              child: new Text(value),
                                            );
                                          }).toList(),
                                          value: _departcurrentItemSelected,
                                          onChanged: (String newValueSelected) {
                                            // Your code to execute, when a menu item is selected from dropdown
                                            _onDropDownItemSelecteddep(
                                                newValueSelected);
                                          },
                                          style: new TextStyle(
                                            color: Colors.grey,
                                          ),
                                        ),
                                      )),
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
                                  if ( videofile != null ) {
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
                                          "انت غير متصل بشبكة إنترنت طال عمرك",
                                          context,
                                          duration: Toast.LENGTH_LONG,
                                          gravity: Toast.BOTTOM);
                                    }
                                  } else {
                                    Toast.show(
                                        "ضيف صورة علي الاقل حق إعلانك طال عمرك",
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

  void _onDropDownItemSelecteddep(String newValueSelected) {
    setState(() {
      this._departcurrentItemSelected = newValueSelected;

    });
  }



  Future uploadpp0() async {
    print("mmmmm2");

    DateTime now = DateTime.now();
    StorageReference ref = FirebaseStorage.instance.ref().child("video").child('$now.mp4');
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
    StorageReference ref = FirebaseStorage.instance.ref().child("thumbnail").child('$now.jpg');
    StorageUploadTask uploadTask = ref.putFile(thumbnailurlfile);
    var thumbnailurl = await (await uploadTask.onComplete).ref.getDownloadURL();
    final String gurl = thumbnailurl.toString();


    // Uri downloadUrl = (await uploadTask.onComplete).downloadUrl;
    print(gurl);
    setState(() {
      _load2 = true;
    });

    createRecord(vurl,gurl);
  }

  void createRecord(urlvideo,urlgif) {
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
        'carrange': arrange,
        'cId': _userId,
        'cdate': date1,
        'ctitle': _titleController.text,
        'cdepart': _departcurrentItemSelected,
        'cdetail': _detailController.text,
        'cpublished': false,
        'curi': urlvideo,
        'likes': 0,
        'seens': 0,
        'imgurl': urlgif,


      }).whenComplete(() {

        setState(() {
          _load2 = false;
          urlvideo="";
          urlgif="";
          videofile=null;
          _titleController.text = "";
          _detailController.text = "";
          _departcurrentItemSelected = departlist[0];
          videocheck=false;
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


 }
