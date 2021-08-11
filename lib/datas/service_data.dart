import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';

class ServiceData{
  String title = "";
  String description = "";
  double price = 0.0;
  int duration = 0;
  List images = [];

  ServiceData.fromDocument(DocumentSnapshot snapshot){
    title = snapshot.data["title"];
    description = snapshot.data["description"];
    price = snapshot.data["price"] + 0.0;
    duration = snapshot.data["duration"];
    images = snapshot.data["images"];
  }
}