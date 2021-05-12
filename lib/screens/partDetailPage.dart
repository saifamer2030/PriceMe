import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:priceme/ChatRoom/widget/chat.dart';
import 'package:priceme/screens/widgets/commentsList.dart';
import 'package:priceme/ui_utile/myColors.dart';
import 'package:priceme/ui_utile/myFonts.dart';

class PartDetailPage extends StatefulWidget {
  @override
  _PartDetailPageState createState() => _PartDetailPageState();
}

class _PartDetailPageState extends State<PartDetailPage> {

  bool isAddedFavorite = false;
  TextEditingController _commentInputController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
         appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 2,
        title: Text("التفاصيل", textAlign: TextAlign.right, textDirection: TextDirection.rtl,
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

      body: partDetailWidget(),
      ),
    );
  }

  Widget partDetailWidget(){
    return Stack(
      children: [
        Container(
          child: SingleChildScrollView(
            child: Column(
              textDirection: TextDirection.rtl,
              crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 220,
                child: Directionality(
                  textDirection: TextDirection.rtl,
                   child: Swiper(
                    
                    loop: false,
                    pagination: new SwiperPagination(
                                  builder: DotSwiperPaginationBuilder(
                                      color: Colors.grey[200],
                                      activeColor: Colors.cyan)),
                    control: new SwiperControl(
                                  size: 30, color: Colors.cyan),
                    itemCount: 5,
                    itemBuilder: (BuildContext context, int itemIndex){
                      return Container(
                           color: Colors.orange[200],
                           child: Center(
                            child: FlutterLogo(size: 100,)
                           ),
                      );
                    }
                  ),
                ),
              ),
              
              Padding(
                padding: EdgeInsets.only(right: 16, top: 10),
                child: Row(
                  textDirection: TextDirection.rtl,
                  children: [
                    Expanded(child: Text("باب أمامي",maxLines: 2, textDirection: TextDirection.rtl, textAlign: TextAlign.right, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold,),)),
                    SizedBox(width: 5,),
/*
                     Text(" 250 ريال ",textDirection: TextDirection.rtl, textAlign: TextAlign.right,
    style: TextStyle(fontSize: 14, color: MyColors.secondaryColor, fontWeight: FontWeight.bold,),),
*/
          RichText(
            textDirection: TextDirection.rtl,
            text: TextSpan(
              text: "1350",
              style: TextStyle(fontSize: 15, color: MyColors.primaryColor, fontWeight: FontWeight.bold, fontFamily: "Cairo"),
              children: <TextSpan>[
                TextSpan(text: " ر.س ",
              style: TextStyle(fontSize: 10, color: MyColors.primaryColor, fontFamily: "Cairo"),),
              
              ]
            ),
          ),
                  SizedBox(width: 10,),
                  ],
                ),

              ),
              Padding(
                padding: EdgeInsets.only(right: 16),
                child: Row(
                  textDirection: TextDirection.rtl,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text("نشر بتاريخ", textDirection: TextDirection.rtl, textAlign: TextAlign.right, style: TextStyle(fontSize: 10,color: Colors.grey),),
                    SizedBox(width: 8),
                    Text("10/05/2021",textDirection: TextDirection.rtl, textAlign: TextAlign.right, style: TextStyle(fontSize: 10,color: Colors.black),),
                  ],
                ),

              ),

               
            
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Row(
                children: [
                  Expanded(
                   child: Divider(thickness: 0.8, height: 16),
                  ),
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                      side: BorderSide(color: Colors.grey, width: 0.8)
                    ),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                      child:
                       Text("معلومات حول القطعة",textDirection: TextDirection.rtl, textAlign: TextAlign.right,
                        style: TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.bold,),),
                        )),
                        Expanded(
                   child: Divider(thickness: 0.8, height: 16),
                  ),
                ],
              ),
            ),

              

             

   Padding(
                padding: EdgeInsets.only(right: 16),
                child: Row(
                  textDirection: TextDirection.rtl,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(width: 150, 
                    child: Text("إسم الماركة",textDirection: TextDirection.rtl, textAlign: TextAlign.right,
                     style: TextStyle(fontSize: 12,color: Colors.grey, fontWeight: FontWeight.bold,),)),
                    FlutterLogo(size: 15,),
                    SizedBox(width: 8,),
                    Text("مارسيدس",textDirection: TextDirection.rtl, textAlign: TextAlign.right, style: TextStyle(fontSize: 12,color: Colors.black, fontWeight: FontWeight.w600,),)
                  ],
                ),

              ),
                Padding(
                padding: EdgeInsets.only(right: 16),
                child: Row(
                  textDirection: TextDirection.rtl,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                      Container( width: 150,
                       child: Text("إسم الموديل:", textDirection: TextDirection.rtl, textAlign: TextAlign.right,
                        style: TextStyle(fontSize: 12,color: Colors.grey, fontWeight: FontWeight.bold),)),
                    SizedBox(width: 8),
                    Text("cx500",textDirection: TextDirection.rtl, textAlign: TextAlign.right, style: TextStyle(fontSize: 12,color: Colors.black, fontWeight: FontWeight.w600),),
                  ],
                ),

              ),
              
              Padding(
                padding: EdgeInsets.only(right: 16),
                child: Row(
                  textDirection: TextDirection.rtl,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                      Container(width: 150,
                       child: Text("سنة الصنع:", textDirection: TextDirection.rtl, textAlign: TextAlign.right,
                        style: TextStyle(fontSize: 12,color: Colors.grey, fontWeight: FontWeight.bold),)),
                    SizedBox(width: 8),
                    Text("2005",textDirection: TextDirection.rtl, textAlign: TextAlign.right,
                     style: TextStyle(fontSize: 12,color: Colors.black, fontWeight: FontWeight.w600),),
                  ],
                ),

              ),
             

 Padding(
   padding: const EdgeInsets.symmetric(vertical: 16),
   child: Row(
                children: [
                  Expanded(
                   child: Divider(thickness: 0.8, height: 16),
                  ),
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                      side: BorderSide(color: Colors.grey, width: 0.8)
                    ),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                      child:
                       Text("معلومات حول البائع",textDirection: TextDirection.rtl, textAlign: TextAlign.right,
                        style: TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.bold,),),
                        )),
                        Expanded(
                   child: Divider(thickness: 0.8, height: 16),
                  ),
                ],
              ),
 ),

              Padding(
                padding: EdgeInsets.only(right: 16, top: 10),
                child: Row(
                  textDirection: TextDirection.rtl,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(width: 150, 
                    child: Text("عنوان المرآب(الكراج)",textDirection: TextDirection.rtl, textAlign: TextAlign.right,
                     style: TextStyle(fontSize: 12,color: Colors.grey, fontWeight: FontWeight.bold,),)),
                    
                    Text("مركز المدينة",textDirection: TextDirection.rtl, textAlign: TextAlign.right, style: TextStyle(fontSize: 12,color: Colors.black, fontWeight: FontWeight.w600,),)
                  ],
                ),

              ),
              Padding(
                padding: EdgeInsets.only(right: 16,),
                child: Row(
                  textDirection: TextDirection.rtl,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(width: 150, 
                    child: Text("رقم الهاتف",textDirection: TextDirection.rtl, textAlign: TextAlign.right,
                     style: TextStyle(fontSize: 12,color: Colors.grey, fontWeight: FontWeight.bold,),)),
                    
                    Text("0555555556",textDirection: TextDirection.rtl, textAlign: TextAlign.right, style: TextStyle(fontSize: 12,color: Colors.black, fontWeight: FontWeight.w600,),)
                  ],
                ),

              ), 

               Padding(
                 padding: const EdgeInsets.symmetric(vertical: 16),
                 child: Row(
              children: [
                  Expanded(
                   child: Divider(thickness: 0.8, height: 16),
                  ),
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                      side: BorderSide(color: Colors.grey, width: 0.8)
                    ),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                      child:
                       Text("الوصف",textDirection: TextDirection.rtl, textAlign: TextAlign.right,
                        style: TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.bold,),),
                        )),
                        Expanded(
                   child: Divider(thickness: 0.8, height: 16),
                  ),
              ],
            ),
               ),



                Padding(
                padding: EdgeInsets.only(right: 16,),
                child: Text("الج ووو مممم كككك كككك كككك لمن باب تجريبي تجريبي تجريبي تجريبي تجريبي تجريبي تجريبي تجريبي ",
                  maxLines: null,
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.right,
                  style: TextStyle(fontSize: 10, color: Colors.grey,),),

              ),

              SizedBox(height: 16,),

            Row(
             textDirection: TextDirection.rtl,
              children: [
                SizedBox(width: 16,),
                Text("التعليقات",textDirection: TextDirection.rtl, textAlign: TextAlign.right,
                  style: TextStyle(fontSize: 12, color: Colors.black, fontWeight: FontWeight.w600,),),
                SizedBox(width: 5,),
                Text("10",textDirection: TextDirection.rtl, textAlign: TextAlign.right,
                  style: TextStyle(fontSize: 12, color: Colors.black, fontWeight: FontWeight.bold,),),
                SizedBox(width: 10,),
                Expanded(
                  child: Divider(thickness: 0.8, height: 0.8,),
                )

              ],
            ),

              SizedBox(height: 10,),

            InkWell(
              onTap: (){
                showAddCommentBottomSheet();
              },
                child: Container(
                  height: 54,
                  margin: EdgeInsets.symmetric(horizontal: 16),
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey[300], width: 0.5)
                  ),
                  alignment: Alignment.centerRight,
                  child:  Text("أضف تعليقك الآن ...",textDirection: TextDirection.rtl, textAlign: TextAlign.right,
                    style: TextStyle(fontSize: 12, color: Colors.grey,),),
                ),
              ),



              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding:  EdgeInsets.only(right: 10),
                  child: Container(
                    width: 150,
                    child: FlatButton(
                      onPressed: (){
                        showCommentsBottomSheet();
                      },
                      child:  Row(
                        textDirection: TextDirection.rtl,
                        children: [
                          Text("إظهار التعليقات",textDirection: TextDirection.rtl, textAlign: TextAlign.right,
                            style: TextStyle(fontSize: 10, color: Colors.black, fontWeight: FontWeight.w600,),),
                          SizedBox(width: 4,),
                          Icon(Icons.arrow_drop_down,size: 15,)
                        ],
                      ),
                    ),
                  ),
                ),
              ),
/*
              Center(
                child: Text("لا توجد أي تعليقات",textDirection: TextDirection.rtl, textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 10, color: Colors.grey,),),
              ),
            */
              SizedBox(height: 64,)
            ],
            ),),
        ),

        Align(
          alignment: Alignment.bottomCenter,
                  child: Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: StatefulBuilder(
                builder: (ctx, setState){
                  return Container(

                
                child: Row(
                  textDirection: TextDirection.rtl,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RaisedButton(

                      onPressed: (){

                        setState.call(() {
                           isAddedFavorite = !isAddedFavorite;
                        });
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(topRight: Radius.circular(20),
                        bottomRight: Radius.circular(20)),

                        ),
                      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      color: MyColors.primaryColor,
                      elevation: 2,
                      child: Row(
                        textDirection: TextDirection.rtl,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(isAddedFavorite ? Icons.favorite  : Icons.favorite_border, color: Colors.white,size: 20,),
                          SizedBox(width: 8),
                          Text( isAddedFavorite ? "إزالة من المفضلة" : "أضف للمفضلة", textDirection: TextDirection.rtl, textAlign: TextAlign.right,
                          style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                        ],
                      )),

                    RaisedButton(
                        onPressed: (){
                         },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(20),
                              bottomLeft: Radius.circular(20)),

                        ),
                        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                        color: Colors.white,
                        elevation: 2,
                        child: Row(
                          textDirection: TextDirection.rtl,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.chat, color: MyColors.primaryColor, size: 20, ),
                            SizedBox(width: 8),
                            Text(  "مراسلة البائع" , textDirection: TextDirection.rtl, textAlign: TextAlign.right,
                              style: TextStyle(color: MyColors.primaryColor, fontSize: 12, fontWeight: FontWeight.bold),
                            ),
                          ],
                        )),
                  ],
                ),
              );
                },
                          
            ),
          ),
        ),
       
        
      ],
    );
  }

  showAddCommentBottomSheet(){
    showModalBottomSheet(context: context,
        isScrollControlled: true,
        backgroundColor: Colors.grey[100],
        builder: (BuildContext bc) {
           return Padding(
            padding: EdgeInsets.fromLTRB(16,16,16,MediaQuery.of(context).viewInsets.bottom, ),
             child: SingleChildScrollView(
               child: Column(
                 mainAxisSize: MainAxisSize.min,
                 children: [
                   Container(

                     decoration: BoxDecoration(
                         borderRadius: BorderRadius.circular(10),
                         border: Border.all(color: Colors.grey[400], width: 0.6),
                         color: Colors.white),
                     child:

                     Directionality(
                       textDirection: TextDirection.rtl,
                       child: TextField(
                         textAlignVertical: TextAlignVertical.top,
                         maxLines: 2,
                         controller:
                         _commentInputController,

                         style: TextStyle(
                             color: Colors.black,
                             fontSize: 14.0,
                             fontFamily: MyFonts.primaryFont),
                         textDirection: TextDirection.rtl,
                         decoration: InputDecoration(
                           errorStyle: TextStyle(
                               color: Colors.red,
                               fontSize: 15.0),
                           contentPadding: EdgeInsets.all(10),
                           hintText: "أضف تعليقك ...",
                           hintStyle: TextStyle(
                               color: Colors.grey,
                               fontSize: 12.0,
                               fontWeight: FontWeight.w300,
                               fontFamily: MyFonts.primaryFont),
                           border: InputBorder.none,
                           labelStyle: TextStyle(
                               color: Colors.black,
                               fontSize: 12.0,
                               fontFamily: MyFonts.primaryFont),
                         ),
                       ),
                     ),
                   ),

                   SizedBox(height: 20,),

                   Container(
                     height: 36,
                     width: 150,
                     decoration: BoxDecoration(
                         borderRadius: BorderRadius.circular(16),
                         color: MyColors.primaryColor),
                     child: RaisedButton(
                       elevation: 2,
                       shape: RoundedRectangleBorder(
                         borderRadius: BorderRadius.circular(12),
                       ),
                       onPressed: ()  {

                       },
                       color: MyColors.primaryColor,
                       child: Center(
                         child: Text(
                           'أضف تعليقك',
                           textAlign: TextAlign.center,
                           style: TextStyle(
                               color: Colors.white,
                               fontSize: 12,
                               fontWeight: FontWeight.bold,
                               fontFamily: MyFonts.primaryFont),
                         ),
                       ),
                     ),
                   ),
                   SizedBox(height: 16,),
                 ],
               ),
             ),
           );
        });
  }

  showCommentsBottomSheet(){
    showModalBottomSheet(context: context,
        isScrollControlled: true,
        isDismissible: false,
        backgroundColor: Colors.grey[100],
        builder: (BuildContext bc) {
          return Container(
            height: MediaQuery.of(context).size.height - 34,
            child: Padding(
              padding: EdgeInsets.only( bottom: MediaQuery.of(context).viewInsets.bottom, ),
              child: Column(

                children: [
                  AppBar(

                    centerTitle: true,
                    automaticallyImplyLeading: false,
                    backgroundColor: Colors.white,
                    elevation: 2,
                    title: Text("التعليقات", textAlign: TextAlign.right, textDirection: TextDirection.rtl,
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                    actions: [
                      IconButton(
                          onPressed: (){
                            Navigator.pop(bc);
                          },
                          icon: Icon(Icons.close)
                      ),

                      SizedBox(width: 10,)

                    ],
                  ),
                  Expanded(
                      child: CommentsList())
],
              ),
            ),
          );
        });
  }
}