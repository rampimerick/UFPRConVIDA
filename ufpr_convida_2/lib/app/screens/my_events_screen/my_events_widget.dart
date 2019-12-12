import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ufpr_convida_2/app/shared/models/event.dart';
import 'package:ufpr_convida_2/app/shared/globals/globals.dart' as globals;
import 'package:http/http.dart' as http;

enum WhyFarther {Alterar, Deletar}

class MyEventsWidget extends StatefulWidget {
  @override
  _MyEventsWidgetState createState() => _MyEventsWidgetState();
}

class _MyEventsWidgetState extends State<MyEventsWidget> {

  String _url = globals.URL;
  var jsonData;
  String _imageAsset = "";
  DateFormat date = new DateFormat.yMMMMd("pt_BR");
  DateFormat hour = new DateFormat.Hm();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return null;
      },
      child: globals.token == ""
          ? _withoutLogin(context)
          : Container(
        child: Center(
          child: FutureBuilder(
            future: getMyEvents(globals.userName),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              print(snapshot.data);

              List<Event> values = snapshot.data;

              print(values);

              if (snapshot.data == null) {
                return CircularProgressIndicator();
              } else if (values.length == 0){ //Caso nao haver eventos!
                return Container(
                  child: Text ("Sem eventos criados!"),
                );
              } else {
                return ListView.builder(
                    itemCount: values.length,
                    itemBuilder: (BuildContext context, int index) {
                      //Select the image:
                      print("Event type: ${values[index].type }");

                      if(values[index].type == 'Saúde'){
                        _imageAsset = 'type-health.png';
                      }else if (values[index].type == 'Esporte e Lazer'){
                        _imageAsset = 'type-sport.png';
                      }else if (values[index].type == 'Festas e Comemorações'){
                        _imageAsset = 'type-party.png';
                      }else if (values[index].type == 'Cultura'){
                        _imageAsset = 'type-art.png';
                      }else if (values[index].type == 'Acadêmico'){
                        _imageAsset = 'type-graduation.png';
                      }else {
                        _imageAsset = 'type-others.png';
                      }

                      DateTime eventDate = DateTime.parse(values[index].dateStart);
                      DateTime eventHour = DateTime.parse(values[index].hrStart);

                      return SizedBox(
                        width: double.infinity,
                        height: 120,
                        child: Card(
                          child: Column(
                            children: <Widget>[
                              //Event's Info:
                              ListTile(
                                title: Text(
                                  values[index].name,
                                  style: TextStyle(
                                      color: Colors.black87,
                                      fontSize: 21.0,
                                      fontWeight: FontWeight.w500),
                                ),
                                subtitle: Text(
                                  "${date.format(eventDate)} - ${hour.format(eventHour)}",
                                  style: TextStyle(
                                      fontStyle: FontStyle.italic,
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w300),
                                ),
                                leading: CircleAvatar(
                                  radius: 42.0,
                                  backgroundColor: Colors.white,
                                  child: Image.asset("assets/$_imageAsset"),
                                ),
                                isThreeLine: true,

                                //Just a Test:
                                trailing: PopupMenuButton<WhyFarther>(
                                  onSelected: (WhyFarther result) {
                                    setState(() {});
                                  },
                                  itemBuilder: (BuildContext context) =>
                                  <PopupMenuEntry<WhyFarther>>[
                                    const PopupMenuItem<WhyFarther>(
                                      value: WhyFarther.Alterar,
                                      child: Text('Alterar evento'),
                                    ),
                                    const PopupMenuItem<WhyFarther>(
                                      value: WhyFarther.Deletar,
                                      child: Text('Deletar evento'),
                                    ),

                                  ],
                                ),
                                onTap: () {
                                  Navigator.pushNamed(context, '/my-detailed-event', arguments: {
                                    'id' : values[index].id
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    });
              }
            },
          ),
        ),
      ),
    );
  }
  Container _withoutLogin(BuildContext context) {
    return Container(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            //Botao Entrar
            Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Image.asset(
                      //Image:
                      "assets/logo-ufprconvida-sembordas.png",
                      width: 400.0,
                      height: 400.0,
                      //color: Colors.white70,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: RaisedButton(
                        color: Color(0xFF295492),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        onPressed: () async {
                          Navigator.of(context).pushNamed("/login");
                        },
                        padding: EdgeInsets.fromLTRB(60, 12, 60, 12),
                        child: Text('Fazer Login',
                            style:
                            TextStyle(color: Colors.white, fontSize: 18)),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: RaisedButton(
                        color: Color(0xFF8A275D),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        onPressed: () {
                          //When press Signup:
                          Navigator.of(context).pushNamed("/signup");
                        },
                        padding: EdgeInsets.fromLTRB(43, 12, 43, 12),
                        child: Text('Fazer Cadastro',
                            //Color(0xFF295492),(0xFF8A275D)
                            style:
                            TextStyle(color: Colors.white, fontSize: 18)),
                      ),
                    ),
                    SizedBox(height: 30),
                  ],
                )),
          ],
        ),
      ),
    );
  }

  Future<List> getMyEvents(String userName) async {
    Map<String, String> mapHeaders = {
      "Accept": "application/json",
      "Content-Type": "application/json",
      HttpHeaders.authorizationHeader: "Bearer ${globals.token}"
    };

    http.Response response = await http.get("$_url/users/myevents?text=$userName", headers: mapHeaders);

    print("-------------------------------------------------------");
    print("Request on: $_url/users/myevents?text=$userName");
    print("Status Code: ${response.statusCode}");
    print("Loading My Events...");
    print("-------------------------------------------------------");

    if ((response.statusCode == 200) || (response.statusCode == 201)) {
      final parsed = json.decode(response.body).cast<Map<String, dynamic>>();
      return parsed.map<Event>((json) => Event.fromJson(json)).toList();
    } else {
      throw Exception("Falhou!");
    }
  }
}
