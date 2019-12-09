import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';
import 'dart:io';
import 'package:ufpr_convida_2/app/shared/globals/globals.dart' as globals;
import 'package:ufpr_convida_2/app/shared/models/event.dart';

class DetailedEventWidget extends StatefulWidget {
  @override
  _DetailedEventWidgetState createState() => _DetailedEventWidgetState();
}

class _DetailedEventWidgetState extends State<DetailedEventWidget> {

  String _url = globals.URL;
  final DateFormat formatter = new DateFormat.yMd("pt_BR").add_Hm();
  final DateFormat hour = new DateFormat.Hm();
  final DateFormat teste = new DateFormat("EEE, d MMM","pt_BR");

  @override
  Widget build(BuildContext context) {
    final routeArgs = ModalRoute.of(context).settings.arguments as Map<String, String>;
    final eventId = routeArgs['id'];

    return FutureBuilder(
      future: getEvent(eventId),
      builder: (BuildContext context, AsyncSnapshot <Event> snapshot ) {
        if (snapshot.data == null){
          return CircularProgressIndicator();
        } else {

          DateTime dateEvent = DateTime.parse(snapshot.data.dateEvent);
          


          return Scaffold(
            backgroundColor: Colors.white70,
            body: CustomScrollView(
              slivers: <Widget>[
                SliverAppBar(
                    centerTitle: true,
                    title: Text("${snapshot.data.name}"),
                    pinned: true,
                    floating: true),
                SliverFixedExtentList(
                  itemExtent: 150.0,
                  delegate: SliverChildListDelegate(
                    [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 6),
                        child: Container(
                          alignment: Alignment.topLeft,
                          color: Colors.white,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("${snapshot.data.name}",
                                    style: TextStyle(
                                        fontSize: 18, fontWeight: FontWeight.bold)),
                              ),
                              //SizedBox(height: 6),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                                child: Row(
                                  children: <Widget>[
                                    Icon(Icons.access_time, size: 28),
                                    SizedBox(width: 5),
                                    Text("Sáb, 25 jan - ${teste.format(dateEvent)}"),
                                  ],
                                ),
                              ),

                              Padding(
                                padding: const EdgeInsets.only(left: 42),
                                child:
                                Text("12h - ${hour.format(dateEvent)}", style: TextStyle(fontSize: 12)),
                              ),

                              Padding(
                                padding: const EdgeInsets.fromLTRB(8, 8, 0, 0),
                                child: Row(
                                  children: <Widget>[
                                    Icon(Icons.location_on, size: 28),
                                    SizedBox(width: 5),
                                    Text("SEPT - UFPR")
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 42),
                                child: Text("Rua tal tal tal tsl stal",
                                    style: TextStyle(fontSize: 12)),
                              ),
                            ],
                          ),
                        ),
                      ),

                      //Description
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 6),
                        child: Container(
                          alignment: Alignment.topLeft,
                          color: Colors.white,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("Descrição do evento",
                                    style: TextStyle(
                                        fontSize: 18, fontWeight: FontWeight.bold)),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                    "Tals talsTals talsTals talsTals talsTals tals Tals talsTals talsTals talsTals talsTals tals Tals talsTals talsTals ls talsTals tals Tals Tals talsTals talsTals talsTals talsTals tals sTals talsTals talsTals talsTals talsTals tals"),
                              ),
                            ],
                          ),
                        ),
                      ),

                      Container(
                        padding: const EdgeInsets.fromLTRB(0, 6, 0, 6),
                        alignment: Alignment.topLeft,
                        color: Colors.white,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text("Sobre o organizador",
                                  style: TextStyle(
                                      fontSize: 18, fontWeight: FontWeight.bold)),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                  "Tals talsTals talsTals talsTals talsTals tals"),
                            ),
                          ],
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 6, 0, 6),
                        child: Container(
                          alignment: Alignment.topLeft,
                          color: Colors.white,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("Mais informaçoes",
                                    style: TextStyle(
                                        fontSize: 18, fontWeight: FontWeight.bold)),
                              ),
                              SizedBox(
                                height: 2,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: Text("Link: www...."),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: Text("Categoria: Festa"),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: IconButton(icon: Icon(Icons.my_location), onPressed: () => null),
                              ),
                            ],
                          ),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 6),
                        child: Container(
                          alignment: Alignment.topLeft,
                          color: Colors.white,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("Inscrições:",
                                    style: TextStyle(
                                        fontSize: 18, fontWeight: FontWeight.bold)),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container (child: Text("nao tem!"))

                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            bottomNavigationBar: BottomAppBar(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  //crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      RaisedButton(
                        color: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        onPressed: () {
                          Navigator.pushNamed(context, '/main');
                        },
                        padding: EdgeInsets.fromLTRB(60, 12, 60, 12),
                        child: Text('Favoritar',
                            style: TextStyle(color: Colors.white, fontSize: 18)),
                      ),
                    ]),
              ),
            ),
          );
        }
      },
    );
  }
  Future <Event> getEvent(String eventId) async {
    http.Response response =
        await http.get("$_url/events/$eventId");
    print(response.statusCode);
    var jsonEvent;
    if ((response.statusCode == 200) || (response.statusCode == 201)) {
      jsonEvent = json.decode(response.body);
      Event e = Event.fromJson(jsonEvent);
      return e;

    } else {
      throw Exception("Falhou!");
    }
  }
}
