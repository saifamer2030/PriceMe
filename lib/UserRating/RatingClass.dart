import 'package:firebase_database/firebase_database.dart';

class Rating {
  String _id ;
  String _rate;
  String _comment;


  Rating(this._id,this._rate,this._comment);


////////////////// لوضع اسم لكل بيان فى قاعدة البيانات /////////////////////////
  Rating.map(dynamic obj){
    this._id = obj['id'];
    this._rate = obj['Rate'];
    this._comment = obj['Comment'];

  }


///////////////////////// للحصول على بيانات من اليوزر ///////////////////
  String get id => _id;
  String get rate => _rate;
  String get comment => _comment;




//////////////// لاستعادة البيانات من الفاير بيز /////////////////////
  Rating.fromSnapShot(DataSnapshot snapshot){
    _id = snapshot.key;
    _rate = snapshot.value['Rate'];
    _comment = snapshot.value['Comment'];
  }
}