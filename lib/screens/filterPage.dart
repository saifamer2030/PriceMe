import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:priceme/classes/filterType.dart';
import 'package:priceme/screens/widgets/brandsListPage.dart';
import 'package:priceme/screens/widgets/modelsListPage.dart';
import 'package:priceme/screens/widgets/yearsListPage.dart';
import 'package:priceme/ui_utile/myColors.dart';

class FilterPage extends StatefulWidget {

  FilterType filterType;   
  FilterPage({@required this.filterType});
  @override
  _FilterPageState createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {

    List<String> partsName = [
    "محرك",
    "عجلة",
    "إطار",
    "قطعة اضافية",
    "باب",
    "شبك",
    "دينامو",
    "مروحة",
    "دواسة",
    "جناح",
    "سماعة",
    "كمبيوتر",
    "موتور",
    "مقعد",
    "سكان",
    "مرايا",
    "اسطاب",
    "سماعة",
    "نوافذ"
  ];

  String sortBy = "الأحدث";
  int sortRadioValue = 1;
  String brand, model, year;
  List selectedParts = [];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 2,
          centerTitle: true,
          title: Text("فلترة الطلبات", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),),
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              onPressed: (){
                Navigator.pop(context);
              },
              icon: Icon(Icons.close, color: Colors.grey,),
            ),

            SizedBox(width: 10,),
          ],
          leading: IconButton(
             onPressed: (){
               setState(() {

                 // reset data
                sortBy = "الأحدث";
                sortRadioValue = 1;
                brand = null;
                model = null;
                year = null; 
               });
             },
             icon: Icon(Icons.refresh, color: Colors.grey),
          )
        ),
        body: filterWidget(),
      ),
    );
  }

  Widget filterWidget(){
    return Column(
      children: [
        Expanded(
                  child: SingleChildScrollView(
              child: Column(
                children: [

                  SizedBox(height: 6,),

                  InkWell(
 
                onTap: (){
                  showSortDialog(context);
                },
                child: Container(
                      height: 50, 
                      
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                       color: Colors.white,
                          boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 0.8,
                                blurRadius: 0.8,
                                offset: Offset(0, 0.3), // changes position of shadow
                              ),
                            ],
                      ),
                      child: Row(
                        textDirection: TextDirection.rtl,
                       children: [
                          Icon(FontAwesomeIcons.sortAlphaDownAlt, size: 20,),
                          SizedBox(width: 8,),
                          Expanded(
                                              child: Text("ترتيب حسب", textAlign: TextAlign.right,
                                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                          ),
                        Text(sortBy, textAlign: TextAlign.right,
                                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                            ), 

                        SizedBox(width: 8,),

                        Icon(Icons.arrow_back_ios, color: Colors.grey, size: 15,)     
                       ],
                      ),
                    ),
                  ),

                  SizedBox(height: 16,),

                  InkWell(
                    onTap: (){
                     
               Navigator.push(context, MaterialPageRoute(
                 builder: (ctx) => BrandsListPage()
               )).then((value){
                 if(value != null){
                   setState((){
                     brand = value;
                   });
                 }
               });
           
                    },
                                child: Container(
                      height: 50,
                      
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                       color: Colors.white,
                          boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 0.8,
                                blurRadius: 0.8,
                                offset: Offset(0, 0.3), // changes position of shadow
                              ),
                            ],
                      ),
                      child: Row(
                        textDirection: TextDirection.rtl,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(brand == null ? "الماركة": brand, textAlign: TextAlign.right, 
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold,),),
                      Icon(Icons.arrow_back_ios, color: Colors.grey, size: 15),
                        ],
                      ),
                    ),
                  ),

                  InkWell(
                    onTap:  (){
                 if(brand != null){
Navigator.push(context, MaterialPageRoute(
                 builder: (ctx) => ModelsListPage()
               )).then((value){
                 if(value != null){
                   setState((){
                     model = value;
                   });
                 }
               });
                 }else{
                          Scaffold.of(context).showSnackBar(
                   SnackBar(content: Text("الرجاء تحديد اسم الماركة", textAlign: TextAlign.center,
                   style: TextStyle(fontSize: 12, color: Colors.white, fontFamily: "Cairo"),),
                   duration: Duration(seconds: 2)
                   ));

                 }     
               

             },
                                child: Container(
                      height: 50,
                      
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                       color: Colors.white,
                          boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 0.8,
                                blurRadius: 0.8,
                                offset: Offset(0, 0.3), // changes position of shadow
                              ),
                            ],
                      ),
                      child: Row(
                        textDirection: TextDirection.rtl,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(model == null ?"الموديل" : model, textAlign: TextAlign.right, 
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: brand == null? Colors.grey : Colors.black),),
                      Icon(Icons.arrow_back_ios, color: Colors.grey, size: 15),
                        ],
                      ),
                    ),
                  ),

                  InkWell(
                    onTap: (){
                  if(model != null){
  Navigator.push(context, MaterialPageRoute(
                 builder: (ctx) => YearsListPage()
               )).then((value){
                 if(value != null){
                   setState((){
                     year = value;
                   });
                 }
               });
                  }else{
           Scaffold.of(context).showSnackBar(
                   SnackBar(content: Text("الرجاء تحديد الموديل ", textAlign: TextAlign.center, 
                   style: TextStyle(fontSize: 12, color: Colors.white, fontFamily: "Cairo"),),
                   duration: Duration(seconds: 2)
                   ));
                  }    
                    
                    },
                      child: Container(
                      height: 50,
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                       color: Colors.white,
                          boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 0.8,
                                blurRadius: 0.8,
                                offset: Offset(0, 0.3), // changes position of shadow
                              ),
                            ],
                      ),
                      child: Row(
                        textDirection: TextDirection.rtl,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(year == null ? "سنة الصنع" : year, textAlign: TextAlign.right, 
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: year == null ? Colors.grey : Colors.black)),
                      Icon(Icons.arrow_back_ios, color: Colors.grey, size: 15),
                        ],
                      ),
                    ),
                  ),
                  
                  SizedBox(height: 16,),
                  
                  Container(
                    color: Colors.white,
                    width: double.infinity,
                    padding: EdgeInsets.only(right: 16, top: 10),
                     child: Text("القطع المتوفرة", textAlign: TextAlign.right, 
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold,),)
                  ),
                  Container(
                    padding: EdgeInsets.all(10) ,
                    
                    color: Colors.white,
                    child: Wrap(
                      direction: Axis.horizontal,
                      spacing: 10,
                      runSpacing: 5,
                      textDirection: TextDirection.rtl,
                      children: partsName.map((value){
                        return RaisedButton(
                          onPressed: (){
                            setState(() {
                               if(selectedParts.contains(value)){
                              selectedParts.remove(value);
                            }else{
                              selectedParts.add(value);
                            }
                            });
                           
                          },
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          elevation: 2,
                          color: selectedParts.contains(value) ? MyColors.primaryColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8),
                           side: BorderSide(color: MyColors.primaryColor, width: 1)),
                          child: Row(
                            textDirection: TextDirection.rtl,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.car_rental, size: 15, 
                              color: selectedParts.contains(value) ? Colors.black :  Colors.grey,),
                              SizedBox(width: 5,),
                              Text(value, textAlign: TextAlign.center, 
                              style: TextStyle(color: selectedParts.contains(value) ? Colors.white : MyColors.primaryColor,
                               fontSize: 12),),
                              SizedBox(width: 5,),
                              Text("(2500)", textAlign: TextAlign.center,
                               style: TextStyle(color: selectedParts.contains(value) ? Colors.white : Colors.black,
                               fontSize: 12),),
                            ],
                          ),);
                      }).toList()
                    )
                  )
                    
                ],
              ),
          ),
        ),
        Divider(thickness: 0.8, height: 0.8,),

        Container(
          height: 50,
          child: Row(
          textDirection: TextDirection.rtl,
          children: [
              Container(

                              child: FlatButton(
                                height: 50,
                                minWidth: 180,
                  onPressed: (){},
                  color: MyColors.primaryColor,
                  child: Text("إظهار النتائج", textAlign: TextAlign.center, textDirection: TextDirection.rtl, 
                                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)
                  ),
                ),
              ),
              Expanded(
                child: Text("مجموع القطع: 3505", textAlign: TextAlign.center, textDirection: TextDirection.rtl, 
                              style: TextStyle(fontSize: 12),
                )
              ),
            ],
          ),
        ),
      
      ],
    );
  }

   showSortDialog(context){
     
     showDialog(
       context: context,
       builder: (ctx){
         return AlertDialog(
           title: Text("الترتيب حسب", textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),),
           
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
                   title: Text("الأحدث", style: TextStyle(fontSize: 12, color: Colors.black, fontWeight: FontWeight.w600),),
                   value: 1,
                   groupValue: sortRadioValue,
                   onChanged: (value){
                     setState.call(() {
                      sortRadioValue = value; 
                     });
                   },
                 ),
               ),
                Directionality(
                  textDirection: TextDirection.rtl,
                                child: RadioListTile(
                   title: Text("الأقدم", style: TextStyle(fontSize: 12, color: Colors.black, fontWeight: FontWeight.w600),),
                   value: 2,
                   groupValue: sortRadioValue,
                   onChanged: (value){
                     setState.call(() {
                      sortRadioValue = value; 
                     });
                   },
                   
               ),
                ),
                widget.filterType == FilterType.Market?
                Directionality(
                  textDirection: TextDirection.rtl,
                                child: RadioListTile(
                   title: Text("الأكبر سعرا", style: TextStyle(fontSize: 12, color: Colors.black, fontWeight: FontWeight.w600),),
                   value: 3,
                   groupValue: sortRadioValue,
                   onChanged: (value){
                     setState.call(() {
                      sortRadioValue = value; 
                     });
                   },
                   
               ),
                ): SizedBox(),

                    widget.filterType == FilterType.Market?
                Directionality(
                  textDirection: TextDirection.rtl,
                                child: RadioListTile(
                   title: Text("الأقل سعرا", style: TextStyle(fontSize: 12, color: Colors.black, fontWeight: FontWeight.w600),),
                   value: 4,
                   groupValue: sortRadioValue,
                   onChanged: (value){
                     setState.call(() {
                      sortRadioValue = value; 
                     });
                   },
                   
               ),
                ): SizedBox(),

              

Divider(thickness: 0.8,),

             Center(
               child: FlatButton(
                 onPressed: (){
                  
                   
                    
              
    switch(sortRadioValue){
      case 1: sortBy = "الأحدث"; break;
      case 2: sortBy = "الأقدم"; break;
      case 3: sortBy = "الأكبر سعرا"; break;
      case 4: sortBy = "الأقل سعرا"; break;
      default: sortBy = "الأحدث";
    }
    
     
      Navigator.of(ctx).pop(sortBy);                 
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
       setState(() {});
     });
 }
}