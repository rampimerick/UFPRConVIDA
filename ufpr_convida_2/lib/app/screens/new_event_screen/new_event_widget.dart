import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:ufpr_convida_2/app/shared/globals/globals.dart' as globals;
import 'package:ufpr_convida_2/app/shared/models/event.dart';
import 'package:http/http.dart' as http;

class NewEventWidget extends StatefulWidget {
  @override
  _NewEventWidgetState createState() => _NewEventWidgetState();
}

class _NewEventWidgetState extends State<NewEventWidget> {
  String _url = globals.URL;
  final _formKey = GlobalKey<FormState>();

  //Coordenadas do Evento
  LatLng coords;

  //Dates:
  final DateFormat formatter = new DateFormat.yMd("pt_BR").add_Hm();
  final DateFormat dateFormat = new DateFormat("yyyy-MM-ddTHH:mm:ss");

  String showDateStart = "";
  String showDateEnd = "";
  String showSubStart = "";
  String showSubEnd = "";

  String postDateEventStart;
  String postDateEventEnd;
  String postSubEventStart;
  String postSubEventEnd;

  DateTime selectedDateEventStart = DateTime.now();
  DateTime selectedDateEventEnd = DateTime.now();
  DateTime selectedSubEventStart = DateTime.now();
  DateTime selectedSubEventEnd = DateTime.now();

  //Events Types
  var _dropDownMenuItemsTypes = ["Reunião", "Festa", "Formatura", "Indefinido"];
  String _currentType = 'Indefinido';

  //Switch:
  bool isSwitchedUFPR = false;
  bool isSwitchedSubs = false;

  //Controllers:
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

  @override
  Widget build(BuildContext context) {
    coords = ModalRoute
        .of(context)
        .settings
        .arguments as LatLng;

    return Scaffold(
      body: Form(
        key: _formKey,
        child: ListView(
          children: <Widget>[
            //Tittle
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

            //Event Name:
            eventNameInput(),

            //Event Target
            eventTargetInput(),

            //Event Description
            eventDescInput(),

            //Event Date Start:
            Padding(
                padding: const EdgeInsets.fromLTRB(47, 8, 8, 8),
                child: Container(
                  decoration: containerDecoration(),
                  child: InkWell(
                    onTap: () async {
                      final selectedDate = await _selectedDate(context);
                      if (selectedDate == null) return 0;

                      final selectedTime = await _selectedTime(context);
                      if (selectedDate == null) return 0;

                      setState(() {
                        this.selectedDateEventStart = DateTime(
                            selectedDate.year,
                            selectedDate.month,
                            selectedDate.day,
                            selectedTime.hour,
                            selectedTime.minute);
                        postDateEventStart =
                            dateFormat.format(selectedDateEventStart);
                        showDateStart =
                            formatter.format(selectedDateEventStart);
                        print("Formato data post: $postDateEventStart");
                      });
                      return 0;
                    },
                    child: eventDateStartOutput(),
                  ),
                )),

            //Date End Event:
            Padding(
                padding: const EdgeInsets.fromLTRB(47, 8, 8, 8),
                child: Container(
                  decoration: containerDecoration(),
                  child: InkWell(
                    onTap: () async {
                      final selectedDate = await _selectedDate(context);
                      if (selectedDate == null) return 0;

                      final selectedTime = await _selectedTime(context);
                      if (selectedDate == null) return 0;

                      setState(() {
                        this.selectedDateEventEnd = DateTime(
                            selectedDate.year,
                            selectedDate.month,
                            selectedDate.day,
                            selectedTime.hour,
                            selectedTime.minute);
                        //Format's:
                        postDateEventEnd =
                            dateFormat.format(selectedDateEventEnd);
                        showDateEnd = formatter.format(selectedDateEventEnd);
                        print("Formato data post: $postDateEventEnd");
                      });
                      return 0;
                    },
                    child: eventDateEndOutput(),
                  ),
                )),

            //Event Link or Email:
            eventLinkInput(),

            //Event Category
            Padding(
              padding: EdgeInsets.fromLTRB(6, 8, 8, 8),
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(2, 10, 15, 0),
                    child: Icon(Icons.calendar_today, color: Colors.grey),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                    child: Container(
                      decoration: containerDecoration(),
                      child: Row(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.fromLTRB(10, 5, 5, 5),
                            child: new Text(
                              "Tipo do evento: ",
                              style: TextStyle(
                                  fontSize: 16, color: Colors.black54),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(55, 5, 70, 5),
                            child: DropdownButton<String>(

                              items: _dropDownMenuItemsTypes.map((
                                  String dropDownStringIten) {
                                return DropdownMenuItem<String>(
                                    value: dropDownStringIten,
                                    child: Text(dropDownStringIten)
                                );
                              }).toList(),

                              onChanged: (String newType) {
                                setState(() {
                                  print("Executou um setState $newType");
                                  _currentType = newType;
                                });
                              },
                              value: _currentType,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            //Event Switch UFPR:
            eventSwitchUFPR(),
            Container(
                child: isSwitchedUFPR == true
                    ? Container(
                  child: Column(
                    children: <Widget>[
                      //Event Sector:
                      eventSectorInput(),
                      //Event Bloc:
                      eventBlocInput(),
                    ],
                  ),
                )
                    : nothingToShow()),

            //Event Switch Subscriptions:
            eventSwitchSubs(),

            Container(
                child: isSwitchedSubs == true
                    ? Container(
                  child: Column(
                    children: <Widget>[
                      //Subscriptions Start:
                      Padding(
                          padding: const EdgeInsets.fromLTRB(47, 8, 8, 8),
                          child: Container(
                            decoration: containerDecoration(),
                            child: InkWell(
                              onTap: () async {
                                final selectedDate =
                                await _selectedDate(context);
                                if (selectedDate == null) return 0;

                                final selectedTime =
                                await _selectedTime(context);
                                if (selectedDate == null) return 0;

                                setState(() {
                                  this.selectedSubEventStart = DateTime(
                                      selectedDate.year,
                                      selectedDate.month,
                                      selectedDate.day,
                                      selectedTime.hour,
                                      selectedTime.minute);
                                  //Format's:
                                  postSubEventStart = dateFormat
                                      .format(selectedSubEventStart);
                                  showSubStart = formatter
                                      .format(selectedSubEventStart);
                                  print(
                                      "Formato data post: $postSubEventStart");
                                });
                                return 0;
                              },
                              child: eventSubsStartOutput(),
                            ),
                          )),

                      //Subscriptions End:
                      Padding(
                          padding: const EdgeInsets.fromLTRB(47, 8, 8, 8),
                          child: Container(
                            decoration: containerDecoration(),
                            child: InkWell(
                              onTap: () async {
                                final selectedDate =
                                await _selectedDate(context);
                                if (selectedDate == null) return 0;

                                final selectedTime =
                                await _selectedTime(context);
                                if (selectedDate == null) return 0;

                                setState(() {
                                  this.selectedSubEventEnd = DateTime(
                                      selectedDate.year,
                                      selectedDate.month,
                                      selectedDate.day,
                                      selectedTime.hour,
                                      selectedTime.minute);
                                  //Format's:
                                  postSubEventEnd = dateFormat
                                      .format(selectedSubEventEnd);
                                  showSubEnd = formatter
                                      .format(selectedSubEventEnd);
                                  print(
                                      "Formato data post: $postSubEventEnd");
                                });
                                return 0;
                              },
                              child: eventSubsEndOutput(),
                            ),
                          )),
                    ],
                  ),
                )
                    : nothingToShow()),

            //Buttons:
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    padding: EdgeInsets.all(12),
                    onPressed: null,
                    color: Color(0xFF295492),
                    child: Text(
                      "Cancelar",
                      style: TextStyle(color: Colors.white, fontSize: 17.0),
                    ),
                  ),
                  SizedBox(width: 30),
                  RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    padding: EdgeInsets.all(12),
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        Event e = await postNewEvent();
                        //Event e is ready to do something else
                      }
                    },
                    color: Color(0xFF8A275D),
                    child: Text(
                      "Criar",
                      style: TextStyle(color: Colors.white, fontSize: 17.0),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<Event> postNewEvent() async {
    String id = "5d9244b9cc3ae9291e278265";

    Event p = new Event(
        //id: id,
        name: _eventNameController.text,
        target: _eventTargetController.text,
        desc: _eventDescController.text,
        dateEvent: postDateEventStart,
        //dateEventEnd: postDateEventEnd
        link: _eventLinkController.text,
        type: _currentType,
        sector: _eventSectorController.text,
        bloc: _eventBlocController.text,
        init: postSubEventStart,
        end: postSubEventEnd,
        lat: coords.latitude,
        lng: coords.longitude);

    String eventJson = json.encode(p.toJson());

    print(eventJson);
    print("Post em $_url/events");

    Map<String, String> mapHeaders = {
      "Accept": "application/json",
      "Content-Type": "application/json",
      HttpHeaders.authorizationHeader: "Bearer ${globals.token}"
    };

    Event success = await http
        .post("$_url/events", body: eventJson, headers: mapHeaders)
        .then((http.Response response) {
      final int statusCode = response.statusCode;
      if ((statusCode == 200) || (statusCode == 201)) {
        print("Post Event Success!");
        return Event.fromJson(json.decode(response.body));
      } else {
        throw new Exception("Error while fetching data, status code: $statusCode");
      }
    });

    return success;
  }

  Column eventSubsEndOutput() {
    return new Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 10, 180, 0),
          child: new Text(
            "Fim das inscrições: ",
            style: TextStyle(fontSize: 16, color: Colors.black54),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: new Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              //Dia
              Text(
                "$showSubEnd",
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
            ],
          ),
        )
      ],
    );
  }

  Column eventSubsStartOutput() {
    return new Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 10, 180, 0),
          child: new Text(
            "Inicio das Inscrições: ",
            style: TextStyle(fontSize: 16, color: Colors.black54),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: new Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              //Dia
              Text(
                "$showSubStart",
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
            ],
          ),
        )
      ],
    );
  }

  Padding eventSwitchSubs() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(47, 8.0, 8.0, 8.0),
      child: Row(
        children: <Widget>[
          Text("Seu evento tem datas de inscrições?"),
          Switch(
              value: isSwitchedSubs,
              onChanged: (value) {
                setState(() {
                  print("Executou um setState");
                  isSwitchedSubs = value;
                });
              }),
        ],
      ),
    );
  }

  Padding eventSwitchUFPR() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(47, 8.0, 8.0, 8.0),
      child: Row(
        children: <Widget>[
          Text("Seu evento é na UFPR?"),
          Switch(
              value: isSwitchedUFPR,
              onChanged: (value) {
                setState(() {
                  print("Executou um setState");
                  isSwitchedUFPR = value;
                });
              }),
        ],
      ),
    );
  }

  Container nothingToShow() {
    return Container(
      child: SizedBox(width: 0),
    );
  }

  Padding eventSectorInput() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: _eventSectorController,

        decoration: InputDecoration(
            hintText: "Informe o Setor:",
            border:
            OutlineInputBorder(borderRadius: BorderRadius.circular(4.5)),
            icon: Icon(Icons.import_contacts)),
        //Validations:
        validator: (value) {
          if (value.isEmpty) {
            return 'Não Obrigatório';
          }
          return null;
        },
      ),
    );
  }

  Padding eventBlocInput() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: _eventBlocController,

        decoration: InputDecoration(
            hintText: "Informe o Bloco: ",
            border:
            OutlineInputBorder(borderRadius: BorderRadius.circular(4.5)),
            icon: Icon(Icons.account_balance)),
        //Validations:
        validator: (value) {
          if (value.isEmpty) {
            return 'Não obrigatório';
          }
          return null;
        },
      ),
    );
  }

  Padding eventLinkInput() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: _eventLinkController,

        decoration: InputDecoration(
            hintText: "Link ou Email: ",
            border:
            OutlineInputBorder(borderRadius: BorderRadius.circular(4.5)),
            icon: Icon(Icons.link)),
        //Validations:
        validator: (value) {
          if (value.isEmpty) {
            return 'Favor coloque um link ou email';
          }
          return null;
        },
      ),
    );
  }

  Column eventDateEndOutput() {
    return new Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 10, 180, 0),
          child: new Text(
            "Fim do Evento: ",
            style: TextStyle(fontSize: 16, color: Colors.black54),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: new Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              //Dia
              Text(
                "$showDateEnd",
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
            ],
          ),
        )
      ],
    );
  }

  BoxDecoration containerDecoration() {
    return BoxDecoration(
        borderRadius: BorderRadius.circular(4.5),
        border: Border.all(
          color: Colors.grey,
          width: 1.0,
        ));
  }

  Column eventDateStartOutput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 10, 180, 0),
          child: new Text(
            "Inicio do Evento: ",
            style: TextStyle(fontSize: 16, color: Colors.black54),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: new Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              //Dia
              Text(
                "$showDateStart",
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
            ],
          ),
        )
      ],
    );
  }

  Padding eventDescInput() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: _eventDescController,
        maxLines: 3,
        decoration: InputDecoration(
            hintText: "Descrição: ",
            border:
            OutlineInputBorder(borderRadius: BorderRadius.circular(4.5)),
            icon: Icon(Icons.note)),
        //Validations:
        validator: (value) {
          if (value.isEmpty) {
            return 'Favor coloque uma descrição';
          }
          return null;
        },
      ),
    );
  }

  Padding eventTargetInput() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: _eventTargetController,
        decoration: InputDecoration(
            hintText: "Público alvo: ",
            border:
            OutlineInputBorder(borderRadius: BorderRadius.circular(4.5)),
            icon: Icon(Icons.person_pin_circle)),
        //Validations:
        validator: (value) {
          if (value.isEmpty) {
            return 'Não obrigatório';
          }
          return null;
        },
      ),
    );
  }

  Padding eventNameInput() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: _eventNameController,
        decoration: InputDecoration(
            hintText: "Nome do evento: ",
            border:
            OutlineInputBorder(borderRadius: BorderRadius.circular(4.5)),
            icon: Icon(Icons.event_note)),
        //Validations:
        validator: (value) {
          if (value.isEmpty) {
            return 'Favor entre com o nome do Evento';
          }
          return null;
        },
      ),
    );
  }

  Future<DateTime> _selectedDate(BuildContext context) =>
      showDatePicker(
          context: context,
          initialDate: DateTime.now().add(Duration(seconds: 1)),
          firstDate: DateTime(1900),
          lastDate: DateTime(2100));

  Future<TimeOfDay> _selectedTime(BuildContext context) {
    final now = DateTime.now();
    return showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: now.hour, minute: now.minute),
    );
  }
}
