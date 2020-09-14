
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
import 'package:priceme/classes/AdvClass.dart';
import 'package:priceme/screens/signin.dart';

import 'package:toast/toast.dart';
import 'package:video_player/video_player.dart';


class AllVideos extends StatefulWidget {


  AllVideos();

  @override
  _AllVideosState createState() => _AllVideosState();
}

class _AllVideosState extends State<AllVideos> {
  List<AdvClass> advlist = [];
  bool _load = false;
  String _userId="";
  String  worktype="";
  String tradertype="";

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
      body: Container(
        child: StreamBuilder(
          stream: Firestore.instance
              .collection('videos')
              .orderBy('carrange',
                  descending:
                      true) //.where("cproblemtype", isEqualTo:"قطع غيار")
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
                      height: 300.0,
                      alignment: Alignment.center,

                      child: Container(
                          key: new PageStorageKey(
                            "keydata$index",
                          ),

                          child: VideoWidget(
                            play: false,
                            url: snapshot.data.documents[index]["curi"],
                              title:snapshot.data.documents[index]["ctitle"],
                              details: snapshot.data.documents[index]["cdetail"]
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

//   Widget firebasedata(
//       BuildContext context, int index, DocumentSnapshot document) {
//     return Padding(
//       padding: const EdgeInsets.all(2.0),
//       child: Card(
//         shape: new RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(4.0)),
//         //borderOnForeground: true,
//         elevation: 10.0,
//         margin: EdgeInsets.only(right: 1, left: 1, bottom: 2),
//         child: InkWell(
//           onTap: () {
//             // Navigator.push(
//             //     context,
//             //     MaterialPageRoute(
//             //         builder: (context) =>
//             //             AdvDetail(document['userId'], document['advid'])));
//           },
//           child: Container(
//               child: Row(
//             children: <Widget>[
//               Column(
//                 children: <Widget>[
//                   Container(
//                     color: Colors.white,
//                     child: Center(
//                       child: document['curi'] == null
//                           ? new Image.asset(
//                               "assets/images/ic_logo2.png",
//                             )
//                           : new Image.network(
//                               document['curi'],
//                               fit: BoxFit.fitHeight,
//                             ),
//                     ),
//                     width: 100,
//                     height: 130,
//                   ),
//                   Container(
//                       child:
//                       SingleChildScrollView(
//                         physics: new BouncingScrollPhysics(),
//                         scrollDirection: Axis.vertical,
//                         child: Column(
//                           mainAxisSize: MainAxisSize.min,
//                           children: <Widget>[
//                             ListView.separated(
//                               shrinkWrap: true,
//                               cacheExtent: 1000,
//                               physics: NeverScrollableScrollPhysics(),
//                               scrollDirection: Axis.vertical,
//                               key: PageStorageKey(widget.position),
//                               addAutomaticKeepAlives: true,
//                               itemCount: itemList.isEmpty ? 0 : itemList.length,
//                               itemBuilder: (BuildContext context, int index) =>
//                                   Container(
//                                     width: double.infinity,
//                                     height: 350.0,
//                                     alignment: Alignment.center,
//
//                                     child: Container(
//                                         key: new PageStorageKey(
//                                           "keydata$index",
//                                         ),
//
//                                         child: VideoWidget(
//                                           play: true,
//
//                                           url: itemList.elementAt(index),
//                                         )
//                                     ),
//                                   ),
//                               separatorBuilder: (context, index) {
//                                 return Divider();
//                               },
//                             ),
//                           ],
//                         ),
//                       )
//                   )
//                   Padding(
//                     padding: const EdgeInsets.only(right: 5),
//                     child: Text(
//                       "منذ: ${document['cdate']}",
//                       textDirection: TextDirection.rtl,
//                       textAlign: TextAlign.right,
//                       style: TextStyle(
//                           color: Colors.black,
//                           fontSize: 10,
// //                                  fontFamily: 'Estedad-Black',
//                           fontStyle: FontStyle.normal),
//                     ),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.all(5.0),
//                     child: Text(
//                       document['ctitle'],
//                       textDirection: TextDirection.rtl,
//                       textAlign: TextAlign.right,
//                       style: TextStyle(
//                           color: Colors.green,
// //                                  fontFamily: 'Estedad-Black',
//                           fontWeight: FontWeight.bold,
//                           fontSize: 15.0,
//                           fontStyle: FontStyle.normal),
//                     ),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.all(5.0),
//                     child: Text(
//                       document['cdetail'],
//                       textDirection: TextDirection.rtl,
//                       textAlign: TextAlign.right,
//                       style: TextStyle(
//                           color: Colors.green,
// //                                  fontFamily: 'Estedad-Black',
//                           fontWeight: FontWeight.bold,
//                           fontSize: 15.0,
//                           fontStyle: FontStyle.normal),
//                     ),
//                   ),
//
//                 ],
//               ),
//             ],
//           )),
//         ),
//       ),
//     );
//   }
}
class VideoWidget extends StatefulWidget {

  final bool play;
  final String url;
  final String title;
  final String details;

  const VideoWidget({Key key, @required this.url, @required this.play, @required this.title, @required this.details})
      : super(key: key);

  @override
  _VideoWidgetState createState() => _VideoWidgetState();
}


class _VideoWidgetState extends State<VideoWidget> {
  VideoPlayerController videoPlayerController ;
  Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();
    videoPlayerController = new VideoPlayerController.network(widget.url);

    _initializeVideoPlayerFuture = videoPlayerController.initialize().then((_) {
      //       Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
      setState(() {});
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

              child: Card(
                key: new PageStorageKey(widget.url),
                elevation: 5.0,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Chewie(
                        key: new PageStorageKey(widget.url),
                        controller: ChewieController(
                          videoPlayerController: videoPlayerController,
                          aspectRatio: 3 / 2,
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
                    Padding(
                      padding: const EdgeInsets.only(right:10.0, left: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [

                          Icon(
                            Icons.favorite_border,
                            color: Colors.red,
                            size: 20,
                          ),
                          Text("مشاهدات:0"),
                          Text(widget.title),
                        ],
                      ),
                    ),
                    Align(
                        child: Text(widget.details,textDirection: TextDirection.rtl,),
                    ),

                  ],
                ),
              ),
            );
          }
          else {
            return Center(
              child: CircularProgressIndicator(),);
          }
        },
      );
    }
  }