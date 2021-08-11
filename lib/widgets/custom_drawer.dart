import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:kadosh/models/user_model.dart';
import 'package:kadosh/screens/login_screen.dart';
import 'package:kadosh/tiles/drawer_tile.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:transparent_image/transparent_image.dart';

class CustomDrawer extends StatelessWidget {

  final PageController pageController;
  CustomDrawer(this.pageController);

  @override
  Widget build(BuildContext context) {
    Widget _buildDrawerBack() => Container(
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

    return Drawer(
      child: Stack(
        children: [
          _buildDrawerBack(),
          ListView(
            padding: EdgeInsets.only(left: 32.0, top: 16.0),
            children: [
              Container(
                margin: EdgeInsets.only(bottom: 8.0),
                padding: EdgeInsets.fromLTRB(0.0, 16.0, 16.0, 8.0),
                height: 170.0,
                child: Stack(
                  children: [
                    Positioned(
                        top: 8.0,
                        left: 0.0,
                        child: Image.asset('assets/images/logo/logo_home.png')
                    ),
                    Positioned(
                        left: 0.0,
                        bottom: 0.0,
                        child: ScopedModelDescendant<UserModel>(
                          builder: (context, child, model){
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text("Olá, ${!model.isLoggedIn() ? "" : model.userData["name"]}",
                                    style: TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold)),
                                GestureDetector(
                                  child: Text(
                                      !model.isLoggedIn() ? "Entre ou cadastre-se >" : "Sair",
                                      style: TextStyle(
                                          color: Theme.of(context).primaryColor,
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold)),
                                  onTap: () {
                                    if(!model.isLoggedIn())
                                      Navigator.of(context).push(
                                        MaterialPageRoute(builder: (context)=>LoginScreen()),
                                      );
                                    else
                                      model.signOut();
                                  },
                                ),
                              ],
                            );
                          },
                        )

                    ),
                  ],
                ),
              ),
              Divider(),
              DrawerTile(Icons.home, "Início", pageController, 0),
              DrawerTile(Icons.list, "Serviços", pageController, 1),
              DrawerTile(Icons.calendar_today, "Meus horários", pageController, 2),
              DrawerTile(Icons.history, "Histórico", pageController, 3),
              DrawerTile(Icons.location_on_outlined, "Localização", pageController, 4),
            ],
          )
        ],
      ),
    );
  }
}