import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Event {
  String name;
  String target;
  String date_event;
  String desc;
  String init;
  String end;
  String link;
  String type;

  Event(this.name, this.target, this.date_event, this.desc, this.init, this.end,
      this.link, this.type);
}

class telaEventos extends StatefulWidget {
  @override
  _telaEventosState createState() => _telaEventosState();
}

class _telaEventosState extends State<telaEventos> {
  Future<List> getEvents() async {
    String apiUrl = "http://10.0.2.2:8080/events";
    http.Response response = await http.get(apiUrl);
    //Caso vir código 200, OK!
    var jsonData;
    if ((response.statusCode == 200) || (response.statusCode == 201)) {
      jsonData = json.decode(response.body);
    } else {
      throw Exception("Falhou!");
    }

    List<Event> events = [];

    for (var e in jsonData) {
      Event event = Event(
          e['name'],
          e["target"],
          e["date_event"],
          e["desc"],
          e["init"],
          e["end"],
          e["link"],
          e["type"]);
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
                } else {
                  //Here we can build the List of Events:
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
                                          color: Color(0xFF8A275D),
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
                                        "19/09",
                                        style: TextStyle(
                                          color: Colors.white70,
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                    ),
                                    trailing: Icon(Icons.more_vert),
                                    isThreeLine: true,
                                    onTap: () {
                                      Navigator.push(context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  DetailPage(
                                                      snapshot.data[index])));
                                    }
                                ))
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

class DetailPage extends StatelessWidget {
  final Event event;

  //Detail page get the Event on that INDEX
  DetailPage(this.event);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Evento: ${event.name}")
      ),
      body: Container(
        child: Center(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Data do Evento:",
                  style: TextStyle(
                    color: Color(0xFF8A275D),
                    fontSize: 23.0,
                    fontWeight: FontWeight.bold,
                  ),),

              ),


              Padding(
                padding: const EdgeInsets.all(8.0),
                     child: Text(event.date_event,
                  style: TextStyle(
                    color: Color(0xFF8A275D),
                    fontSize: 23.0,
                    fontWeight: FontWeight.bold,
                  ),),

              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(event.desc,
                  style: TextStyle(
                    color: Colors.white12,
                    fontSize: 21.0,
                    fontWeight: FontWeight. w500,
                  ),),
              ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(event.target,
              style: TextStyle(
                color: Color(0xFF8A275D),
                fontSize: 23.0,
                fontWeight: FontWeight.bold,
                ),),
            ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(event.init,
                  style: TextStyle(
                    color: Color(0xFF8A275D),
                    fontSize: 23.0,
                    fontWeight: FontWeight.bold,
                  ),),
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(event.end,
                  style: TextStyle(
                    color: Color(0xFF8A275D),
                    fontSize: 23.0,
                    fontWeight: FontWeight.bold,
                  ),),
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(event.link,
                  style: TextStyle(
                    color: Color(0xFF8A275D),
                    fontSize: 23.0,
                    fontWeight: FontWeight.bold,
                  ),),
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(event.type,
                  style: TextStyle(
                    color: Color(0xFF8A275D),
                    fontSize: 23.0,
                    fontWeight: FontWeight.bold,
                  ),),
              ),

          ],
        ),
      ),
    ),);
  }
}
