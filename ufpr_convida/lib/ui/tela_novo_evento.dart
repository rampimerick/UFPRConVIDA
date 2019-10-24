import 'dart:async';
import 'dart:async' as prefix0;
import 'dart:convert';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:intl/intl.dart';
import 'package:ufpr_convida/modelos/location.dart';
import 'package:ufpr_convida/ui/tela_eventos.dart';
import 'package:ufpr_convida/ui/tela_mapa.dart';
import 'package:ufpr_convida/ui/tela_principal.dart';

var coord = null;
String dateEvent;
String dateInit;
String dateEnd;

class Post {
  //final String Id;
  final String name;
  final String target;
  final String date_event;
  final String desc;
  final String init;
  final String end;
  final String link;
  final String type;
  final String sector;
  final String block;
  final double lat;
  final double lng;

  Post(
      {this.name,
      this.target,
      this.date_event,
      this.desc,
      this.init,
      this.end,
      this.link,
      this.type,
      this.sector,
      this.block,
      this.lat,
      this.lng});

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
        //Id: json['Id'],
        name: json['name'],
        target: json['target'],
        date_event: json['date_event'],
        desc: json['desc'],
        init: json['init'],
        end: json['end'],
        link: json['link'],
        type: json['type'],
        sector: json['sector'],
        block: json['block'],
        lat: json['lat'],
        lng: json['lng']);
  }

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "target": target,
      "date_event": date_event,
      "desc": desc,
      "init": init,
      "end": end,
      "link": link,
      "type": type,
      "sector": sector,
      "block": block,
      "lat": lat,
      "lng": lng
    };
  }
}

Future<Post> createPost(String url, {String body}
    /*Aqui tem que ter HEADERS?*/) async {
  Map<String, String> mapHeaders = {
    "Accept": "application/json",
    "Content-Type": "application/json"
  };

  return http
      .post(url, body: body, headers: mapHeaders)
      .then((http.Response response) {
    final int statusCode = response.statusCode;
    print(statusCode);

    if ((statusCode == 200) || (statusCode == 201)) {
      return null; //Post.fromJson(json.decode(response.body));
    } else {
      throw new Exception("Error while fetching data");
    }
  });
}

class telaNovoEvento extends StatefulWidget {
  final Location locationObject;

  telaNovoEvento({Key key, @required this.locationObject}) : super(key: key);

  @override
  _telaNovoEventoState createState() => _telaNovoEventoState(locationObject);
}

class _telaNovoEventoState extends State<telaNovoEvento> {
  Location location;

  final DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm");
  final DateFormat showDate = DateFormat("dd/MM/yyyy HH:mm");
  String showDateEvent = "Informe a Data do Evento";
  String showDateInit = "Informe o Inicio das Inscrições";
  String showDateEnd = "Informe o Fim das Inscrições";
  DateTime selectedDateEvent = DateTime.now();
  DateTime selectedDateInit = DateTime.now();
  DateTime selectedDateEnd = DateTime.now();

  _telaNovoEventoState(this.location);

  @override
  //Controles:
  final TextEditingController _eventNameController =
      new TextEditingController();
  final TextEditingController _eventTargetController =
      new TextEditingController();
  final TextEditingController _eventDateController =
      new MaskedTextController(mask: '0000/00/00');
  final TextEditingController _eventDescController =
      new TextEditingController();
  final TextEditingController _eventDateInitController =
      new MaskedTextController(mask: '0000/00/00');
  final TextEditingController _eventDateEndController =
      new MaskedTextController(mask: '0000/00/00');
  final TextEditingController _eventLinkController =
      new TextEditingController();
  final TextEditingController _eventTypeController =
      new TextEditingController();
  final TextEditingController _eventSectorController =
      new TextEditingController();
  final TextEditingController _eventBlockController =
      new TextEditingController();

  Widget build(BuildContext context) {
    return Scaffold(
//        appBar: AppBar(
//          title: Text("Seu novo Evento"),
//        ),
        body: Container(
          child: ListView(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(10),
                child: Container(
                  alignment: Alignment.center,
                  child: Text(
                    "Criando Novo Evento",
                    style: TextStyle(
                        color: Color(0xFF295492), //Color(0xFF8A275D),
                        fontSize: 32.0,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: TextField(
                    controller: _eventNameController,
                    decoration: InputDecoration(
                      hintText: "Nome do seu Evento:",
                      //border: OutlineInputBorder(
                      //  borderRadius:,
                      //),
                      icon: Icon(Icons.event_note),
                    )),
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: TextField(

                    controller: _eventTargetController,
                    decoration: InputDecoration(
                      hintText: "Público Alvo:",
                      //border: OutlineInputBorder(
                      //  borderRadius:,
                      //),
                      icon: Icon(Icons.person_pin_circle),
                    )),
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: TextField(
                    controller: _eventDescController,
                    maxLines: 2,
                    decoration: InputDecoration(
                      hintText: "Descrição:",
                      //border: OutlineInputBorder(
                      //  borderRadius:,
                      //),
                      icon: Icon(Icons.note),
                    )),
              ),
              Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Row(
                    children: <Widget>[

                      Padding(
                        padding: const EdgeInsets.fromLTRB(45.0, 8.0, 8.0, 8.0),
                        child: Container(
                          width: 242.0,
                          height: 38.0,
                          child: Center(
                            child: Text(showDateEvent,
                                style: TextStyle(
                                color: Color(0xFF295492),
                                fontWeight: FontWeight.w500,
                                fontSize: 16.0
                              ),),
                          ),
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: Color(0xFF295492),
                                  width: 3.0,
                                  style: BorderStyle.solid
                              ),
                              borderRadius: BorderRadius.all(
                               Radius.circular(6)
                              ),


                          ),

                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: RaisedButton(
                          child: Icon(Icons.today),
                          onPressed: () async {
                            final selectedDate = await _selectedDateTime(context);
                            if (selectedDate == null) return 0;

                            final selectedTime = await _selectedTime(context);
                            if (selectedDate == null) return 0;

                            setState(() {
                              this.selectedDateEvent = DateTime(
                                selectedDate.year,
                                selectedDate.month,
                                selectedDate.day,
                                selectedTime.hour,
                                selectedTime.minute
                              );
                              dateEvent = selectedDate.toString();
                              print("DateEvent String: $dateEvent");
                              showDateEvent = showDate.format(selectedDate);
                            });
                            return 0;
                          },

                          padding: EdgeInsets.all(5),

                        ),
                      ),

                    ],
                  )),

              //------------------------------------------------------------------------
              Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Row(
                    children: <Widget>[

                      Padding(
                        padding: const EdgeInsets.fromLTRB(45.0, 8.0, 8.0, 8.0),
                        child: Container(
                          width: 242.0,
                          height: 38.0,
                          child: Center(
                            child: Text(showDateInit,
                              style: TextStyle(
                                  color: Color(0xFF295492),
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16.0
                              ),),
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: Color(0xFF295492),
                                width: 3.0,
                                style: BorderStyle.solid
                            ),
                            borderRadius: BorderRadius.all(
                                Radius.circular(6)
                            ),


                          ),

                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: RaisedButton(
                          child: Icon(Icons.today),
                          onPressed: () async {
                            final selectedDate = await _selectedDateTime(context);
                            if (selectedDate == null) return 0;

                            final selectedTime = await _selectedTime(context);
                            if (selectedDate == null) return 0;

                            setState(() {
                              this.selectedDateInit = DateTime(
                                  selectedDate.year,
                                  selectedDate.month,
                                  selectedDate.day,
                                  selectedTime.hour,
                                  selectedTime.minute
                              );
                              dateEvent = selectedDate.toString();
                              print("DateEvent String: $dateEvent");
                              showDateInit = showDate.format(selectedDate);
                            });
                            return 0;
                          },

                          padding: EdgeInsets.all(5),

                        ),
                      ),

                    ],
                  )),


              Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Row(
                    children: <Widget>[

                      Padding(
                        padding: const EdgeInsets.fromLTRB(45.0, 8.0, 8.0, 8.0),
                        child: Container(
                          width: 242.0,
                          height: 38.0,
                          child: Center(
                            child: Text(showDateEnd,
                              style: TextStyle(
                                  color: Color(0xFF295492),
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16.0
                              ),),
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: Color(0xFF295492),
                                width: 3.0,
                                style: BorderStyle.solid
                            ),
                            borderRadius: BorderRadius.all(
                                Radius.circular(6)
                            ),


                          ),

                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: RaisedButton(
                          child: Icon(Icons.today),
                          onPressed: () async {
                            final selectedDate = await _selectedDateTime(context);
                            if (selectedDate == null) return 0;

                            final selectedTime = await _selectedTime(context);
                            if (selectedDate == null) return 0;

                            setState(() {
                              this.selectedDateEnd = DateTime(
                                  selectedDate.year,
                                  selectedDate.month,
                                  selectedDate.day,
                                  selectedTime.hour,
                                  selectedTime.minute
                              );
                              dateEvent = selectedDate.toString();
                              print("DateEvent String: $dateEvent");
                              showDateEnd = showDate.format(selectedDate);
                            });
                            return 0;
                          },

                          padding: EdgeInsets.all(5),

                        ),
                      ),

                    ],
                  )),
              //------------------------------------------------------------------------
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: TextField(
                    controller: _eventLinkController,
                    decoration: InputDecoration(
                      hintText: "Link do seu Evento:",
                      //border: OutlineInputBorder(
                      //  borderRadius:,
                      //),
                      icon: Icon(Icons.link),
                    )),
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: TextField(
                    controller: _eventTypeController,
                    decoration: InputDecoration(
                      hintText: "Tipo do seu Evento:",
                      //border: OutlineInputBorder(
                      //  borderRadius:,
                      //),
                      icon: Icon(Icons.assignment),
                    )),
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: TextField(
                    controller: _eventSectorController,
                    decoration: InputDecoration(
                      hintText: "Caso for na UFPR: Informe o Setor",
                      //border: OutlineInputBorder(
                      //  borderRadius:,
                      //),
                      icon: Icon(Icons.import_contacts),
                    )),
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: TextField(
                    controller: _eventBlockController,
                    decoration: InputDecoration(
                      hintText: "Caso for na UFPR: Informe o Bloco",
                      //border: OutlineInputBorder(
                      //  borderRadius:,
                      //),
                      icon: Icon(Icons.account_balance),
                    )),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                        child: FlatButton(
                          onPressed: () => Navigator.of(context).push(new MaterialPageRoute(
                            builder: (BuildContext context) {
                              return new telaPrincipal();
                            })),
                          color: Color(0xFF295492),
                          child: Text(
                            "Cancelar",
                            style:
                                TextStyle(color: Colors.white, fontSize: 17.0),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                        child: FlatButton(
                          onPressed: () async {
                            DateFormat dateFormat = DateFormat("yyyy-MM-dd");
                            dateEvent = dateFormat.format(selectedDateEvent);

                            print("Data formatada: $dateEvent");

                            String coords = location.coords.toString();
                            _eventDateController.text.replaceAll("/", "-");

                              dateInit = _eventDateInitController.text
                                .replaceAll("/", "-");
                              dateEnd = _eventDateEndController.text
                                .replaceAll("/", "-");

                            print(dateEvent);

                            Post newPost = new Post(
                                //Id: "123",
                                name: _eventNameController.text,
                                target: _eventTargetController.text,
                                date_event: dateEvent,
                                desc: _eventDescController.text,
                                init: dateInit,
                                end: dateEnd,
                                link: _eventLinkController.text,
                                type: _eventTypeController.text,
                                sector: _eventSectorController.text,
                                block: _eventBlockController.text,
                                lat: location.coords.latitude,
                                lng: location.coords.longitude);

                            String post1 = json.encode(newPost.toMap());
                            print(post1);
                            Post p = await createPost(
                                "http://10.0.2.2:8080/events",
                                body: post1);
                            Navigator.of(context).push(new MaterialPageRoute(
                                builder: (BuildContext context) {
                              return new telaPrincipal();
                            }));
                            //Navigator.pop(context, () {setState(() {});});
                            //telaMapa();
                          },
                          color: Color(0xFF8A275D),
                          child: Text(
                            "Criar",
                            style:
                                TextStyle(color: Colors.white, fontSize: 17.0),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
          // ------------------------
        ));
  }

  Future<TimeOfDay> _selectedTime(BuildContext context) {
    final now = DateTime.now();

    return showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: now.hour, minute: now.minute),
    );
  }

  Future<DateTime> _selectedDateTime(BuildContext context) => showDatePicker(
      context: context,
      initialDate: DateTime.now().add(Duration(seconds: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100));
}
