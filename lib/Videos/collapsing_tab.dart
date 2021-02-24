import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:priceme/Videos/addVideo.dart';
import 'package:priceme/Videos/allvideos.dart';
import 'package:priceme/Videos/photosvideocomercial.dart';
import 'package:priceme/Videos/photosvideoentertainment.dart';
import 'package:priceme/ui_utile/myColors.dart';


class CollapsingTab extends StatefulWidget {
  @override
  _CollapsingTabState createState() => new _CollapsingTabState();
}

class _CollapsingTabState extends State<CollapsingTab> with SingleTickerProviderStateMixin {

  TabController _tabController;
  ScrollController scrollController;
  bool exbandedsliver=false;
  bool enableFilter = false;
  int tapIndex = 0;
String _cType;

  @override
  void dispose() {
    super.dispose();

    scrollController.dispose();
    _tabController.dispose();

  }
  Widget firebasedata(
      BuildContext context, int index, DocumentSnapshot document) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => AllVideos(document['carrange'],null,null)));
        // _onInstagramStorySwipeClicked();
      },
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Stack(
          children: [
            Container(
              height: 200,
              width: 150,
              decoration: BoxDecoration(
                border: new Border.all(
                  color: Colors.black,
                  width: 1,
                ),
                image: document['imgurl'] == null
                    ? DecorationImage(
                  image: AssetImage("assets/images/ic_background.png"),
                  fit: BoxFit.fill,
                )
                    : DecorationImage(
                  image: NetworkImage(document['imgurl']),
                  fit: BoxFit.fill,
                ),
                borderRadius: BorderRadius.circular(9.0),
              ),
            ),
            Positioned(
                top: 90,
                left: 60,
                child: Container(
                  child: Icon(
                    Icons.play_circle_outline,
                    color: Colors.white,
                    size: 35,
                  ),
                )),
            Positioned(
                bottom: 10,
                right: 5,
                child: Container(
                  child: Text( document['ctitle']==null||document['ctitle']==""?"عنوان غير معلوم":document['ctitle']
                    ,style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold),),
                )),
            Positioned(
              top: 5,
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
                    image: NetworkImage(document['cphotourl']==null||document['cphotourl']==""?
                    "https://i.pinimg.com/564x/0c/3b/3a/0c3b3adb1a7530892e55ef36d3be6cb8.jpg"  :document['cphotourl']),
                    fit: BoxFit.fill,
                  ),
                  shape: BoxShape.circle,
                ),
              ),

            ),
          ],
        ),
      ),
    );
  }
  @override
  void initState() {
    super.initState();
    scrollController = new ScrollController();
    scrollController.addListener(() => setState(() {}));
    _tabController = new TabController(length: 2, vsync: this);
    FirebaseAuth.instance.currentUser().then((user) => user == null
        ? null
        : setState(() {
     String _userId = user.uid;
      var userQuery = Firestore.instance.collection('users').where('uid', isEqualTo: _userId).limit(1);
      userQuery.getDocuments().then((data){
        if (data.documents.length > 0){
          setState(() {
            _cType = data.documents[0].data['cType'];
          });
        }
      });
    }));
  }

  @override
  Widget build(BuildContext context) {

    /*
    var flexibleSpaceWidget = new SliverAppBar(
      leading: new Container(),

      expandedHeight:exbandedsliver? 200.0:50,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
          centerTitle: true,
          title:  Transform.translate(
            offset: Offset(0.0, 25.0),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("الفيديوهات",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12.0,
                      )),
                  IconButton(
                    icon: Icon(exbandedsliver?Icons.keyboard_arrow_up:Icons.keyboard_arrow_down),
                    color: Colors.white,
                    onPressed: () {
                      setState(() {
                        exbandedsliver=!exbandedsliver;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),

        background: Padding(
          padding: const EdgeInsets.only(top:20.0,bottom:50),
          child: Container(
            //color: Colors.white,
            // height: 100,
            child: StreamBuilder(
              stream: Firestore.instance
                  .collection('videos')
                  .orderBy('seens', descending: true)
                  .limit(5) //.where("cproblemtype", isEqualTo:"قطع غيار")
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                      child: Text(
                        "Loading..",
                      ));
                }

                return new ListView.builder(
                    reverse: true,
                    physics: BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    // controller: _controller,
                    itemCount: snapshot.data.documents.length,
                    itemBuilder: (context, index) {
                      return firebasedata(
                          context, index, snapshot.data.documents[index]);
                    });
              },
            ),
          ),
        ),

      ),

    );
   */

    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: ( _cType =="trader")? Align(
        alignment: Alignment.bottomLeft,
        child: Padding(
          padding: const EdgeInsets.only(left:25),
          child: FloatingActionButton(
            backgroundColor: MyColors.secondaryColor,
            //const Color(0xff43AAAF),
            heroTag: "unique29",
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (cont18ext) =>
                          AddVideo()));
            },
            //backgroundColor: Colors.white,
            // elevation: 20.0,
            child: Container(
              height: 100,
              child: Icon(
                Icons.video_call,
                size: 32,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ):Container(),

      body:
      videosTabsScreen()
          /*
      new DefaultTabController(
        length: 2,
        child: NestedScrollView(
          controller: scrollController,
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
             flexibleSpaceWidget,
            //  Container(height: 50,),
              SliverPersistentHeader(
                delegate: _SliverAppBarDelegate(
                  TabBar(
                    labelColor: Colors.black87,
                    unselectedLabelColor: Colors.black26,
                    tabs: [

                      Tab( text:  "تجارى",),
                      Tab( text:  "ترفيهى",),

                    ],
                  ),
                ),
                pinned: true,
              ),
            ];
          },
          body: new TabBarView(
            children: <Widget>[
              VidiosPhotoComercial(),
              VidiosPhotoEntertainment(),

            ],
          ),
        ),
      ),
      */


    );
  }

  Widget videosTabsScreen(){
    return Column(
       textDirection: TextDirection.rtl,
      children: [
        SizedBox(height: 24,),
        Container(
          height: 40,
          child: Stack(
            children: [
              Align(
                alignment: Alignment.center,
                child: Container(
                    height: 40,
                    width: 180,

                    child: Directionality(
                      textDirection: TextDirection.rtl,
                      child: TabBar(
                        unselectedLabelColor: Colors.grey,
                        labelColor: Colors.deepOrange,
                        tabs: [

                          new Tab(
                            child: Text(
                              "تجاري",
                              style: TextStyle(
                                fontSize: 12,
                                // fontFamily: MyFonts.fontFamily,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          new Tab(
                            child: Text(
                              "ترفيهي",
                              style: TextStyle(
                                fontSize: 12,
                                //fontFamily: MyFonts.fontFamily,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                        controller: _tabController,
                        indicatorColor: Colors.black,
                        indicatorSize: TabBarIndicatorSize.label,
                        onTap: (index){
                          tapIndex = index;
                        },
                      ),
                    ),
                  ),

              ),
              Align(
                  alignment: Alignment.centerRight,
                  child: InkWell(
                      onTap: () {
                        setState(() {
                          enableFilter = !enableFilter;
                        });
                      },
                      child: Container(
                        height: 40,
                        width: 40,
                        padding: EdgeInsets.only(top:4),
                        margin: EdgeInsets.only(right: 8),
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.filter_list,
                          size: 24,
                          color: enableFilter == true
                              ? Colors.deepOrange
                              : Colors.grey,
                        ),
                      )))
            ],
          ),
        )
        ,
        SizedBox(height: 8,),

        Expanded(child:TabBarView(
          physics: NeverScrollableScrollPhysics(),
          children: [
            VidiosPhotoComercial(enableFilter),
            VidiosPhotoEntertainment(enableFilter),

          ],
          controller: _tabController,
        ) )

      ],
    );
  }

}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar _tabBar;

  _SliverAppBarDelegate(this._tabBar);

  @override
  double get minExtent => _tabBar.preferredSize.height;

  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return new Container(
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
