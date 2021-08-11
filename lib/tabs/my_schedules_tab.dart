import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kadosh/tiles/my_schedules_tile.dart';

class MySchedulesTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Widget _buildBodyBack() => Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 250, 225, 225),
              Color.fromARGB(255, 240, 180, 180),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          )),
    );

    return Stack(children: [
      _buildBodyBack(),
      //incluir validação para recuperar somente os agendamentos do usuário
      //recuperar somente os agendamentos com data futura
      FutureBuilder<QuerySnapshot>(
          future: Firestore.instance.collection("schedule").orderBy("start").getDocuments(),
          builder: (context, snapshot) {
            if (!snapshot.hasData)
              return Center(
                child: CircularProgressIndicator(),
              );
            else {
              var dividedTiles = ListTile.divideTiles(
                tiles: snapshot.data!.documents.map((doc) {
                  return MySchedulesTile(doc);
                }).toList(),
                color: Colors.grey[500],
              ).toList();
              return ListView(
                children: dividedTiles,
              );
            }
          })
    ]);
  }
}
