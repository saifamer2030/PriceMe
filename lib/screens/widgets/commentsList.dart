import 'package:flutter/material.dart';

class CommentsList extends StatelessWidget {
  final ScrollController _commentsController = ScrollController();
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: BouncingScrollPhysics(),
      shrinkWrap: true,
      itemCount: 5,
      controller: _commentsController,
      itemBuilder: (ctx, index){
        return Column(
          children: [
            commentItem(index),
            Divider(thickness: 1, height: 1.2,)
          ],
        );
      },
    );
  }

  Widget commentItem(int index){
    return Padding(
      padding: EdgeInsets.all(10),
      child: Row(
        textDirection: TextDirection.rtl,
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              height: 35,
              width: 35,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                shape: BoxShape.circle
              ),
              child: Icon(Icons.person, color: Colors.grey,),
            ),
          ),
          SizedBox(width: 10,),
          Expanded(
            child: Column(
              textDirection: TextDirection.rtl,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("الإسم",textDirection: TextDirection.rtl,
                  textAlign: TextAlign.right,
                  style: TextStyle(fontSize: 12,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,),),
                Text("منذ ساعة",textDirection: TextDirection.rtl,
                  textAlign: TextAlign.right,
                  style: TextStyle(fontSize: 8,
                    color: Colors.grey,
                    ),),
                SizedBox(height: 5,),
                Text("قطعة جيدة و مفيدة",textDirection: TextDirection.rtl,
                  textAlign: TextAlign.right,
                  style: TextStyle(fontSize: 10,
                    color: Colors.black,
                    ),)
              ],
            ),
          )
        ],
      ),
    );
  }
}
