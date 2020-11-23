
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:priceme/Splash.dart';
import 'package:priceme/classes/AdvClass.dart';
import 'package:priceme/screens/editadv.dart';
import 'package:toast/toast.dart';

import 'advdetail.dart';

class Advertisements extends StatefulWidget {
  List<String> mainfaultsList = [];
  List<String> mainsparsList = [];
  Advertisements(this.mainsparsList,this.mainfaultsList);
  @override
  _AdvertisementsState createState() => _AdvertisementsState();
}

class _AdvertisementsState extends State<Advertisements> {
  List<AdvClass> advlist = [];
  bool _load = false;
  String _userId="";
  List<String> _imageUrls;
  bool chechsearch=false;
  List<String> typelist =  ["الكل","اعطال","قطع غيار"];
  var _typecurrentItemSelected = '';
  String searchtype;
  var _sparecurrentItemSelected = '';
  String searchspare;
   var _faultcurrentItemSelected = '';
  var _monthcurrentItemSelected="";
  List<String> monthlist = [];
  List<String>  monthNames = ["يناير", "فبراير", "مارس", "ابريل", "مايو", "يونيو",
    "يوليو", "اغسطس", "سبتمبر", "اكتوبر", "نوفمبر", "ديسمبر"
  ];
  int searchmonth=300000000000;
  String filtter;
  TextEditingController searchcontroller = TextEditingController();
  @override
  void initState() {
    super.initState();
    _typecurrentItemSelected=typelist[0];
    _sparecurrentItemSelected=widget.mainsparsList[0];
    _faultcurrentItemSelected=widget.mainfaultsList[0];
    DateTime now = DateTime.now();
    monthlist=new List<String>.generate(11, (i) =>monthNames[now.month-1 -i]);
    // monthlist=new List<String>.generate(13, (i) {
    //   int newDate = new DateTime(now.year, now.month - i, now.day).month;
    //
    //   DateTime.now().subtract(new Duration(seconds: 10));
    // });

  //  monthlist[0]=("الكل");
    _monthcurrentItemSelected=monthlist[0];

    FirebaseAuth.instance.currentUser().then((user) => user == null
        ? setState(() {})
        : setState(() {_userId = user.uid;}));
  }

  final double _minimumPadding = 5.0;
  var _controller = ScrollController();


  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    Widget loadingIndicator = _load
        ? new Container(
      child: SpinKitCircle(color: Colors.black),
    )
        : new Container();
    TextStyle textStyle = Theme.of(context).textTheme.subtitle;
    return Scaffold(
      backgroundColor: const Color(0xffffffff),
      floatingActionButton:  FloatingActionButton(
        heroTag: "uniqu03",
        child: Container(
          width: 50,
          height: 50,
          child: Icon(
            Icons.search,
//                size: 40,
          ),
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  const Color(0xffff2121),
                  const Color(0xffff5423),
                  const Color(0xffff7024),
                  const Color(0xffff904a)
                ],
              )),
        ),
        onPressed: () {
          setState(() {
            chechsearch=!chechsearch;
          });
        },
      ),
      body:
      ListView(
        children: [
          chechsearch?   Column(
            children: [
              Container(
                height: 50,
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    height: 35,
                    margin: EdgeInsets.only(right: 15, left: 15),
                    child: Row(
                      children: <Widget>[
                        Container(
                          height: 40,
                          child: IconButton(
                            icon: Icon(Icons.refresh),
                            tooltip: 'إعاده تهيأة البحث',
                            onPressed: () {
                               searchtype=null;
                               searchspare=null;
                               filtter=null;
                                searchmonth=300000000000;
                               List<String> typelist =  ["الكل","اعطال","قطع غيار"];
                                _typecurrentItemSelected = typelist[0];
                                _sparecurrentItemSelected = widget.mainsparsList[0];
                                _faultcurrentItemSelected = widget.mainfaultsList[0];
                              },
                          ),
                        ),
                        Flexible(
                          child: Container(
                            // width: 210,
                            height: 30,
                            margin: EdgeInsets.only(left: 2),
                            decoration: BoxDecoration(
                              color: Color.fromARGB(97, 248, 248, 248),
                              border: Border.all(
                                width: 1,
                                color: Color.fromARGB(97, 216, 216, 216),
                              ),
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                            ),

                            child: Container(
                                height: 13,
                                child: Directionality(
                                  textDirection: TextDirection.rtl,
                                  child: TextField(
                                    style: TextStyle(color: Colors.black),
                                    onChanged: (value) {
                                      setState(() {
                                        filtter = value;

                                      });
                                    },
                                    controller: searchcontroller,
                                    // focusNode: focus,
                                    decoration: InputDecoration(
                                      labelText: searchcontroller.text.isEmpty
                                          ? "بحث بالعنوان"
                                          : '',
                                      labelStyle: TextStyle(
                                          color: Colors.black, fontSize: 18.0),
                                      prefixIcon: Icon(
                                        Icons.search,
                                        color: Colors.black,
                                      ),
                                      suffixIcon: searchcontroller.text.isNotEmpty
                                          ? IconButton(
                                        icon: Icon(Icons.cancel,
                                            color: Colors.black),
                                        onPressed: () {
                                          setState(() {
                                            searchcontroller.clear();

                                            setState(() {
                                              filtter = null;

                                            });
                                          });
                                        },
                                      )
                                          : null,
                                      errorStyle: TextStyle(color: Colors.blue),
                                      enabled: true,
                                      alignLabelWithHint: true,
                                    ),
                                  ),
                                )),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    height: 50,width: 150,
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
                                items: typelist
                                    .map((String value) {
                                  return new DropdownMenuItem<String>(
                                    value: value,
                                    child: new Text(value),
                                  );
                                }).toList(),
                                value: _typecurrentItemSelected,
                                onChanged: (String newValueSelected) {
                                  // Your code to execute, when a menu item is selected from dropdown
                                  _onDropDownItemSelectetype(
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
                   _typecurrentItemSelected==typelist[1]?
                  Container(
                    height: 50,width: 150,
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
                                items: widget.mainfaultsList
                                    .map((String value) {
                                  return new DropdownMenuItem<String>(
                                    value: value,
                                    child: new Text(value),
                                  );
                                }).toList(),
                                value:_sparecurrentItemSelected,
                                onChanged: (String newValueSelected) {
                                  // Your code to execute, when a menu item is selected from dropdown
                                  _onDropDownItemSelectefault(
                                      newValueSelected);
                                },
                                style: new TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                            )),
                      ),
                    ),
                  ):Container(),

                  _typecurrentItemSelected==typelist[2]?
                  Container(
                    height: 50,width: 150,
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
                                items: widget.mainsparsList
                                    .map((String value) {
                                  return new DropdownMenuItem<String>(
                                    value: value,
                                    child: new Text(value),
                                  );
                                }).toList(),
                                value:_sparecurrentItemSelected,
                                onChanged: (String newValueSelected) {
                                  // Your code to execute, when a menu item is selected from dropdown
                                  _onDropDownItemSelectespare(
                                      newValueSelected);
                                },
                                style: new TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                            )),
                      ),
                    ),
                  ) :Container(),

                ],
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
                          items: monthlist.map((String value) {
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
                          value: _monthcurrentItemSelected,
                          onChanged: (String newValueSelected) {
                            // Your code to execute, when a menu item is selected from dropdown
                            _onDropDownItemSelectedmonth(
                                newValueSelected);
                          },
                        ),
                      )),
                ),
              ),

            ],
          ):Container(),

          Container(
            width: width,
            height: height,
            child: StreamBuilder(
              stream: Firestore.instance.collection('advertisments').orderBy('carrange', descending: true)
                  .where("cproblemtype", isEqualTo:searchtype)
                  .where("mfaultarray", arrayContains: searchspare)
                  .where("ctitle", isEqualTo:filtter)
                  .where("carrange", isLessThanOrEqualTo:searchmonth)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.data?.documents == null || !snapshot.hasData)
                  return Center(child: Text("لا يوجد بيانات...",));
                return Container(
                  child: ListView(
                    shrinkWrap: true,
                    children: <Widget>[
                      Container(
                          padding: EdgeInsets.all(10),
                          child: SingleChildScrollView(
                            child: GridView.builder(
                              physics: ScrollPhysics(),
                              shrinkWrap: true,
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 6,
                                childAspectRatio: MediaQuery.of(context).size.width /
                                    (MediaQuery.of(context).size.height*1),
                              ),
                              itemCount:snapshot.data.documents.length,
                              itemBuilder: (BuildContext context, int index) {
                                return  firebasedata(context,index, snapshot.data.documents[index]);
                              },
                            ),
                          ))
                    ],
                  ),
                );

              },
            ),
          ),
        ],
      ),

    );
  }

  Widget firebasedata(BuildContext context,int index, DocumentSnapshot document) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Card(
        shape: new RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4.0)),
        //borderOnForeground: true,
        elevation: 10.0,
        margin: EdgeInsets.only(right: 1, left: 1, bottom: 2),
        child: InkWell(
          onTap: () {

            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        AdvDetail(document['userId'], document['advid'])));



          },
          child: Container(
           // height: 1000,
              child: Column(
                children: <Widget>[
                  Stack(
                    children: [
                      Container(
                        height: 200,
                      child:  document['curi'] == null
                            ? new Image.asset("assets/images/ic_logo2.png",
                        )
                            : new Image.network(
                          document['curi'],
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        top: 0,
                        right: 0,
                        child: Container(
                            width: 100,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(2.0),
                              color:Colors.black54,
                            ),
                            child:  Padding(
                              padding: const EdgeInsets.only(right: 5),
                              child: Text(
                                "منذ: ${ document['cdate'].toString()}",
                                textDirection: TextDirection.rtl,
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
//                                  fontFamily: 'Estedad-Black',
                                    fontStyle: FontStyle.normal),
                              ),
                            )

                        ),
                      ),
                      Positioned(
                        top: 0,
                        left: 0,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(2.0),
                            color:const Color(0xff444460),
                          ),
                          child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child:  Text(
                                document['cproblemtype'].toString(),
                                textDirection: TextDirection.rtl,
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
//                                          fontFamily: 'Estedad-Black',
                                    fontStyle: FontStyle.normal),
                              )
                          ),

                        ),
                      ),

                    ],
                  ),

                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text(
                      document['ctitle'].toString(),
                      textDirection: TextDirection.rtl,
                      textAlign: TextAlign.right,
                      style: TextStyle(
                          color: Colors.green,
//                                  fontFamily: 'Estedad-Black',
                          fontWeight: FontWeight.bold,
                          fontSize: 15.0,
                          fontStyle: FontStyle.normal),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[


                     Text(
                        "${document['subfault']}",
                        textDirection: TextDirection.rtl,
                        textAlign: TextAlign.right,
                        style: TextStyle(
//                                      fontFamily: 'Estedad-Black',
                            fontSize: 10.0,
                            fontStyle: FontStyle.normal),
                      ),
                      new Icon(
                        Icons.directions_car,
                        color: Colors.black,
                        size: 15,
                      ),
                    ],
                  ),
                ],
              )),
        ),
      ),
    );
  }
  void _onDropDownItemSelectetype(String newValueSelected) {
    setState(() {
      this._typecurrentItemSelected = newValueSelected;
      if(newValueSelected=="الكل"){
        searchtype=null;
      }else{
        searchtype=newValueSelected;

      }

    });
  }
  void _onDropDownItemSelectespare(String newValueSelected) {
    setState(() {
      this._sparecurrentItemSelected = newValueSelected;
      if(newValueSelected=="الكل"){
        searchspare=null;
      }else{
        searchspare=newValueSelected;

      }

    });
  }
  void _onDropDownItemSelectefault(String newValueSelected) {
    setState(() {
      this._faultcurrentItemSelected = newValueSelected;
      if(newValueSelected=="الكل"){
        searchspare=null;
      }else{
        searchspare=newValueSelected;

      }

    });
  }
  void _onDropDownItemSelectedmonth(String newValueSelected) {
    setState(() {
      this._monthcurrentItemSelected = newValueSelected;
      if(newValueSelected=="الكل"){
        searchmonth=300000000000;
      }else{
        //'${now.year}${b}${c}${d}${e}'

        searchmonth= ((DateTime.now().year*100)+(monthNames.indexOf(newValueSelected)+2))*1000000;
       // searchmonth=monthNames.indexOf(newValueSelected)+1;
      }
      print("vvv$searchmonth");
    });
  }
}
