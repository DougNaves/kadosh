import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ScheduleData {
  String eventName = "";
  DateTime from = DateTime.now();
  DateTime to = DateTime.now();
  //Color background = Colors.red;
  // bool isAllDay = false;


  ScheduleData.fromDocument(DocumentSnapshot snapshot){
    eventName = snapshot.data["service"];
    from = snapshot.data["start"].toDate();
    to =  snapshot.data["end"].toDate();
  }

  ScheduleData.createDocument(String name, DateTime date, int duration){
    Map<String, dynamic> data ={
      "service": name,
      "start": date,
      "end": date.add(Duration(minutes: duration)),
      //"color": this.color,
      // "allDay": this.isAllDay,
    };
    Firestore.instance.collection('schedule').add(data);
  }

}
