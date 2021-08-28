import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kadosh/tiles/category_tile.dart';

class ServicesTab extends StatelessWidget {
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
      FutureBuilder<QuerySnapshot>(
          future: Firestore.instance.collection("products").getDocuments(),
          builder: (context, snapshot) {
            if (!snapshot.hasData)
              return Center(
                child: CircularProgressIndicator(
                  color: Theme.of(context).primaryColor
                ),
              );
            else {
              var dividedTiles = ListTile.divideTiles(
                tiles: snapshot.data!.documents.map((doc) {
                  return CategoryTile(doc);
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
