import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:priceme/classes/AdvClass.dart';
import 'package:priceme/screens/rentdetail.dart';
import 'package:priceme/screens/signin.dart';

import 'package:toast/toast.dart';

import 'advdetail.dart';
import 'offerdetail.dart';

class AllRents extends StatefulWidget {


  AllRents();

  @override
  _AllRentsState createState() => _AllRentsState();
}

class _AllRentsState extends State<AllRents> {
  List<AdvClass> advlist = [];
  bool _load = false;
  String _userId="";
  String  worktype="";
  String tradertype="";
  int _currentSliderValue1=200;
  double _currentSliderValue = 200;
  @override List<String> carlist = ["السيارة","هونداى","فيات","تويوتا"];
  var _carcurrentItemSelected = '';
  String filt;

  void initState() {
    super.initState();
    _carcurrentItemSelected=carlist[0];

    FirebaseAuth.instance.currentUser().then((user) => user == null
        ? Navigator.of(context, rootNavigator: false).push(MaterialPageRoute(
            builder: (context) => SignIn(), maintainState: false))
        : setState(() {
            _userId = user.uid;
            var userQuery = Firestore.instance
                .collection('users')
                .where('uid', isEqualTo: _userId)
                .limit(1);
            userQuery.getDocuments().then((data) {
              if (data.documents.length > 0) {
                setState(() {
                  // firstName = data.documents[0].data['firstName'];
                  // lastName = data.documents[0].data['lastName'];
                  // tradertype = data.documents[0].data['traderType'];
                  // worktype = data.documents[0].data['worktype'];
                  // tradertype=="تاجر صيانة"?tradertype="اعطال":tradertype="قطع غيار";
                  print("mmm" + worktype);
                });
              }
            });
          }));
  }

  final double _minimumPadding = 5.0;
  var _controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    Widget loadingIndicator = _load
        ? new Container(
            child: SpinKitCircle(color: Colors.black),
          )
        : new Container();
    TextStyle textStyle = Theme.of(context).textTheme.subtitle;
    return Scaffold(
      backgroundColor: const Color(0xffffffff),
      floatingActionButton: Container(
        height: 30.0,
        width: 30.0,
        child: FittedBox(
          child: FloatingActionButton(
            heroTag: "unique9",
            onPressed: () {
              _controller.animateTo(0.0,
                  curve: Curves.easeInOut, duration: Duration(seconds: 1));
            },
            backgroundColor: Colors.white,
            elevation: 20.0,
            child: Icon(
              Icons.arrow_drop_up,
              size: 50,
              color: const Color(0xff171732),
            ),
          ),
        ),
      ),
      body: ListView(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Slider(
                value: _currentSliderValue,
                min: 0,
                max: 200,
                divisions: 5,
                label: _currentSliderValue.round().toString(),
                onChanged: (double value) {
                  setState(() {
                    _currentSliderValue=value;
                    _currentSliderValue1 =int.parse(value.toStringAsFixed(0));

                  });
                },
              ),
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
                            items: carlist
                                .map((String value) {
                              return new DropdownMenuItem<String>(
                                value: value,
                                child: new Text(value),
                              );
                            }).toList(),
                            value: _carcurrentItemSelected,
                            onChanged: (String newValueSelected) {
                              // Your code to execute, when a menu item is selected from dropdown
                              _onDropDownItemSelectedcar(
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

            ],
          ),

          Container(
            child: StreamBuilder(
              stream: Firestore.instance
                  .collection('rents')
                  .orderBy('carrange',
                      descending:
                          true) //.where("cproblemtype", isEqualTo:"قطع غيار")
                  .where("ccar", isEqualTo:filt)
                 .where("price", isLessThanOrEqualTo:_currentSliderValue1)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: Text("لا يوجد بيانات"));
                }

                return new ListView.builder(
                    physics: BouncingScrollPhysics(),
                    shrinkWrap: true,
                    controller: _controller,
                    itemCount: snapshot.data.documents.length,
                    itemBuilder: (context, index) {
                      return firebasedata(
                          context, index, snapshot.data.documents[index]);
                    });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget firebasedata(
      BuildContext context, int index, DocumentSnapshot document) {
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
                        RentDetail(document['userId'], document['offerid'])));
          },
          child: Container(
              child: Row(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Container(
                    color: Colors.white,
                    child: Stack(
                      children: <Widget>[
                        Center(
                          child: document['curi'] == null
                              ? new Image.asset(
                                  "assets/images/ic_logo2.png",
                                )
                              : new Image.network(
                                  document['curi'],
                                  fit: BoxFit.fitHeight,
                                ),
                        ),
                      ],
                    ),
                    width: 100,
                    height: 130,
                  ),
                  Container(
                      width: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(2.0),
                        color: Colors.black12,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(right: 5),
                        child: Text(
                          "منذ: ${document['cdate']}",
                          textDirection: TextDirection.rtl,
                          textAlign: TextAlign.right,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 10,
//                                  fontFamily: 'Estedad-Black',
                              fontStyle: FontStyle.normal),
                        ),
                      )),
                ],
              ),
              Container(
                height: 130,
                child: Stack(
                  //alignment: Alignment.bottomCenter,
                  children: <Widget>[
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text(
                          document['ctitle'],
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
                    ),
                    Positioned(
                      top: 50,
                      right: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text("${ document['price']} دينار",
                            textDirection: TextDirection.rtl,
                            textAlign: TextAlign.right,
                            style: TextStyle(
                                color: Colors.green,
//                                  fontFamily: 'Estedad-Black',
                                fontWeight: FontWeight.bold,
                                fontSize: 15.0,
                                fontStyle: FontStyle.normal),
                          ),
                          SizedBox(
                            height: _minimumPadding,
                            width: _minimumPadding,
                          ),

                          new Icon(
                            Icons.monetization_on,
                            color: Colors.black,
                            size: 15,
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      top: 100,
                      right: 0,
                      child: Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              document['fPlaceName'],
                              textDirection: TextDirection.rtl,
                              textAlign: TextAlign.right,
                              style: TextStyle(
//                                      fontFamily: 'Estedad-Black',
                                  fontSize: 10.0,
                                  fontStyle: FontStyle.normal),
                            ),
                            new Icon(
                              Icons.location_on,
                              color: Colors.black,
                              size: 15,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 10, right: 5, top: 5, bottom: 5),
                          child: Text(
                            "                                                                    ",
                            textDirection: TextDirection.rtl,
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          )),
        ),
      ),
    );
  }
  void _onDropDownItemSelectedcar(String newValueSelected) {
    print("kkk$newValueSelected");
    if(newValueSelected=="السيارة"){
      setState(() {
        this._carcurrentItemSelected = newValueSelected;
        filt=null;
      });
    }else{
      setState(() {
        this._carcurrentItemSelected = newValueSelected;
        filt=_carcurrentItemSelected;
      });
    }
  }

}
