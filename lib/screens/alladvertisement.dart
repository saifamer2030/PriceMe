import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:priceme/ChatRoom/widget/const.dart';
import 'package:priceme/Splash.dart';
import 'package:priceme/classes/AdvClass.dart';
import 'package:priceme/ui_utile/myCustomShape.dart';
import 'package:toast/toast.dart';

import 'advdetail.dart';

class AllAdvertisement extends StatefulWidget {


  AllAdvertisement();

  @override
  _AllAdvertisementState createState() => _AllAdvertisementState();
}

class _AllAdvertisementState extends State<AllAdvertisement> {
  List<AdvClass> advlist = [];
  bool _load = false;
  String _userId="";
  String  worktype="";
  String tradertype="";
  String selectedcars="";
  List<String> selectedcarslist;
  var _stream;
  @override
  void initState() {
    super.initState();

    FirebaseAuth.instance.currentUser().then((user) => user == null
        ? Navigator.of(context, rootNavigator: false).push(MaterialPageRoute(
            builder: (context) => Splash(), maintainState: false))
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
                  selectedcars = data.documents[0].data['selectedcarstring'];
                  tradertype = data.documents[0].data['traderType'];
                  worktype = data.documents[0].data['worktype'];
                  tradertype=="تاجر صيانة"?tradertype="اعطال":tradertype="قطع غيار";
                  selectedcars==null?selectedcars="":selectedcars=selectedcars;
                  selectedcarslist = selectedcars
                     // .replaceAll(" ", "")
                      .replaceAll("[", "")
                      .replaceAll("]", "")
                      .split(",");
                  print("mmm" + worktype);
                  if(tradertype=="قطع غيار"){
                    setState(() {
                    _stream=  Firestore.instance
                          .collection('advertisments')
                          .orderBy('carrange',descending:true)
                          .where("mfaultarray", arrayContains: worktype)
                          .where("cproblemtype", isEqualTo: tradertype)
                          .where("ccar", whereIn:selectedcarslist)
                          .snapshots();
                    });

                  }else{
                    setState(() {
                      _stream=    Firestore.instance
                          .collection('advertisments')
                          .orderBy('carrange',descending:true)
                          .where("mfaultarray", arrayContains: worktype)
                          .where("cproblemtype", isEqualTo: tradertype)
                          .snapshots();
                    });

                  }
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
      body: Stack(
        children: [
          CustomPaint(
            size: Size(MediaQuery.of(context).size.width,140), //You can Replace this with your desired WIDTH and HEIGHT
            painter: MyCustomShape(),
          ),
/*
          Positioned(
              top: 48,
              right: 20,
              child:
              InkWell(
                onTap: (){
                  Navigator.pop(context);
                },
                child: Container(
                  height: 30,
                  width: 30,
                  child: Icon(Icons.arrow_forward, color: Colors.white),
                ),
              )

          ),
*/

          Positioned(
            top: 42,
            child: Container(
              alignment: Alignment.center,
              height: 40,
              width: MediaQuery.of(context).size.width,
              child: Text(
                "طلبات المحل",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold
                ),
              ),
            ),
          ),


          Padding(
            padding: const EdgeInsets.only(top:88.0),
            child: StreamBuilder(
              stream: _stream,
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
                                mainAxisSpacing: 6,
                                childAspectRatio: (MediaQuery.of(context)
                                    .size
                                    .width) /
                                    (MediaQuery.of(context).size.height * 0.6),
                              ),
                              itemCount:snapshot.data.documents.length,
                              itemBuilder: (BuildContext context, int index) {
                                return  advertisementItemWidget(context, snapshot.data.documents[index]);
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


  Widget advertisementItemWidget(
      BuildContext context, DocumentSnapshot document) {
    return
      InkWell(
        onTap: () {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  AdvDetail(document['userId'], document['advid'])));
    },
    child:
      Card(
      shape: new RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(color: Colors.grey)),
      elevation: 10.0,
      margin: EdgeInsets.only(right: 1, left: 1, bottom: 2),
      child:  Container(
          // height: 1000,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              textDirection: TextDirection.rtl,
              children: [
                Expanded(
                    child: Container(
                      width: double.infinity,
                      child: Stack(
                        children: [
                          Container(
                              height: double.infinity,
                              width: double.infinity,

                              child: ClipRRect(
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(10),
                                    topLeft: Radius.circular(10)),
                                child:                                 CachedNetworkImage(
                                  placeholder: (context, url) => Container(
                                    child: Image.asset(
                                      "assets/images/ic_logo2.png",
                                      width: 150.0,
                                      height: 150.0,
                                      fit: BoxFit.contain,color: Colors.orange,
                                    ),
                                    width:100.0,
                                    height: 100.0,
                                    padding: EdgeInsets.all(70.0),
                                    decoration: BoxDecoration(
                                      color: greyColor2,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(8.0),
                                      ),
                                    ),
                                  ),
                                  errorWidget: (context, url, error) => Material(
                                    child: Image.asset(
                                      "assets/images/ic_logo2.png",
                                      width: 200.0,
                                      height: 200.0,
                                      fit: BoxFit.cover,color: Colors.orange,
                                    ),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(8.0),
                                    ),
                                    clipBehavior: Clip.hardEdge,
                                  ),
                                  imageUrl:document['curi'],
                                  width: 200.0,
                                  height: 200.0,
                                  fit: BoxFit.cover,
                                ),

                                // document['curi'] == null
                                //     ? new Image.asset(
                                //   "assets/images/ic_logo2.png",
                                // )
                                //     : new Image.network(
                                //   document['curi'],
                                //   fit: BoxFit.cover,
                                // ),
                              )),
                          Positioned(
                            right: 0,
                            child: Container(
                              width: 72,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(10)),
                                color: Colors.black.withOpacity(0.6),
                              ),
                              child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Text(
                                    document['cproblemtype'].toString(),
                                    textDirection: TextDirection.rtl,
                                    textAlign: TextAlign.right,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontStyle: FontStyle.normal),
                                  )),
                            ),
                          ),
                        ],
                      ),
                    )),
                Container(
                  padding: EdgeInsets.only(right: 10, left: 10),
                  child: Text(
                    document['ctitle'].toString(),
                    textDirection: TextDirection.rtl,
                    textAlign: TextAlign.right,
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 12.0,
                        fontStyle: FontStyle.normal),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(right: 10, left: 10),
                  child: Text(
                    document['pname'] != null && document['pname'].toString().length > 0
                      ? document['pname'].toString():
                    "مجهول",
                    textDirection: TextDirection.rtl,
                    textAlign: TextAlign.right,
                    style: TextStyle(
                        color: Colors.grey,

                        fontWeight: FontWeight.normal,
                        fontSize: 10,
                        fontStyle: FontStyle.normal),
                  ),
                ),
                SizedBox(
                  height: 10,
                )
              ],
            )),

    ));
  }


/////////////////////////////////////////// Previous widgets /////////////////////////////////
  ///////////////// This function is not used

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
//
                                    fontStyle: FontStyle.normal),
                              ),
                            )

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
}
