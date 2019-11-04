import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:ufpr_convida/modelos/evento.dart';
import 'package:ufpr_convida/ui/alter_event_screen.dart';
import 'package:ufpr_convida/ui/tela_principal.dart';
import 'package:ufpr_convida/util/globals.dart' as globals;

class DetailedEventScreen extends StatefulWidget {
  String idEvent;


  DetailedEventScreen({Key key, @required this.idEvent}) : super(key: key);

  @override
  _DetailedEventScreenState createState() => _DetailedEventScreenState(idEvent);
}

class _DetailedEventScreenState extends State<DetailedEventScreen> {
  String idEvent;


  _DetailedEventScreenState(this.idEvent);

  Future<Event> event;
  String url = globals.URL;
  @override
  void initState() {
    print("ID do Evento:$idEvent");
    event = getEvent();
    super.initState();
  }

  Future<Event> getEvent() async {
    http.Response response =
        await http.get("$url/events/$idEvent");
    print(response.statusCode);
    var jsonEvent;
    if ((response.statusCode == 200) || (response.statusCode == 201)) {
      jsonEvent = json.decode(response.body);
    } else {
      throw Exception("Falhou!");
    }

    var _event = Event.fromJson(jsonEvent);
    print("${_event.name}");
    return _event;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: FutureBuilder(
          future: event,
          builder: (context, AsyncSnapshot<Event> snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              //Snapshot.data == Event
              //Recebe a imagem específica do tipo de evento:
              String imagem;
              if (snapshot.data.type.compareTo('Reunião') == 0) {
                imagem = "assets/event-type-2.png";
              } else if (snapshot.data.type.compareTo('Festa') == 0) {
                imagem = "assets/event-type-1.png";
              } else {
                imagem = "assets/event-type-3.png";
              }

              //Trata a data:
              var f = new DateFormat.yMMMMd("pt_BR").add_Hm();
              var parsedDate;
              String showDateEvent = "Data não informada";
              if (snapshot.data.date_event != null){
                parsedDate = DateTime.parse(snapshot.data.date_event);
                showDateEvent = f.format(parsedDate);
              }

              return Scaffold(
                  appBar: AppBar(title: Text("Evento: ${snapshot.data.name}")),
                  body: Container(
                    child: ListView(
                      children: <Widget>[
                        Stack(
                          alignment: Alignment.topCenter,
                          children: <Widget>[
                            //Imagem de fundo
                            Container(
                              child: Image.asset(imagem),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 250),
                              //Card que ficará as informações
                              child: Container(
                                height: 375,
                                width: 350,
                                child: Material(
                                  color: Colors.white,
                                  elevation: 4.0,
                                  borderRadius: BorderRadius.circular(20),
                                  shadowColor: Color(0x802196f3),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      //Informações:

                                      //Nome do evento:
                                      Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Text(
                                          "${snapshot.data.name}",
                                          style: TextStyle(
                                            fontStyle: FontStyle.italic,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 30.0,
                                            color: Colors.pink,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10.0,
                                      ),

                                      //Descrição do Evento
                                      Padding(
                                        padding: const EdgeInsets.only(left: 8, right: 8),
                                        child: Text(
                                          "${snapshot.data.desc}",
                                          style: TextStyle(
                                            fontSize: 18.0,
                                            color: Colors.black54,
                                          ),
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
                                              "$showDateEvent",
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
                                              size: 24.0,
                                              color: Color(0xffE810350),
                                            ),
                                            SizedBox(
                                              height: 10.0,
                                            ),
                                            //Link do
                                            Text(
                                              " ${snapshot.data.link}",
                                              style: TextStyle(
                                                  fontSize: 20.0,
                                                  color: Color(0xffE810350)),
                                            )
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: 20.0),
                                      //---------------------------Melhorar--------------------------
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
                                                        //Passa o Evento
                                                        event: snapshot.data,
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
                                                          //Passa o String evento ID para deletar
                                                          deleteEvent(snapshot.data.id);
                                                          //Faz a requisição com o ID do evento
                                                          Navigator.of(context).push(
                                                              new MaterialPageRoute(
                                                                  builder: (BuildContext
                                                                  context) {
                                                                    return new telaPrincipal();
                                                                  }));
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
                                          //------------------------------------------------------------------------
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ));
            }
          },
        ),
      ),
    );
  }

  void deleteEvent(String eventId) async {

    Map<String, String> mapHeaders = {
      "Accept": "application/json",
      "Content-Type": "application/json",
      HttpHeaders.authorizationHeader: "Bearer ${globals.token}"
    };

    Response response = await http.delete("$url/events/$eventId", headers: mapHeaders);
    print("Deletando: $url/events/$eventId");
    int statusCode = response.statusCode;
    print("StatusCode:$statusCode");
  }
}
