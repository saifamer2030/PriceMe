
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
import 'package:priceme/screens/myadvertisement.dart';
import 'package:priceme/screens/network_connection.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:io' as io;

import 'package:toast/toast.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:math' as Math;

import '../Splash.dart';

class EditAdv extends StatefulWidget{


int index,length,carrange;
String advid,cNew,caudiourl,cbody,ccar,ccarversion,cdate,cdiscribtion,cimagelist,cmodel,cproblemtype,
    ctitle,curi,mfault,pname,pphone,sparepart,subfault,userId;

  final LocalFileSystem localFileSystem;

EditAdv(
      this.index,
      this.length,
      this.carrange,
      this.advid,
      this.cNew,
      this.caudiourl,
      this.cbody,
      this.ccar,
      this.ccarversion,
      this.cdate,
      this.cdiscribtion,
      this.cimagelist,
      this.cmodel,
      this.cproblemtype,
      this.ctitle,
      this.curi,
      this.mfault,
      this.pname,
      this.pphone,
      this.sparepart,
      this.subfault,
      this.userId,
       {localFileSystem}) : this.localFileSystem = localFileSystem ?? LocalFileSystem();

  @override
  _EditAdvState createState() => _EditAdvState();
}
enum SingingCharacter4 { used, New, NO }

class _EditAdvState extends State<EditAdv> {
  bool fault_s_apear = false;
  bool spare_s_apear = false;
  List<FaultsClass> subfaultsList = [];
  List<FaultsClass> subsparesList = [];
 String faultid="";
  List<SparePartsClass> mainfaultsList = [];
  List<SparePartsClass> mainsparsList = [];

  List<String> faultoutput= [];
  List<String> faultoutputsub= [];

  bool _load1 = false;
  String url1;
  String imagepathes = '';
  List<String> urlList = [];
  List<String> proplemtype = ["اعطال","قطع غيار"];
  List<String> indyearlist = [];
  List<bool> subcheckList = [];

  List<bool> subcheckList1 = [];

  List<FaultStringClass> sparesList = [];
  List<FaultStringClass> faultsList = [];

  String cNew;


  String subfault="";
  String subcheck="";

  String subfault1="";
  String subcheck1="";
  List<Asset> images = List<Asset>();
  String _error = 'No Error Dectected';
  var _formKey = GlobalKey<FormState>();
  LatLng fromPlace, toPlace ;
  //String fromPlaceLat , fromPlaceLng , fPlaceName ;
  Map <String , dynamic > sendData = Map();
  String model1;
  String model2;
  String fault1;
  String fault2;
double _value=0.0;
String _userId,audiourl;
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
            faultoutput.contains(sparepart.data['sName'])?const Color(0xff171732):const Color(0xff8C8C96),
            faultoutput.contains(sparepart.data['sName'])?true:false,
          );
          // const Color(0xff171732);
          setState(() {
            mainfaultsList.add(spc);
            if(widget.cproblemtype=="اعطال"){
            if(faultoutput.contains(sparepart.data['sName'])){
              faultid= sparepart.data['sid'];
            }}
          });
        });
      }).then((value) {getsubdatainitial();});
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
            faultoutput.contains(sparepart.data['sName'])?const Color(0xff171732):const Color(0xff8C8C96),
            faultoutput.contains(sparepart.data['sName'])?true:false,
          );


          setState(() {
            mainsparsList.add(spc);
            if(widget.cproblemtype=="قطع غيار"){
              if(faultoutput.contains(sparepart.data['sName'])){
                faultid= sparepart.data['sid'];
              }
            }

          });

        });
      }).then((value) {getsubdatainitial();});
    });

  }
  void getsubdatainitial(){
    print("vvv$faultid");

    if(_probtypecurrentItemSelected=="اعطال"&&faultid!=""){
      subfaultsList.clear();
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
            faultoutputsub.contains( fault.data['fsubName'])?const Color(0xff171732):const Color(0xff8C8C96),
            faultoutputsub.contains( fault.data['fsubName'])?true:false,
          );
          setState(() {
            subfaultsList.add(fp);
          });
        });
      }).whenComplete(() => setState((){ fault_s_apear = true;}));

    }else  if(_probtypecurrentItemSelected=="قطع غيار"&&faultid!=""){
      subsparesList.clear();
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
            faultoutputsub.contains( fault.data['fsubName'])?const Color(0xff171732):const Color(0xff8C8C96),
            faultoutputsub.contains( fault.data['fsubName'])?true:false,
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
    titleController = TextEditingController(text: widget.ctitle);
    bodyController = TextEditingController(text: widget.cbody);
    discController = TextEditingController(text: widget.cdiscribtion);
    cNew=widget.cNew;
    cNew= _character4.toString().contains("used")
        ? "مستعملة"
        : _character4.toString().contains("New")
        ? "جديدة"
        : "جديدة/مستعملة";
print("new:$cNew");
     _character4 =
     cNew=="مستعملة"? SingingCharacter4.used
         :cNew=="جديدة"? SingingCharacter4.New
         : cNew=="جديدة/مستعملة"?SingingCharacter4.NO
         :null;



    model1 = widget.ccar;
    model2 =widget.ccarversion;
    faultoutput=widget.mfault
        .replaceAll(" ", "")
        .replaceAll("[", "")
        .replaceAll("]", "")
        .split(",");
    faultoutputsub=widget.subfault
        .replaceAll(" ", "")
        .replaceAll("[", "")
        .replaceAll("]", "")
        .split(",");
    fault1=widget.mfault;
    fault2=widget.subfault;
    audiourl=widget.caudiourl;
    urlList =widget.cimagelist
        .replaceAll(" ", "")
        .replaceAll("[", "")
        .replaceAll("]", "")
        .split(",");

    DateTime now = DateTime.now();
    indyearlist=new List<String>.generate(50, (i) =>  NumberUtility.changeDigit((now.year+1 -i).toString(), NumStrLanguage.English));
    indyearlist[0]=("الموديل");
    _indyearcurrentItemSelected=widget.cmodel;
    _sparecurrentItemSelected=widget.sparepart;
    _probtypecurrentItemSelected=widget.cproblemtype=="قطع غيار"?widget.cproblemtype:proplemtype[0];
    // _sparecurrentItemSelected =  widget.probtype0=="قطع غيار"?widget.selecteditem0:widget.sparepartsList[0];

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

    getDataf();
    getDatas();
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
                                              faultoutputsub.contains( fault.data['fsubName'])?const Color(0xff171732):const Color(0xff8C8C96),
                                              faultoutputsub.contains( fault.data['fsubName'])?true:false,
                                            );
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
                                              faultoutputsub.contains( fault.data['fsubName'])?const Color(0xff171732):const Color(0xff8C8C96),
                                              faultoutputsub.contains( fault.data['fsubName'])?true:false,
                                            );
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
                      ),
                      // _probtypecurrentItemSelected==proplemtype[0]?SizedBox(
                      //   height: _minimumPadding,
                      //   width: _minimumPadding,
                      // ):Container(),
                      // _probtypecurrentItemSelected==proplemtype[0]?Container(
                      //   height: 40,
                      //   color: Colors.grey,
                      //   child: InkWell(
                      //     onTap: () {
                      //       Navigator.push(
                      //           context,
                      //           MaterialPageRoute(
                      //               builder: (context) => MyForm4(
                      //                   faultsList,widget.subfault,widget.mfault,
                      //                   onSubmit4: onSubmit4)));
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
                      //   padding: EdgeInsets.only(
                      //       top: _minimumPadding, bottom: _minimumPadding),
                      //   child: Container(
                      //     height: 40,
                      //     color: Colors.grey,
                      //     child: InkWell(
                      //       onTap: () {
                      //         Navigator.push(
                      //             context,
                      //             MaterialPageRoute(
                      //                 builder: (context) => MyForm4(
                      //                     sparesList,widget.subfault,widget.mfault,
                      //                     onSubmit4: onSubmit4)));
                      //
                      //       },
                      //       child: Card(
                      //         elevation: 0.0,
                      //         color: const Color(0xff171732),
                      //         shape: RoundedRectangleBorder(
                      //           borderRadius: BorderRadius.circular(5),
                      //         ),
                      //         child: Center(
                      //           child: Padding(
                      //             padding: const EdgeInsets.all(8.0),
                      //             child: Text(
                      //               "نوع قطع الغيار",
                      //               textDirection: TextDirection.rtl,
                      //               style: TextStyle(
                      //                   color: Colors.grey,
                      //                   fontSize: 12,
                      //                   fontWeight: FontWeight.bold),
                      //             ),
                      //           ),
                      //         ),
                      //       ),
                      //     ),
                      //   )
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
                            onTap:_init,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                width: 60,
                                height: 60,
                                child: Icon(
                                  Icons.cancel,
                                  color: Colors.red,
                                  size: 30,
                                ),
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color(0xFFe0f2f1)),
                              ),
                            ),
                          ),

                          InkWell(
                            onTap: _currentStatus != RecordingStatus.Unset ? _stop : null,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                width: 60,
                                height: 60,
                                child: Icon(Icons.backup,color: Colors.green, size: 30,),
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color(0xFFe0f2f1)),
                              ),
                            ),
                          ),

                        ],
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
                                "يرجى الضغط على الصورة لتحميل صور المشكلة",
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
                                color: images.length>0 ?Colors.green: Colors.red,
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
//                       Padding(
//                         padding: EdgeInsets.only(
//                             top: _minimumPadding * 5, bottom: _minimumPadding),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: <Widget>[
//                             InkWell(
//                               onTap: () async {
//                                 sendData = await Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                       builder: (context) =>
//                                           CurrentLocation2()),
//                                 );
//
//                                 // print("\n\n\n\n\n\n\nfromPlaceLng>>>>"+
//                                 //     fromPlaceLng+fPlaceName+"\n\n\n\n\n\n");
// setState(() {
//   fromPlace = sendData["loc_latLng"];
//   fromPlaceLat = fromPlace.latitude.toString();
//   fromPlaceLng = fromPlace.longitude.toString();
//   fPlaceName = sendData["loc_name"];
// });
//                               } ,
//                               child: Icon(
//                                 fromPlaceLat == null ? Icons.gps_fixed : Icons.check_circle
//                                     ,
//                                 color: Colors.purpleAccent,
//                                 size: 50,
//                               ),
//                             ),
//                             SizedBox(
//                               width: 10.0,
//                             ),
//                             Expanded(
//                               child: Text(
//                                 "يرجى الضغط على الصورة لتحديد موقع المحل",
//                                 textDirection: TextDirection.rtl,
//                                 style: TextStyle(
//                                     color: Colors.black,
//                                     fontSize: 15,
//                                     fontWeight: FontWeight.bold),
//                               ),
//                             ),
//                             Align(
//                               alignment: Alignment.topCenter,
//                               child: Icon(
//                                 Icons.star,
//                                 color: Colors.red,
//                                 size: 15,
//                               ),
//                             ),
//
//                           ],
//                         ),
//                       ),
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


                                    try {
                                      final result = await InternetAddress.lookup('google.com');
                                      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
                                        setState(() {
                                          _load1 = true;
                                        });
                                        if(song==null){uploadpp0();}else{uploadaudio();}



                                      }
                                    } on SocketException catch (_) {
                                      //  print('not connected');
                                       Toast.show("برجاء مراجعة الاتصال بالشبكة",context,duration: Toast.LENGTH_LONG,gravity:  Toast.BOTTOM);

                                    }//}

                                } else
                                  print('correct');
                              },
                              child: Center(
                                child: Text(
                                  'تعديل',
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
  Future uploadpp0() async {
    setState(() {
      _load1 = true;
    });
    if (images.length != 0) {
      urlList.clear();
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

    }else{
      if(urlList.length==0){
        Toast.show("برجاء أضافة صورة واحدة على الاقل", context,
            duration: Toast.LENGTH_SHORT,
            gravity: Toast.BOTTOM);
      }else{ createRecord(audiourl,urlList);}
    }

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

      Firestore.instance
          .collection('advertisments')
          .document(widget.advid)
          .updateData({
        'carrange': arrange,
        'advid': widget.advid,
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

        'ctitle': titleController.text,
        'mfaultarray':faultoutput,
        'subfaultarray':faultoutputsub,
        'sparepart':"",
        'cNew':  _probtypecurrentItemSelected==proplemtype[1]
            ? _character4.toString().contains("used")
            ? "مستعملة"
            : _character4.toString().contains("New")
            ? "جديدة"
            : "جديدة/مستعملة"
            : null,

      }).whenComplete(() {
        Navigator.push(
            context,
            new MaterialPageRoute(
                builder: (context) => MyAdvertisement()));
      });

    }));
  }


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
      faultid="";
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
  void onSubmit4(String result1,String result2) {
    setState(() {
      fault1=result1;
      fault2=result2;

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
        audiourl = Audiourl.toString();
    //  print("$_extension  mmm$url2");
      setState(() {
        _load1 = true;
      });
      Toast.show("تم تحميل التسجيل الصوتى", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
      uploadpp0();
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
typedef void MyFormCallback4(String result1,String result2);
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
   // if (widget.mainitem.substring(1).contains(",")||widget.selecteditem.contains(",")){
   //   List<String> mi=widget.mainitem.substring(1).split(",");
   //   List<String> si=widget.selecteditem.split(",");
   //   for(var j=0;j<mi.length;j++){
   //     outputList.add(OutputClass(mi[j],si[j]));
   //   }
   //
   // }else{ outputList.add(OutputClass(widget.mainitem,widget.selecteditem));}

    for(int i = 0; i < widget.faultsList.length; i++){

      setState(() {
        print("rrrrrrr"+checlist.toString());
        aList.add(AClass(i,
            widget.faultsList[i].title,
            widget.faultsList[i].subtitle.split(","),

            List<bool>.generate(widget.faultsList[i].subtitle.split(",").length,
                    (k) =>
                        _currentValuesub.contains(widget.faultsList[i].subtitle.split(",")[k]) )

        ));
      });


    }
    outputList.clear();
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
                     // outputList.add(OutputClass(aList[i].title,aList[i].subtitle[j]));
                      _currentValuesub = _currentValuesub+","+aList[i].subtitle[j];
                      _currentValuem=_currentValuem+","+aList[i].title[j];
                    });
                  }else{
                    _currentValuesub = _currentValuesub.replaceAll(aList[i].subtitle[j], "");
                    _currentValuem=_currentValuem.replaceFirst(aList[i].title[j], "");
                    // outputList.removeWhere((item) => item.subtitle == aList[i].subtitle[j]);
                    // print("hhh${outputList.length}//"+aList[i].title+aList[i].subtitle[j]);

                  }
                },
                ))),

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
                    widget.onSubmit4(_currentValuem,_currentValuesub);
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
