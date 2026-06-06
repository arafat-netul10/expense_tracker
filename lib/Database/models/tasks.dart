//
// import 'package:flutter/cupertino.dart';
//
// class Tasks {
//
//   final int ? id;
//   final String ? title;
//   final bool isDone;
//
//   Tasks({this.id, required this.title, required this.isDone});
//
//   Map<String, dynamic> toMap(){
//
//     return {
//
//       'id' : id,
//       'title': title,
//       'isDone' : isDone ? 1 : 0,
//
//     };
//   }
//
//   factory Tasks.formMap(Map<String, dynamic> map){
//
//     return Tasks(id: map['id'], title: map['title'], isDone: map['isDone'] == 1,);
//
//   }
//
// }