import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class MySchedulesTile extends StatelessWidget {
  final DocumentSnapshot snapshot;
  MySchedulesTile(this.snapshot);

  String _convertData(Timestamp time){
    DateTime dt = time.toDate();
    String date = DateFormat('dd/MM/yyyy - HH:mm').format(dt);
    return date;
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.calendar_today),
      title: Text(snapshot.data["service"]),
      subtitle: Text(_convertData(snapshot.data["start"])),
      onTap: () {
        //método para excluir um agendamento do usuário
      },
    );
  }
}