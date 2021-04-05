import 'package:flutter/material.dart';

class YearsListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: yearsListWidget(context),
      ),
    );
  }

  Widget yearsListWidget(context){
    return Column(
           children: [
             Container(
               height: 55,
               padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
               child: Row(
                 textDirection: TextDirection.rtl,
                 children: [
                   IconButton(
                     onPressed: (){
                       Navigator.pop(context);
                     },
                     icon: Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 25,),
                   ),

                   Expanded(
                     child: 
                  
                   Text(
                     "حدد سنة الصنع", textAlign: TextAlign.center,
                     style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                   )),

                   
                 ],
               ),
             ),
             Divider(),
       
             Expanded(
               child: ListView.builder(
                   itemCount: 12,
                   itemBuilder: (_, index){
                      return Column(
                        children: [
                          ListTile(
                            title: 
                             Text("1990", textAlign: TextAlign.right, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),),
                            onTap: (){
                              Navigator.of(context).pop("1990");},
                          ),
                          Divider(),
                        ],
                      );
                   },
             ),)
           ],
      );
  }
}