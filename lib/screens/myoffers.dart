import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:priceme/classes/AdvClass.dart';
import 'package:priceme/screens/addoffer.dart';
import 'package:priceme/screens/editoffer.dart';
import 'package:priceme/screens/signin.dart';

import 'package:toast/toast.dart';

import 'advdetail.dart';
import 'offerdetail.dart';

class MyOffers extends StatefulWidget {


  MyOffers();

  @override
  _MyOffersState createState() => _MyOffersState();
}

class _MyOffersState extends State<MyOffers> {
  List<AdvClass> advlist = [];
  bool _load = false;
  String _userId="";
  String  worktype="";
  String tradertype="";
  List<String> _imageUrls;

  @override
  void initState() {
    super.initState();

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
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          AddOffer()));
            },
            //backgroundColor: Colors.white,
           // elevation: 20.0,
            child: Container(
              height: 100,
              child: Icon(
                Icons.add,
                //size: 50,
                color: const Color(0xff171732),
              ),
            ),
          ),
        ),
      ),
      body: Container(
        child: StreamBuilder(
          stream: Firestore.instance
              .collection('offers')
              .orderBy('carrange',
                  descending:
                      true) .where("userId", isEqualTo:_userId)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: Text("Loading.."));
            }

            return new ListView.builder(
                physics: BouncingScrollPhysics(),
                shrinkWrap: true,
                controller: _controller,
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context, index) {
                  return Slidable(
                    actionPane: SlidableDrawerDismissal(),
                    child: firebasedata(
                        context, index, snapshot.data.documents[index]),
                    secondaryActions: <Widget>[
                      Container(
                        padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                        child: IconSlideAction(
                          caption: 'تعديل',
                          color: Colors.green,
                          icon: Icons.edit,
                          onTap: () {
                            Navigator.push(
                              context,
                              new MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                  new EditOffer(
                                    index,
                                    snapshot.data.documents.length,
                                    snapshot.data.documents[index]["carrange"],
                                    snapshot.data.documents[index]["cdate"],
                                    snapshot.data.documents[index]["cdiscribtion"],
                                    snapshot.data.documents[index]["cimagelist"],
                                    snapshot.data.documents[index]["cproblemtype"],
                                    snapshot.data.documents[index]["ctitle"],
                                    snapshot.data.documents[index]["curi"],
                                    snapshot.data.documents[index]["fPlaceName"],
                                    snapshot.data.documents[index]["fromPLat"],
                                    snapshot.data.documents[index]["fromPLng"],
                                    snapshot.data.documents[index]["offerid"],
                                    snapshot.data.documents[index]["pname"],
                                    snapshot.data.documents[index]["pphone"],
                                    snapshot.data.documents[index]["price"],
                                    snapshot.data.documents[index]["userId"],

                                  )),
                            );
                          },
                        ),
                      )

                    ],
                    actions: <Widget>[
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
                                  content: new Text("تبغي تحذف اعلانك؟"),
                                  actions: [
                                    CupertinoDialogAction(
                                        isDefaultAction: false,
                                        child: new FlatButton(
                                          onPressed: () {

                                            setState(() {
                                              Firestore.instance.collection("offers")
                                                  .document(snapshot.data.documents[index]["offerid"])
                                                  .delete().whenComplete(() =>
                                                  setState(() async {
                                                    Navigator.pop(context);
                                                    Toast.show("تم الحذف", context,
                                                        duration: Toast.LENGTH_SHORT,
                                                        gravity: Toast.BOTTOM);
                                                    _imageUrls = snapshot.data.documents[index]["cimagelist"]
                                                        .replaceAll(" ", "")
                                                        .replaceAll("[", "")
                                                        .replaceAll("]", "")
                                                        .split(",");

                                                    for(String imge in _imageUrls){

                                                      final StorageReference storageRef =
                                                      await FirebaseStorage.instance.getReferenceFromUrl(imge);
                                                      //   print("hhhhhhhhhhhhhhh${storageRef.path}");
                                                      await storageRef.delete().whenComplete(() {
                                                      });
                                                    }
                                                    this.reassemble();
                                                  }));
                                            });
                                          }
                                          ,
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
                });
          },
        ),
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
                        OfferDetail(document['userId'], document['offerid'])));
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
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(2.0),
                            color: const Color(0xff444460),
                          ),
                          child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Text(
                                document['cproblemtype'],
                                textDirection: TextDirection.rtl,
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
//                                          fontFamily: 'Estedad-Black',
                                    fontStyle: FontStyle.normal),
                              )),
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
}
