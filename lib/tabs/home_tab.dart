import 'package:carousel_pro/carousel_pro.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:transparent_image/transparent_image.dart';

class HomeTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Theme.of(context).primaryColor;

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

    return Stack(
      children: [
        _buildBodyBack(),
        FutureBuilder<QuerySnapshot>(
          future: Firestore.instance
              .collection("home")
              .orderBy("pos")
              .getDocuments(),
          builder: (context, snapshot) {
            if (!snapshot.hasData)
              return Container(
                height: 200.0,
                alignment: Alignment.center,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              );
            else
              return Carousel(
                images: snapshot.data!.documents.map((doc) {
                  return NetworkImage(doc.data["image"]);
                }).toList(),
                dotSize: 4.0,
                dotSpacing: 15.0,
                dotBgColor: Colors.transparent,
                dotColor: primaryColor,
                autoplay: false,
              );
          },
        ),
      ],
    );
  }
}
