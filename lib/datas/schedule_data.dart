import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ScheduleData {
  String clientId = "";
  String clientName = "";
  String service = "";
  DateTime from = DateTime.now();
  DateTime to = DateTime.now();
  Color background = Colors.red;


  ScheduleData.fromDocument(var snapshot){
    clientId = snapshot.data["clientId"];
    clientName = snapshot.data["clientName"];
    service = snapshot.data["service"];
    from = snapshot.data["start"].toDate();
    to =  snapshot.data["end"].toDate();
    background = Colors.red;
  }

  ScheduleData.createDocument(String clientId, String clientName, String service, DateTime date, int duration){
    Firestore.instance.collection('schedule').add(
        {
          "clientId": clientId,
          "clientName": clientName,
          "service": service,
          "start": date,
          "end": date.add(Duration(minutes: duration))
        }
    );
   }
   ScheduleData.removeDocument(var snapshot){
     snapshot.reference.delete();
   }

}
