import 'package:flutter/material.dart';
import 'package:kadosh/screens/map_screen.dart';
import 'package:kadosh/tabs/history_tab.dart';
import 'package:kadosh/tabs/home_tab.dart';
import 'package:kadosh/tabs/schedule_tab.dart';
import 'package:kadosh/tabs/services_tab.dart';
import 'package:kadosh/widgets/custom_drawer.dart';


class HomeScreen extends StatelessWidget {
  final _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: _pageController,
      physics: NeverScrollableScrollPhysics(),
      children: [
        Scaffold(
          appBar: AppBar(
            title: Text("Conheça o nosso espaço"),
            centerTitle: true,
          ),
          drawer: CustomDrawer(_pageController),
          body: HomeTab(),
        ),
        Scaffold(
          appBar: AppBar(
            title: Text("Serviços"),
            centerTitle: true,
          ),
          drawer: CustomDrawer(_pageController),
          body: ServicesTab(),
        ),
        Scaffold(
          appBar: AppBar(
            title: Text("Meus Horários"),
            centerTitle: true,
          ),
          drawer: CustomDrawer(_pageController),
          body: ScheduleTab(),
        ),
        Scaffold(
          appBar: AppBar(
            title: Text("Histórico"),
            centerTitle: true,
          ),
          drawer: CustomDrawer(_pageController),
          body: HistoryTab(),
        ),
        Scaffold(
          appBar: AppBar(
            title: Text("Localização"),
            centerTitle: true,
          ),
          drawer: CustomDrawer(_pageController),
          body: MapScreen(),
        )
      ],
    );
  }
}