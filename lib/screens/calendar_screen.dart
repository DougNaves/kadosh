import 'dart:core';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kadosh/datas/schedule_data.dart';
import 'package:kadosh/datas/schedule_data_source.dart';
import 'package:kadosh/datas/service_data.dart';
import 'package:kadosh/models/user_model.dart';
import 'package:kadosh/screens/home_screen.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'login_screen.dart';

class CalendarScreen extends StatefulWidget {
  final ServiceData service;


  CalendarScreen(this.service);

  @override
  _CalendarScreenState createState() => _CalendarScreenState(service);
}

class _CalendarScreenState extends State<CalendarScreen> {
  _CalendarScreenState(this.service);

  final ServiceData service;
  final CalendarController _calendarController = CalendarController();


  @override
  initState() {
    super.initState();
    _calendarController.selectedDate = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
        appBar: AppBar(
          title: Text("Agendamento"),
          centerTitle: true,
        ),
        body: ScopedModelDescendant<UserModel>(builder: (context, child, model) {
          if (model.isLoggedIn()) {
            return StreamBuilder<QuerySnapshot>(
                stream: Firestore.instance.collection("schedule").snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: primaryColor,
                      ),
                    );
                  } else {
                    List<ScheduleData> _list =
                        snapshot.data!.documents.map((doc) {
                      return ScheduleData.fromDocument(doc);
                    }).toList();

                    return SfCalendar(
                      controller: _calendarController,
                      view: CalendarView.workWeek,
                      dataSource: ScheduleDataSource(_list),
                      initialSelectedDate: DateTime.now(),
                      showDatePickerButton: true,
                      allowViewNavigation: true,
                      todayHighlightColor: primaryColor,
                      timeSlotViewSettings: TimeSlotViewSettings(
                          startHour: 9,
                          endHour: 19,
                          timeFormat: 'hh:mm a',
                          timeRulerSize: 50,
                          timeIntervalHeight: 50,
                          timeInterval: Duration(minutes: 30),
                          nonWorkingDays: <int>[
                            DateTime.sunday,
                            DateTime.monday
                          ]),
                      minDate: DateTime.now(),
                      backgroundColor: Colors.black12,
                      onLongPress: (CalendarController) {
                        DateTime pick = _calendarController.selectedDate!;
                        DateTime end = pick.add(Duration(minutes: service.duration));
                        DateTime limit = new DateTime (end.year, end.month, end.day, 19, 0);
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                  title: Text("Confirmação de horário", textAlign: TextAlign.center,),
                                  titlePadding: EdgeInsets.all(10),
                                  content: Text("Deseja confirmar o agendamento do serviço ${service.title} para o dia ${DateFormat('dd/MM/yyyy - HH:mm').format(pick)} ?",
                                      textAlign: TextAlign.justify),
                                  actions: [
                                    ElevatedButton(
                                        onPressed: () {
                                          if (end.isAfter(limit)) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(
                                                    content: Text(
                                                        "O tempo para a realização do serviço excede o horário de funcionamento")));
                                            Navigator.pop(context);
                                          } else {
                                            ScheduleData.createDocument(
                                                model.firebaseUser.uid,
                                                model.userData["name"],
                                                service.title,
                                                pick,
                                                service.duration);
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(
                                                    content: Text(
                                                        "Agendamento realizado com sucesso!",
                                                        textAlign: TextAlign.center)));
                                            Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        HomeScreen()));
                                          }
                                        },
                                        style: ButtonStyle(
                                        backgroundColor: MaterialStateProperty.all<Color>(primaryColor),
                                        ),
                                        child: Text("Sim")),
                                    ElevatedButton(
                                        onPressed: () {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                                  content: Text(
                                                      "Selecione outra data",
                                                      textAlign: TextAlign.center)));
                                          Navigator.pop(context);
                                        },
                                        style: ButtonStyle(
                                          backgroundColor: MaterialStateProperty.all<Color>(primaryColor),
                                        ),
                                        child: Text("Não"))
                                  ]);
                            }); //showDialog
                      },
                    );
                  }
                });
          } else {
            return Container(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.view_list,
                    size: 80.0,
                    color: primaryColor,
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                  Text(
                    "Faça o login para agendar!",
                    style:
                        TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                  ElevatedButton(
                    child: Text(
                      "Entrar",
                      style: TextStyle(fontSize: 18.0, color: Colors.white),
                    ),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => LoginScreen()));
                    },
                  )
                ],
              ),
            );
          }
        }
        )
    );
  }
}
