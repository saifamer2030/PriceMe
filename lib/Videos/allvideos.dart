
import 'dart:ui';

import 'package:chewie/chewie.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:priceme/Splash.dart';
import 'package:priceme/Videos/photosvideo.dart';
import 'package:priceme/classes/AdvClass.dart';
import 'package:toast/toast.dart';
import 'package:video_player/video_player.dart';


class AllVideos extends StatefulWidget {
String cdepart;
int carrange;
  AllVideos(this.carrange,this.cdepart);

  @override
  _AllVideosState createState() => _AllVideosState();
}

class _AllVideosState extends State<AllVideos> {
  List<AdvClass> advlist = [];
  bool _load = false;
  String _userId="";
  String  worktype="";
  String tradertype="";
  String cType,username;
  @override
  void initState() {
    super.initState();

    FirebaseAuth.instance.currentUser().then((user) => user == null
        ? setState(() {})
        : setState(() {
            _userId = user.uid;
            var userQuery = Firestore.instance
                .collection('users')
                .where('uid', isEqualTo: _userId)
                .limit(1);
            userQuery.getDocuments().then((data) {
              if (data.documents.length > 0) {
                setState(() {
                  username = data.documents[0].data['name'];

                  cType = data.documents[0].data['cType'];
                  tradertype = data.documents[0].data['traderType'];
                  worktype = data.documents[0].data['worktype'];
                  tradertype=="تاجر صيانة"?tradertype="اعطال":tradertype="قطع غيار";
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
      backgroundColor: Colors.black,
      // floatingActionButton: Container(
      //   height: 30.0,
      //   width: 30.0,
      //   child: FittedBox(
      //     child: FloatingActionButton(
      //       heroTag: "unique9",
      //       onPressed: () {
      //         _controller.animateTo(0.0,
      //             curve: Curves.easeInOut, duration: Duration(seconds: 1));
      //       },
      //       backgroundColor: Colors.white,
      //       elevation: 20.0,
      //       child: Icon(
      //         Icons.arrow_drop_up,
      //         size: 50,
      //         color: const Color(0xff171732),
      //       ),
      //     ),
      //   ),
      // ),
      body: Container(
        // color: ,
        child: StreamBuilder(
          stream: Firestore.instance
              .collection('videos')
              .orderBy('carrange',
                  descending:
                      true) .where("carrange", isLessThanOrEqualTo:widget.carrange).limit(5)
              .where("cdepart", isEqualTo:widget.cdepart)
             .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: Text("Loading.."));
            }

            return SingleChildScrollView(
              physics: new BouncingScrollPhysics(),
              scrollDirection: Axis.vertical,
              child: new ListView.separated(
                shrinkWrap: true,
                cacheExtent: 1000,
                physics: NeverScrollableScrollPhysics(),
                scrollDirection: Axis.vertical,
                key: PageStorageKey(""),
                addAutomaticKeepAlives: true,
                  controller: _controller,
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (context, index) {
                    return Container(
                      width: double.infinity,
//                      height: 300.0,
                      alignment: Alignment.center,

                      child: Container(
                          key: new PageStorageKey(
                            "keydata$index",
                          ),

                          child: VideoWidget(
                              play: false,
                              document:snapshot.data.documents[index],
                            itr: index,
                              len:snapshot.data.documents.length,
                            cType: cType,
                              username:username
                          )
                      ),
                    );
                    //firebasedata(context, index, snapshot.data.documents[index]);
                  },
                separatorBuilder: (context, index) {
                  return Divider();
                },
    ),
            );
          },
        ),
      ),
    );
  }


}
class VideoWidget extends StatefulWidget {

  final bool play;
  // final String url;
  // final String title;
  // final String details;
  final DocumentSnapshot document;
  final int itr;
  final int len;
  final String cType,username;
  const VideoWidget({Key key,@required this.document,@required  this.play,@required  this.itr,@required  this.len

   , @required this.cType, @required this.username//, @required this.title, @required this.details
  })
      : super(key: key);

  @override
  _VideoWidgetState createState() => _VideoWidgetState();
}


class _VideoWidgetState extends State<VideoWidget> {
  VideoPlayerController videoPlayerController ;
  Future<void> _initializeVideoPlayerFuture;
 String a,_userId;
  //var list = new List<int>.generate(10, (i) => i + 1);
  // List<int> seens = new List<int>.generate(widget.len, (i) => 0);
// bool isplay=false;
  List<int> seens=[];
  List<int> likes=[];
  List<bool> seencheck=[];
  List<bool> favcheck=[];
  List<bool> isplay=[];
 //  int likes;
 // bool seencheck=true;
 //  bool favcheck;
  @override
  void initState() {
    super.initState();
     seens = new List<int>.generate(widget.len, (i) => 0);
    likes = new List<int>.generate(widget.len, (i) => 0);
    seencheck = new List<bool>.generate(widget.len, (i) => true);
    favcheck = new List<bool>.generate(widget.len, (i) => false);
    isplay = new List<bool>.generate(widget.len, (i) => false);

    favcheck[widget.itr]= widget.document['favcheck'];
    seens[widget.itr]=widget.document['seens'];
    likes[widget.itr]=widget.document['likes'];

    videoPlayerController = new VideoPlayerController.network(widget.document['curi']);

    FirebaseAuth.instance.currentUser().then((user) => user == null
        ?  a=""

        : setState(() {_userId = user.uid;}));
    _initializeVideoPlayerFuture = videoPlayerController.initialize().then((_) {
      //       Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
      setState(() {});
    });
    videoPlayerController.addListener(() {
      if (  videoPlayerController.value.isPlaying){
        if( !isplay[widget.itr])
        setState(() {
          isplay[widget.itr] =true;
        });
      }else{
        if( isplay[widget.itr])
        setState(() {
          isplay[widget.itr] =false;
        });      }
      if (videoPlayerController.value.position ==
          videoPlayerController.value.duration) {
        //print('video Ended');
        if(seencheck[widget.itr]) {
          setState(() {
            seens[widget.itr] = seens[widget.itr] + 1;
          });
          Firestore.instance.collection('videos')
              .document(widget.document['cId'])
              .updateData({
            'seens': seens[widget.itr],
          });
          seencheck[widget.itr]= false;
        }
      }
    });
  }
    @override
    void dispose() {
      videoPlayerController.dispose();
      //    widget.videoPlayerController.dispose();
      super.dispose();
    }


    @override
    Widget build(BuildContext context) {

      return FutureBuilder(
        future: _initializeVideoPlayerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return new Container(
              // width: MediaQuery.of(context).size.width,
              // height: MediaQuery.of(context).size.height,
              child: Stack(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: Chewie(
                      key: new PageStorageKey(widget.document['curi']),
                      controller: ChewieController(
                        videoPlayerController: videoPlayerController,
                        aspectRatio:MediaQuery.of(context).size.width / (MediaQuery.of(context).size.height-16),// 4 / 3,
                        // Prepare the video to be played and display the first frame
                        autoInitialize: true,
                        looping: false,
                        autoPlay: false,

                        // Errors can occur for example when trying to play a video
                        // from a non-existent URL
                        errorBuilder: (context, errorMessage) {
                          return Center(
                            child: Text(
                              errorMessage,
                              style: TextStyle(color: Colors.white),
                            ),
                          );
                        },
                      ),
                    ),
                  ),

                  Positioned(
                    top: 15,
                    right:10,
                    child:     (_userId == widget.document['cuserId']||widget.cType=="admin")
                        ?  Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 25,
                        child: IconButton(
                          icon: Icon(Icons.delete,size:40 ,),
                          color: Colors.red,
                          onPressed: () {
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
                                            Firestore.instance.collection("videos")
                                                .document(widget.document['cId'])
                                                .delete().whenComplete(() =>
                                                setState(() async {
                                                  Navigator.pop(context);
                                                  Toast.show("تم الحذف", context,
                                                      duration: Toast.LENGTH_SHORT,
                                                      gravity: Toast.BOTTOM);

                                                  Navigator.pushReplacement(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) => VidiosPhoto()));
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
                        ),),
                    ):Container(),
                  ),

                  Positioned(
                    top: 25,
                    left:70,
                    right:  MediaQuery.of(context).size.width/3,
                    child:    Text(widget.document['cname']==null?"اسم غير معلوم":widget.document['cname'],
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold,
                        )),
                  ),

                  Positioned(
                    top: 45,
                    left:70,
                    right:  MediaQuery.of(context).size.width/3,
                    child:    Text(widget.document['cdate'],
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold,
                        )),
                  ),

                  Positioned(
                    top: 15,
                    left: 5,
                    child: Container(
                      height: 50,
                      width: 50,
                      // child: Text(
                      //   sparepartsList[index].sName, style: TextStyle(color: Colors.red,fontSize: 20
                      // ),textAlign: TextAlign.center,
                      //
                      // ),
                      decoration: BoxDecoration(
                        border: new Border.all(
                          color: Colors.black,
                          width: 1.0,
                        ),
                        image: DecorationImage(
                          image: NetworkImage(widget.document['cphotourl']==null||widget.document['cphotourl']==""?
                          "https://i.pinimg.com/564x/0c/3b/3a/0c3b3adb1a7530892e55ef36d3be6cb8.jpg"  :widget.document['cphotourl']),
                          fit: BoxFit.fill,
                        ),
                        shape: BoxShape.circle,
                      ),
                    ),

                  ),
                  Positioned(
                    bottom: 60,
                    right:100,
                    left: 100,
                    child:    Text(widget.document['cdetail'],textDirection: TextDirection.rtl,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold,
                        )),
                  ),
                  Positioned(
                    bottom: 55,
                    left: 8,
                    child:    InkWell(
                      onTap: () {
                        setState(() {
                          setState(() {
                            favcheck[widget.itr] =
                            ! favcheck[widget.itr] ; //boolean value
                          });
                          if (_userId == null) {
                            //if(favchecklist[position] ){
                            Toast.show(
                                "ابشر .. سجل دخول الاول طال عمرك",
                                context,
                                duration: Toast.LENGTH_LONG,
                                gravity: Toast.BOTTOM);
                            setState(() {
                              favcheck[widget.itr]= false; //boolean value
                            });
                          }else if(_userId==widget.document['cuserId']){
                            Toast.show(
                                "لا يمكن عمل اعجاب بفيديوهاتك",
                                context,
                                duration: Toast.LENGTH_LONG,
                                gravity: Toast.BOTTOM);
                            setState(() {
                              favcheck[widget.itr]= false; //boolean value
                            });
                          } else {
                            if (favcheck[widget.itr]) {
                              setState(() {
                                likes[widget.itr]=likes[widget.itr]+1;
                              });
                              Firestore.instance.collection('videos')
                                  .document(widget.document['cId'])
                                  .updateData({
                                'likes':likes[widget.itr],
                              }).whenComplete(() {
                                DateTime now = DateTime.now();
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
                                String f = now.second.toString();
                                if (f.length < 2) {
                                  f = "0" + f;
                                }

                                DocumentReference documentReference =
                                Firestore.instance.collection('Alarm')
                                    .document(widget.document['cuserId'])
                                    .collection('Alarmid')
                                    .document();
                                documentReference.setData({
                                  'ownerId': widget.document['cuserId'],
                                  'traderid': _userId,
                                  'advID': widget.document['cId'],
                                  'alarmid': documentReference.documentID,
                                  'cdate': DateTime.now().toString(),
                                  'tradname': widget.username,
                                  'ownername': widget.document['cname'],
                                  'comment': widget.document['ctitle'],
                                  'rate': 0.0,
                                  'arrange': int.parse("${now.year.toString()}${b}${c}${d}${e}${f}"),
                                  'cType': "videofav",

                                });
                              });
                              print("rrrrr$_userId");
                              Firestore.instance
                                  .collection('favorite')
                                  .document(_userId)
                                  .collection("fav_offer_id")
                                  .document(widget.document['cId'])
                                  .setData({
                                'cId': widget.document['cId'],
                                'carrange':widget.document['carrange'],
                                'cuserId': widget.document['cuserId'],
                                'cname': widget.document['cname'],
                                'cphotourl': widget.document['cphotourl'],
                                'cdate': widget.document['cdate'],
                                'ctitle': widget.document['ctitle'],
                                'cdepart': widget.document['cdepart'],
                                'cdetail': widget.document['cdetail'],
                                'cpublished': false,
                                'curi':widget.document['curi'],
                                'likes': likes[widget.itr],
                                'seens': seens[widget.itr],
                                'imgurl': widget.document['imgurl'],
                                'favcheck': true,
                              });
                              //////////*******************************************

                            } else {
                              setState(() {
                                likes[widget.itr]=likes[widget.itr]-1;

                              });
                              Firestore.instance.collection('videos')
                                  .document(widget.document['cId'])
                                  .updateData({
                                'likes':likes[widget.itr],
                              });
                              Firestore.instance
                                  .collection("favorite")
                                  .document(_userId)
                                  .collection("fav_offer_id")
                                  .document(widget.document['cId'])
                                  .delete();

                              Toast.show("تم الحذف فى المفضلة",
                                  context,
                                  duration: Toast.LENGTH_SHORT,
                                  gravity: Toast.BOTTOM);
                            }

                            ////////////////*************************
                          }
                        });
                      },
                      child: Container(
                        //decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.blue),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 0.0, bottom: 0.0),
                          child: favcheck[widget.itr]
                              ? Icon(
                            Icons.favorite,
                            size: 40.0,
                            color: Colors.red,
                          )
////
                              : Column(
                            children: <Widget>[
                              Icon(
                                Icons.favorite_border,
                                size: 40.0,
                                color: Colors.red,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 55,
                    left: 50,
                    child: Text("${likes[widget.itr]}",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold,
                        )),
                  ),
                  Positioned(
                    bottom: 55,
                    right: 8,
                    child: Text("مشاهدات:${seens[widget.itr]}",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold,
                        )),
                  ),
                  Positioned(
                    top: 70,
                    left:10,
                    right:  MediaQuery.of(context).size.width/3,
                    child:    Text(widget.document['ctitle'],
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold,
                        )),
                  ),
                ],
              ),
            );
          }
          else {
            return Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Center(
                child: CircularProgressIndicator(),),
            );
          }
        },
      );
    }
  }