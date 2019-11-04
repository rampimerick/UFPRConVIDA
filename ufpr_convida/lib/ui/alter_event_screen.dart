import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ufpr_convida/modelos/evento.dart';
import 'package:http/http.dart' as http;
import 'package:ufpr_convida/ui/tela_eventos.dart';
import 'package:ufpr_convida/ui/tela_principal.dart';
import 'package:ufpr_convida/util/globals.dart' as globals;

DateTime parsedDateEvent = DateTime.now();
DateTime parsedDateInit = DateTime.now();
DateTime parsedDateEnd = DateTime.now();

String showDateEvent = "Informe a Data do Evento";
String showDateInit ="Informe o Início das Inscrições";
String showDateEnd = "Informe o Fim das Inscrições";

String dateEvent ="";
String dateInit ="";
String dateEnd ="";

final DateFormat showDate = DateFormat("dd/MM/yyyy HH:mm");
final DateFormat dateFormat = DateFormat("yyyy-MM-ddTHH:mm:ss");


class alterEvent extends StatefulWidget {
  Event event;
  alterEvent({Key key, @required this.event}) : super(key: key);

  @override
  _alterEventState createState() => _alterEventState(event);
}

class _alterEventState extends State<alterEvent> {
  Event event;
  _alterEventState(this.event);

  String url = globals.URL;

  List _types = ["Reunião","Festa","Formatura","Indefinido"];
  List<DropdownMenuItem<String>> _dropDownMenuItemsTypes;
  String _currentType;

    @override
    void initState() {
      _dropDownMenuItemsTypes = getDropDownMenuItemsTypes();
      _currentType = _dropDownMenuItemsTypes[0].value;

      _eventNameController.text = event.name;
      _eventTargetController.text = event.target;
      _eventDescController.text = event.desc;
      _eventLinkController.text = event.link;
      _eventTypeController.text = event.type;
      _eventBlocController.text = event.bloc;
      _eventSectorController.text = event.sector;
      //Datas:
      //Mostrar as datas como nao informadas, pois ao criar eventos sem informar datas, todas recebem a mesma data
      if (event.init == event.end) {
        showDateInit = "Informe o Início das Inscrições";
        showDateEnd = "Informe o Fim das Inscrições";
      }
      if ((event.date_event == event.init) && (event.date_event == event.end)) {
        showDateEvent = "Informe a Data do Evento";
        showDateInit = "Informe o Início das Inscrições";
        showDateEnd = "Informe o Fim das Inscrições";
      }

      if (event.date_event != null) {
        parsedDateEvent = DateTime.parse(event.date_event);
        dateEvent = dateFormat.format(parsedDateEvent);
        showDateEvent = showDate.format(parsedDateEvent);
      }
      if (event.init != null) {
        parsedDateInit = DateTime.parse(event.init);
        dateInit = dateFormat.format(parsedDateInit);
        showDateInit = showDate.format(parsedDateInit);
      }
      if (event.end != null) {
        parsedDateEnd = DateTime.parse(event.end);
        dateEnd = dateFormat.format(parsedDateEnd);
        showDateEnd = showDate.format(parsedDateEnd);
      }
      super.initState();
    }

    //Controles:
      final TextEditingController _eventNameController =
      new TextEditingController();
      final TextEditingController _eventTargetController =
      new TextEditingController();
      final TextEditingController _eventDescController =
      new TextEditingController();
      final TextEditingController _eventLinkController =
      new TextEditingController();
      final TextEditingController _eventTypeController =
      new TextEditingController();
      final TextEditingController _eventSectorController =
      new TextEditingController();
      final TextEditingController _eventBlocController =
      new TextEditingController();

    final DateFormat dateFormat = DateFormat("yyyy-MM-ddTHH:mm:ss");
    final DateFormat showDate = DateFormat("dd/MM/yyyy HH:mm");

    DateTime selectedDateEvent = DateTime.now();
    DateTime selectedDateInit = DateTime.now();
    DateTime selectedDateEnd = DateTime.now();

    Widget build(BuildContext context) {

    return Scaffold(
      //child: Text("Evento que será alterado: ${event.name}"),

      body: Container(
        child: ListView(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(10),
              alignment: Alignment.center,
              child: Text(
                "Alterando Evento",
                style: TextStyle(
                    color: Color(0xFF295492), //Color(0xFF8A275D),
                    fontSize: 32.0,
                    fontWeight: FontWeight.bold),
              ),
            ),

            //Nome do Evento:
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

            //Publico Alvo
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

            //Descrição:
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
            //-----------------------
            //DATAS:
            //Data do Evento:
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
                            dateEvent = dateFormat.format(selectedDateEvent);
                            showDateEvent = showDate.format(selectedDateEvent);
                            print("Formato data post: $dateEvent");
                          });
                          return 0;
                        },
                        padding: EdgeInsets.all(5),

                      ),
                    ),

                  ],
                )),

            //Data Inicio Inscrições
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
                            dateInit = dateFormat.format(selectedDateInit);
                            showDateInit = showDate.format(selectedDateInit);
                            print("Formato data post: $dateInit");
                          });
                          return 0;
                        },

                        padding: EdgeInsets.all(5),

                      ),
                    ),

                  ],
                )),

            //Data Fim Inscrições:
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
                            dateEnd = dateFormat.format(selectedDateEnd);
                            showDateEnd = showDate.format(selectedDateEnd);
                            print("Formato data post: $dateEnd");
                          });
                          return 0;
                        },

                        padding: EdgeInsets.all(5),

                      ),
                    ),

                  ],
                )),
            //-----------------------
            //Link
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

            //Tipo
            Padding(
              padding: EdgeInsets.fromLTRB(6, 8, 8, 8),
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 10, 15, 0),
                          child: Icon(Icons.calendar_today,color: Colors.grey),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 10, 18, 0),
                          child: new Text("Tipo do evento: ", style: TextStyle(
                              fontSize: 16,
                              color: Colors.black54
                          ),),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: DropdownButton(
                            value: _currentType,
                            items: _dropDownMenuItemsTypes,
                            onChanged: changedDropDownItemType,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            //Setor:
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
            //Bloco
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: TextField(
                  controller: _eventBlocController,
                  decoration: InputDecoration(
                    hintText: "Caso for na UFPR: Informe o Bloco",
                    //border: OutlineInputBorder(
                    //  borderRadius:,
                    //),
                    icon: Icon(Icons.account_balance),
                  )),
            ),

            //Botões:
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                      child: FlatButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        color: Color(0xFF295492),
                        shape:RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        padding: EdgeInsets.fromLTRB(30, 12, 30, 12),
                        child: Text(
                          "Cancelar",
                          style: TextStyle(color: Colors.white, fontSize: 17.0),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                      child: RaisedButton(
                        onPressed: () async {
                          Put newPut = new Put(
                            name: _eventNameController.text,
                            target: _eventTargetController.text,
                            date_event: dateEvent,
                            desc: _eventDescController.text,
                            init: dateInit,
                            end: dateEnd,
                            link:_eventLinkController.text,
                            type: _currentType,
                            sector: _eventSectorController.text,
                            bloc: _eventBlocController.text
                          );
                          String stringPut = json.encode(newPut.toMap());
                          print(stringPut);

                          Put p = await createPut("$url/events/${event.id}",body: stringPut);
                          Navigator.of(context).push(new MaterialPageRoute(
                              builder: (BuildContext context) {
                                return new telaPrincipal();
                              }));
                        },
                        color: Color(0xFF8A275D),
                        shape:RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),

                        ),
                        padding: EdgeInsets.fromLTRB(30, 12, 30, 12),
                        child: Text(
                          "Alterar",
                          style: TextStyle(color: Colors.white, fontSize: 17.0),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void name() {
    _eventNameController.value = _eventNameController.value.copyWith(
      text: event.name,
      selection: TextSelection(
          baseOffset: event.name.length, extentOffset: event.name.length),
      composing: TextRange.empty,
    );
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

  List<DropdownMenuItem<String>> getDropDownMenuItemsTypes() {
    List<DropdownMenuItem<String>> items = new List();
    for (String type in _types) {
      items.add(new DropdownMenuItem(value: "$type", child: new Text(type)));
    }
    return items;
  }

  void changedDropDownItemType(String selected) {
    setState(() {
      _currentType = selected;
    });
  }
}

class Put {
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
  final String bloc;

  Put(
      { this.name,
        this.target,
        this.date_event,
        this.desc,
        this.init,
        this.end,
        this.link,
        this.type,
        this.sector,
        this.bloc});

  factory Put.fromJson(Map<String, dynamic> json) {
    return Put(

        name: json['name'],
        target: json['target'],
        date_event: json['date_event'],
        desc: json['desc'],
        init: json['init'],
        end: json['end'],
        link: json['link'],
        type: json['type'],
        sector: json['sector'],
        bloc: json['bloc']
    );
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
      "bloc": bloc,
    };
  }
}

Future<Put> createPut(String url, {String body}
    /*Aqui tem que ter HEADERS?*/) async {
  Map<String, String> mapHeaders = {
    "Accept": "application/json",
    "Content-Type": "application/json",
    HttpHeaders.authorizationHeader: "Bearer ${globals.token}"
  };

  return http
      .put(url, body: body, headers: mapHeaders)
      .then((http.Response response) {
    final int statusCode = response.statusCode;
    print(statusCode);

    if ((statusCode == 200) || (statusCode == 201) || (statusCode == 204)) {
      return null; //Post.fromJson(json.decode(response.body));
    } else {
      throw new Exception("Error while fetching data");
    }
  });
}