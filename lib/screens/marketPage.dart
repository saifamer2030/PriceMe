import 'package:flutter/material.dart';
import 'package:priceme/classes/filterType.dart';
import 'package:priceme/screens/filterPage.dart';
import 'package:priceme/screens/partDetailPage.dart';
import 'package:priceme/ui_utile/myColors.dart';

class MarketPage extends StatefulWidget {
  @override
  _MarketPageState createState() => _MarketPageState();
}

class _MarketPageState extends State<MarketPage> {

  var _marketController = ScrollController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: marketWidget()
    );
  }


Widget marketWidget(){
  return Column(
    children: [
      
              Container(
                height: 64,
       padding: EdgeInsets.only(top: 10, bottom: 10, right: 10, left: 8),
        decoration: BoxDecoration(
                       color: Colors.white,
                          boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 0.8,
                                blurRadius: 0.8,
                                offset: Offset(0, 0.8), // changes position of shadow
                              ),
                            ],
                      ),
       child: Row(
         textDirection: TextDirection.rtl,
         children: [
           Expanded(
             child: Container(
                     decoration: BoxDecoration(
                       color: Colors.grey[200],
                       borderRadius: BorderRadius.circular(16)
                     ),
                     child: Directionality(
                                        textDirection: TextDirection.rtl,
                                        child: TextFormField(
                                         textAlign: TextAlign.right,
                                         keyboardType: TextInputType.text,
                                        style: TextStyle(fontSize: 12),
                                         decoration: InputDecoration(
                                            isDense: true,
                                            prefixIcon: Icon(Icons.search, color: Colors.grey[400], size:20),
                                           // filled: true,
                                          // fillColor: Colors.grey[200],
                                            
                                            hintText: 'البحث',
                                            hintStyle: TextStyle(fontSize: 12, color: Colors.grey[400]),
                                            border: InputBorder.none,
                                            
                                           errorStyle: TextStyle(
                                              color: Colors.red,
                                              fontSize: 12.0),
                                            contentPadding:
                                            const EdgeInsets.only(left: 10.0, bottom: 8.0, top:8.0, right: 10),


                                          
                                          ),
                                        ),
                                      ),
                   ),
           ),
        
         IconButton(
           onPressed: (){
               Navigator.of(context).push(MaterialPageRoute(
               builder: (ctx)=> FilterPage(filterType: FilterType.Market,)));
           },
           icon: Icon(Icons.filter_alt, size: 25, color: Colors.grey,)
         )  
         ],
       ),
      ),
       SizedBox(height: 10,),
      Expanded(
        child: ListView.builder(
          physics: BouncingScrollPhysics(),
          shrinkWrap: true,
          itemCount: 12,
          controller: _marketController,
          itemBuilder: (ctx, index){
            return itemWidget(index);
          },
        ),
      )
    ],
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
}