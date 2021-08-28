import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kadosh/datas/schedule_data.dart';
import 'package:kadosh/models/user_model.dart';
import 'package:kadosh/screens/login_screen.dart';
import 'package:kadosh/tiles/schedule_tile.dart';
import 'package:scoped_model/scoped_model.dart';

class ScheduleTab extends StatefulWidget {
  @override
  _ScheduleTabState createState() => _ScheduleTabState();
}

class _ScheduleTabState extends State<ScheduleTab> {


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

    return ScopedModelDescendant<UserModel>(builder: (context, child, model) {

      if (model.isLoggedIn()) {
        return Stack(children: [
          _buildBodyBack(),
           StreamBuilder<QuerySnapshot>(
              stream: Firestore.instance
                  .collection("schedule")
                  .where("start", isGreaterThanOrEqualTo: Timestamp.now())
                  .where("clientId", isEqualTo: model.firebaseUser.uid.toString())
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Container(
                      child: Center(
                          child: CircularProgressIndicator(
                            color: Theme
                                .of(context)
                                .primaryColor,
                          )
                      )
                  );
                }
                else if (snapshot.data!.documents.isEmpty){
                  return Container(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.calendar_today,
                          size: 80.0,
                          color: Theme
                              .of(context)
                              .primaryColor,
                        ),
                        SizedBox(
                          height: 16.0,
                        ),
                        Text(
                          "Você não possui serviços agendados",
                          style: TextStyle(
                              fontSize: 20.0, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                }
                else {
                  var dividedTiles = ListTile.divideTiles(
                    tiles: snapshot.data!.documents.map((doc) {
                      return ScheduleTile(doc);
                    }).toList(),
                    color: Colors.grey[500],
                  ).toList();
                  return ListView(
                    children: dividedTiles,
                  );
                }
              })
        ]);
      } else {
        return Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.calendar_today,
                size: 80.0,
                color: Theme.of(context).primaryColor,
              ),
              SizedBox(
                height: 16.0,
              ),
              Text(
                "Faça o login para visualizar os seus horários!",
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 16.0,
              ),
              ElevatedButton(
                child: Text(
                  "Entrar",
                  style: TextStyle(fontSize: 18.0),
                ),
                style: ElevatedButton.styleFrom(primary: Theme.of(context).primaryColor),
                onPressed: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => LoginScreen()));
                },
              )
            ],
          ),
        );
      }
    });
  }
}
