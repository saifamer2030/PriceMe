
import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file/local.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_recorder/flutter_audio_recorder.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:priceme/classes/ModelClass.dart';
import 'package:priceme/classes/sharedpreftype.dart';
import 'package:priceme/screens/cur_loc.dart';
import 'package:priceme/screens/network_connection.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:io' as io;

import 'package:toast/toast.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:math' as Math;

class AddAdv extends StatefulWidget {
  final LocalFileSystem localFileSystem;

  AddAdv({localFileSystem})
      : this.localFileSystem = localFileSystem ?? LocalFileSystem();
  @override
  _AddAdvState createState() => _AddAdvState();
}

class _AddAdvState extends State<AddAdv> {
  bool _load1 = false;
  String url1;
  String imagepathes = '';
  List<String> urlList = [];
  List<String> sparesList = ["11","22"];
  List<String> indyearlist = [];

  List<Asset> images = List<Asset>();
  String _error = 'No Error Dectected';
  var _formKey = GlobalKey<FormState>();
  LatLng fromPlace, toPlace ;
  String fromPlaceLat , fromPlaceLng , fPlaceName ;
  Map <String , dynamic > sendData = Map();
  String model1;
  String model2;
  String fault1;
  String fault2;


  var song;  //var _typearray = DefConstants.countriesArray;

  final userdatabaseReference =
  FirebaseDatabase.instance.reference().child("coiffuredata");

  final double _minimumPadding = 5.0;

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmpasswordController = TextEditingController();
  TextEditingController discController = TextEditingController();
  TextEditingController bodyController = TextEditingController();
  var _indyearcurrentItemSelected="";

  //var _typecurrentItemSelected = '';
  var _sparecurrentItemSelected = '';
  FlutterAudioRecorder _recorder;
  Recording _current;
  RecordingStatus _currentStatus = RecordingStatus.Unset;

  @override
  void initState() {
    super.initState();
    _init();

    DateTime now = DateTime.now();
    indyearlist=new List<String>.generate(50, (i) =>  NumberUtility.changeDigit((now.year+1 -i).toString(), NumStrLanguage.English));
    indyearlist[0]=("الموديل");
    _indyearcurrentItemSelected=indyearlist[0];
    // _typecurrentItemSelected = _typearray[0];
    _sparecurrentItemSelected = sparesList[0];
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
        child: Stack(
          children: <Widget>[
            Form(
              key: _formKey,
              child: Padding(
                  padding: EdgeInsets.all(_minimumPadding * 2),
                  child: ListView(
                    physics: BouncingScrollPhysics(),
                    children: <Widget>[

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                                top: _minimumPadding, bottom: _minimumPadding),
                            child: Container(
                              height: 40.0,
                              child: Material(
                                  borderRadius: BorderRadius.circular(5.0),
                                  shadowColor: const Color(0xffdddddd),
                                  color: const Color(0xffe7e7e7),
                                  elevation: 2.0,
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: DropdownButton<String>(
                                      items: indyearlist.map((String value) {
                                        return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(
                                              value,
                                              style: TextStyle(
                                                  color: const Color(0xffF1AB37),
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold),
                                            ));
                                      }).toList(),
                                      value: _indyearcurrentItemSelected,
                                      onChanged: (String newValueSelected) {
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
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      "نوع السيارة",
                                      textDirection: TextDirection.rtl,
                                      style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: _minimumPadding,
                        width: _minimumPadding,
                      ),
                      Container(
                        height: 40,
                        color: Colors.grey,
                        child: InkWell(
                          onTap: () {
//                            Navigator.push(
//                                context,
//                                MaterialPageRoute(
//                                    builder: (context) => MyForm4(
//                                        "widget.department",
//                                        onSubmit4: onSubmit4)));

                          },
                          child: Card(
                            elevation: 0.0,
                            color: const Color(0xff171732),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "نوع العطل",
                                  textDirection: TextDirection.rtl,
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            top: _minimumPadding * 5, bottom: _minimumPadding),
                        child: Center(
                          child: Text(
                            "معلومات إضافية",
                            style: TextStyle(
                                color: const Color(0xffF1AB37),
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
                          child: Directionality(
                            textDirection: TextDirection.rtl,
                            child: TextFormField(
                              textAlign: TextAlign.right,
                              keyboardType: TextInputType.text,
                              style: textStyle,
                              //textDirection: TextDirection.rtl,
                              controller: discController,
                              validator: (String value) {
                                if (value.isEmpty) {
                                  return 'برجاء إدخال وصف المشكلة';
                                }
                              },
                              decoration: InputDecoration(
                                labelText: 'وصف المشكلة',
                                //hintText: 'Name',
                                labelStyle: textStyle,
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
                              textAlign: TextAlign.right,
                              keyboardType: TextInputType.text,
                              style: textStyle,
                              //textDirection: TextDirection.rtl,
                              controller: bodyController,
                              validator: (String value) {
                                if (value.isEmpty) {
                                  return 'برجاء إدخال رقم الهيكل';
                                }

                              },
                              decoration: InputDecoration(
                                labelText: 'رقم الهيكل',
                                //hintText: 'Name',
                                labelStyle: textStyle,
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

                      SizedBox(
                        height: _minimumPadding,
                        width: _minimumPadding,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: Text(
                          "اختار قطع الغيار",
                          textDirection: TextDirection.rtl,
                          style: TextStyle(
                              color: const Color(0xffF1AB37),
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            top: _minimumPadding, bottom: _minimumPadding),
                        child: Container(
                          height: 40.0,
                          child: Material(
                              borderRadius: BorderRadius.circular(5.0),
                              shadowColor: const Color(0xffdddddd),
                              color: const Color(0xffe7e7e7),
                              elevation: 2.0,
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: DropdownButton<String>(
                                  items: sparesList.map((String value) {
                                    return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(
                                          value,
                                          style: TextStyle(
                                              color: const Color(0xffF1AB37),
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold),
                                        ));
                                  }).toList(),
                                  value: _sparecurrentItemSelected,
                                  onChanged: (String newValueSelected) {
                                    // Your code to execute, when a menu item is selected from dropdown
                                    _onDropDownItemSelectedSpares(
                                        newValueSelected);
                                  },
                                ),
                              )),
                        ),
                      ),
                      SizedBox(
                        height: _minimumPadding,
                        width: _minimumPadding,
                      ),
                      SizedBox(
                        height: _minimumPadding,
                        width: _minimumPadding,
                      ),

///////////////////////////////////////
                      new Slider(value:0.0 ,
                          max: 300.0,min: 0.0,
                          onChanged: (double value){
                            value= double.parse(_current?.duration.inSeconds.toString());
                          }),
                      Center(
                        child: new Text(
                            " ${_current?.duration.toString()}"),
                      ),
                      new Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child:
                            new InkWell(
                              onTap: () {
                                switch (_currentStatus) {
                                  case RecordingStatus.Initialized:
                                    {
                                      _start();
                                      break;
                                    }
                                  case RecordingStatus.Recording:
                                    {
                                      _pause();
                                      break;
                                    }
                                  case RecordingStatus.Paused:
                                    {
                                      _resume();
                                      break;
                                    }
                                  case RecordingStatus.Stopped:
                                    {
                                      _init();
                                      break;
                                    }
                                  default:
                                    break;
                                }
                              },
                              child: Container(
                                width: 60,
                                height: 60,
                                child:  _buildText(_currentStatus),
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color(0xFFe0f2f1)),
                              ),
                            ),

//                            FlatButton(
//                              onPressed: () {
//                                switch (_currentStatus) {
//                                  case RecordingStatus.Initialized:
//                                    {
//                                      _start();
//                                      break;
//                                    }
//                                  case RecordingStatus.Recording:
//                                    {
//                                      _pause();
//                                      break;
//                                    }
//                                  case RecordingStatus.Paused:
//                                    {
//                                      _resume();
//                                      break;
//                                    }
//                                  case RecordingStatus.Stopped:
//                                    {
//                                      _init();
//                                      break;
//                                    }
//                                  default:
//                                    break;
//                                }
//                              },
//                              child: _buildText(_currentStatus),
//                              color: Colors.lightBlue,
//                            ),
                          ),
                          InkWell(
                            onTap: _currentStatus != RecordingStatus.Unset ? _stop : null,
                            child: Container(
                              width: 60,
                              height: 60,
                              child: Icon(Icons.stop, size: 20,),
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color(0xFFe0f2f1)),
                            ),
                          ),
//                          new FlatButton(
//                            onPressed:
//                            _currentStatus != RecordingStatus.Unset ? _stop : null,
//                            child:
//                            new Icon(
//                              Icons.stop,
//                              color: Colors.white,
//                            ),
//                            color: Colors.blueAccent.withOpacity(0.5),
//                          ),
                          SizedBox(
                            width: 8,
                          ),
                          InkWell(
                            onTap:uploadaudio,//onPlayAudio,
                            child: Container(
                              width: 60,
                              height: 60,
                              child: Icon(Icons.file_upload, size: 20,),
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color(0xFFe0f2f1)),
                            ),
                          ),
//                          new FlatButton(
//                            onPressed: onPlayAudio,
//                            child:
//                            new Text("Play", style: TextStyle(color: Colors.white)),
//                            color: Colors.blueAccent.withOpacity(0.5),
//                          ),
                        ],
                      ),
//                      new Text("Status : $_currentStatus"),
//                      new Text('Avg Power: ${_current?.metering?.averagePower}'),
//                      new Text('Peak Power: ${_current?.metering?.peakPower}'),
//                      new Text("File path of the record: ${_current?.path}"),
//                      new Text("Format: ${_current?.audioFormat}"),
//                      new Text(
//                          "isMeteringEnabled: ${_current?.metering?.isMeteringEnabled}"),
//                      new Text("Extension : ${_current?.extension}"),


                    //////////////////////////////////////////
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
                              onTap: (){loadAssets();} ,
                              child: Icon(
                                images.length>0 ? Icons.check_circle : Icons
                                    .add_photo_alternate,
                                color: Colors.greenAccent,
                                size: 50,
                              ),
                            ),
                            SizedBox(
                              width: 10.0,
                            ),
                            Expanded(
                              child: Text(
                                "يرجى الضغط على الصورة لتحميل صور الاعمال السابقة",
                                textDirection: TextDirection.rtl,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
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
                                fromPlace = sendData["loc_latLng"];
                                fromPlaceLat = fromPlace.latitude.toString();
                                fromPlaceLng = fromPlace.longitude.toString();
                                fPlaceName = sendData["loc_name"];
                                print("\n\n\n\n\n\n\nfromPlaceLng>>>>"+
                                    fromPlaceLng+fPlaceName+"\n\n\n\n\n\n");

                              } ,
                              child: Icon(
                                fromPlaceLat == null ? Icons.gps_fixed : Icons.check_circle
                                    ,
                                color: Colors.purpleAccent,
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
                                    fontSize: 15,
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
                        padding: EdgeInsets.only(
                            top: _minimumPadding, bottom: _minimumPadding),
                        child: Container(
                          height: 50.0,
                          child: Material(
                            borderRadius: BorderRadius.circular(20.0),
                            shadowColor: const Color(0xffFCC201),
                            color: const Color(0xffF1AB37),
                            elevation: 3.0,
                            child: GestureDetector(
                              onTap: () async {
                                if (_formKey.currentState.validate()) {

                                  if(fromPlaceLat == null || fromPlaceLng == null ||   fPlaceName == null  ){
                                    Toast.show("برجاء إدخال الموقع",context,duration: Toast.LENGTH_LONG,gravity:  Toast.BOTTOM);
                                  }else{
                                    try {
                                      final result = await InternetAddress.lookup('google.com');
                                      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
                                        uploadpp0();

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
                              child: Center(
                                child: Text(
                                  'تسجيل',
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

                    ],
                  )),
            ),
            new Align(
              child: loadingIndicator, alignment: FractionalOffset.center,),

          ],
        ),
      ),
    );
  }

//  void _onDropDownItemSelectedType(String newValueSelected) {
//    setState(() {
//      this._typecurrentItemSelected = newValueSelected;
//    });
//  }
  void _onDropDownItemSelectedSpares(String newValueSelected) {
    setState(() {
      this._sparecurrentItemSelected = newValueSelected;
    });
  }
  void _onDropDownItemSelectedindyear(String newValueSelected) {
    setState(() {
      this._indyearcurrentItemSelected = newValueSelected;
    });
  }

  Future<void> loadAssets() async {
    List<Asset> resultList = List<Asset>();
    String error = 'No Error Dectected';

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 7,
        enableCamera: false,
        selectedAssets: images,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "اعلان"),
        materialOptions: MaterialOptions(
          statusBarColor: "#000000",
          actionBarColor: "#000000",
          actionBarTitle: "price me",
          allViewTitle: "كل الصور",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );
    } on Exception catch (e) {
      error = e.toString();
    }


    if (!mounted) return;

    setState(() {
      images = resultList;
      _error = error;

    });
  }
  void _uploaddata(urlList) {
    //print("kkk"+urlList[0].toString());

    FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: emailController.text,
      password: passwordController.text,
    ).then((signedInUser) {
      print("kkk"+signedInUser.toString());

      adduser(signedInUser.user, urlList);
    }).catchError((e) {
      Toast.show(e,context,duration: Toast.LENGTH_LONG,gravity:  Toast.BOTTOM);
      //  print(e);
    });


//    var alertDialog = AlertDialog(
//      title: Text("مبارك"),
//        Toast.show("تم تسجيل الدخول بنجاح",context,duration: Toast.LENGTH_SHORT,gravity:  Toast.BOTTOM);  content: Text("تم الحجز بنجاح"),
//    );
//
//    showDialog(
//        context: context,
//        builder: (BuildContext context) => alertDialog);
  }
  void adduser( signedInUser, urlList) {
    print("kkk"+signedInUser.uid);
    Firestore.instance.collection('users').document(signedInUser.uid).setData({
      'uid': signedInUser.uid,
      'email': emailController.text,
      'name': nameController.text,
      'body': bodyController.text,
      'photourl': signedInUser.photoUrl,
      'curilist': urlList.toString(),
      "provider": signedInUser.providerData[1].providerId,
      'fromPLat': fromPlaceLat,
      'fromPLng': fromPlaceLng,
      'fPlaceName':fPlaceName,
      'spareparts': _sparecurrentItemSelected,
      'discribtion': discController.text,
      'cType': "trader",
    }).whenComplete(() {
      SessionManager prefs =  SessionManager();
      prefs.setAuthType("trader");
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ConnectionScreen()));
    });
  }

  Future uploadpp0() async {
    if (images.length == 0) {
      _uploaddata("");

    } else {
    final StorageReference storageRef =
    FirebaseStorage.instance.ref().child('myimage');
    int i = 0;
    for (var f in images) {
      //  images.forEach((f) async {
      var byteData = await f.getByteData(quality: 50);
//      final String path1 = await getApplicationDocumentsDirectory().path;
//      var file=await getImageFileFromAssets(path);
      // final byteData = await rootBundle.load('$f');
      DateTime now = DateTime.now();
      final file = File('${(await getTemporaryDirectory()).path}/$f');
      await file.writeAsBytes(byteData.buffer
          .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
      final StorageUploadTask uploadTask =
      storageRef.child('$now.jpg').putFile(file);
      var Imageurl = await (await uploadTask.onComplete).ref.getDownloadURL();
      Toast.show("تم تحميل صورة طال عمرك", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
      setState(() {
        url1 = Imageurl.toString();
        urlList.add(url1);
        //  print('URL Is${images.length} ///$url1///$urlList');
        i++;
        // _load2 = false;
      });
      if (i == images.length) {
        // print('gggg${images.length} ///$i');
        _uploaddata(urlList);
      }
    }
    setState(() {
      _load1 = true;
    });
  }
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
  void onSubmit4(String result) {
    setState(() {
      fault1 = result.split(",")[0];
      fault2 = result.split(",")[1];
      Toast.show(
          "${result.split(",")[0]}///////${result.split(",")[1]}", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    });
  }
  _init() async {
    try {
      if (await FlutterAudioRecorder.hasPermissions) {
        String customPath = '/flutter_audio_recorder_';
        io.Directory appDocDirectory;
//        io.Directory appDocDirectory = await getApplicationDocumentsDirectory();
        if (io.Platform.isIOS) {
          appDocDirectory = await getApplicationDocumentsDirectory();
        } else {
          appDocDirectory = await getExternalStorageDirectory();
        }

        // can add extension like ".mp4" ".wav" ".m4a" ".aac"
        customPath = appDocDirectory.path +
            customPath +
            DateTime.now().millisecondsSinceEpoch.toString();

        // .wav <---> AudioFormat.WAV
        // .mp4 .m4a .aac <---> AudioFormat.AAC
        // AudioFormat is optional, if given value, will overwrite path extension when there is conflicts.
        _recorder =
            FlutterAudioRecorder(customPath, audioFormat: AudioFormat.WAV);

        await _recorder.initialized;
        // after initialization
        var current = await _recorder.current(channel: 0);
        print(current);
        // should be "Initialized", if all working fine
        setState(() {
          _current = current;
          _currentStatus = current.status;
          print(_currentStatus);
        });
      } else {
        Scaffold.of(context).showSnackBar(
            new SnackBar(content: new Text("You must accept permissions")));
      }
    } catch (e) {
      print(e);
    }
  }

  _start() async {
    try {
      await _recorder.start();
      var recording = await _recorder.current(channel: 0);
      setState(() {
        _current = recording;
      });

      const tick = const Duration(milliseconds: 50);
      new Timer.periodic(tick, (Timer t) async {
        if (_currentStatus == RecordingStatus.Stopped) {
          t.cancel();
        }

        var current = await _recorder.current(channel: 0);
        // print(current.status);
        setState(() {
          _current = current;
          _currentStatus = _current.status;
        });
      });
    } catch (e) {
      print(e);
    }
  }

  _resume() async {
    await _recorder.resume();
    setState(() {});
  }

  _pause() async {
    await _recorder.pause();
    setState(() {});
  }

  _stop() async {
    var result = await _recorder.stop();
    print("Stop recording: ${result.path}");
    print("Stop recording: ${result.duration}");
    File file = widget.localFileSystem.file(result.path);
    print("File length: ${await file.length()}");
    setState(() {
      song=file.readAsBytesSync();
      _current = result;
      _currentStatus = _current.status;
    });
  }

  Widget _buildText(RecordingStatus status) {
    var text = "";
    var icon=Icons.play_arrow;
    switch (_currentStatus) {
      case RecordingStatus.Initialized:
        {
          text = 'Start';
         icon=Icons.play_arrow;

          break;
        }
      case RecordingStatus.Recording:
        {
          text = 'Pause';
          icon=Icons.pause;

          break;
        }
      case RecordingStatus.Paused:
        {
          text = 'Resume';
          icon=Icons.arrow_forward_ios;

          break;
        }
      case RecordingStatus.Stopped:
        {
          text = 'Init';
          icon=Icons.cancel;

        break;
        }
      default:
        break;
    }
    return Icon(icon);
  }

  void onPlayAudio() async {
    AudioPlayer audioPlayer = AudioPlayer();
    await audioPlayer.play(_current.path, isLocal: true);
  }
  uploadaudio(){
    DateTime now = DateTime.now();

    String filePath = _current?.path;
    String _extension = _current?.audioFormat.toString();
    StorageReference storageRef =
    FirebaseStorage.instance.ref().child("myaudio");
//    ref=FirebaseStorage.instance.ref().child(songpath);
//    StorageUploadTask uploadTask=ref.putData(song);
//
//    song_down_url=await (await uploadTask.onComplete).ref.getDownloadURL();
    final StorageUploadTask uploadTask = storageRef.child("$now.${_current?.audioFormat}").putData(song
//      StorageMetadata(
//        contentType: 'audio/$_extension',
//      ),
    );
    setState(() async {
      var Audiourl = await (await uploadTask.onComplete).ref.getDownloadURL();
      var  url2 = Audiourl.toString();
      print("$_extension  mmm$url2");
    });  }

//  uploadaudio(){
//    DateTime now = DateTime.now();
//
//    String filePath = _current?.path;
//    String _extension = _current?.audioFormat.toString();
//    StorageReference storageRef =
//    FirebaseStorage.instance.ref().child("myaudio");
//
//    final StorageUploadTask uploadTask = storageRef.child("$now.$_extension").putFile(
//      File(filePath),
////      StorageMetadata(
////        contentType: 'audio/$_extension',
////      ),
//    );
//    setState(() async {
//      var Audiourl = await (await uploadTask.onComplete).ref.getDownloadURL();
//    var  url2 = Audiourl.toString();
//    print("$_extension mmm$url2");
//    });  }
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
      new ModelClass("تويوتا",["كورولا","ياريس"]),
      new ModelClass("هونداى",["اكسينت","اكسيل","ماتريكس"]),
      new ModelClass("فيات",["128","132"]),

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
        centerTitle:true ,
        title: Text(
          widget.model,
          style: TextStyle(fontWeight: FontWeight.bold),
          textDirection: TextDirection.rtl,
        ),

      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top:18.0),
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
                      children: modelList[i].subtitle
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
                            widget.onSubmit3(_currentValue1.toString() + "," + _currentValue.toString());
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
//////////////////////////////////

//typedef void MyFormCallback4(String result);
//
//class MyForm4 extends StatefulWidget {
//  final MyFormCallback4 onSubmit4;
//  String dep;
//
//  MyForm4(this.dep, {this.onSubmit4});
//
//  @override
//  _MyForm4State createState() => _MyForm4State();
//}
//
//class _MyForm4State extends State<MyForm4> {
//  String _currentValue = '';
//  String _currentValue1 = '';
//
//  List<DepartmentClass> departlist1 = [];
//
//  @override
//  void initState() {
//    super.initState();
//    _currentValue = widget.dep;
//
//    final departments1databaseReference = FirebaseDatabase.instance
//        .reference()
//        .child("Departments1")
//        .child(widget.dep);
//    // print("##########${widget.dep}");
//    departments1databaseReference.once().then((DataSnapshot snapshot) {
//      var KEYS = snapshot.value.keys;
//      var DATA = snapshot.value;
//      //Toast.show("${snapshot.value.keys}",context,duration: Toast.LENGTH_LONG,gravity:  Toast.BOTTOM);
//      //  print("kkkk${DATA.toString()}");
//
//      departlist1.clear();
//      for (var individualkey in KEYS) {
//        // if (!blockList.contains(individualkey) &&user.uid != individualkey) {
//        DepartmentClass departmentclass = new DepartmentClass(
//          DATA[individualkey]['id'],
//          DATA[individualkey]['title'],
//          DATA[individualkey]['subtitle'],
//          DATA[individualkey]['uri'],
//          Colors.white,
//          false,
//          DATA[individualkey]['arrange'],
//        );
//        //  print("kkkkkkkkk"+ctitle+ DATA[individualkey]['title']);
//        setState(() {
//          if (DATA[individualkey]['arrange'] == null)
//            departmentclass = new DepartmentClass(
//              DATA[individualkey]['id'],
//              DATA[individualkey]['title'],
//              DATA[individualkey]['subtitle'],
//              DATA[individualkey]['uri'],
//              const Color(0xff8C8C96),
//              false,
//              100,
//            );
//          departlist1.add(departmentclass);
//          setState(() {
////            print("size of list : 5");
//            departlist1.sort((depart1, depart2) =>
//                depart1.arrange.compareTo(depart2.arrange));
//          });
//        });
//        // }
//      }
//    });
//  }
//
//  @override
//  Widget build(BuildContext context) {
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
//          widget.onSubmit4(
//              _currentValue1.toString() + "," + _currentValue.toString());
//        });
//      },
//    );
//    return Scaffold(
//      appBar: AppBar(
//        backgroundColor: const Color(0xff171732),
//        centerTitle:true ,
//        title: Text(
//          widget.dep,
//          style: TextStyle(fontWeight: FontWeight.bold),
//          textDirection: TextDirection.rtl,
//        ),
//
//      ),
//      body: new ListView.builder(
//        itemCount: departlist1.length,
//        itemBuilder: (context, i) {
//          return new ExpansionTile(
//            title: new Text(
//              departlist1[i].title,
//              style: new TextStyle(
//                  fontSize: 20.0,
//                  fontWeight: FontWeight.bold,
//                  fontStyle: FontStyle.italic),
//            ),
//            children: <Widget>[
//              Column(
//                // padding: EdgeInsets.all(8.0),
//                children: departlist1[i].subtitle != null
//                    ? departlist1[i]
//                    .subtitle
//                    .split(",")
//                    .map((value) => RadioListTile(
//                  groupValue: _currentValue,
//                  title: Text(
//                    value,
//                    textDirection: TextDirection.rtl,
//                  ),
//                  value: value,
//                  onChanged: (val) {
//                    setState(() {
//                      // debugPrint('VAL = $val');
//                      _currentValue = val;
//                      _currentValue1 = departlist1[i].title;
//                    });
//                  },
//                ))
//                    .toList()
//                    : departlist1[i]
//                    .title
//                    .split(",")
//                    .map((value) => RadioListTile(
//                  groupValue: _currentValue,
//                  title: Text(
//                    value,
//                    textDirection: TextDirection.rtl,
//                  ),
//                  value: value,
//                  onChanged: (val) {
//                    setState(() {
//                      debugPrint('VAL = $val');
//                      _currentValue = val;
//                      _currentValue1 = departlist1[i].title;
//                    });
//                  },
//                ))
//                    .toList(),
//              ),
////              new Column(
////                children:
////                _buildExpandableContent(regionlist[i]),
////              ),
//              Row(
//                mainAxisAlignment: MainAxisAlignment.spaceAround,
//                children: <Widget>[
//                  cancelButton,
//                  continueButton,
//                ],
//              )
//            ],
//          );
//        },
//      ),
//    );
//  }
//}
//

