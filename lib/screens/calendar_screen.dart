import 'dart:core';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kadosh/datas/schedule_data.dart';
import 'package:kadosh/datas/schedule_data_source.dart';
import 'package:kadosh/datas/service_data.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/scheduler.dart';

class CalendarScreen extends StatefulWidget {
  final ServiceData service;
  CalendarScreen(this.service);

  @override
  _CalendarScreenState createState() => _CalendarScreenState(service);
}

class _CalendarScreenState extends State<CalendarScreen> {
  _CalendarScreenState(this.service);
  final ServiceData service;
  CalendarController _calendarController = CalendarController();

  @override
  initState() {
    super.initState();
    _calendarController.selectedDate = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Agendamento"),
          centerTitle: true,
        ),
        body: FutureBuilder<QuerySnapshot>(
            future: Firestore.instance.collection("schedule").getDocuments(),
            builder: (context, snapshot) {
              if (!snapshot.hasData)
                return Center(
                  child: CircularProgressIndicator(),
                );
              else {
                List<ScheduleData> _list = snapshot.data!.documents.map((doc) {
                  return ScheduleData.fromDocument(doc);
                }).toList();

                return SfCalendar(
                  controller: _calendarController,
                  view: CalendarView.month,
                  dataSource: ScheduleDataSource(_list),
                  initialSelectedDate: DateTime.now(),
                  showDatePickerButton: true,
                  allowViewNavigation: true,
                  timeSlotViewSettings: TimeSlotViewSettings(
                      startHour: 9,
                      endHour: 19,
                      timeIntervalHeight: 30,
                      timeIntervalWidth: 30,
                      timeInterval: Duration(minutes: 30),
                      nonWorkingDays: <int>[DateTime.sunday, DateTime.monday]),
                  minDate: DateTime.now(),
                  backgroundColor: Colors.black12,
                  onLongPress: (CalendarController)  {
                    DateTime? dt = _calendarController.selectedDate;
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                              title: Text("Confirmação de agendamento"),
                              titlePadding: EdgeInsets.all(20),
                              content: Text(
                                  "Deseja confirmar o agendamento do serviço ${service.title} para o dia ${DateFormat('dd/MM/yyyy - HH:mm').format(dt!)} ?"),
                              actions: [
                                ElevatedButton(
                                    onPressed: () {
                                      ScheduleData.createDocument(
                                          service.title, dt, service.duration);
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              content: Text(
                                                  "Agendamento realizado com sucesso!")));
                                      Navigator.pop(context);
                                    },
                                    child: Text("Sim")),
                                ElevatedButton(
                                    onPressed: () {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              content: Text(
                                                  "Selecione outra data")));
                                      Navigator.pop(context);
                                    },
                                    child: Text("Não"))
                              ]);
                        }); //showDialog
                  },
                );
              }
            }
            )
    );
  }
}
