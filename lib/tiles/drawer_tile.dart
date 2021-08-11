import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:kadosh/tabs/home_tab.dart';
import 'package:kadosh/tabs/my_schedules_tab.dart';
import 'package:kadosh/tabs/services_tab.dart';

class DrawerTile extends StatelessWidget {
  //Vamos criar um construtor para criar os itens do menu drawer
  final IconData icon;
  final String text;
  final PageController pageController;
  final int page;

  DrawerTile(this.icon, this.text, this.pageController, this.page);

  @override
  Widget build(BuildContext context) {
    //Retornando Material para colocar efeito visual

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.of(context).pop();
          pageController.jumpToPage(page);
        },
        child: Container(
          height: 60.0,
          child: Row(
            children: [
              Icon(
                icon,
                size: 32.0,
                //se eu estiver na mesma página, a cor é diferente
                // e o texto fica em itálico
                color: pageController.page!.round() == page
                    ? Theme.of(context).primaryColor
                    : Colors.black,
              ),
              SizedBox(width: 32.0),
              Text(text,
                  style: pageController.page!.round() == page
                      ? TextStyle(
                      fontSize: 16.0,
                      color: Theme.of(context).primaryColor,
                      fontStyle: FontStyle.italic)
                      : TextStyle(fontSize: 16.0, color: Colors.black))
            ],
          ),
        ),
      ),
    );
  }
}