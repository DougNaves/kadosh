import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:kadosh/datas/service_data.dart';
import 'package:kadosh/models/user_model.dart';
import 'calendar_screen.dart';
import 'login_screen.dart';

class ServiceScreen extends StatefulWidget {
  final ServiceData service;

  ServiceScreen(this.service);

  @override
  _ServiceScreenState createState() => _ServiceScreenState(service);
}

class _ServiceScreenState extends State<ServiceScreen> {
  final ServiceData service;

  _ServiceScreenState(this.service);

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      appBar: AppBar(
        title: Text(service.title),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          AspectRatio(
            aspectRatio: 1.2,
            child: Carousel(
              images: service.images.map((url) {
                return NetworkImage(url);
              }).toList(),
              dotSize: 4.0,
              dotSpacing: 15.0,
              dotBgColor: Colors.transparent,
              dotColor: primaryColor,
              autoplay: false,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  service.title,
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w500),
                  maxLines: 3,
                ),
                SizedBox(height: 8.0),
                Text(
                  "R\$${service.price.toStringAsFixed(2)}",
                  style: TextStyle(
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
                SizedBox(height: 16.0),
                Text(
                  "${service.duration} minutos",
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 16.0),
                SizedBox(
                  height: 44.0,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(primary: primaryColor),
                    onPressed: () {
                      if (UserModel.of(context).isLoggedIn()) {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => CalendarScreen(service)));
                      } else {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => LoginScreen()));
                      }
                    },
                    child: Text(
                      UserModel.of(context).isLoggedIn()
                          ? "Agendar"
                          : "Entre para Agendar",
                      style: TextStyle(fontSize: 18.0),
                    ),
                  ),
                ),
                SizedBox(height: 16.0),
                Text("Descrição",
                    style:
                        TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500)),
                Text(service.description, style: TextStyle(fontSize: 16.0))
              ],
            ),
          )
        ],
      ),
    );
  }
}
