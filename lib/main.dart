import 'package:flutter/material.dart';
import 'package:kadosh/screens/home_screen.dart';
import 'package:scoped_model/scoped_model.dart';
import 'models/user_model.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModel<UserModel>(
        model: UserModel(),
        child: MaterialApp(
          title: 'Espaço Kadosh',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.blue,
            primaryColor: Color.fromARGB(255, 170, 80, 90),
          ),
          home: HomeScreen(),
        ))  ;


  }
}