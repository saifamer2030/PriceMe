import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
// import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
import 'package:flutter_video_compress/flutter_video_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:priceme/Videos/photosvideomine.dart';
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

class EditVideo extends StatefulWidget {

  int carrange;
  String cId,cuserId,cname,cphotourl,cdate,cdepart,cdetail,curi,imgurl,ctitle,ccar,ccarversion,cyear;

  EditVideo(this.carrange, this.cId, this.cuserId, this.cname, this.cphotourl,
      this.cdate, this.cdepart, this.cdetail, this.curi, this.imgurl,this.ctitle
      ,this.ccar,this.ccarversion,this.cyear);

  @override
  _EditVideoState createState() => _EditVideoState();
}

class _EditVideoState extends State<EditVideo> {
  final double _minimumPadding = 5.0;
  var _formKey = GlobalKey<FormState>();
  bool _load2 = false;
  String _userId;
  String dep1;
  String dep2;
  int picno = 0;
  List<String> urlList = [];
  String _cName,_cphotourl,_cType;
  List<String> departlist = ["ترفيهى","تجارى"];
  File videofile,thumbnailurlfile;
 bool videocheck=false;
  double _value = 0.0;
  TextEditingController _titleController = TextEditingController();
  TextEditingController _detailController = TextEditingController();
  var _departcurrentItemSelected = '';
  String imgurl,urlvideo,cphotourl;
  List<Asset> images = List<Asset>();
 double _currentSliderValue=0.0;
  int vd=0;
  var _indyearcurrentItemSelected="";
  List<String> indyearlist = [];

  String model1;
  String model2;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.ctitle);
    _detailController = TextEditingController(text: widget.cdetail);
    _departcurrentItemSelected=widget.cdepart;
    urlvideo=widget.curi;
    imgurl=widget.imgurl;
    model1 = widget.ccar;model2 =widget.ccarversion;
    DateTime now = DateTime.now();
    indyearlist=new List<String>.generate(50, (i) =>  NumberUtility.changeDigit((now.year+1 -i).toString(), NumStrLanguage.English));
    indyearlist[0]=("الموديل");
    _indyearcurrentItemSelected=widget.cyear;
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
          _cType = data.documents[0].data['cType'];
          _cName = data.documents[0].data['name'];
          _cphotourl = data.documents[0].data['photourl'];
          if(_cphotourl==null){
            if(user.photoUrl==null||user.photoUrl==""){
              _cphotourl= "https://i.pinimg.com/564x/0c/3b/3a/0c3b3adb1a7530892e55ef36d3be6cb8.jpg" ;
            }else{_cphotourl=user.photoUrl;}}
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
                          Center(
                            child: Container(
                              width: 200,
                              height: 150,
                              decoration: BoxDecoration(
                                border: new Border.all(
                                  color: Colors.white,
                                  width: 0,
                                ),
                                image: imgurl == null?DecorationImage(
                                  image: AssetImage("assets/images/ic_background.png" ),
                                  fit: BoxFit.fill,
                                ):DecorationImage(
                                  image:  NetworkImage(
                                      imgurl             ),

                                  fit: BoxFit.fill,
                                ),
                                borderRadius: BorderRadius.circular(0.0),
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
                          _cType=="trader"? Center(
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
                          ):Container(),
                          _departcurrentItemSelected==departlist[1]?  Row(
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
                                                widget.ccar,widget.ccarversion,
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
                          ):Container(),

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
                                    "تعديل",
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
                                    try {
                                      final result =
                                          await InternetAddress.lookup(
                                              'google.com');
                                      if (result.isNotEmpty &&
                                          result[0].rawAddress.isNotEmpty) {
                                        print("mmmmm1");

                                        createRecord();
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




  void createRecord() {
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


      Firestore.instance
          .collection('videos')
          .document(widget.cId)
          .updateData({
        'cId': widget.cId,
        'carrange': arrange,
        'cuserId': _userId,
        'cname': _cName,
        'cphotourl': _cphotourl,
        'cdate': date1,
        'ctitle': _titleController.text,
        'cdepart': _departcurrentItemSelected,
        'cdetail': _detailController.text,
        'curi': urlvideo,
        'imgurl': imgurl,
        'ccar':model1,
        'ccarversion':model2,
        'cyear':_indyearcurrentItemSelected,


      }).whenComplete(() {

        Navigator.push(
            context,
            new MaterialPageRoute(
                builder: (context) => VidiosPhotoMine()));


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
  String model1;

  MyForm3(this.model,this.model1, {this.onSubmit3});
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
    _currentValue = widget.model1;
    modelList = [
      new ModelClass("تويوتا",["كورولا","ياريس"]),
      new ModelClass("هونداى",["اكسينت","اكسيل","ماتريكس"]),
      new ModelClass("فيات",["128","132"]),

    ];
  }

  @override
  Widget build(BuildContext context) {
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
///////////////////////////////