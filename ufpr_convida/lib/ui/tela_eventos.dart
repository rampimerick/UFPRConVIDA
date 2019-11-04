import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:ufpr_convida/ui/alter_event_screen.dart';
import 'package:ufpr_convida/ui/detailed_event_screen.dart';
import 'package:ufpr_convida/ui/tela_principal.dart';
import 'package:ufpr_convida/modelos/evento.dart';
import 'package:ufpr_convida/util/globals.dart' as globals;

class telaEventos extends StatefulWidget {
  @override
  _telaEventosState createState() => _telaEventosState();
}

class _telaEventosState extends State<telaEventos> {

  String url = globals.URL;

  Future<List> getEvents() async {
    print("Requisição getEvents: $url/events");
    http.Response response = await http.get("$url/events");
    print("StatusCode:${response.statusCode}");

    if ((response.statusCode != 200) && (response.statusCode != 201)) {
      String url = "http://10.0.2.2:8080/events";
      print("Tentando com $url");
      response = await http.get(url);
    }

    //Caso vir código 200, OK!
    var jsonData;
    if ((response.statusCode == 200) || (response.statusCode == 201)) {
      jsonData = json.decode(response.body);
    } else {
      throw Exception("Falhou!");
    }

    List<Event> events = [];

    for (var e in jsonData) {
      Event event = Event(e['id'], e['name'], e["target"], e["date_event"],
          e["desc"], e["init"], e["end"], e["link"], e["type"], e["sector"],e["bloc"],e["lat"],e["lng"]);
      events.add(event);
    }
    return events;
  }

  @override
  //Tela onde terá a lista de todos os eventos que o usuario decidir criar/participar
  //Os eventos que nao estão listados podem ser vistos no mapa e ao clicar tem a opção de participar
  Widget build(BuildContext context) {
    //print(events.length);
    return Scaffold(
        body: Center(
      child: Container(
        child: FutureBuilder(
          //initialData: "Loading..",
          future: getEvents(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            List<Event> values = snapshot.data;

            if (snapshot.data == null) {
              return CircularProgressIndicator();
            }
            else {
              String imagemAvatar = "assets/calendar.png";
              //Contruímos a lista de eventos:
              return ListView.builder(
                  itemCount: values.length,
                  itemBuilder: (BuildContext context, int index) {
                    //print(values[index].type);
                    if(values[index].type == "Reunião")
                      imagemAvatar = "assets/meeting.png";
                    else if(values[index].type == "Festa")
                      imagemAvatar = "assets/disco-ball.png";
                    else if(values[index].type == "Formatura")
                      imagemAvatar = "assets/graduated.png";
                    else
                      imagemAvatar = "assets/calendar.png";

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
                                  backgroundColor: Colors.white,
                                  child:Image.asset(imagemAvatar),
                                ),
                                trailing: Icon(Icons.more_vert),
                                isThreeLine: true,
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => DetailedEventScreen(
                                               idEvent: values[index].id)));
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
