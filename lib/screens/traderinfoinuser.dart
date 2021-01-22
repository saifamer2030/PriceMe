
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:priceme/ChatRoom/widget/chat.dart';
import 'package:toast/toast.dart';
import 'package:url_launcher/url_launcher.dart';

Color color1 = Colors.orange;
Color color2 = Colors.orangeAccent;

class TraderInfoInUser extends StatefulWidget {
  String ownerId;
  String traderid;
  TraderInfoInUser(this.ownerId,this.traderid);

  @override
  _TraderInfoInUserState createState() => _TraderInfoInUserState();
}
class _TraderInfoInUserState extends State<TraderInfoInUser> {
  String email,name,phone,photourl,curilist,fromPLat,fromPLng,fPlaceName,worktype,
      workshopname,cType,traderType,_userId;
  var _formKey = GlobalKey<FormState>();
  final double _minimumPadding = 5.0;
  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.currentUser().then((user) => user == null
        ? _userId=null
        : setState(() {_userId = user.uid;}),);
    var userQuery = Firestore.instance.collection('users').where('uid', isEqualTo: widget.traderid).limit(1);
    userQuery.getDocuments().then((data){
      if (data.documents.length > 0){
        setState(() {
          cType = data.documents[0].data['cType'].toString();
          name = data.documents[0].data['name'].toString();
          phone = data.documents[0].data['phone'].toString();
          photourl = data.documents[0].data['photourl'].toString();
          fromPLat = data.documents[0].data['fromPLat'].toString();
          fromPLng = data.documents[0].data['fromPLng'].toString();
          fPlaceName = data.documents[0].data['fPlaceName'].toString();
          worktype = data.documents[0].data['worktype'].toString();
          workshopname = data.documents[0].data['workshopname'].toString();
          traderType = data.documents[0].data['traderType'].toString();
        });
      }
    });



  }

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.subtitle;
    return Scaffold(
        body: Container(
//          child: Form(
//            key: _formKey,
          child: Padding(
              padding: EdgeInsets.only(
                  left: _minimumPadding,
                  right: _minimumPadding,
                  bottom: _minimumPadding),
              child: ListView(
                physics: BouncingScrollPhysics(),
                children: <Widget>[
                  SizedBox(
                    height: _minimumPadding,
                    width: _minimumPadding,
                  ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Container(
                        width: 150 /*MediaQuery.of(context).size.width*/,
                        height: 40,
                        child: new RaisedButton(
                          child: Row(
                            mainAxisAlignment:
                                MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              new Text(
                                "تواصل عبر الدردشة",
                                style: TextStyle(
                                  color: const Color(0xff171732),
                                  fontSize: 10,
                                ),
                              ),
                              Icon(
                                Icons.mail_outline,
                                color: const Color(0xff171732),
                              ),
                            ],
                          ),
                          textColor: const Color(0xff171732),
                          color: Colors.grey[400],
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Chat(
                                      peerId: "${widget.traderid}-${widget.ownerId}",
                                    )));
                           // sortrate();
                            // if (_userId == null) {
                            //   Toast.show(
                            //       "ابشر .. سجل دخول الاول طال عمرك",
                            //       context,
                            //       duration: Toast.LENGTH_LONG,
                            //       gravity: Toast.BOTTOM);
                            // } else {
                            //   // Navigator.push(
                            //   //   context,
                            //   //   new MaterialPageRoute(
                            //   //       builder: (BuildContext context) =>
                            //   //           new ChatPage(
                            //   //               name: widget.cName,
                            //   //               uid: widget.cId)),
                            //   // );
                            // }
                          },

//
                          shape: new RoundedRectangleBorder(
                              borderRadius:
                                  new BorderRadius.circular(10.0)),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Container(
                        width: 150 /*MediaQuery.of(context).size.width*/,
                        height: 40,
                        child: new RaisedButton(
                          child: Row(
                            mainAxisAlignment:
                                MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              new Text(
                                "تواصل برقم الجوال",
                                style: TextStyle(
                                  color: const Color(0xff171732),
                                  fontSize: 10,
                                ),
                              ),
                              Icon(
                                Icons.phone,
                                color: const Color(0xff171732),
                              ),
                            ],
                          ),
                          textColor: const Color(0xff171732),
                          color: Colors.grey[400],
                          onPressed: () {
                            if (_userId == null) {
                              Toast.show(
                                  "برجاء .. تسجيل الدخول اولا",
                                  context,
                                  duration: Toast.LENGTH_LONG,
                                  gravity: Toast.BOTTOM);
                            } else {
                              if (phone != null) {
                                _makePhoneCall(
                                    'tel:${phone}');
                              } else {
                                Toast.show("حاول تانيا", context,
                                    duration: Toast.LENGTH_LONG,
                                    gravity: Toast.BOTTOM);
                              }
                            }
                          },
//
                          shape: new RoundedRectangleBorder(
                              borderRadius:
                                  new BorderRadius.circular(10.0)),
                        ),
                      ),
                    ),
                  ],
                ),
                  SizedBox(
                    height:2* _minimumPadding,
                    width: _minimumPadding,
                  ),
                  Container(
                      height: 40,
                      width: 350,
                      margin: EdgeInsets.only(
                          left: 10.0, right: 10.0, bottom: 10.0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0x80000000),
                              blurRadius: 10.0,
                              offset: Offset(0.0, 5.0),
                            ),
                          ],
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [color1, color2],
                          )),
                      child: Padding(
                        padding: EdgeInsets.only(
                            left: _minimumPadding, right: _minimumPadding),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Text(
                              name==null?"": name,
                              style: TextStyle(
                                fontSize: 15,
                              ),
                              textDirection: TextDirection.rtl,
                            ),
                            Text(
                              "الإسم بالكامل:",
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                              textDirection: TextDirection.rtl,
                            ),
//                          Padding(
//                            padding: EdgeInsets.only(left: 5.0, right: 5.0),
//                            child: Icon(
//                              Icons.edit,
//                              color: Colors.black,
//                            ),
//                          ),
                          ],
                        ),
                      )),
                  SizedBox(
                    height: _minimumPadding,
                    width: _minimumPadding,
                  ),
                  Container(
                      height: 40,
                      width: 350,
                      margin: EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0x80000000),
                              blurRadius: 10.0,
                              offset: Offset(0.0, 5.0),
                            ),
                          ],
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [color1, color2],
                          )),
                      child: Padding(
                        padding: EdgeInsets.only(
                            left: _minimumPadding, right: _minimumPadding),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Text(
                              workshopname==null?"": workshopname,
                              style: TextStyle(
                                fontSize: 15,
                              ),
                              textDirection: TextDirection.rtl,
                            ),
                            Text(
                              "اسم المحل:",
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                              textDirection: TextDirection.rtl,
                            ),
//                          Padding(
//                            padding: EdgeInsets.only(left: 5.0, right: 5.0),
//                            child: Icon(
//                              Icons.edit,
//                              color: Colors.black,
//                            ),
//                          ),
                          ],
                        ),
                      )),
                  SizedBox(
                    height: _minimumPadding,
                    width: _minimumPadding,
                  ),
//                   Container(
//                       height: 40,
//                       width: 350,
//                       margin: EdgeInsets.all(10.0),
//                       decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(8.0),
//                           boxShadow: [
//                             BoxShadow(
//                               color: Color(0x80000000),
//                               blurRadius: 10.0,
//                               offset: Offset(0.0, 5.0),
//                             ),
//                           ],
//                           gradient: LinearGradient(
//                             begin: Alignment.topLeft,
//                             end: Alignment.bottomRight,
//                             colors: [color1, color2],
//                           )),
//                       child: Padding(
//                         padding: EdgeInsets.only(
//                             left: _minimumPadding, right: _minimumPadding),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.end,
//                           children: <Widget>[
//                             Text(
//                               phone==null?"":phone,
//                               style: TextStyle(
//                                 fontSize: 15,
//                               ),
//                               textDirection: TextDirection.rtl,
//                             ),
//                             Text(
//                               "رقم الهاتف:",
//                               style: TextStyle(
//                                   fontSize: 15, fontWeight: FontWeight.bold),
//                               textDirection: TextDirection.rtl,
//                             ),
// //                          Padding(
// //                            padding: EdgeInsets.only(left: 5.0, right: 5.0),
// //                            child: Icon(
// //                              Icons.edit,
// //                              color: Colors.black,
// //                            ),
// //                          ),
//                           ],
//                         ),
//                       )),
//                   SizedBox(
//                     height: _minimumPadding,
//                     width: _minimumPadding,
//                   ),
//                    Container(
//                      height: 40,
//                      width: 350,
//                      margin: EdgeInsets.all(10.0),
//                      decoration: BoxDecoration(
//                          borderRadius: BorderRadius.circular(8.0),
//                          boxShadow: [
//                            BoxShadow(
//                              color: Color(0x80000000),
//                              blurRadius: 10.0,
//                              offset: Offset(0.0, 5.0),
//                            ),
//                          ],
//                          gradient: LinearGradient(
//                            begin: Alignment.topLeft,
//                            end: Alignment.bottomRight,
//                            colors: [
//                              Color(0xFFE57373),
//                              Color(0xFFEF9A9A),
//                            ],
//                          )),
//                      child: Row(
//                        mainAxisAlignment: MainAxisAlignment.end,
//                        children: <Widget>[
//                          Text(
//                            _curCoiffure.email,
//                            style: TextStyle(
//                              fontSize: 15,
//                            ),
//                            textDirection: TextDirection.rtl,
//                          ),
//                          Text(
//                            "البريد الإلكتروني:",
//                            style: TextStyle(
//                                fontSize: 15, fontWeight: FontWeight.bold),
//                            textDirection: TextDirection.rtl,
//                          ),
////                          Padding(
////                            padding: EdgeInsets.only(left: 5.0, right: 5.0),
////                            child: Icon(
////                              Icons.edit,
////                              color: Colors.black,
////                            ),
////                          ),
//                        ],
//                      ),
//                    ),
//                    SizedBox(
//                      height: _minimumPadding,
//                      width: _minimumPadding,
//                    ),
//                    Container(
//                      height: 40,
//                      width: 350,
//                      margin: EdgeInsets.all(10.0),
//                      decoration: BoxDecoration(
//                          borderRadius: BorderRadius.circular(8.0),
//                          boxShadow: [
//                            BoxShadow(
//                              color: Color(0x80000000),
//                              blurRadius: 10.0,
//                              offset: Offset(0.0, 5.0),
//                            ),
//                          ],
//                          gradient: LinearGradient(
//                            begin: Alignment.topLeft,
//                            end: Alignment.bottomRight,
//                            colors: [
//                              Color(0xFFE57373),
//                              Color(0xFFEF9A9A),
//                            ],
//                          )),
//                      child: Row(
//                        mainAxisAlignment: MainAxisAlignment.end,
//                        children: <Widget>[
//                          Text(
//                            _curCoiffure.tel,
//                            style: TextStyle(
//                              fontSize: 15,
//                            ),
//                            textDirection: TextDirection.rtl,
//                          ),
//                          Text(
//                            "رقم الهاتف:",
//                            style: TextStyle(
//                                fontSize: 15, fontWeight: FontWeight.bold),
//                            textDirection: TextDirection.rtl,
//                          ),
////                          Padding(
////                            padding: EdgeInsets.only(left: 5.0, right: 5.0),
////                            child: Icon(
////                              Icons.edit,
////                              color: Colors.black,
////                            ),
////                          ),
//                        ],
//                      ),
//                    ),
//                    SizedBox(
//                      height: _minimumPadding,
//                      width: _minimumPadding,
//                    ),
                  Container(
                      height: 100,
                      width: 350,
                      margin: EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0x80000000),
                              blurRadius: 10.0,
                              offset: Offset(0.0, 5.0),
                            ),
                          ],
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [color1, color2],
                          )),
                      child: Padding(
                        padding: EdgeInsets.only(
                            left: _minimumPadding, right: _minimumPadding),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                fPlaceName==null?"": fPlaceName,
                                style: TextStyle(
                                  fontSize: 15,
                                ),
                                textDirection: TextDirection.rtl,
                              ),
                            ),
                            Text(
                              "العنوان:",
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                              textDirection: TextDirection.rtl,
                            ),
//                          Padding(
//                            padding: EdgeInsets.only(left: 5.0, right: 5.0),
//                            child: Icon(
//                              Icons.edit,
//                              color: Colors.black,
//                            ),
//                          ),
                          ],
                        ),
                      )),
                  SizedBox(
                    height: _minimumPadding,
                    width: _minimumPadding,
                  ),
                  Container(
                      height: 40,
                      width: 350,
                      margin: EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0x80000000),
                              blurRadius: 10.0,
                              offset: Offset(0.0, 5.0),
                            ),
                          ],
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [color1, color2],
                          )),
                      child: Padding(
                        padding: EdgeInsets.only(
                            left: _minimumPadding, right: _minimumPadding),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Text(
                              traderType==null?"": traderType,
                              style: TextStyle(
                                fontSize: 15,
                              ),
                              textDirection: TextDirection.rtl,
                            ),
                            Text(
                              "نوع التاجر:",
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                              textDirection: TextDirection.rtl,
                            ),
//                          Padding(
//                            padding: EdgeInsets.only(left: 5.0, right: 5.0),
//                            child: Icon(
//                              Icons.edit,
//                              color: Colors.black,
//                            ),
//                          ),
                          ],
                        ),
                      )),
                  SizedBox(
                    height: _minimumPadding,
                    width: _minimumPadding,
                  ),
                  Container(
                      height: 40,
                      width: 350,
                      margin: EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0x80000000),
                              blurRadius: 10.0,
                              offset: Offset(0.0, 5.0),
                            ),
                          ],
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [color1, color2],
                          )),
                      child: Padding(
                        padding: EdgeInsets.only(
                            left: _minimumPadding, right: _minimumPadding),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Text(
                              worktype==null?"":  worktype,
                              style: TextStyle(
                                fontSize: 15,
                              ),
                              textDirection: TextDirection.rtl,
                            ),
                            Text(
                              "نوع العمل:",
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                              textDirection: TextDirection.rtl,
                            ),
//                          Padding(
//                            padding: EdgeInsets.only(left: 5.0, right: 5.0),
//                            child: Icon(
//                              Icons.edit,
//                              color: Colors.black,
//                            ),
//                          ),
                          ],
                        ),
                      )),


                ],
              )),
        ));
  }
  Future<void> _makePhoneCall(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
