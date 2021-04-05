import 'package:flutter/material.dart';

class ModelsListPage extends StatefulWidget {
  @override
  _ModelsListPageState createState() => _ModelsListPageState();
}

class _ModelsListPageState extends State<ModelsListPage> {

  bool isSearching = false;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: modelsListWidget(),
      ),
    );
  }

    Widget modelsListWidget(){
      
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
                   isSearching? 
                   Container(
                     decoration: BoxDecoration(

                     ),
                     child: Directionality(
                                        textDirection: TextDirection.rtl,
                                        child: TextFormField(
                                         textAlign: TextAlign.right,
                                         keyboardType: TextInputType.text,
                                         autofocus: true,
                                         
                                         style: TextStyle(fontSize: 12),
                                         decoration: InputDecoration(
                                            isDense: true,
                                            prefixIcon: Icon(Icons.search, color: Colors.grey[400], size:20),
                                            filled: true,
                                           fillColor: Colors.grey[200],
                                            
                                            hintText: 'البحث عن الموديل',
                                            hintStyle: TextStyle(fontSize: 12, color: Colors.grey[400]),
                                            border: InputBorder.none,
                                            
                                           errorStyle: TextStyle(
                                              color: Colors.red,
                                              fontSize: 12.0),
                                            contentPadding:
                                            const EdgeInsets.only(left: 10.0, bottom: 10.0, top:10.0, right: 10),


                                          
                                          ),
                                        ),
                                      ),
                   )
                   :
                   Text(
                     "حدد الموديل", textAlign: TextAlign.center,
                     style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                   )),

                    IconButton(
                     onPressed: (){
                       setState(() {
                        isSearching = !isSearching; 
                       });
                     },
                     icon: Icon( isSearching? Icons.close : Icons.search, 
                     color: Colors.grey,),
                   ),
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
                             Text("cx 500", textAlign: TextAlign.right, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),),
                            onTap: (){
                                Navigator.of(context).pop("cx 500");
                            },
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