import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kadosh/datas/schedule_data.dart';

class ScheduleTile extends StatelessWidget {
  final DocumentSnapshot snapshot;

  ScheduleTile(this.snapshot);

  String _convertData(Timestamp time) {
    DateTime dt = time.toDate();
    String date = DateFormat('dd/MM/yyyy - HH:mm').format(dt);
    return date;
  }

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Theme.of(context).primaryColor;

    return ListTile(
        leading: Icon(Icons.calendar_today),
        title: Text(snapshot.data["service"]),
        subtitle: Text(_convertData(snapshot.data["start"])),
        onTap: () {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                    title: Text(
                      "Confirmação de cancelamento de agendamento",
                      textAlign: TextAlign.center,
                    ),
                    titlePadding: EdgeInsets.all(10),
                    content: Text(
                        "Deseja cancelar o agendamento do serviço ${snapshot.data["service"]} para o dia ${_convertData(snapshot.data["start"])} ?",
                        textAlign: TextAlign.justify),
                    actions: [
                      ElevatedButton(
                          onPressed: () {
                            ScheduleData.removeDocument(snapshot);
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text(
                                    "O agendamento foi cancelado com sucesso",
                                    textAlign: TextAlign.center)));
                            Navigator.pop(context);
                          },
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  primaryColor)),
                          child: Text("Sim")),
                      ElevatedButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text("O horário agendado foi mantido",
                                    textAlign: TextAlign.center)));
                            Navigator.pop(context);
                          },
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all<Color>(primaryColor),
                          ),
                          child: Text("Não"))
                    ]);
              });
        });
  }
}
