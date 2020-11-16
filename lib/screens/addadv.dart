
import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file/local.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_recorder/flutter_audio_recorder.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:priceme/classes/AClass.dart';
import 'package:priceme/classes/FaultStringClass.dart';
import 'package:priceme/classes/FaultsClass.dart';
import 'package:priceme/classes/ModelClass.dart';
import 'package:priceme/classes/OutputClass.dart';
import 'package:priceme/classes/SparePartsClass.dart';
import 'package:priceme/classes/sharedpreftype.dart';
import 'package:priceme/screens/cur_loc.dart';
import 'package:priceme/screens/network_connection.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:io' as io;

import 'package:toast/toast.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:math' as Math;

import '../Splash.dart';

class AddAdv extends StatefulWidget {
  final LocalFileSystem localFileSystem;
  String probtype0, selecteditem0, selecteditemid;
  AddAdv(this.probtype0, this.selecteditem0, this.selecteditemid,  {localFileSystem})
      : this.localFileSystem = localFileSystem ?? LocalFileSystem();

  @override
  _AddAdvState createState() => _AddAdvState();
}
enum SingingCharacter4 { used, New, NO }

class _AddAdvState extends State<AddAdv> {
  bool _load1 = false;
  bool fault_s_apear = false;
  bool spare_s_apear = false;

  String url1;
  String imagepathes = '';
  List<String> urlList = [];
  List<String> proplemtype = ["اعطال","قطع غيار"];
  List<String> indyearlist = [];

  List<bool> subcheckList1 = [];
  List<bool> subcheckList = [];
  List<FaultStringClass> sparesList = [];
  List<FaultStringClass> faultsList = [];

  List<FaultsClass> subfaultsList = [];
  List<FaultsClass> subsparesList = [];

  List<SparePartsClass> mainfaultsList = [];
  List<SparePartsClass> mainsparsList = [];

  List<String> faultoutput= [];
  List<String> faultoutputsub= [];


  String subfault="";
  String subcheck="";

  String subfault1="";
  String subcheck1="";
  List<Asset> images = List<Asset>();
  String _error = 'No Error Dectected';
  var _formKey = GlobalKey<FormState>();
  LatLng fromPlace, toPlace ;
  String fromPlaceLat , fromPlaceLng , fPlaceName ;
  Map <String , dynamic > sendData = Map();
  String model1;
  String model2="...";
  String fault1,faultid;
  String fault2;
  double _value=0.0;
  String _userId;
  var song;  //var _typearray = DefConstants.countriesArray;
  SingingCharacter4 _character4 = SingingCharacter4.New;

  final double _minimumPadding = 5.0;
  String _cName = "";
  String _cMobile;
  String _cEmail="";
  TextEditingController titleController = TextEditingController();

  TextEditingController discController = TextEditingController();
  TextEditingController bodyController = TextEditingController();
  var _indyearcurrentItemSelected="";

  var _probtypecurrentItemSelected = '';
  var _sparecurrentItemSelected = '';
  FlutterAudioRecorder _recorder;
  Recording _current;
  RecordingStatus _currentStatus = RecordingStatus.Unset;
  void getDataf() {
    setState(() {
      //  print("ooooooo${widget.sparepartsList[0]}");
      final SparePartsReference = Firestore.instance;

      mainfaultsList.clear;

      SparePartsReference.collection("faults")
          .getDocuments()
          .then((QuerySnapshot snapshot) {
        snapshot.documents.forEach((sparepart) {
          SparePartsClass spc = SparePartsClass(
            sparepart.data['sid'],
            sparepart.data['sName'],
            sparepart.data['surl'],
              sparepart.data['sid']==widget.selecteditemid?const Color(0xff171732):const Color(0xff8C8C96),
            sparepart.data['sid']==widget.selecteditemid?true:false,
          );
          // const Color(0xff171732);
          setState(() {
            mainfaultsList.add(spc);
          });
        });
      });
    });

  }
  void getDatas() {
    setState(() {
      //  print("ooooooo${widget.sparepartsList[0]}");
      final SparePartsReference = Firestore.instance;
      final SparePartsReference1 = Firestore.instance;

      mainsparsList.clear;

      SparePartsReference.collection("spareparts")
          .getDocuments()
          .then((QuerySnapshot snapshot) {
        snapshot.documents.forEach((sparepart) {
          SparePartsClass spc = SparePartsClass(
            sparepart.data['sid'],
            sparepart.data['sName'],
            sparepart.data['surl'],
            sparepart.data['sid']==widget.selecteditemid?const Color(0xff171732):const Color(0xff8C8C96),
            sparepart.data['sid']==widget.selecteditemid?true:false,
          );


          setState(() {

            mainsparsList.add(spc);
            // print(sparepartsList.length.toString() + "llll");
          });

        });
      });
    });

  }
  void getsubdatainitial(){
  if(_probtypecurrentItemSelected=="اعطال"&&faultid!=null){
    final SparePartsReference1 = Firestore.instance;
    SparePartsReference1.collection("subfaults").document( faultid).collection("subfaultid")
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      FaultsClass fp;
      snapshot.documents.forEach((fault) {
        fp = FaultsClass(
          fault.data['fid'],
          fault.data['fName'],
          fault.data['fsubId'],
          fault.data['fsubName'],
          fault.data['fsubDesc'],
          fault.data['fsubUrl'],
          const Color(0xff8C8C96),
          false,
        );
        setState(() {
          subfaultsList.add(fp);
        });
      });
    }).whenComplete(() => setState((){ fault_s_apear = true;}));

  }else  if(_probtypecurrentItemSelected=="قطع غيار"&&faultid!=null){

    final SparePartsReference1 = Firestore.instance;
    SparePartsReference1.collection("subspares").document( faultid).collection("subsparesid")
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      FaultsClass fp;
      snapshot.documents.forEach((fault) {
        fp = FaultsClass(
          fault.data['fid'],
          fault.data['fName'],
          fault.data['fsubId'],
          fault.data['fsubName'],
          fault.data['fsubDesc'],
          fault.data['fsubUrl'],
          const Color(0xff8C8C96),
          false,
        );
        setState(() {
          subsparesList.add(fp);


        });
      });
    }).whenComplete(() => setState((){ spare_s_apear = true;}));

  }

}
  @override
  void initState() {
    super.initState();
    _init();

    FirebaseAuth.instance.currentUser().then((user) => user == null
        ?     Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => Splash()))
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

        });
      }
    });
    }));

    DateTime now = DateTime.now();
    indyearlist=new List<String>.generate(50, (i) =>  NumberUtility.changeDigit((now.year+1 -i).toString(), NumStrLanguage.English));
    indyearlist[0]=("الموديل");
    _indyearcurrentItemSelected=indyearlist[0];
    _probtypecurrentItemSelected=widget.probtype0=="قطع غيار"?widget.probtype0:proplemtype[0];
    // _sparecurrentItemSelected =  widget.probtype0=="قطع غيار"?widget.selecteditem0:widget.sparepartsList[0];
    //fault1=widget.mfault;
    fault1=widget.selecteditem0;
    faultid=widget.selecteditemid;
    getDataf();
    getDatas();
    getsubdatainitial();

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
                                  items: proplemtype.map((String value) {
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
                                  value: _probtypecurrentItemSelected,
                                  onChanged: (String newValueSelected) {
                                    // Your code to execute, when a menu item is selected from dropdown
                                    _onDropDownItemSelectedproblem(
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
                      _probtypecurrentItemSelected==proplemtype[0]?  Container(
                        height: 35,
                        child: mainfaultsList.length == 0
                            ? new Text("برجاء الإنتظار")
                            : new ListView.builder(
                            physics: BouncingScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            reverse: true,
                            itemCount: mainfaultsList.length,
                            itemBuilder: (BuildContext ctxt, int index) {
                              return Padding(
                                padding: const EdgeInsets.only(
                                    top: 1.0, right: 5.0, left: 5.0),
                                child: Card(
                                  color: const Color(0xff8C8C96),
                                  shape: new RoundedRectangleBorder(
                                      side: new BorderSide(
                                          color: mainfaultsList[index].ccolor, width: 3.0),
                                      borderRadius: BorderRadius.circular(100.0)),
                                  //borderOnForeground: true,
                                  elevation: 10.0,
                                  margin: EdgeInsets.all(1),
                                  child: InkWell(
                                    onTap: () {
                                      subfaultsList.clear();
                                      setState(() {
                                        fault_s_apear=true;
                                        mainfaultsList[index].ccolorcheck =
                                        !mainfaultsList[index].ccolorcheck;
                                        if (mainfaultsList[index].ccolorcheck) {
                                          mainfaultsList[index].ccolor =
                                          const Color(0xff171732);
                                          for (var i = 0; i < mainfaultsList.length; i++) {
                                            if (i != index) {
                                              mainfaultsList[i].ccolor =
                                              const Color(0xff8C8C96);
                                            }
                                          }
                                        } else {
                                          mainfaultsList[index].ccolor =
                                          const Color(0xff8C8C96);
                                        }
                                      });

                                      setState((){
                                        final SparePartsReference1 = Firestore.instance;
                                        SparePartsReference1.collection("subfaults").document( mainfaultsList[index].sid).collection("subfaultid")
                                            .getDocuments()
                                            .then((QuerySnapshot snapshot) {
                                          FaultsClass fp;
                                          snapshot.documents.forEach((fault) {
                                            fp = FaultsClass(
                                              fault.data['fid'],
                                              fault.data['fName'],
                                              fault.data['fsubId'],
                                              fault.data['fsubName'],
                                              fault.data['fsubDesc'],
                                              fault.data['fsubUrl'],
                                              const Color(0xff8C8C96),
                                              false,
                                            );

                                            if(faultoutputsub.contains( fault.data['fsubName'])){
                                              fp = FaultsClass(
                                                fault.data['fid'],
                                                fault.data['fName'],
                                                fault.data['fsubId'],
                                                fault.data['fsubName'],
                                                fault.data['fsubDesc'],
                                                fault.data['fsubUrl'],
                                                const Color(0xff171732),
                                                true,
                                              );
                                            }

                                            setState(() {
                                              subfaultsList.add(fp);
                                            });
                                          });
                                        });
                                      });
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Padding(
                                        padding: const EdgeInsets.only(top: 5),
                                        child: Text(
                                          mainfaultsList[index].sName,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontFamily: "",
                                            fontWeight: FontWeight.bold,
                                            fontSize: 11,
                                            letterSpacing: 0.5,
                                            height: 1,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }),
                      ):Container(),
                      SizedBox(
                        height: _minimumPadding,
                        width: _minimumPadding,
                      ),
                      _probtypecurrentItemSelected==proplemtype[0]? fault_s_apear?  Container(
                        height: 35,
                        child:
                        // subfaultsList.length == 0
                        //     ? new Text("")
                        //     :
                        new ListView.builder(
                            physics: BouncingScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            reverse: true,
                            itemCount: subfaultsList.length,
                            itemBuilder: (BuildContext ctxt, int index) {
                              return Padding(
                                padding: const EdgeInsets.only(
                                    top: 1.0, right: 5.0, left: 5.0),
                                child: Card(
                                  color: const Color(0xff8C8C96),
                                  shape: new RoundedRectangleBorder(
                                      side: new BorderSide(
                                          color: subfaultsList[index].ccolor, width: 3.0),
                                      borderRadius: BorderRadius.circular(100.0)),
                                  //borderOnForeground: true,
                                  elevation: 10.0,
                                  margin: EdgeInsets.all(1),
                                  child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        subfaultsList[index].ccolorcheck =
                                        !subfaultsList[index].ccolorcheck;
                                        if (subfaultsList[index].ccolorcheck) {
                                          subfaultsList[index].ccolor =
                                          const Color(0xff171732);
                                          faultoutput.add(subfaultsList[index].fName);
                                          faultoutputsub.add(subfaultsList[index].fsubName);
                                        } else {
                                          subfaultsList[index].ccolor =
                                          const Color(0xff8C8C96);
                                          faultoutput.remove(subfaultsList[index].fName);
                                          faultoutputsub.remove(subfaultsList[index].fsubName);//removeWhere((item){item==subfaultsList[index].fsubName;});
                                        }
                                      });
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Padding(
                                        padding: const EdgeInsets.only(top: 5),
                                        child: Text(
                                          subfaultsList[index].fsubName,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Colors.black,
//                                                  const Color(0xff171732),
                                            fontFamily: "",
                                            fontWeight: FontWeight.bold,
                                            fontSize: 11,
                                            letterSpacing: 0.5,
                                            height: 1,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }),
                      ):Container():Container(),
                      SizedBox(
                        height: _minimumPadding,
                        width: _minimumPadding,
                      ),
                      _probtypecurrentItemSelected==proplemtype[1]? Container(
                        height: 35,
                        child: mainsparsList.length == 0
                            ? new Text("برجاء الإنتظار")
                            : new ListView.builder(
                            physics: BouncingScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            reverse: true,
                            itemCount: mainsparsList.length,
                            itemBuilder: (BuildContext ctxt, int index) {
                              return Padding(
                                padding: const EdgeInsets.only(
                                    top: 1.0, right: 5.0, left: 5.0),
                                child: Card(
                                  color: const Color(0xff8C8C96),
                                  shape: new RoundedRectangleBorder(
                                      side: new BorderSide(
                                          color: mainsparsList[index].ccolor, width: 3.0),
                                      borderRadius: BorderRadius.circular(100.0)),
                                  //borderOnForeground: true,
                                  elevation: 10.0,
                                  margin: EdgeInsets.all(1),
                                  child: InkWell(
                                    onTap: () {
                                      subsparesList.clear();
                                      setState(() {
                                        spare_s_apear=true;
                                        mainsparsList[index].ccolorcheck =
                                        !mainsparsList[index].ccolorcheck;
                                        if (mainsparsList[index].ccolorcheck) {
                                          mainsparsList[index].ccolor =
                                          const Color(0xff171732);
                                          for (var i = 0; i < mainsparsList.length; i++) {
                                            if (i != index) {
                                              mainsparsList[i].ccolor =
                                              const Color(0xff8C8C96);
                                            }
                                          }
                                        } else {
                                          mainsparsList[index].ccolor =
                                          const Color(0xff8C8C96);
                                        }
                                      });

                                      setState((){
                                        final SparePartsReference1 = Firestore.instance;
                                        SparePartsReference1.collection("subspares").document( mainsparsList[index].sid).collection("subsparesid")
                                            .getDocuments()
                                            .then((QuerySnapshot snapshot) {
                                          FaultsClass fp;
                                          snapshot.documents.forEach((fault) {
                                            fp = FaultsClass(
                                              fault.data['fid'],
                                              fault.data['fName'],
                                              fault.data['fsubId'],
                                              fault.data['fsubName'],
                                              fault.data['fsubDesc'],
                                              fault.data['fsubUrl'],
                                              const Color(0xff8C8C96),
                                              false,
                                            );

                                            if(faultoutputsub.contains( fault.data['fsubName'])){
                                              fp = FaultsClass(
                                                fault.data['fid'],
                                                fault.data['fName'],
                                                fault.data['fsubId'],
                                                fault.data['fsubName'],
                                                fault.data['fsubDesc'],
                                                fault.data['fsubUrl'],
                                                const Color(0xff171732),
                                                true,
                                              );
                                            }

                                            setState(() {
                                              subsparesList.add(fp);
                                            });
                                          });
                                        });
                                      });
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Padding(
                                        padding: const EdgeInsets.only(top: 5),
                                        child: Text(
                                          mainsparsList[index].sName,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontFamily: "",
                                            fontWeight: FontWeight.bold,
                                            fontSize: 11,
                                            letterSpacing: 0.5,
                                            height: 1,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }),
                      ):Container(),
                      SizedBox(
                        height: _minimumPadding,
                        width: _minimumPadding,
                      ),
                      _probtypecurrentItemSelected==proplemtype[1]? spare_s_apear?  Container(
                        height: 35,
                        child:
                        new ListView.builder(
                            physics: BouncingScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            reverse: true,
                            itemCount: subsparesList.length,
                            itemBuilder: (BuildContext ctxt, int index) {
                              return Padding(
                                padding: const EdgeInsets.only(
                                    top: 1.0, right: 5.0, left: 5.0),
                                child: Card(
                                  color: const Color(0xff8C8C96),
                                  shape: new RoundedRectangleBorder(
                                      side: new BorderSide(
                                          color: subsparesList[index].ccolor, width: 3.0),
                                      borderRadius: BorderRadius.circular(100.0)),
                                  //borderOnForeground: true,
                                  elevation: 10.0,
                                  margin: EdgeInsets.all(1),
                                  child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        subsparesList[index].ccolorcheck =
                                        !subsparesList[index].ccolorcheck;
                                        if (subsparesList[index].ccolorcheck) {
                                          subsparesList[index].ccolor =
                                          const Color(0xff171732);
                                          faultoutput.add(subsparesList[index].fName);
                                          faultoutputsub.add(subsparesList[index].fsubName);
                                        } else {
                                          subsparesList[index].ccolor =
                                          const Color(0xff8C8C96);
                                          faultoutput.remove(subsparesList[index].fName);
                                          faultoutputsub.remove(subsparesList[index].fsubName);//removeWhere((item){item==subfaultsList[index].fsubName;});
                                        }
                                      });
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Padding(
                                        padding: const EdgeInsets.only(top: 5),
                                        child: Text(
                                          subsparesList[index].fsubName,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Colors.black,
//                                                  const Color(0xff171732),
                                            fontFamily: "",
                                            fontWeight: FontWeight.bold,
                                            fontSize: 11,
                                            letterSpacing: 0.5,
                                            height: 1,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }),
                      ):Container():Container(),
                      Container(
                        height: 50,
                        child:Center(child: Text(faultoutputsub.toString())),),
                      SizedBox(
                        height: _minimumPadding,
                        width: _minimumPadding,
                      ),
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
                                      "نوع السيارة($model2)",
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
                      // _probtypecurrentItemSelected==proplemtype[0]?Container(
                      //   height: 40,
                      //   color: Colors.grey,
                      //   child: InkWell(
                      //     onTap: () {
                      //       // Navigator.push(
                      //       //     context,
                      //       //     MaterialPageRoute(
                      //       //         builder: (context) => MyForm4(
                      //       //             faultsList,widget.selecteditem0,widget.mfault,
                      //       //             onSubmit4: onSubmit4)));
                      //
                      //     },
                      //     child: Card(
                      //       elevation: 0.0,
                      //       color: const Color(0xff171732),
                      //       shape: RoundedRectangleBorder(
                      //         borderRadius: BorderRadius.circular(5),
                      //       ),
                      //       child: Center(
                      //         child: Padding(
                      //           padding: const EdgeInsets.all(8.0),
                      //           child: Text(
                      //             "نوع العطل",
                      //             textDirection: TextDirection.rtl,
                      //             style: TextStyle(
                      //                 color: Colors.grey,
                      //                 fontSize: 12,
                      //                 fontWeight: FontWeight.bold),
                      //           ),
                      //         ),
                      //       ),
                      //     ),
                      //   ),
                      // ):Container(),
//  List<SparePartsClass> mainfaultsList = [];










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
                              controller: titleController,
                              validator: (String value) {
                                if (value.isEmpty) {
                                  return 'برجاء إدخال عنوان';
                                }
                              },
                              decoration: InputDecoration(
                                labelText: 'عنوان المشكلة',
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
                      _probtypecurrentItemSelected==proplemtype[0]?Container():Padding(
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
                      _probtypecurrentItemSelected==proplemtype[0]?Container():SizedBox(
                        height: _minimumPadding,
                        width: _minimumPadding,
                      ),

                      _probtypecurrentItemSelected==proplemtype[0]?Container():SizedBox(
                        height: _minimumPadding,
                        width: _minimumPadding,
                      ),
                      _probtypecurrentItemSelected==proplemtype[0]?Container():Padding(
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
                      _probtypecurrentItemSelected==proplemtype[0]?Container():SizedBox(
                        height: _minimumPadding,
                        width: _minimumPadding,
                      ),
                      _probtypecurrentItemSelected==proplemtype[0]?Container():Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          ListTile(
                            title: const Text(
                              'جديدة',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
//                                          fontFamily: 'Estedad-Black',
                              ),
                              textAlign: TextAlign.right,
                            ),
                            trailing: Radio(
                              value: SingingCharacter4.New,
                              groupValue: _character4,
                              onChanged: (SingingCharacter4 value) {
                                setState(() {
                                  _character4 = value;
                                });
                              },
                            ),
                          ),
                          ListTile(
                            title: const Text(
                              'جديدة/مستعملة',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
//                                          fontFamily: 'Estedad-Black',
                              ),
                              textAlign: TextAlign.right,
                            ),
                            trailing: Radio(
                              value: SingingCharacter4.NO,
                              groupValue: _character4,
                              onChanged: (SingingCharacter4 value) {
                                setState(() {
                                  _character4 = value;
                                });
                              },
                            ),
                          ),
                          ListTile(
                            title: const Text(
                              'مستعملة',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
//                                          fontFamily: 'Estedad-Black',
                              ),
                              textAlign: TextAlign.right,
                            ),
                            trailing: Radio(
                              value: SingingCharacter4.used,
                              groupValue: _character4,
                              onChanged: (SingingCharacter4 value) {
                                setState(() {
                                  _character4 = value;
                                });
                              },
                            ),
                          ),
                        ],
                      ),

                      // _probtypecurrentItemSelected==proplemtype[0]?Container():Padding(
                      //     padding: EdgeInsets.only(
                      //         top: _minimumPadding, bottom: _minimumPadding),
                      //     child: Container(
                      //       height: 40,
                      //       color: Colors.grey,
                      //       child: InkWell(
                      //         onTap: () {
                      //           // Navigator.push(
                      //           //     context,
                      //           //     MaterialPageRoute(
                      //           //         builder: (context) => MyForm4(
                      //           //             sparesList,widget.selecteditem0,widget.mfault,
                      //           //             onSubmit4: onSubmit4)));
                      //
                      //         },
                      //         child: Card(
                      //           elevation: 0.0,
                      //           color: const Color(0xff171732),
                      //           shape: RoundedRectangleBorder(
                      //             borderRadius: BorderRadius.circular(5),
                      //           ),
                      //           child: Center(
                      //             child: Padding(
                      //               padding: const EdgeInsets.all(8.0),
                      //               child: Text(
                      //                 "نوع قطع الغيار",
                      //                 textDirection: TextDirection.rtl,
                      //                 style: TextStyle(
                      //                     color: Colors.grey,
                      //                     fontSize: 12,
                      //                     fontWeight: FontWeight.bold),
                      //               ),
                      //             ),
                      //           ),
                      //         ),
                      //       ),
                      //     )
                      // ),
                      // Container(
                      //   //decoration: BoxDecoration(border: Border.all(color: Colors.teal)),
                      //   child: new Directionality(textDirection: TextDirection.rtl,
                      //     child: CheckboxListTile(
                      //       title: const Text('هل تريد قطع غيار جديدة ام قديمة؟'),
                      //       subtitle: const Text('فعل الزر فى حالة الجديدة'),
                      //       secondary: const Icon(Icons.directions_car),
                      //       activeColor: Colors.red,
                      //       checkColor: Colors.yellow,
                      //       selected: _isChecked,
                      //       value: _isChecked,
                      //       onChanged: (bool value) {
                      //         setState(() {
                      //           _isChecked = value;
                      //         });
                      //       },
                      //     ),
                      //   ),
                      // ),
                      SizedBox(
                        height: _minimumPadding,
                        width: _minimumPadding,
                      ),

///////////////////////////////////////
                      new Slider(value:_value??0.0,
                          max: 62.0,min: 0.0,
                          onChanged: (double value){
                            setState(() {
                              value= double.parse(_current?.duration.inSeconds.toString());

                            });
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
                              child: Icon(Icons.backup,color: Colors.green, size: 30,),
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
//                           SizedBox(
//                             width: 8,
//                           ),
//                           InkWell(
//                             onTap:onPlayAudio,//uploadaudio,//onPlayAudio,
//                             child: Container(
//                               width: 60,
//                               height: 60,
//                               child: Icon(Icons.file_upload, size: 20,),
//                               decoration: BoxDecoration(
//                                   shape: BoxShape.circle,
//                                   color: Color(0xFFe0f2f1)),
//                             ),
//                           ),
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
                      // Padding(
                      //   padding: EdgeInsets.only(
                      //       top: _minimumPadding * 5, bottom: _minimumPadding),
                      //   child: Row(
                      //     mainAxisAlignment: MainAxisAlignment.center,
                      //     children: <Widget>[
                      //       InkWell(
                      //         onTap: () async {
                      //           sendData = await Navigator.push(
                      //             context,
                      //             MaterialPageRoute(
                      //                 builder: (context) =>
                      //                     CurrentLocation2()),
                      //           );
                      //
                      //           // print("\n\n\n\n\n\n\nfromPlaceLng>>>>"+
                      //           //     fromPlaceLng+fPlaceName+"\n\n\n\n\n\n");
                      //           setState(() {
                      //             fromPlace = sendData["loc_latLng"];
                      //             fromPlaceLat = fromPlace.latitude.toString();
                      //             fromPlaceLng = fromPlace.longitude.toString();
                      //             fPlaceName = sendData["loc_name"];
                      //           });
                      //         } ,
                      //         child: Icon(
                      //           fromPlaceLat == null ? Icons.gps_fixed : Icons.check_circle
                      //           ,
                      //           color: Colors.purpleAccent,
                      //           size: 50,
                      //         ),
                      //       ),
                      //       SizedBox(
                      //         width: 10.0,
                      //       ),
                      //       Expanded(
                      //         child: Text(
                      //           "يرجى الضغط على الصورة لتحديد موقع المحل",
                      //           textDirection: TextDirection.rtl,
                      //           style: TextStyle(
                      //               color: Colors.black,
                      //               fontSize: 15,
                      //               fontWeight: FontWeight.bold),
                      //         ),
                      //       ),
                      //       Align(
                      //         alignment: Alignment.topCenter,
                      //         child: Icon(
                      //           Icons.star,
                      //           color: Colors.red,
                      //           size: 15,
                      //         ),
                      //       ),
                      //
                      //     ],
                      //   ),
                      // ),
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

                                  if(images.length == 0 || song == null||  model1 == null || model2 == null||model2=="..."||  faultoutputsub.length == 0 ){
                                    Toast.show("برجاء التأكد من إضافة كل البيانات المطلوبة",context,duration: Toast.LENGTH_LONG,gravity:  Toast.BOTTOM);
                                  }else{
                                    try {
                                      final result = await InternetAddress.lookup('google.com');
                                      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
                                        setState(() {
                                          _load1 = true;
                                        });
                                        uploadaudio();


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
                                  'الإضافة و النشر',
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
  Future uploadpp0(audiourl) async {
    // String url1;
    final StorageReference storageRef =
    FirebaseStorage.instance.ref().child('myimage');
    int i = 0;
    for(var f in images){
      //  images.forEach((f) async {
      var byteData = await f.getByteData(quality: 50);

      DateTime now = DateTime.now();
      final file = File('${(await getTemporaryDirectory()).path}/$f');
      await file.writeAsBytes(byteData.buffer
          .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
      final StorageUploadTask uploadTask =
      storageRef.child('$now.jpg').putFile(file);
      var Imageurl = await (await uploadTask.onComplete).ref.getDownloadURL();
      Toast.show("تم تحميل صورة ", context,
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
        createRecord(audiourl,urlList);
      }
    }
    setState(() {
      _load1 = true;
    });

  }
  void createRecord(audiourl,urlList) {
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
      Firestore.instance.collection('advertisments').document();
      documentReference.setData({
        //'timestamp': FieldValue.serverTimestamp(), to arrange data using orderby

        'carrange': arrange,
        'advid': documentReference.documentID,
        'userId': _userId,
        'cdate': date1,
        'cdiscribtion': discController.text,
        'cbody': bodyController.text,
        'cpublished': false,
        'curi': urlList[0],
        'cimagelist': urlList.toString(),
        'caudiourl': audiourl,
        'pphone': _cMobile,
        'pname': _cName,

        'cproblemtype':_probtypecurrentItemSelected,

        'ccar':model1,
        'ccarversion':model2,
        'cmodel':_indyearcurrentItemSelected,

        'mfault':faultoutput.toString(),
        'subfault':faultoutputsub.toString(),
        'mfaultarray':faultoutput,
        'subfaultarray':faultoutputsub,
        'sparepart':"",

        'ctitle': titleController.text,
        // 'fromPLat': fromPlaceLat,
        // 'fromPLng': fromPlaceLng,
        // 'fPlaceName':fPlaceName,
        'cNew':  _probtypecurrentItemSelected==proplemtype[1]
            ? _character4.toString().contains("used")
            ? "مستعملة"
            : _character4.toString().contains("New")
            ? "جديدة"
            : "جديدة/مستعملة"
            : null,

      }).whenComplete(() {
        setState(() {
          // _load2 = false;
          urlList.clear();
          images.clear();
          song=null;
          titleController.text = "";
          discController.text = "";
          bodyController.text = "";
          // _sparecurrentItemSelected = widget.probtype0=="قطع غيار"?widget.selecteditem0:widget.sparepartsList[0];
          // _probtypecurrentItemSelected=widget.probtype0=="قطع غيار"?widget.probtype0:proplemtype[0];
          _indyearcurrentItemSelected=indyearlist[0];
          model1=null;model2="...";fault1=null;fault2=null;
          _value = 0;
        //  fromPlaceLat=null; fromPlaceLng=null; fPlaceName =null;
          _load1 = false;
          fault1="";
          faultid="";
           fault_s_apear = false;
           spare_s_apear = false;

          faultoutput.clear();
          faultoutputsub.clear();
          _init();
        });
      });

    }));
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

  void _onDropDownItemSelectedproblem(String newValueSelected) {
    setState(() {
      this._probtypecurrentItemSelected = newValueSelected;
      faultoutput.clear();
      faultoutputsub.clear();
       fault_s_apear = false;
       spare_s_apear = false;

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



  void onSubmit3(String result) {
    setState(() {
      model1 = result.split(",")[0];
      model2 = result.split(",")[1];
      Toast.show(
          "${result.split(",")[0]}///////${result.split(",")[1]}", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    });
  }
  void onSubmit4(List<OutputClass> result) {
    setState(() {
      //result.clear();
      for(int i = 0; i < result.length; i++){
        // setState(() {
        fault1 = fault1+","+result[i].title;
        fault2 = fault2+","+result[i].subtitle;
        // });
        print("${result[i].title}///////${result[i].subtitle}");
      }
      // fault1 = result.split(",")[0];
      // fault2 = result.split(",")[1];
      Toast.show(
          "$fault1///////${fault2}", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      result.clear();

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
        _value= double.parse(_current?.duration.inSeconds.toString())??0.0;

        if (_currentStatus == RecordingStatus.Stopped) {
          t.cancel();
        }
        if (double.parse(_current?.duration.inSeconds.toString()) > 60) {
          //t.cancel();
          _stop();
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
          icon=Icons.record_voice_over;

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
          icon=Icons.play_arrow;

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
      setState(() {
        _load1 = true;
      });
      Toast.show("تم تحميل التسجيل الصوتى", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
      uploadpp0(url2);
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
////////////////////////////////

//////////////////////////////////
typedef void MyFormCallback4(List<OutputClass> result);
class MyForm4 extends StatefulWidget {
  final MyFormCallback4 onSubmit4;
  List<FaultStringClass> faultsList = [];
  String selecteditem,mainitem;
  MyForm4(this.faultsList,this.selecteditem,this.mainitem,{this.onSubmit4});
  @override
  _MyForm4State createState() => _MyForm4State();
}
class _MyForm4State extends State<MyForm4> {
  String _currentValuesub = '';
  String _currentValuem = '';
  bool _isChecked= false;
  List<ModelClass> modelList = [];
  List<AClass> aList = [];
  List<OutputClass> outputList = [];

  List<bool> checlist = [];
  @override
  void initState() {
    super.initState();
    outputList.clear();
    _currentValuesub = widget.selecteditem;
    _currentValuem=widget.mainitem;
    if (widget.mainitem==""||widget.selecteditem==""){}else{ outputList.add(OutputClass(widget.mainitem,widget.selecteditem));}
    for(int i = 0; i < widget.faultsList.length; i++){
      // checlist.clear();
      // for(int n = 0; n < widget.faultsList[i].subtitle.split(",").length; n++){
      //   if (widget.faultsList[i].subtitle.split(",")[n]==_currentValue){
      //     print("rrrrrr"+widget.faultsList[i].subtitle.split(",")[n]+"1"+_currentValue);
      //       checlist.add(true);
      //   }else{
      //       checlist.add(false);
      //
      //     print("rrrrrr"+widget.faultsList[i].subtitle.split(",")[n]+"0"+_currentValue);
      //
      //   }
      // }
      setState(() {
        print("rrrrrrr"+checlist.toString());
        aList.add(AClass(i,
            widget.faultsList[i].title,
            widget.faultsList[i].subtitle.split(","),
            //checlist
            // List.filled(widget.faultsList[i].subtitle.split(",").length, false),
            List<bool>.generate(widget.faultsList[i].subtitle.split(",").length,
                    (k) => widget.faultsList[i].subtitle.split(",")[k]==_currentValuesub)

        ));
      });


    }
    // modelList = widget.faultsList;
  }
  @override
  Widget build(BuildContext context) {

    return  Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff171732),
        centerTitle:true ,
        title: Text(
          "اختر العطل",
          style: TextStyle(fontWeight: FontWeight.bold),
          textDirection: TextDirection.rtl,
        ),

      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top:18.0),
            child: ListView.builder(
              itemCount:aList.length,
              itemBuilder: (context, i) {
                if(  aList[i].subtitle.contains(widget.selecteditem)){
                  //_currentValuem=aList[i].title;
                  // print(_currentValuem+"ppp");
                  // widget.onSubmit4(_currentValue1.toString() + "," + _currentValue.toString());
                  //   subcheck.clear();
                  // subcheck = List.filled(widget.faultsList[i].subtitle.split(",").length, false);
                }
                return new ExpansionTile(
                  title: new Text(
                    aList[i].title,
                    style: new TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic),
                  ),
                  children: <Widget>[
                    Column(
                      // padding: EdgeInsets.all(8.0),widget.faultsList[i].subtitle.substring(0, widget.faultsList[i].subtitle.length() - 1)
                        children:  List.generate( aList[i].subtitle.length, (j) => aList[i].subtitle[j]==""||aList[i].subtitle[j].length==0?Container(): CheckboxListTile(
                          //  groupValue: _currentValue,
                          title: Text(
                            aList[i].subtitle[j],
                            textDirection: TextDirection.rtl,
                          ),
                          //  value: value,
                          value: aList[i].checklist[j],

                          onChanged: (val) {
                            setState(() {
                              aList[i].checklist[j]=val;
                            });
                            if(val){
                              setState(() {
                                outputList.add(OutputClass(aList[i].title,aList[i].subtitle[j]));
                                print("hhh${outputList.length}//"+aList[i].title+aList[i].subtitle[j]);
                                // _currentValuesub=aList[i].subtitle[j];
                                //   _currentValuem =aList[i].title;
                              });
                            }else{
                              outputList.removeWhere((item) => item.subtitle == aList[i].subtitle[j]);
                              print("hhh${outputList.length}//"+aList[i].title+aList[i].subtitle[j]);

                            }
                          },
                        ))),

                    // widget.faultsList[i].subtitle.split(",")
                    //     .mapIndexed((value,i) =>value==""?Container(): CheckboxListTile(
                    // //  groupValue: _currentValue,
                    //   title: Text(
                    //     value,
                    //     textDirection: TextDirection.rtl,
                    //   ),
                    // //  value: value,
                    //   value: false,
                    //
                    //   onChanged: (val) {
                    //     setState(() {
                    //       debugPrint('VAL = $val');
                    //       _isChecked = val;
                    //       _currentValue1 =  widget.faultsList[i].title;
                    //       });
                    //   },
                    // ))
                    //     .toList(),
                    //  ),
//              new Column(
//                children:
//                _buildExpandableContent(regionlist[i]),
//              ),
                  ],
                );
              },
            ),
          ),
          Positioned(
            bottom: 5,

            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment:MainAxisAlignment.spaceBetween ,
              children: <Widget>[
                RaisedButton(
                  onPressed: () {
                    widget.onSubmit4(outputList/**_currentValuem.toString() + "," + _currentValuesub.toString()**/);
                    Navigator.pop(context);

                  },
                  child: const Text('حفظ', style: TextStyle(fontSize: 20)),
                ),
                SizedBox(width: 10,),
                RaisedButton(
                  onPressed: () {
                    Navigator.pop(context);

                  },
                  child: const Text("الغاء", style: TextStyle(fontSize: 20)),
                ),
              ],
            ),
          )

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
