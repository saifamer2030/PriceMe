import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';


class DisplayPhoto extends StatefulWidget {
  String imageUrl;
  DisplayPhoto(this.imageUrl);

  @override
  _DisplayPhotoState createState() => _DisplayPhotoState();
}

class _DisplayPhotoState extends State<DisplayPhoto> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        //color: Colors.grey[200],
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: widget.imageUrl == null
            ? SpinKitThreeBounce(
                size: 35,
                color: const Color(0xff171732),
              )
            :Image.network(widget.imageUrl ,fit: BoxFit.contain,),


//            Swiper(
//                    loop: false,
//                    duration: 1000,
//                    autoplay: false,
//                    autoplayDelay: 15000,
//                    itemCount: widget.imageUrls.length,
//                    pagination: new SwiperPagination(
//                      margin: new EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
//                      builder: new DotSwiperPaginationBuilder(
//                          color: Colors.grey,
//                          activeColor: const Color(0xff171732),
//                          size: 8.0,
//                          activeSize: 8.0),
//                    ),
//                    control: new SwiperControl(),
//                    viewportFraction: 1,
//                    scale: 0.1,
//                    outer: false,
//                    itemBuilder: (BuildContext context, int index) {
//                      return InteractiveViewer(
//                        minScale: 0.1,
//                        maxScale: 8.6,
//                        child: Image.network(widget.imageUrls[index],
//                            fit: BoxFit.contain, loadingBuilder:
//                                (BuildContext context, Widget child,
//                                    ImageChunkEvent loadingProgress) {
//                          if (loadingProgress == null) return child;
//                          return SpinKitThreeBounce(
//                            color: const Color(0xff171732),
//                            size: 35,
//                          );
//                        }),
//                      );
//                    },
//                  ),
        // Swiper(
        //         loop: true,
        //         duration: 1000,
        //         autoplay: false,
        //         autoplayDelay: 15000,
        //         itemCount: widget.imageUrls.length,
        //         pagination: new SwiperPagination(
        //           margin: new EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
        //           builder: new DotSwiperPaginationBuilder(
        //               color: Colors.grey,
        //               activeColor: const Color(0xff171732),
        //               size: 8.0,
        //               activeSize: 8.0),
        //         ),
        //         control: new SwiperControl(),
        //         viewportFraction: 1,
        //         scale: 0.1,
        //         outer: true,
        //         // itemBuilder: (BuildContext context, int index) {
        //         //   return InteractiveViewer(
        //         //     minScale: 0.1,
        //         //     maxScale: 8.6,
        //         //     child: Image.network(widget.imageUrls[index],
        //         //         fit: BoxFit.contain, loadingBuilder:
        //         //             (BuildContext context, Widget child,
        //         //                 ImageChunkEvent loadingProgress) {
        //         //       if (loadingProgress == null) return child;
        //         //       return SpinKitThreeBounce(
        //         //         color: const Color(0xff171732),
        //         //         size: 35,
        //         //       );
        //         //     }),
        //         //   );
        //         // },
        //       )
      ),
    );
  }
}
