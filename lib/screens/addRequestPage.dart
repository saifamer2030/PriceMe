import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:priceme/screens/widgets/brandsListPage.dart';
import 'package:priceme/screens/widgets/modelsListPage.dart';
import 'package:priceme/screens/widgets/yearsListPage.dart';

import 'package:priceme/ui_utile/myColors.dart';


class AddRequestPage extends StatefulWidget {
  @override
  _AddRequestPageState createState() => _AddRequestPageState();
}

class _AddRequestPageState extends State<AddRequestPage> with SingleTickerProviderStateMixin {

  TabController _tabController;
  PageController _pageController;
  int engineRadioValue= 1;
  int gearRadioValue= 1;

  String spBrand, spModel, spYear; // for spare parts
  String carBrand, carModel, carYear; // for cars

  String engineState = "غير محدد";
  String gearState = "غير محدد";

 @override
  void initState() {

    super.initState();
    _tabController = new TabController(length: 2, vsync: this);
    _pageController = PageController(
      initialPage: 0,
    );
  }

  @override
  void dispose() {

    super.dispose();
        _pageController.dispose();
    _tabController.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
           
           
            child: Column(
              
              children: [
                SizedBox(height: 20,),
                   Container(
                     height: 50,
                     child: Directionality(
                textDirection: TextDirection.rtl,
                child: TabBar(
                  unselectedLabelColor: Colors.grey,
                  labelColor: MyColors.primaryColor,
                  tabs: [

                      new Tab(
        child: Text(
          "أطلب قطع غيار",
          style: TextStyle(
            fontSize: 12,
            // fontFamily: MyFonts.fontFamily,
            fontWeight: FontWeight.bold,
          ),
        ),
                      ),
                      new Tab(
        child: Text(
          "أعرض سيارتك للبيع",
          style: TextStyle(
            fontSize: 12,
            //fontFamily: MyFonts.fontFamily,
            fontWeight: FontWeight.bold,
          ),
        ),
                      ),
                  ],
                  controller: _tabController,
                  indicatorColor: MyColors.primaryColor,
                  
                  indicatorSize: TabBarIndicatorSize.tab,
                ),
              ),
                   ),
        Divider(thickness: 0.5),
        Expanded(child:
        TabBarView(
        physics: NeverScrollableScrollPhysics(),
        children: [
          addSparePartTab(),
          scrapCarTab(),
        ],
        controller: _tabController,
        ) ),


              

 
              ],),
          ),
      );
  }

   Widget addSparePartTab(){
    return 
    Column(
      children: [
        Expanded(
          child:     SingleChildScrollView(
          child:
           Column(children: [
         SizedBox(
           height: 22,
         ),

         Text("أدخل المعلومات الخاصة بقطعة الغيار", 
         style: TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.w600)),
SizedBox(
           height: 16,
         ),

         Padding(
           padding: const EdgeInsets.symmetric(horizontal: 16),
           child: RaisedButton(
             
              padding: EdgeInsets.zero,
              shape:RoundedRectangleBorder(
                
                borderRadius: BorderRadius.circular(5.0)),
             onPressed: (){
               Navigator.push(context, MaterialPageRoute(
                 builder: (ctx) => BrandsListPage()
               )).then((value){
                 if(value != null){
                   setState((){
                     spBrand = value;
                   });
                 }
               });
             },
             color: Colors.white,
             child: Container(
               height: 46.0,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5.0),
                                  color: Colors.white,
                                  border: Border.all(width: 0.5, color: Colors.grey)
             ),
             child: Row(
               textDirection: TextDirection.rtl,
              
               children: [
                 Expanded(
                                    child: Text(
                   spBrand == null ?  'حدد الماركة' : spBrand,
                     style: TextStyle(

                       fontSize: 14,
                       color: Colors.black,
                       fontWeight: FontWeight.w600,

                     ),
                     textAlign: TextAlign.center,
                   ),
                 ),
                 Icon(Icons.arrow_back_ios, size: 15, color: Colors.grey,),
                 SizedBox(width: 10,)

               ],
             ),
             )
               
           ),
         ),

         SizedBox(height: 16,),

  Padding(
           padding: const EdgeInsets.symmetric(horizontal: 16),
           child: RaisedButton(
             
              padding: EdgeInsets.zero,
              
              shape:RoundedRectangleBorder(
                
                borderRadius: BorderRadius.circular(5.0)),
             onPressed: (){
               if(spBrand != null){
                  Navigator.push(context, MaterialPageRoute(
                 builder: (ctx) => ModelsListPage()
               )).then((value){
                 if(value != null){
                   setState((){
                     spModel = value;
                   });
                 }
               });
               }else{
                 Scaffold.of(context).showSnackBar(
                   SnackBar(content: Text("الرجاء تحديد اسم الماركة", 
                   style: TextStyle(fontSize: 12, color: Colors.white),)));
               }
              
             },
             color: Colors.white,
             child: Container(
               height: 46.0,
               decoration: BoxDecoration(
               borderRadius: BorderRadius.circular(5.0),
               color: Colors.white,
               border: Border.all(width: 0.5, color: Colors.grey)
             ),
             child: Row(
               textDirection: TextDirection.rtl,
              
               children: [
                 Expanded(
                                    child: Text(
                  spModel == null ?   'حدد الموديل': spModel,
                     style: TextStyle(
                       fontSize: 14,
                       color: spBrand == null? Colors.grey  : Colors.black,
                       ),
                     textAlign: TextAlign.center,
                   ),
                 ),
                 Icon(Icons.arrow_back_ios, size: 15, color: Colors.grey,),
                 SizedBox(width: 10,)

               ],
             ),
             )
               
           ),
         ),
        SizedBox(height: 16,),

           Padding(
           padding: const EdgeInsets.symmetric(horizontal: 16),
           child: RaisedButton(
             
              padding: EdgeInsets.zero,
              shape:RoundedRectangleBorder(
                
                borderRadius: BorderRadius.circular(5.0)),
             onPressed: (){
               if(spModel != null){
 Navigator.push(context, MaterialPageRoute(
                 builder: (ctx) => YearsListPage()
               )).then((value){
                 if(value != null){
                   setState((){
                     spYear = value;
                   });
                 }
               });
               }else{
                       Scaffold.of(context).showSnackBar(
                   SnackBar(content: Text("الرجاء تحديد الموديل ", 
                   style: TextStyle(fontSize: 12, color: Colors.white),)));
               }
              
             },
             color: Colors.white,
             child: Container(
               height: 46.0,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5.0),
                                  color: Colors.white,
                                  border: Border.all(width: 0.5, color: Colors.grey)
             ),
             child: Row(
               textDirection: TextDirection.rtl,
              
               children: [
                 Expanded(
                                    child: Text(
                  spYear == null ?   'حدد سنة الصنع' : spYear,
                     style: TextStyle(
                      fontSize: 14,
                       color: spModel == null? Colors.grey : Colors.black,
                      ),
                     textAlign: TextAlign.center,
                   ),
                 ),
                 Icon(Icons.arrow_back_ios, size: 15, color: Colors.grey,),
                 SizedBox(width: 10,)

               ],
             ),
             )
               
           ),
         ),

         SizedBox(height: 30,),

         Align(alignment: Alignment.centerRight, child: Padding(
           padding: const EdgeInsets.only(right: 16),
           child: Text("ضع وصفا أو  صورة للقطعة المطلوبة", textAlign: TextAlign.right, style: TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.bold),),
         )),
          SizedBox(height: 10,),
         Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: Container(
                              decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.0),
                            border: Border.all(color: Colors.grey[400], width: 0.8),
                         
                          ),
                              child: Row(
                                textDirection: TextDirection.rtl,
                                children: [
                                  IconButton(
                                    onPressed: (){},
                                    icon: Icon(Icons.add_a_photo, color: Colors.grey,)
                                  ),

                                 Expanded(
                                    child: Directionality(
                                      textDirection: TextDirection.rtl,
                                      child: TextFormField(
                                       textAlign: TextAlign.right,
                                       maxLines: null,
                                       keyboardType: TextInputType.multiline,
                                       style: TextStyle(fontSize: 12),
                                       decoration: InputDecoration(
                                          isDense: true,
                                         // filled: true,
                                          //fillColor: Colors.white,
                                          hintText: 'ضع وصفا للقطع المطلوبة',
                                          hintStyle: TextStyle(fontSize: 12, color: Colors.grey[400]),
                                          border: InputBorder.none,
                                         errorStyle: TextStyle(
                                            color: Colors.red,
                                            fontSize: 12.0),
                                          contentPadding:
                                          const EdgeInsets.only(left: 10.0, bottom: 6.0, top:6.0, right: 10),


                                        
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )),
       SizedBox(height: 20,),

       FlatButton(
         onPressed: (){},
         child: Row(
           textDirection: TextDirection.rtl,
           mainAxisAlignment: MainAxisAlignment.center,
           children: [
             Icon(Icons.add, color: MyColors.primaryColor,),
             SizedBox(width: 10,),
             Text("أضف قطعة أخرى", style: TextStyle(color: MyColors.primaryColor, fontSize: 12, fontWeight: FontWeight.bold),)
           ],
         ),
         
       )

      ],),
    )
        ),
        Container(
                height: 50,
                child: FlatButton(
                  
                  onPressed: (){},
                  color: MyColors.primaryColor,
                  child: Center(
                    child: Text("إرسال", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold))
                  ),
                ),
              ),
      ],
    )
    
    
    
    
;
  }

  Widget scrapCarTab(){
    return Column(
      children: [
        Expanded(
                  child: SingleChildScrollView(
                child:
                 Column(children: [
               SizedBox(
                 height: 22,
               ),

               Text("أدخل المعلومات الخاصة بالسيارة المعروضة للبيع ", 
               style: TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.w600)),
SizedBox(
                 height: 16,
               ),

               Padding(
                 padding: const EdgeInsets.symmetric(horizontal: 16),
                 child: RaisedButton(
                   
                    padding: EdgeInsets.zero,
                    shape:RoundedRectangleBorder(
                      
                      borderRadius: BorderRadius.circular(5.0)),
                   onPressed:  (){
               Navigator.push(context, MaterialPageRoute(
                 builder: (ctx) => BrandsListPage()
               )).then((value){
                 if(value != null){
                   setState((){
                     carBrand = value;
                   });
                 }
               });
             },
                   color: Colors.white,
                   child: Container(
                     height: 46.0,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5.0),
                                        color: Colors.white,
                                        border: Border.all(width: 0.5, color: Colors.grey)
                   ),
                   child: Row(
                     textDirection: TextDirection.rtl,
                    
                     children: [
                       Expanded(
                                          child: Text(
                      carBrand == null ?  'حدد الماركة' : carBrand,
                           style: TextStyle(

                             fontSize: 14,
                             color: Colors.black,
                             fontWeight: FontWeight.w600,
                             

                           ),
                           textAlign: TextAlign.center,
                         ),
                       ),
                       Icon(Icons.arrow_back_ios, size: 15, color: Colors.grey,),
                       SizedBox(width: 10,)

                     ],
                   ),
                   )
                     
                 ),
               ),

               SizedBox(height: 16,),

  Padding(
                 padding: const EdgeInsets.symmetric(horizontal: 16),
                 child: RaisedButton(
                   
                    padding: EdgeInsets.zero,
                    shape:RoundedRectangleBorder(
                      
                      borderRadius: BorderRadius.circular(5.0)),
                   onPressed: (){

                     if(carBrand != null){
  Navigator.push(context, MaterialPageRoute(
                 builder: (ctx) => ModelsListPage()
               )).then((value){
                 if(value != null){
                   setState((){
                     carModel = value;
                   });
                 }
               });
                     }else{
                               Scaffold.of(context).showSnackBar(
                   SnackBar(content: Text("الرجاء تحديد اسم الماركة", textAlign: TextAlign.center,
                   style: TextStyle(fontSize: 12, color: Colors.white, fontFamily: "Cairo"),),
                   duration: Duration(seconds: 2),
                   ));
                     }
             
             },
                   color: Colors.white,
                   child: Container(
                     height: 46.0,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5.0),
                                        color: Colors.white,
                                        border: Border.all(width: 0.5, color: Colors.grey)
                   ),
                   child: Row(
                     textDirection: TextDirection.rtl,
                    
                     children: [
                       Expanded(
                                          child: Text(
                          carModel == null? 'حدد الموديل' : carModel,
                           style: TextStyle(

                             fontSize: 14,
                             color: carBrand == null? Colors.grey : Colors.black,
                           ),
                           textAlign: TextAlign.center,
                         ),
                       ),
                       Icon(Icons.arrow_back_ios, size: 15, color: Colors.grey,),
                       SizedBox(width: 10,)

                     ],
                   ),
                   )
                     
                 ),
               ),
              SizedBox(height: 16,),

                 Padding(
                 padding: const EdgeInsets.symmetric(horizontal: 16),
                 child: RaisedButton(
                   
                    padding: EdgeInsets.zero,
                    shape:RoundedRectangleBorder(
                      
                      borderRadius: BorderRadius.circular(5.0)),
                   onPressed: (){
                     if(carModel != null){
 Navigator.push(context, MaterialPageRoute(
                 builder: (ctx) => YearsListPage()
               )).then((value){
                 if(value != null){
                   setState((){
                     carYear = value;
                   });
                 }
               });
                     }else{
                            Scaffold.of(context).showSnackBar(
                   SnackBar(content: Text("الرجاء تحديد الموديل ", textAlign: TextAlign.center,
                   style: TextStyle(fontSize: 12, color: Colors.white, fontFamily: "Cairo"),),
                   duration: Duration(seconds: 2),

                   ),
                   
                   );
                     }
              
             },
                   color: Colors.white,
                   child: Container(
                     height: 46.0,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5.0),
                                        color: Colors.white,
                                        border: Border.all(width: 0.5, color: Colors.grey)
                   ),
                   child: Row(
                     textDirection: TextDirection.rtl,
                    
                     children: [
                       Expanded(
                                          child: Text(
                         carYear == null?   'حدد سنة الصنع' : carYear,
                           style: TextStyle(
                            fontSize: 14,
                             color: carModel == null? Colors.grey : Colors.black,
                            ),
                           textAlign: TextAlign.center,
                         ),
                       ),
                       Icon(Icons.arrow_back_ios, size: 15, color: Colors.grey,),
                       SizedBox(width: 10,)

                     ],
                   ),
                   )
                     
                 ),
               ),

               SizedBox(height: 16,),

               Align(alignment: Alignment.centerRight, child: Padding(
                 padding: const EdgeInsets.only(right: 16),
                 child: Text("معلومات إضافية (إختياري)", textAlign: TextAlign.right, style: TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.bold),),
               )),

                SizedBox(height: 10,),

          StatefulBuilder(
            builder: (BuildContext ct, StateSetter setState){
              return Container(
                 color: Colors.white,
                 child: Column(
                   
                   children: [
                     FlatButton(
                       onPressed: (){
                         showEngineStateDialog(context, setState);
                       },
                       child: Container(
                        
                          padding: EdgeInsets.all(10),
                        child: Row(
                           textDirection: TextDirection.rtl,
                           children: [
                             Expanded(
                                                  child: Text("ماهي حالة المحرك ؟" , textAlign: TextAlign.right, textDirection: TextDirection.rtl,
                                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                                ),
                             ),
                            Text(engineState , textAlign: TextAlign.right, textDirection: TextDirection.rtl,
                                  style: TextStyle(fontSize: 10, color: Colors.grey),
                                ), 
                           SizedBox(width: 4,),
                           Icon(Icons.arrow_back_ios, size: 12, color: Colors.grey[400],),     
                           ],
                         ),
                       ),
                     ),
                     Padding(
                       padding: const EdgeInsets.symmetric(horizontal: 10),
                       child: Divider(),
                     ),
                          FlatButton(
                   onPressed: (){
                     showGearStateDialog(context, setState);
                   },
                   child: Container(
                     
                     padding: EdgeInsets.all(10),
                    child: Row(
                       textDirection: TextDirection.rtl,
                       children: [
                         Expanded(
                                              child: Text("ماهي حالة الترس ؟" , textAlign: TextAlign.right, textDirection: TextDirection.rtl,
                              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                            ),
                         ),
                        Text(gearState , textAlign: TextAlign.right, textDirection: TextDirection.rtl,
                              style: TextStyle(fontSize: 10, color: Colors.grey),
                            ), 
                       SizedBox(width: 4,),
                       Icon(Icons.arrow_back_ios, size: 12, color: Colors.grey[400],),     
                       ],
                     ),
                   ),
                 ),
                   ],
                 ),
               );
            },
          ),
               

              SizedBox(height: 10,),

             Align(
               alignment: Alignment.centerRight,
               child: Container(
                 height: 48,
                 width: 140,
                
                 child: FlatButton(
                   onPressed: (){},
                   child: Row(
                     textDirection: TextDirection.rtl,
                     children: [
                       Icon(Icons.add_a_photo, color: MyColors.primaryColor, size: 18,),
                       SizedBox(width: 4,),
                       Text("رفع الصورة", textDirection: TextDirection.rtl, textAlign: TextAlign.right,
                                          style: TextStyle(color: MyColors.primaryColor, fontSize: 12, fontWeight: FontWeight.w600),
                       )
                     ],
                   ),
                 ),
               ),
             ),   

            SizedBox(height: 10,)

            

            ],),
          ),
        ),

                Container(
                height: 50,
                child: FlatButton(
                  
                  onPressed: (){},
                  color: MyColors.primaryColor,
                  child: Center(
                    child: Text("إرسال", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold))
                  ),
                ),
              ),
      ],
    );
  }

 showEngineStateDialog(context, StateSetter state){
     
     showDialog(
       context: context,
       builder: (ctx){
         return AlertDialog(
           title: Text("حالة المحرك", textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),),
           
           content: 
           StatefulBuilder(
             builder: (BuildContext ct, StateSetter setState){
                return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              textDirection: TextDirection.rtl,
             children: [
               Directionality(
                 textDirection: TextDirection.rtl,
                              child: RadioListTile(
                   title: Text("غير محدد", style: TextStyle(fontSize: 12, color: Colors.black, fontWeight: FontWeight.w600),),
                   value: 1,
                   groupValue: engineRadioValue,
                   onChanged: (value){
                     setState.call(() {
                      engineRadioValue = value; 
                     });
                   },
                 ),
               ),
                Directionality(
                  textDirection: TextDirection.rtl,
                                child: RadioListTile(
                   title: Text("جيد", style: TextStyle(fontSize: 12, color: Colors.black, fontWeight: FontWeight.w600),),
                   value: 2,
                   groupValue: engineRadioValue,
                   onChanged: (value){
                     setState.call(() {
                      engineRadioValue = value; 
                     });
                   },
                   
               ),
                ),

                Directionality(
                  textDirection: TextDirection.rtl,
                                child: RadioListTile(
                   title: Text("تالف", style: TextStyle(fontSize: 12, color: Colors.black, fontWeight: FontWeight.w600)),
                   value: 3,
                   groupValue: engineRadioValue,
                   onChanged: (value){
                     setState.call(() {
                      engineRadioValue = value; 
                     });
                   },
               ),
                ),

Divider(thickness: 0.8,),

             Center(
               child: FlatButton(
                 onPressed: (){
                  
                   
                    
              
    switch(engineRadioValue){
      case 1: engineState = "غير محدد"; break;
      case 2: engineState = "جيد"; break;
      case 3: engineState = "تالف"; break;
      default: engineState = "غير محدد";
    }
    
     
      Navigator.of(ctx).pop(engineState);                 
                 },
                 child: Text("تأكيد", style: TextStyle(color: MyColors.secondaryColor, fontWeight: FontWeight.bold, fontSize: 14,))
               ),
             )   
             ],
         ); 
             },
                       
           )
          )
         ;
       } 
     ).then((value){
       state.call(() {});
     });
 }


 showGearStateDialog(context, StateSetter state){
     
     showDialog(
       context: context,
       builder: (ctx){
         return AlertDialog(
           title: Text("حالة الترس", textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),),
           
           content: 
           StatefulBuilder(
             builder: (BuildContext ct, StateSetter setState){
                return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              textDirection: TextDirection.rtl,
             children: [
               Directionality(
                 textDirection: TextDirection.rtl,
                              child: RadioListTile(
                   title: Text("غير محدد", style: TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w600),),
                   value: 1,
                   groupValue: gearRadioValue,
                   onChanged: (value){
                     setState.call(() {
                      gearRadioValue = value; 
                     });
                   },
                 ),
               ),
                Directionality(
                  textDirection: TextDirection.rtl,
                                child: RadioListTile(
                   title: Text("جيد", style: TextStyle(fontSize: 12, color: Colors.black, fontWeight: FontWeight.w600),),
                   value: 2,
                   groupValue: gearRadioValue,
                   onChanged: (value){
                     setState.call(() {
                      gearRadioValue = value; 
                     });
                   },
                   
               ),
                ),

                Directionality(
                  textDirection: TextDirection.rtl,
                                child: RadioListTile(
                   title: Text("تالف", style: TextStyle(fontSize: 12, color: Colors.black, fontWeight: FontWeight.w600)),
                   value: 3,
                   groupValue: gearRadioValue,
                   onChanged: (value){
                     setState.call(() {
                      gearRadioValue = value; 
                     });
                   },
               ),
                ),
Divider(thickness: 0.8,),
             Center(
               child: FlatButton(
                 onPressed: (){
                  
                   
                    
              
    switch(gearRadioValue){
      case 1: gearState = "غير محدد"; break;
      case 2: gearState = "جيد"; break;
      case 3: gearState = "تالف"; break;
      default: gearState = "غير محدد";
    }
    
     
      Navigator.of(ctx).pop(gearState);                 
                 },
                 child: Text("تأكيد", style: TextStyle(color: MyColors.secondaryColor, fontWeight: FontWeight.bold, fontSize: 14,))
               ),
             )   
             ],
         ); 
             },
                       
           )
          )
         ;
       } 
     ).then((value){
       state.call(() {});
     });
 }

}