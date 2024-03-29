import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:priceme/ChatRoom/widget/const.dart';
import 'package:priceme/ChatRoom/widget/full_photo.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Chat extends StatelessWidget {
  final String peerId;

  Chat({Key key, @required this.peerId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: <Color>[
                const Color(0xffff2121),
                const Color(0xffff5423),
                const Color(0xffff7024),
                const Color(0xffff904a),
              ])),
        ),
        title: new Text(
          'محادثة',
          style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: new ChatScreen(
        peerId: peerId,

      ),
    );
  }
}

class ChatScreen extends StatefulWidget {
  final String peerId;

  ChatScreen({Key key, @required this.peerId})
      : super(key: key);

  @override
  State createState() =>
      new ChatScreenState(peerId: peerId);
}

class ChatScreenState extends State<ChatScreen> {
  ChatScreenState({Key key, @required this.peerId});

  String peerId;
  String avatar,tradeAvatar;
  String id,tradeId;
  String name ,tradeName;
  var listMessage;
  String groupChatId;
  SharedPreferences prefs;
String from,to;
  File imageFile;
  bool isLoading;
  bool isShowSticker;
  String imageUrl;

  final TextEditingController textEditingController =
      new TextEditingController();
  final ScrollController listScrollController = new ScrollController();
  final FocusNode focusNode = new FocusNode();
  String  uId;
  @override
  void initState() {
    super.initState();
    tradeId=peerId.split("-")[0] ;
    id= peerId.split("-")[1] ;
    print("kkk$peerId////$tradeId///$id");
    groupChatId=peerId;

    FirebaseAuth.instance.currentUser().then((user) => user == null
        ? null
        : setState(() {
             uId = user.uid;
           if(uId==id){from=id;to=tradeId;}else{from=tradeId;to=id;}
          }));

    var userQuery = Firestore.instance
        .collection('users')
        .where('uid', isEqualTo:id)
        .limit(1);
    userQuery.getDocuments().then((data) {
      if (data.documents.length > 0) {
        setState(() {
          name = data.documents[0].data['name'];
          avatar = data.documents[0].data['photourl'];


        });
      }
    });
    var userQuery1 = Firestore.instance
        .collection('users')
        .where('uid', isEqualTo:tradeId)
        .limit(1);
    userQuery1.getDocuments().then((data) {
      if (data.documents.length > 0) {
        setState(() {
          tradeName = data.documents[0].data['name'];
          tradeAvatar = data.documents[0].data['photourl'];


        });
      }
    });
    focusNode.addListener(onFocusChange);

 //   groupChatId = '';

    isLoading = false;
    isShowSticker = false;
    imageUrl = '';

  //  readLocal();
  }

  void onFocusChange() {
    if (focusNode.hasFocus) {
      // Hide sticker when keyboard appear
      setState(() {
        isShowSticker = false;
      });
    }
  }

  // readLocal() async {
  //   prefs = await SharedPreferences.getInstance();
  //   id = prefs.getString('id') ?? '';
  //   if (id.hashCode <= peerId.hashCode) {
  //     groupChatId = '-$peerId';
  //   } else {
  //     groupChatId = '-$id';
  //   }
  // }

  Future getImage() async {
    imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);

    if (imageFile != null) {
      setState(() {
        isLoading = true;
      });
      uploadFile();
    }
  }

  void getSticker() {
    // Hide keyboard when sticker appear
    focusNode.unfocus();
    setState(() {
      isShowSticker = !isShowSticker;
    });
  }

  Future uploadFile() async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    StorageReference reference = FirebaseStorage.instance.ref().child(fileName);
    StorageUploadTask uploadTask = reference.putFile(imageFile);
    StorageTaskSnapshot storageTaskSnapshot = await uploadTask.onComplete;
    storageTaskSnapshot.ref.getDownloadURL().then((downloadUrl) {
      imageUrl = downloadUrl;
      setState(() {
        isLoading = false;
        onSendMessage(imageUrl, 1);
      });
    }, onError: (err) {
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(msg: 'This file is not an image');
    });
  }

  void onSendMessage(String content, int type) {
    // type: 0 = text, 1 = image, 2 = sticker
    if (content.trim() != '') {
      textEditingController.clear();

      var documentReference = Firestore.instance
          .collection('messages')
          .document(groupChatId)
          .collection(groupChatId)
          .document(DateTime.now().millisecondsSinceEpoch.toString());
      print("##################  id :$id");
      Firestore.instance.runTransaction((transaction) async {
        await transaction.set(
          documentReference,
          {
            'idFrom': from,
            'idTo': to,
            'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
            'content': content,
            'type': type
          },
        );
      }).whenComplete(() => setState(() {
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
        int arrange = int.parse('${now.year}${b}${c}${d}${e}');
        DocumentReference documentReference = Firestore.instance
            .collection('Alarm')
            .document(to)
            .collection('Alarmid')
            .document();
        documentReference.setData({
          'ownerId': id,
          'traderid': tradeId,
          'advID': peerId,
          'alarmid': documentReference.documentID,
          'cdate': now.toString(),
          'tradname': tradeName,
          'ownername': name,
          'price': content,
          'rate': 0,
          'arrange': int.parse("${now.year.toString()}${b}${c}${d}${e}00"),
          'cType': "chat",
          'photo':uId==id? avatar:tradeAvatar,

        });
        Firestore.instance .collection('ChatList')
            .document(id)
            .collection('peerid')
            .document(peerId).setData({
          'peerId': peerId,
          'idTo': tradeId,
          'uid': id,
          'arrange':arrange,
          'name': tradeName,
          'aboutMe': content,
          'photourl':tradeAvatar,
        });

        Firestore.instance .collection('ChatList')
            .document(tradeId)
            .collection('peerid')
            .document(id).setData({
          'peerId': peerId,
          'idTo': id,
          'uid': tradeId,
          'arrange':arrange,

          'name': name,
          'aboutMe': content,
          'photourl':avatar,
        });


        Firestore.instance
            .collection('users')
            .document(peerId)
            .updateData({'chattingWith': id});

            print("##################  id :$id");
            Firestore.instance
                .collection('users')
                .document(peerId)
                .updateData({'chattingWith': id});
          }));
      listScrollController.animateTo(0.0,
          duration: Duration(milliseconds: 300), curve: Curves.easeOut);
    } else {
      Fluttertoast.showToast(msg: 'Nothing to send');
    }
  }

  Widget buildItem(int index, DocumentSnapshot document) {
    if (document['idFrom'] == id) {
      // Right (my message)
      return Padding(
        padding: const EdgeInsets.all(5.0),
        child: Column(
        //  crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Row(
              children: <Widget>[

                document['type'] == 0
                    // Text
                    ? Container(
                        child: Text(
                          document['content'],
                          style: TextStyle(color: primaryColor),
                        ),
                        padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                        width: 200.0,
                        decoration: BoxDecoration(
                            color: greyColor2,
                            borderRadius: BorderRadius.circular(8.0)),
                        // margin: EdgeInsets.only(
                        //     bottom: isLastMessageRight(index) ? 20.0 : 10.0,
                        //     right: 10.0),
                      )
                    : document['type'] == 1
                        // Image
                        ? Container(
                            child: FlatButton(
                              child: Material(
                                child: CachedNetworkImage(
                                  placeholder: (context, url) => Container(
                                    child: CircularProgressIndicator(
                                      valueColor:
                                          AlwaysStoppedAnimation<Color>(themeColor),
                                    ),
                                    width: 200.0,
                                    height: 200.0,
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
                                      'images/img_not_available.jpeg',
                                      width: 200.0,
                                      height: 200.0,
                                      fit: BoxFit.cover,
                                    ),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(8.0),
                                    ),
                                    clipBehavior: Clip.hardEdge,
                                  ),
                                  imageUrl: document['content'],
                                  width: 200.0,
                                  height: 200.0,
                                  fit: BoxFit.cover,
                                ),
                                borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                clipBehavior: Clip.hardEdge,
                              ),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            FullPhoto(url: document['content'])));
                              },
                              padding: EdgeInsets.all(0),
                            ),
                            margin: EdgeInsets.only(
                                bottom: isLastMessageRight(index) ? 20.0 : 10.0,
                                right: 10.0),
                          )
                        // Sticker
                        : Container(
                            child: new Image.asset(
                              'images/${document['content']}.gif',
                              width: 100.0,
                              height: 100.0,
                              fit: BoxFit.cover,
                            ),
                            margin: EdgeInsets.only(
                                bottom: isLastMessageRight(index) ? 20.0 : 10.0,
                                right: 10.0),
                          ),
                isLastMessageLeft(index)
                    ? Material(
                  child: avatar != null?
                  CachedNetworkImage(
                    placeholder: (context, url) => Container(
                      child: CircularProgressIndicator(
                        strokeWidth: 1.0,
                        valueColor:
                        AlwaysStoppedAnimation<Color>(themeColor),
                      ),
                      width: 35.0,
                      height: 35.0,
                      padding: EdgeInsets.all(10.0),
                    ),
                    imageUrl: avatar==null?"":avatar,
                    width: 35.0,
                    height: 35.0,
                    fit: BoxFit.cover,
                  ):
                  Icon(
                  Icons.account_circle,
                  size: 35.0,
                  color: greyColor,
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(18.0),
                  ),
                  clipBehavior: Clip.hardEdge,
                )
                    : Container(width: 35.0),
              ],
              mainAxisAlignment: MainAxisAlignment.end,
            ),

            // Time
            isLastMessageLeft(index)
                ? Container(
              child: Text(
                DateFormat('dd MMM kk:mm').format(
                    DateTime.fromMillisecondsSinceEpoch(
                        int.parse(document['timestamp']))),
                style: TextStyle(
                    color: greyColor,
                    fontSize: 12.0,
                    fontStyle: FontStyle.italic),
              ),
             // margin: EdgeInsets.only(left: 50.0, top: 5.0, bottom: 5.0),
            )
                : Container()
          ],
        ),
      );
    } else {
      // Left (peer message)
      return Container(
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  isLastMessageLeft(index)
                      ? Material(
                          child:tradeAvatar != null?
                          CachedNetworkImage(
                            placeholder: (context, url) => Container(
                              child: CircularProgressIndicator(
                                strokeWidth: 1.0,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(themeColor),
                              ),
                              width: 35.0,
                              height: 35.0,
                              padding: EdgeInsets.all(10.0),
                            ),
                            imageUrl: tradeAvatar==null?"":tradeAvatar,
                            width: 35.0,
                            height: 35.0,
                            fit: BoxFit.cover,
                          ):Icon(
                            Icons.account_circle,
                            size: 35.0,
                            color: greyColor,
                          ),
                          borderRadius: BorderRadius.all(
                            Radius.circular(18.0),
                          ),
                          clipBehavior: Clip.hardEdge,
                        )
                      : Container(width: 35.0),
                  document['type'] == 0
                      ? Container(
                          child: Text(
                            document['content'],
                            style: TextStyle(color: Colors.white),
                          ),
                          padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                          width: 200.0,
                          decoration: BoxDecoration(
                              color: primaryColor,
                              borderRadius: BorderRadius.circular(8.0)),
                          margin: EdgeInsets.only(left: 10.0),
                        )
                      : document['type'] == 1
                          ? Container(
                              child: FlatButton(
                                child: Material(
                                  child: CachedNetworkImage(
                                    placeholder: (context, url) => Container(
                                      child: CircularProgressIndicator(
                                        valueColor: AlwaysStoppedAnimation<Color>(
                                            themeColor),
                                      ),
                                      width: 200.0,
                                      height: 200.0,
                                      padding: EdgeInsets.all(70.0),
                                      decoration: BoxDecoration(
                                        color: greyColor2,
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(8.0),
                                        ),
                                      ),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        Material(
                                      child: Image.asset(
                                        'images/img_not_available.jpeg',
                                        width: 200.0,
                                        height: 200.0,
                                        fit: BoxFit.cover,
                                      ),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(8.0),
                                      ),
                                      clipBehavior: Clip.hardEdge,
                                    ),
                                    imageUrl: document['content'],
                                    width: 200.0,
                                    height: 200.0,
                                    fit: BoxFit.cover,
                                  ),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8.0)),
                                  clipBehavior: Clip.hardEdge,
                                ),
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => FullPhoto(
                                              url: document['content'])));
                                },
                                padding: EdgeInsets.all(0),
                              ),
                              margin: EdgeInsets.only(left: 10.0),
                            )
                          : Container(
                              child: new Image.asset(
                                'images/${document['content']}.gif',
                                width: 100.0,
                                height: 100.0,
                                fit: BoxFit.cover,
                              ),
                              margin: EdgeInsets.only(
                                  bottom: isLastMessageRight(index) ? 20.0 : 10.0,
                                  right: 10.0),
                            ),
                ],
              ),

              // Time
              isLastMessageLeft(index)
                  ? Container(
                      child: Text(
                        DateFormat('dd MMM kk:mm').format(
                            DateTime.fromMillisecondsSinceEpoch(
                                int.parse(document['timestamp']))),
                        style: TextStyle(
                            color: greyColor,
                            fontSize: 12.0,
                            fontStyle: FontStyle.italic),
                      ),
                      margin: EdgeInsets.only(left: 50.0, top: 5.0, bottom: 5.0),
                    )
                  : Container()
            ],
            crossAxisAlignment: CrossAxisAlignment.start,
          ),
        ),
        margin: EdgeInsets.only(bottom: 10.0),
      );
    }
  }

  bool isLastMessageLeft(int index) {
    if ((index > 0 &&
            listMessage != null &&
            listMessage[index - 1]['idFrom'] == id) ||
        index == 0) {
      return true;
    } else {
      return false;
    }
  }

  bool isLastMessageRight(int index) {
    if ((index > 0 &&
            listMessage != null &&
            listMessage[index - 1]['idFrom'] != id) ||
        index == 0) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> onBackPress() {
    if (isShowSticker) {
      setState(() {
        isShowSticker = false;
      });
    } else {
      Firestore.instance
          .collection('users')
          .document(id)
          .updateData({'chattingWith': null});
      Navigator.pop(context);
    }

    return Future.value(false);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              // List of messages
              buildListMessage(),

              // Sticker
              (isShowSticker ? buildSticker() : Container()),

              // Input content
              buildInput(),
            ],
          ),

          // Loading
          buildLoading()
        ],
      ),
      onWillPop: onBackPress,
    );
  }

  Widget buildSticker() {
    return Container(
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              FlatButton(
                onPressed: () => onSendMessage('mimi1', 2),
                child: new Image.asset(
                  'images/mimi1.gif',
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              ),
              FlatButton(
                onPressed: () => onSendMessage('mimi2', 2),
                child: new Image.asset(
                  'images/mimi2.gif',
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              ),
              FlatButton(
                onPressed: () => onSendMessage('mimi3', 2),
                child: new Image.asset(
                  'images/mimi3.gif',
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              )
            ],
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          ),
          Row(
            children: <Widget>[
              FlatButton(
                onPressed: () => onSendMessage('mimi4', 2),
                child: new Image.asset(
                  'images/mimi4.gif',
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              ),
              FlatButton(
                onPressed: () => onSendMessage('mimi5', 2),
                child: new Image.asset(
                  'images/mimi5.gif',
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              ),
              FlatButton(
                onPressed: () => onSendMessage('mimi6', 2),
                child: new Image.asset(
                  'images/mimi6.gif',
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              )
            ],
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          ),
          Row(
            children: <Widget>[
              FlatButton(
                onPressed: () => onSendMessage('mimi7', 2),
                child: new Image.asset(
                  'images/mimi7.gif',
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              ),
              FlatButton(
                onPressed: () => onSendMessage('mimi8', 2),
                child: new Image.asset(
                  'images/mimi8.gif',
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              ),
              FlatButton(
                onPressed: () => onSendMessage('mimi9', 2),
                child: new Image.asset(
                  'images/mimi9.gif',
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              )
            ],
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          )
        ],
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      ),
      decoration: new BoxDecoration(
          border:
              new Border(top: new BorderSide(color: greyColor2, width: 0.5)),
          color: Colors.white),
      padding: EdgeInsets.all(5.0),
      height: 180.0,
    );
  }

  Widget buildLoading() {
    return Positioned(
      child: isLoading
          ? Container(
              child: Center(
                child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(themeColor)),
              ),
              color: Colors.white.withOpacity(0.8),
            )
          : Container(),
    );
  }

  Widget buildInput() {
    return Container(
      child: Row(
        children: <Widget>[
          // Button send image
          Material(
            child: new Container(
              margin: new EdgeInsets.symmetric(horizontal: 1.0),
              child: new IconButton(
                icon: new Icon(Icons.image),
                onPressed: getImage,
                color: primaryColor,
              ),
            ),
            color: Colors.white,
          ),
          Material(
            child: new Container(
              margin: new EdgeInsets.symmetric(horizontal: 1.0),
              child: new IconButton(
                icon: new Icon(Icons.face),
                onPressed: getSticker,
                color: primaryColor,
              ),
            ),
            color: Colors.white,
          ),

          // Edit text
          Flexible(
            child: Container(
              child: TextField(
                style: TextStyle(color: primaryColor, fontSize: 15.0),
                controller: textEditingController,
                decoration: InputDecoration.collapsed(
                  hintText: 'Type your message...',
                  hintStyle: TextStyle(color: greyColor),
                ),
                focusNode: focusNode,
              ),
            ),
          ),

          // Button send message
          Material(
            child: new Container(
              margin: new EdgeInsets.symmetric(horizontal: 8.0),
              child: new IconButton(
                icon: new Icon(Icons.send),
                onPressed: () => onSendMessage(textEditingController.text, 0),
                color: primaryColor,
              ),
            ),
            color: Colors.white,
          ),
        ],
      ),
      width: double.infinity,
      height: 50.0,
      decoration: new BoxDecoration(
          border:
              new Border(top: new BorderSide(color: greyColor2, width: 0.5)),
          color: Colors.white),
    );
  }

  Widget buildListMessage() {
    return Flexible(
      child: groupChatId == ''
          ? Center(
              child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(themeColor)))
          : StreamBuilder(
              stream: Firestore.instance
                  .collection('messages')
                  .document(groupChatId)
                  .collection(groupChatId)
                  .orderBy('timestamp', descending: true)
                  .limit(20)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                      child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(themeColor)));
                } else {
                  listMessage = snapshot.data.documents;
                  return ListView.builder(
                    padding: EdgeInsets.all(10.0),
                    itemBuilder: (context, index) =>
                        buildItem(index, snapshot.data.documents[index]),
                    itemCount: snapshot.data.documents.length,
                    reverse: true,
                    controller: listScrollController,
                  );
                }
              },
            ),
    );
  }
}
