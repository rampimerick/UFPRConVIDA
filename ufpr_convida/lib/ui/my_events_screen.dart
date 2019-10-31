import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:ufpr_convida/ui/alter_event_screen.dart';
import 'package:ufpr_convida/ui/tela_principal.dart';
import 'package:ufpr_convida/modelos/evento.dart';

class MyEventsScreen extends StatefulWidget {
  @override
  _MyEventsScreenState createState() => _MyEventsScreenState();
}

class _MyEventsScreenState extends State<MyEventsScreen> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        body: Center(
          child: Container(
            child: FutureBuilder(
              //initialData: "Loading..",
              future: getMyEvents(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                List<Event> values = snapshot.data;

                if (snapshot.data == null) {
                  return CircularProgressIndicator();
                } else {
                  //Contruímos a lista de eventos:
                  return ListView.builder(
                      itemCount: values.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Column(
                          children: <Widget>[
                            Card(
                                child: ListTile(
                                    title: Text(
                                      values[index].name,
                                      style: TextStyle(
                                          color: Colors.black87,
                                          fontSize: 21.0,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    subtitle: Text(
                                      values[index].desc,
                                      style: TextStyle(
                                          fontStyle: FontStyle.italic,
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.w300),
                                    ),
                                    leading: CircleAvatar(
                                      radius: 42.0,
                                      backgroundColor: Color(0xFF8A275D),
                                      child: Text(
                                        "30/09",
                                        style: TextStyle(
                                          color: Colors.white70,
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                    ),
                                    trailing: Icon(Icons.more_vert),
                                    isThreeLine: true,
                                    onTap: () {
                                      //Vai para a página de alteração
//                                      Navigator.push(
//                                          context,
//                                          MaterialPageRoute(
//                                              builder: (context) => DetailPage(
//                                                  snapshot.data[index])));
                                    }))
                          ],
                        );
                      });
                }
              },
            ),
          ),
        ));
  }
}

Future<List> getMyEvents() async {
  List<Event> myevents = [];
  return myevents;
}