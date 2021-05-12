import 'package:flutter/material.dart';
import 'package:priceme/screens/partDetailPage.dart';
import 'package:priceme/ui_utile/myColors.dart';

class FavoritePage extends StatefulWidget {
  @override
  _FavoritePageState createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {

  var _favController = ScrollController();
  List favoriteList = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 2,
        title: Text("المفضلة", textAlign: TextAlign.right, textDirection: TextDirection.rtl,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
              onPressed: (){
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_forward)
          ),

          SizedBox(width: 10,)

        ],
      ),

      body: favoriteWidget()
    );
  }

  Widget favoriteWidget(){
    return Padding(
        padding: EdgeInsets.all(10),
      child:
      favoriteList.length == 0 ?
      Center(child: emptyFavorite()) :
      ListView.builder(
        physics: BouncingScrollPhysics(),
        shrinkWrap: true,
        itemCount: favoriteList.length,
        controller: _favController,
        itemBuilder: (ctx, index){
          return itemWidget(index);
        },
      ),
    );
  }

  Widget itemWidget(int index){
    return InkWell(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(
            builder: (ctx)  => PartDetailPage()));
      },
      child: Card(
        elevation: 2,

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Container(
          padding: EdgeInsets.only(left: 10),
          child: Row(
            textDirection: TextDirection.rtl,
            children: [
              Container(
                height: 104,
                width: 110,
                decoration: BoxDecoration(
                    color:Colors.orange[100],
                    borderRadius: BorderRadius.only(topRight: Radius.circular(8), bottomRight: Radius.circular(8))
                ),
                child: Center(
                  child: FlutterLogo(size: 50,),
                ),
              ),

              Expanded(
                child: Container(
                  padding: EdgeInsets.all(10),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    textDirection: TextDirection.rtl,
                    children: [
                      Text("إسم القطعة", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold ),),

                      Row(
                        textDirection: TextDirection.rtl,

                        children: [
                          Icon(Icons.car_repair, color: Colors.grey, size: 15),
                          Text("مارسيدس - سييرا - 2005", textDirection: TextDirection.rtl,
                            style: TextStyle(fontSize: 10, color: Colors.grey ),),


                        ],
                      ),
                      Row(
                        textDirection: TextDirection.rtl,

                        children: [
                          Icon(Icons.store, color: Colors.grey, size: 15),
                          Text("مركز المدينة", textDirection: TextDirection.rtl,
                            style: TextStyle(fontSize: 10, color: Colors.grey ),),


                        ],
                      ),
                      Text("25 ريال", textDirection: TextDirection.rtl,
                        style: TextStyle(fontSize: 12, color: MyColors.primaryColor ,fontWeight: FontWeight.bold ),)
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget emptyFavorite(){
    return Container(
      width: 250,
      height: 254,
      child: Stack(

        children: [
          Opacity(
            opacity: 0.5,
            child: Image.asset("assets/images/empty_favorite.png"),
          ),


          Positioned(
            top: 190,
            left: 85,

            child: Text("المفضلة فارغة", textDirection: TextDirection.rtl,
              style: TextStyle(fontSize: 12, color: MyColors.primaryColor, fontWeight: FontWeight.bold ),),
          ),

          Positioned(
            top: 212,
            left: 20,

            child: Text("لم تقم بإضافة أي عروض للمفضلة لحد الآن",
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.center,
              maxLines: 2,
              style: TextStyle(fontSize: 12, color: Colors.grey[600], ),),
          ),
        ],
      ),
    );
  }
}
