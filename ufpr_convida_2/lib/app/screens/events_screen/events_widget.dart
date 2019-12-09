import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ufpr_convida_2/app/shared/models/event.dart';
import 'package:ufpr_convida_2/app/shared/globals/globals.dart' as globals;
import 'package:http/http.dart' as http;

enum WhyFarther { harder, smarter, selfStarter, tradingCharter }

class EventsWidget extends StatefulWidget {
  @override
  _EventsWidgetState createState() => _EventsWidgetState();
}

class _EventsWidgetState extends State<EventsWidget> {
  String _url = globals.URL;
  var jsonData;

  Future<List> getAllEvents() async {
    List<Event> events = [];
    Iterable list;

    http.Response response = await http.get("$_url/events");
    print("StatusCode:${response.statusCode}");

    if ((response.statusCode == 200) || (response.statusCode == 201)) {
      list = json.decode(response.body);
    } else {
      throw Exception("Falhou!");
    }

    events = list.map((model) => Event.fromJson(model)).toList();
    return events;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        child: FutureBuilder(
            //initialData: "Loading..",
            future: getAllEvents(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              List<Event> values = snapshot.data;
              if (snapshot.data == null) {
                return CircularProgressIndicator();
              } else {
                return ListView.builder(
                    itemCount: values.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
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
                                values[index].desc,
                                style: TextStyle(
                                    fontStyle: FontStyle.italic,
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w300),
                              ),
                              leading: CircleAvatar(
                                radius: 42.0,
                                backgroundColor: Colors.white,
                                child: Image.asset("assets/calendar.png"),
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
                                    value: WhyFarther.harder,
                                    child: Text('Working a lot harder'),
                                  ),
                                  const PopupMenuItem<WhyFarther>(
                                    value: WhyFarther.smarter,
                                    child: Text('Being a lot smarter'),
                                  ),
                                  const PopupMenuItem<WhyFarther>(
                                    value: WhyFarther.selfStarter,
                                    child: Text('Being a self-starter'),
                                  ),
                                  const PopupMenuItem<WhyFarther>(
                                    value: WhyFarther.tradingCharter,
                                    child: Text(
                                        'Placed in charge of trading charter'),
                                  ),
                                ],
                              ),
                              onTap: () {
                                Navigator.pushNamed(context, '/event', arguments: {
                                  'id' : values[index].id
                                });
                              },
                            ),
                          ],
                        ),
                      );
                    });
              }
            }));
  }
}
