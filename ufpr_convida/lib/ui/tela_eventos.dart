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
import 'package:ufpr_convida/ui/tela_principal.dart';
import 'package:ufpr_convida/modelos/evento.dart';

class telaEventos extends StatefulWidget {
  @override
  _telaEventosState createState() => _telaEventosState();
}

class _telaEventosState extends State<telaEventos> {
  Future<List> getEvents() async {
    String apiUrl =
        "http://10.0.2.2:8080/events"; //"http://192.168.0.103:8080/events";
    print("Requisição será feita:");

    http.Response response = await http.get(apiUrl);
    print("StatusCode:${response.statusCode}");

    if ((response.statusCode != 200) && (response.statusCode != 201)) {
      apiUrl = "http://10.0.2.2:8080/events";
      print("Tentando com $apiUrl");
      response = await http.get(apiUrl);
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
          e["desc"], e["init"], e["end"], e["link"], e["type"], e["sector"],e["block"]);
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
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => DetailPage(
                                              snapshot.data[index])));
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

class DetailPage extends StatelessWidget {
  final Event event;

  //Detail page get the Event on that INDEX
  DetailPage(this.event);

  @override
  Widget build(BuildContext context) {
    initializeDateFormatting("pt_BR", null);

    var f = new DateFormat.yMMMMd().add_Hm();
    var parsedDate = DateTime.parse(event.date_event);

    String imagem;
    if (event.type.compareTo('Reuniao') == 0) {
      imagem = "assets/event-type-2.png";
    } else if (event.type.compareTo('Festa') == 0) {
      imagem = "assets/event-type-1.png";
    } else {
      imagem = "assets/event-type-3.png";
    }

    return Scaffold(
      appBar: AppBar(title: Text("Evento: ${event.name}")),
      body: Container(
        //color: Colors.orange,
        child: Container(
          child: Stack(
            alignment: Alignment.topCenter,
            //mainAxisAlignment: MainAxisAlignment.center,
            //crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(child: Image.asset("$imagem")),
              Padding(
                padding: EdgeInsets.only(top: 250),
                child: Container(
                  height: 325.00,
                  width: 350.00,
                  child: Material(
                    color: Colors.white,
                    elevation: 4.0,
                    borderRadius: BorderRadius.circular(20.0),
                    shadowColor: Color(0x802196f3),
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "${event.name}",
                              style: TextStyle(
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.bold,
                                fontSize: 30.0,
                                color: Colors.pink,
                              ),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Text(
                              "${event.desc}",
                              style: TextStyle(
                                fontSize: 18.0,
                                color: Colors.black54,
                              ),
                            ),
                            SizedBox(
                              height: 20.0,
                            ),
                            Container(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Icon(
                                    Icons.today,
                                    size: 20.0,
                                    color: Color(0xffE810350),
                                  ),
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                  Text(
                                    " ${f.format(parsedDate)}",
                                    style: TextStyle(
                                        fontSize: 20.0,
                                        color: Color(0xffE810350)),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Container(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Icon(
                                    Icons.insert_link,
                                    size: 20.0,
                                    color: Color(0xffE810350),
                                  ),
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                  Text(
                                    " ${event.link}",
                                    style: TextStyle(
                                        fontSize: 18.0,
                                        color: Color(0xffE810350)),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(height: 20.0),
                            Column(
                              children: <Widget>[
                                Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 10.0),
                                      child: RaisedButton(
                                        color: Color(0xFF8A275D),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(24),
                                        ),
                                        onPressed: () {
                                          //Ao pressionar Alterar:
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => alterEvent(
                                                  event: event,
                                                ),
                                              ));
                                        },
                                        padding: EdgeInsets.fromLTRB(30, 12, 30, 12),
                                        child: Text('Alterar Evento',
                                            style: TextStyle(color: Colors.white,fontSize: 16)),
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 5.0),
                                      child: RaisedButton(
                                        color: Color(0xFF295492),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(24),
                                        ),
                                        onPressed: () {
                                          //Ao pressionar Deletar:

                                          var alert = AlertDialog(
                                            title: Text(
                                              "Deletar",
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 18.0),
                                            ),
                                            content: Text(
                                                "Deseja realmente deletar esse evento?"),
                                            actions: <Widget>[
                                              FlatButton(
                                                  onPressed: () {
                                                    deleteEvent();
                                                    //Faz a requisição com o ID do evento
//                                                    Navigator.of(context).push(
//                                                        new MaterialPageRoute(
//                                                            builder: (BuildContext
//                                                                context) {
//                                                      return new telaPrincipal();
//                                                    }));
                                                  },
                                                  child: Text("Sim")),
                                              FlatButton(
                                                  onPressed: () {

                                                    Navigator.pop(context);
                                                  },
                                                  child: Text("Não"))
                                            ],
                                          );

                                          //Mostra a caixa de Alerta:
                                          showDialog(
                                              context: context,
                                              builder: (context) => alert);
                                        },
                                        padding: EdgeInsets.fromLTRB(30, 12, 30, 12),
                                        //color: Colors.lightBlueAccent,
                                        child: Text('Deletar Evento',
                                            style: TextStyle(color: Colors.white,fontSize: 16)),
                                      ),


                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future deleteEvent() async {
    

    String id = event.id;

    String url = "https://192.168.0.103:8080/events/$id";
    print("Deletando: $url");
    Response response = await http.delete(url);
    int statusCode = response.statusCode;
    print("StatusCode:$statusCode");

  }
}
