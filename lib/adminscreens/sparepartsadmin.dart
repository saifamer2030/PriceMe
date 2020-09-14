import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:priceme/adminscreens/subsparesadmin.dart';
import 'package:priceme/classes/SparePartsClass.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:toast/toast.dart';

import 'subfaultadmin.dart';

class SparePartsAdmin extends StatefulWidget {
  SparePartsAdmin();

  @override
  _SparePartsAdminState createState() => _SparePartsAdminState();
}

class _SparePartsAdminState extends State<SparePartsAdmin> {
  List<SparePartsClass> sparepartsList = [];
  var _controller = ScrollController();
  TextEditingController _spareNameController = TextEditingController();
  List<Asset> images = List<Asset>();
  String _error = 'No Error Dectected';
  var _formKey = GlobalKey<FormState>();
  bool editcheck=false;
  bool isLoaded = true;
  final SparePartsReference = Firestore.instance;
  String url,id;
  var i;
  bool _load2 = false;
  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    Widget loadingIndicator = _load2
        ? new Container( child: SpinKitCircle(
        color: const Color(0xff171732),
      ),
    ): new Container();
    return Scaffold(

        body: sparepartssScreen(loadingIndicator));
  }

///////////********* Design *****////////////////////////////
  Widget sparepartssScreen(loadingIndicator) {
    return Stack(
      children: [
        Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              Flexible(
                child: isLoaded
                    ? sparepartsList.length == 0
                        ? Center(child: Text("لا يوجد قطع غيار"))
                        : listView()
                    : Center(
                        child: SpinKitFadingCircle(
                          itemBuilder: (_, int index) {
                            return DecoratedBox(
                              decoration: BoxDecoration(
                                  color:
                                      index.isEven ? Colors.orange : Colors.white),
                            );
                          },
                        ),
                      ),
              ),
              Padding(
                  padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
                  child: Directionality(
                      textDirection: TextDirection.rtl,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: Container(
                            alignment: Alignment.center,
                            child: Text(
                              "إضافة قطعة غيار جديدة",
                              textScaleFactor: 1.5,
                            )),
                      ))),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 18.0),
                    child: IconButton(
                      icon: Icon(
                        Icons.image,
                        size: 50,
                      ),
                      color: Colors.orange,
                      onPressed: () {
                        loadAssets();
                      },
                    ),
                  ),
                  Flexible(
                    child: Container(
                      child: Directionality(
                        textDirection: TextDirection.rtl,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                          child: TextFormField(
                            textAlign: TextAlign.right,
                            keyboardType: TextInputType.text,
                            textDirection: TextDirection.rtl,
                            controller: _spareNameController,
                            validator: (String value) {
                              if (value.isEmpty) {
                                return 'الرجاء إدخال أسم قطعة الغيار';
                              }
                            },
                            decoration: InputDecoration(
                                labelText: "اسم قطعة الغيار",
                                errorStyle:
                                    TextStyle(color: Colors.red, fontSize: 15.0),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.0))),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 5.0, right: 5.0, bottom: 3),
                child: RaisedButton(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      editcheck?Text("تعديل"):Text("إضافة"),
                      SizedBox(
                        height: 8.0,
                        width: 8.0,
                      ),
                      Icon(
                        Icons.check,
                        color: Colors.white,
                      ),
                    ],
                  ),
                  textColor: Colors.white,
                  color: const Color(0xff171732),
                  onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      try {
                        final result = await InternetAddress.lookup('google.com');
                        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {

                          if(editcheck){uploadpp0();
                          setState(() {
                            _load2 = true;
                          });
                          }else{

                            if(images.length==0){
                              Toast.show("برجاء إضافة صورة", context,
                                  duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                            }else{ uploadpp0();
                            setState(() {
                              _load2 = true;
                            });
                            }
                          }

                        }
                      } on SocketException catch (_) {
                        //  print('not connected');
                        Toast.show("برجاء مراجعة الاتصال بالشبكة", context,
                            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                      }
                      //loginUserphone(_phoneController.text.trim(), context);

                    } else
                      print('correct');
                  },
//
                  shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(10.0)),
                ),
              ),
            ],
          ),
        ),
        new Align(
          child: loadingIndicator,
          alignment: FractionalOffset.center,
        ),
      ],
    );
  }

  Widget listView() {
    return Column(
      children: <Widget>[
        Expanded(
            child: new ListView.builder(
                physics: BouncingScrollPhysics(),
                controller: _controller,
                itemCount: sparepartsList.length,
                itemBuilder: (BuildContext ctxt, int index) {
                  return Slidable(
                    actionPane: SlidableDrawerDismissal(),
                    child: firebasedata(
                      index,
                    ),
                    actions: <Widget>[
                      Container(
                        padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                        child: IconSlideAction(
                          caption: 'تعديل',
                          color: Colors.green,
                          icon: Icons.edit,
                          onTap: () {
                            setState(() {
                              _spareNameController.text=sparepartsList[index].sName;
                             url=sparepartsList[index].surl;
                             id=sparepartsList[index].sid;
                             editcheck=true;
                             i=index;
                              //updatedata(sparepartsList[index].sid,url);

                            });
                          },
                        ),
                      )
                    ],
                    secondaryActions: <Widget>[
                      Container(
                          padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                          child: IconSlideAction(
                            caption: 'Delete',
                            color: Colors.red,
                            icon: Icons.delete,
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) =>
                                    new CupertinoAlertDialog(
                                  title: new Text("تنبية"),
                                  content: new Text("تبغي تحذف القسم؟"),
                                  actions: [
                                    CupertinoDialogAction(
                                        isDefaultAction: false,
                                        child: new FlatButton(
                                          onPressed: () {
                                            print("kkk${sparepartsList[index].sid}");
                                            setState(() {
                                              Firestore.instance
                                                  .collection("spareparts")
                                                  .document(
                                                      sparepartsList[index].sid)
                                                  .delete()
                                                  .whenComplete(() =>
                                                      Toast.show(
                                                          "تم الحذف",
                                                          context,
                                                          duration: Toast
                                                              .LENGTH_SHORT,
                                                          gravity:
                                                              Toast.BOTTOM));
                                              setState(() {
                                                sparepartsList.removeAt(index);

                                              });
                                              setState(() async {
                                                Navigator.pop(context);

                                                final StorageReference
                                                    storageRef =
                                                    await FirebaseStorage
                                                        .instance
                                                        .getReferenceFromUrl(
                                                            sparepartsList[
                                                                    index]
                                                                .surl);
                                                //   print("hhhhhhhhhhhhhhh${storageRef.path}");
                                                await storageRef
                                                    .delete()
                                                    .whenComplete(() {
                                                  // print("hhhhhhhhhhhhhhh$imge");
                                                });
                                              });
                                            });
                                          },
                                          child: Text("موافق"),
                                        )),
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
                          )),
                    ],
                  );
                })),
      ],
    );
  }

  Widget firebasedata(var index) {
    return InkWell(
      onTap: (){
        // print("kkk"+sparepartsList[index].sName+"///"+sparepartsList[index].sid+"////"+sparepartsList[index].surl);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => SubSparesAdmin(sparepartsList[index].sid,sparepartsList[index].sName,sparepartsList[index].surl)));
      },
      child: Card(
        elevation: 10,
        shape:
            new RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
        margin: EdgeInsets.all(6),
        child: ListTile(
          title: Text(
            sparepartsList[index].sName,
            textDirection: TextDirection.rtl,
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          ),

          trailing: Container(
            height: 120.0,
            width: 60.0,
            decoration: BoxDecoration(

              image: DecorationImage(
                image: NetworkImage(sparepartsList[index].surl),
                fit: BoxFit.fill,
              ),

              shape: BoxShape.circle,
            ),
          ),

        ),
      ),
    );

//      Column(
//      children: <Widget>[
//        Card(
//          elevation: 10,
//          shape: new RoundedRectangleBorder(
//              borderRadius: BorderRadius.circular(4.0)),
//          margin: EdgeInsets.all(6),
//          child: Padding(
//            padding: const EdgeInsets.all(0.0),
//            child: Container(
//              width: 3500,
//              child: Column(
//                crossAxisAlignment: CrossAxisAlignment.end,
//                children: <Widget>[
//                  Container(
//                    height: 50,
//                    width: 3000,
//                    padding: EdgeInsets.all(5),
//                    color: Colors.grey[500].withOpacity(0.6),
//                    child: Padding(
//                      padding: const EdgeInsets.all(8.0),
//                      child: Row(
//                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                        children: <Widget>[
//                          FlatButton(
//                            onPressed: () {
//                             setState(() {
//                               //showAlertDialog(context,employersList[index].kId,index);
//                             });
//                            },
//                            child: Text(
//                              "حذف", style: TextStyle(color: Colors.red,
//                                ),textDirection: TextDirection.ltr,
//
//                            ),
//                          ),
//                          Text(
//                            sparepartsList[index].sName,
//                            style: TextStyle(
//                                fontSize: 20, fontWeight: FontWeight.bold),textDirection: TextDirection.rtl,
//                          ),
//
//                        ],
//                      ),
//                    ),
//                  ),
//                  Container(
//                    width: 3000,
//                    color: Colors.grey[500].withOpacity(0.3),
//                    child: Padding(
//                      padding: const EdgeInsets.all(8.0),
//                      child: Row(
//                        children: <Widget>[
//                          FlatButton(
//                            onPressed: () {
////                              Navigator.push(
////                                context,
////                                MaterialPageRoute(builder: (context) => EditEmployee(employersList,index)),
////                              );
//                            },
//                            child: Text(
//                              "تعديل", style: TextStyle(color: Colors.green,
//                            ),textDirection: TextDirection.ltr,
//
//                            ),
//                          ),
//                          Expanded(
//                            child: Text(
//                              sparepartsList[index].surl,textDirection: TextDirection.rtl,
//                              style: TextStyle(
//                                color: Colors.black,
//                              ),
//                            ),
//                          ),
//                        ],
//                      ),
//                    ),
//                  ),
//                ],
//              ),
//            ),
//          ),
//        ),
//      ],
//    );
  }

  void getData() {
    setState(() {
      SparePartsReference.collection("spareparts")
          .getDocuments()
          .then((QuerySnapshot snapshot) {
        snapshot.documents.forEach((sparepart) {
          SparePartsClass spc = SparePartsClass(
            sparepart.data['sid'],
            sparepart.data['sName'],
            sparepart.data['surl'],
          );
          setState(() {
            sparepartsList.add(spc);
            print(sparepartsList.length.toString() + "llll");
          });
        });
      }).timeout(Duration(seconds: 20), onTimeout: () {
        setState(() {
          isLoaded = true;
        });
      });
    });

  }

  Future<void> loadAssets() async {
    List<Asset> resultList = List<Asset>();
    String error = 'No Error Dectected';

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 1,
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

  Future uploadpp0() async {
    setState(() {
      _load2 = true;
    });
if(images.length==0){updatedata(url);}else {
  final StorageReference storageRef =
  FirebaseStorage.instance.ref().child('myimage');
  int i = 0;
  for (var f in images) {
    var byteData = await f.getByteData(quality: 50);

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
      url = Imageurl.toString();

      i++;
      // _load2 = false;
    });
    if (i == images.length) {
      // print('gggg${images.length} ///$i');
      editcheck ? updatedata(url) : createRecord(Imageurl.toString());
    }
  }
}
  }

  void createRecord(urlList) {
    DocumentReference documentReference =
        Firestore.instance.collection('spareparts').document();
    documentReference.setData({
      'sName': _spareNameController.text,
      'surl': urlList,
      'sid': documentReference.documentID
    }).whenComplete((){
      setState(() {
        sparepartsList.add(new SparePartsClass(
          documentReference.documentID,
          _spareNameController.text,
          urlList,
        ));
        _spareNameController.text="";
        images.clear();
        editcheck=false;
        url=null;id=null;i=null;
      });
      setState(() {
        _load2 = false;
      });
    });
  }


  void updatedata(url) {
        Firestore.instance.collection('spareparts')
        .document(id)
        .updateData({
      'sName': _spareNameController.text,
      'surl': url,
      'sid': id
        }).whenComplete(() {
          setState(() {
            sparepartsList[i].surl=url;
            sparepartsList[i].sName=_spareNameController.text;
            sparepartsList[i].sid=id;

            _spareNameController.text="";
            images.clear();
            editcheck=false;
            url=null;id=null;i=null;
              _load2 = false;
          });

        });

  }


}
