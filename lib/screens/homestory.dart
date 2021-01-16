import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:priceme/classes/stories.dart';

import 'package:story_view/story_view.dart';

class HomeStory extends StatefulWidget {
  int carrange;

  HomeStory(this.carrange);

  @override
  _HomeStoryState createState() => _HomeStoryState();
}

class _HomeStoryState extends State<HomeStory> {
//  List<Photo> photos = [];
  final storyController = StoryController();
  List<StoryItem> storyItems = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
   // final SparePartsReference = Firestore.instance;
    Firestore.instance
        .collection('videos')
        .orderBy('seens', descending: true)
        .where("seens", isLessThanOrEqualTo:widget.carrange)
        .limit(5)
      //   .orderBy('seens', descending: true)

        .getDocuments()
        .then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((story) {
        print( story.toString() + "llll");

        Stories spc = Stories(
          story.data['curi'],
          story.data['cname'],
          story.data['ctitle'],

        );
        print( story.data['ctitle'].toString() + "llll");

        setState(() {
          storyItems.add(StoryItem.pageVideo(
            story.data['curi'],
              controller: storyController,
           caption:"${story.data['cname']},${story.data['ctitle']}",
          ));
          print(storyItems.length.toString() + "llll");
        });
      });
    });


    // Timer(Duration(seconds: 0), () async {
    //   getCompanyphoto(widget.company.id).then((v) async {
    //     setState(() {
    //       photos.addAll(v);
    //       if((photos==null)||(photos.length==0)){
    //         storyItems.add(StoryItem.pageImage(
    //           url:widget.company.coverURL,
    //           caption: "",
    //           controller: storyController,
    //         ));
    //       }else{
    //         for(int j=0;j<photos.length;j++){
    //           storyItems.add(StoryItem.pageImage(
    //             url: photos[j].Url,
    //             caption: "",
    //             controller: storyController,
    //           ));
    //
    //         }
    //       }
    //
    //     });
    //   });
    //   print("hhh1");
    // });
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Container(
          width: double.infinity,
          height: double.infinity,

          child:(storyItems.length==0||storyItems==null)?Container():

          StoryView(
            storyItems: storyItems,
            // [
            //   StoryItem.text(
            //     title: "I guess you'd love to see more of our food. That's great.",
            //     backgroundColor: Colors.blue,
            //   ),
            //   StoryItem.text(
            //     title: "Nice!\n\nTap to continue.",
            //     backgroundColor: Colors.red,
            //
            //   ),
            //   StoryItem.pageImage(
            //     url:
            //     "https://image.ibb.co/cU4WGx/Omotuo-Groundnut-Soup-braperucci-com-1.jpg",
            //     caption: "Still sampling",
            //     controller: storyController,
            //   ),
            //   StoryItem.pageImage(
            //       url: "https://media.giphy.com/media/5GoVLqeAOo6PK/giphy.gif",
            //       caption: "Working with gifs",
            //       controller: storyController),
            //   StoryItem.pageVideo(
            //     "https://firebasestorage.googleapis.com/v0/b/priceme-49386.appspot.com/o/video%2F2020-09-17%2016%3A08%3A58.216357.mp4?alt=media&token=9e4212fb-7553-4cb2-8f68-28cd4432e6fd",
            //     caption: "Hello, from the other side",
            //     controller: storyController,
            //   ),
            //   StoryItem.pageVideo(
            //      "https://firebasestorage.googleapis.com/v0/b/priceme-49386.appspot.com/o/video%2F2020-11-29%2009%3A20%3A59.313442.mp4?alt=media&token=571a7287-1b6f-4944-b0e7-188fd6111bfd",
            //     caption: "Hello, from the other side2",
            //     controller: storyController,
            //   ),
            // ],
            onStoryShow: (s) {
              print("Showing a story");
            },
            onComplete: () {
              Navigator.pop(context);
            },
            progressPosition: ProgressPosition.top,
            repeat: true,
            controller: storyController,
          ),

      ),
    );
  
  
  }


}