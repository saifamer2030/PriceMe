import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProfileAdv extends StatefulWidget {
  @override
  _ProfileAdvState createState() => _ProfileAdvState();
}

class _ProfileAdvState extends State<ProfileAdv> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffffffff),
      body: Column(
        children: [
          Container(
            height: 127.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(36.0),
                bottomLeft: Radius.circular(36.0),
              ),
              gradient: LinearGradient(
                begin: Alignment(0.0, -1.0),
                end: Alignment(0.0, 1.0),
                colors: [
                  const Color(0xffffffff),
                  const Color(0xfff8a623),
                  const Color(0xfff66c6c)
                ],
                stops: [0.0, 0.0, 1.0],
              ),
              border: Border.all(width: 1.0, color: const Color(0xffa5a5a5)),
              boxShadow: [
                BoxShadow(
                  color: const Color(0x8c6583f3),
                  offset: Offset(0, 5),
                  blurRadius: 50,
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'طلب تسعيرة',
                  style: TextStyle(
                    fontFamily: 'Helvetica Neue',
                    fontSize: 20,
                    color: const Color(0xffffffff),
                  ),
                  textAlign: TextAlign.left,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 15),
                      child: SvgPicture.string(
                        _svg_8d4kp7,
                        allowDrawingOutsideViewBox: true,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          Expanded(
              child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10, left: 5, right: 5),
                child: Container(
                  height: 170,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        offset: Offset(0, 3),
                        blurRadius: 3,
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
//                      width: _controller.value,
//                      height: _controller.value,
                        height: 100.0,
                        width: 100.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          border: Border.all(width: 1.0, color: Colors.black),
//                          color: Colors.white,
                          image: DecorationImage(
                            image: AssetImage('assets/images/antenna.png'),
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Text(
                          "وصف الإعلان هنا بالكامل يكتب نص إلي اخرة",
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 30,
                        ),
                        child: Text(
                          "٥٠ ريال",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
               Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "التعليقات",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Icon(
                                  Icons.attach_money,
                                  size: 30,
                                  color: Colors.green,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Icon(
                                  Icons.stars,
                                  size: 30,
                                  color: Colors.amber,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                        Container(
                          height: 100,
                          color: Colors.grey[300],
                          child: Column(
                            children: [
                              Container(
                                color: Colors.white,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "الاسم",
                                        style: TextStyle(fontSize: 12,color: Colors.black),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    )
                  ],

          )
    )
        ],
      ),
    );
  }
}

const String _svg_8d4kp7 =
    '<svg viewBox="17.2 73.0 10.4 18.1" ><path transform="translate(5.96, 66.81)" d="M 14.37271213531494 15.24925994873047 L 21.2272834777832 8.400084495544434 C 21.73423004150391 7.893136978149414 21.73423004150391 7.073392868041992 21.2272834777832 6.571838855743408 C 20.72033309936523 6.064892292022705 19.90059280395508 6.070285797119141 19.39364242553711 6.571838855743408 L 11.62764930725098 14.33244228363037 C 11.13688087463379 14.82320880889893 11.12609481811523 15.61059379577637 11.5898962020874 16.1175422668457 L 19.38825225830078 23.93207550048828 C 19.6417236328125 24.18554878234863 19.97609329223633 24.3095874786377 20.30506896972656 24.3095874786377 C 20.6340446472168 24.3095874786377 20.96841430664062 24.18554878234863 21.22188949584961 23.93207550048828 C 21.72883605957031 23.42512893676758 21.72883605957031 22.60538482666016 21.22188949584961 22.10383033752441 L 14.37271213531494 15.24925994873047 Z" fill="#ffffff" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>';
