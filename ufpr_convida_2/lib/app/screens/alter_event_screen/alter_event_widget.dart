import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:ufpr_convida_2/app/shared/globals/globals.dart' as globals;
import 'package:ufpr_convida_2/app/shared/models/event.dart';
import 'package:http/http.dart' as http;
import 'package:ufpr_convida_2/app/shared/models/user.dart';

class AlterEventWidget extends StatefulWidget {
  Event event;
  AlterEventWidget({Key key, @required this.event}) : super(key: key);
  @override
  _AlterEventWidgetState createState() => _AlterEventWidgetState(event);
}

class _AlterEventWidgetState extends State<AlterEventWidget> {
  Event event;
  _AlterEventWidgetState(this.event);

  String _url = globals.URL;
  final _formKey = GlobalKey<FormState>();
  bool created = false;
  var now = DateTime.now();

  //Dates:
  final DateFormat formatter = new DateFormat.yMd("pt_BR");
  final DateFormat postFormat = new DateFormat("yyyy-MM-ddTHH:mm:ss");
  final DateFormat hourFormat = new DateFormat.Hm();
  final DateFormat dateAndHour = new DateFormat.yMd("pt_BR").add_Hm();

  String showHrStart = "";
  String showHrEnd = "";
  String showDateStart = "";
  String showDateEnd = "";
  String showSubStart = "";
  String showSubEnd = "";

  String postHrStart = "";
  String postHrEnd = "";
  String postDateEventStart = "";
  String postDateEventEnd = "";
  String postSubEventStart = "";
  String postSubEventEnd = "";

  DateTime selectedHrEventStart = DateTime.now();
  DateTime selectedHrEventEnd = DateTime.now();
  DateTime selectedDateEventStart = DateTime.now();
  DateTime selectedDateEventEnd = DateTime.now();
  DateTime selectedSubEventStart = DateTime.now();
  DateTime selectedSubEventEnd = DateTime.now();

  //Events Types
  var _dropDownMenuItemsTypes = [
    "Saúde",
    "Esporte e Lazer",
    "Festas e Comemorações",
    "Cultura",
    "Acadêmico",
    "Outros",
  ];

  String _currentType;

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
  final TextEditingController _eventSectorController =
      new TextEditingController();
  final TextEditingController _eventBlocController =
      new TextEditingController();


  @override
  void initState() {

        _eventNameController.text = event.name;
        _eventTargetController.text = event.target;
        _eventDescController.text = event.desc;
        _eventLinkController.text = event.link;
        _eventSectorController.text = event.sector;
        _eventBlocController.text = event.bloc;

        DateTime parsedHrStart;
        DateTime parsedHrEnd;
        DateTime parsedDateStart;
        DateTime parsedDateEnd;
        DateTime parsedSubStart;
        DateTime parsedSubEnd;

        if (event.hrStart != null) {
          parsedHrStart = DateTime.parse(event.hrStart);
          selectedHrEventStart = parsedHrStart;
          postHrStart = postFormat.format(parsedHrStart);
          showHrStart = hourFormat.format(parsedHrStart);
        }
        if (event.hrEnd != null) {
          parsedHrEnd = DateTime.parse(event.hrEnd);
          selectedHrEventEnd = parsedHrEnd;
          postHrEnd = postFormat.format(parsedHrEnd);
          showHrEnd = hourFormat.format(parsedHrEnd);
        }
        if (event.dateStart != null) {
          parsedDateStart = DateTime.parse(event.dateStart);
          selectedHrEventStart = parsedDateStart;
          postDateEventStart = postFormat.format(parsedDateStart);
          showDateStart = formatter.format(parsedDateStart);
        }
        if (event.dateEnd != null) {
          parsedDateEnd = DateTime.parse(event.dateEnd);
          selectedDateEventEnd = parsedDateEnd;
          postDateEventEnd = postFormat.format(parsedDateEnd);
          showDateEnd = formatter.format(parsedDateEnd);
        }
        if (event.startSub != null) {
          parsedSubStart = DateTime.parse(event.startSub);
          selectedSubEventStart = parsedSubStart;
          postSubEventStart = postFormat.format(parsedSubStart);
          showSubStart = dateAndHour.format(parsedSubStart);
        }
        if (event.endSub != null) {
          parsedSubEnd = DateTime.parse(event.endSub);
          selectedSubEventEnd = parsedSubEnd;
          postSubEventEnd = postFormat.format(parsedSubEnd);
          showSubEnd = dateAndHour.format(parsedSubEnd);
        }

        _currentType = event.type;

        if (event.sector == "") {
          isSwitchedUFPR = false;
        }
        else
          isSwitchedUFPR = true;

        if (event.startSub == "") {
          isSwitchedSubs = false;
        }
        else
          isSwitchedSubs = true;

    super.initState();
  }
  @override
  Widget build(BuildContext context) {

      return WillPopScope(
        onWillPop: () {
          Navigator.of(context).popAndPushNamed("/main");
          return null;
        },
        child: Scaffold(
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

                //Event Hour Start:
                Padding(
                    padding: const EdgeInsets.fromLTRB(47, 8, 8, 8),
                    child: Container(
                      decoration: containerDecoration(),
                      child: InkWell(
                        onTap: () async {
                          final selectedTime = await _selectedTime(
                              context, selectedHrEventStart);
                          if (selectedTime == null) return 0;

                          setState(() {
                            print(
                                "${selectedTime.hour} : ${selectedTime.minute}");

                            this.selectedHrEventStart = DateTime(
                                now.year,
                                now.month,
                                now.day,
                                selectedTime.hour,
                                selectedTime.minute);
                            postHrStart =
                                postFormat.format(selectedHrEventStart);
                            showHrStart =
                                hourFormat.format(selectedHrEventStart);
                            print("Formato data post: $postHrStart");
                          });
                          return 0;
                        },
                        child: eventHourStartOutput(),
                      ),
                    )),

                //Event Hour End
                Padding(
                    padding: const EdgeInsets.fromLTRB(47, 8, 8, 8),
                    child: Container(
                      decoration: containerDecoration(),
                      child: InkWell(
                        onTap: () async {
                          final selectedTime =
                              await _selectedTime(context, selectedHrEventEnd);
                          if (selectedTime == null) return 0;

                          setState(() {
                            this.selectedHrEventEnd = DateTime(
                                now.year,
                                now.month,
                                now.day,
                                selectedTime.hour,
                                selectedTime.minute);
                            postHrEnd = postFormat.format(selectedHrEventEnd);
                            showHrEnd = hourFormat.format(selectedHrEventEnd);
                            print("Formato hora post: $postHrEnd");
                          });
                          return 0;
                        },
                        child: eventHourEndOutput(),
                      ),
                    )),

                //Event Date Start:
                Padding(
                    padding: const EdgeInsets.fromLTRB(47, 8, 8, 8),
                    child: Container(
                      decoration: containerDecoration(),
                      child: InkWell(
                        onTap: () async {
                          final selectedDate = await _selectedDate(
                              context, selectedDateEventStart);
                          if (selectedDate == null) return 0;

                          setState(() {
                            this.selectedDateEventStart = DateTime(
                                selectedDate.year,
                                selectedDate.month,
                                selectedDate.day,
                                now.hour,
                                now.minute);
                            postDateEventStart =
                                postFormat.format(selectedDateEventStart);
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
                          final selectedDate = await _selectedDate(
                              context, selectedDateEventEnd);
                          if (selectedDate == null) return 0;

                          setState(() {
                            selectedDateEventEnd = DateTime(
                                selectedDate.year,
                                selectedDate.month,
                                selectedDate.day,
                                now.hour,
                                now.minute);
                            //Format's:
                            postDateEventEnd =
                                postFormat.format(selectedDateEventEnd);
                            showDateEnd =
                                formatter.format(selectedDateEventEnd);
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
                  padding: const EdgeInsets.fromLTRB(47, 8.0, 8.0, 8.0),
                  child: Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                        child: Container(
                          decoration: containerDecorationCategory(),
                          child: Row(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 5, 5, 5),
                                child: new Text(
                                  "Tipo do evento: ",
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.black54),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(3, 5, 20, 5),
                                child: DropdownButton<String>(
                                  items: _dropDownMenuItemsTypes
                                      .map((String dropDownStringIten) {
                                    return DropdownMenuItem<String>(
                                        value: dropDownStringIten,
                                        child: Text(dropDownStringIten));
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
                                    padding:
                                        const EdgeInsets.fromLTRB(47, 8, 8, 8),
                                    child: Container(
                                      decoration: containerDecoration(),
                                      child: InkWell(
                                        onTap: () async {
                                          final selectedDate =
                                              await _selectedDate(context,
                                                  selectedSubEventStart);
                                          if (selectedDate == null) return 0;

                                          final selectedTime =
                                              await _selectedTime(context,
                                                  selectedSubEventStart);
                                          if (selectedDate == null) return 0;

                                          setState(() {
                                            this.selectedSubEventStart =
                                                DateTime(
                                                    selectedDate.year,
                                                    selectedDate.month,
                                                    selectedDate.day,
                                                    selectedTime.hour,
                                                    selectedTime.minute);
                                            //Format's:
                                            postSubEventStart = postFormat
                                                .format(selectedSubEventStart);
                                            showSubStart = dateAndHour
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
                                    padding:
                                        const EdgeInsets.fromLTRB(47, 8, 8, 8),
                                    child: Container(
                                      decoration: containerDecoration(),
                                      child: InkWell(
                                        onTap: () async {
                                          final selectedDate =
                                              await _selectedDate(
                                                  context, selectedSubEventEnd);
                                          if (selectedDate == null) return 0;

                                          final selectedTime =
                                              await _selectedTime(
                                                  context, selectedSubEventEnd);
                                          if (selectedDate == null) return 0;

                                          setState(() {
                                            this.selectedSubEventEnd = DateTime(
                                                selectedDate.year,
                                                selectedDate.month,
                                                selectedDate.day,
                                                selectedTime.hour,
                                                selectedTime.minute);
                                            //Format's:
                                            postSubEventEnd = postFormat
                                                .format(selectedSubEventEnd);
                                            showSubEnd = dateAndHour
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
                        onPressed: () {
                          Navigator.of(context).pushNamed("/main");
                        },
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
                          if (created) {
                            Navigator.of(context).popAndPushNamed("/main");
                          }
                          if ((_formKey.currentState.validate()) &&
                              (created == false)) {
                            String success = await postNewEvent();
                            _showDialog(success);
                            created = true;
                          }
                        },
                        color: Color(0xFF8A275D),
                        child: Text(
                          "Alterar",
                          style: TextStyle(color: Colors.white, fontSize: 17.0),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      );
  }

  Scaffold withoutLogin(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            //Botao Entrar
            Container(
                margin: const EdgeInsets.all(4.5),
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
                    SizedBox(height: 50),
                    RaisedButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      padding: EdgeInsets.all(12),
                      onPressed: () {
                        Navigator.of(context).pushNamed("/main");
                      },
                      color: Color(0xFF295492),
                      child: Text(
                        "Voltar",
                        style: TextStyle(color: Colors.white, fontSize: 17.0),
                      ),
                    ),
                    SizedBox(height: 30)
                  ],
                )),
          ],
        ),
      ),
    );
  }

  Future<String> postNewEvent() async {
    Map<String, String> mapHeaders = {
      "Accept": "application/json",
      "Content-Type": "application/json",
      HttpHeaders.authorizationHeader: "Bearer ${globals.token}"
    };
    String id = globals.userName;
    User user = await http
        .get("$_url/users/$id", headers: mapHeaders)
        .then((http.Response response) {
      final int statusCode = response.statusCode;
      if ((statusCode == 200) || (statusCode == 201)) {
        print("Post Event Success!");
        return User.fromJson(jsonDecode(response.body));
      } else {
        throw new Exception(
            "Error while fetching data, status code: $statusCode");
      }
    });

    if (isSwitchedUFPR == false) {
      _eventBlocController.text = "";
      _eventSectorController.text = "";
    }
    if (isSwitchedSubs == false) {
      postSubEventStart = "";
      postSubEventEnd = "";
    }

    Event p = new Event(
        name: _eventNameController.text,
        target: _eventTargetController.text,
        desc: _eventDescController.text,
        hrStart: postHrStart,
        hrEnd: postHrEnd,
        dateStart: postDateEventStart,
        dateEnd: postDateEventEnd,
        link: _eventLinkController.text,
        type: _currentType,
        sector: _eventSectorController.text,
        bloc: _eventBlocController.text,
        startSub: postSubEventStart,
        endSub: postSubEventEnd,
        author: user,
        lat: event.lat,
        lng: event.lng);

    String eventJson = json.encode(p.toJson());

    print(eventJson);
    print("Put em $_url/events/${event.id}");

    String s = await http
        .put("$_url/events/${event.id}", body: eventJson, headers: mapHeaders)
        .then((http.Response response) {
      final int statusCode = response.statusCode;
      if ((statusCode == 200) || (statusCode == 201)) {
        print("Put Event Success!");
        return "Evento Alterado com sucesso!";
      } else {
        throw new Exception(
            "Error while fetching data, status code: $statusCode");
      }
    });

    return s;
  }

  void _showDialog(String s) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text(s),
          content: new Text("Prescione 'Ok' para continar"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Ok"),
              onPressed: () {
                Navigator.pop(context);
                Navigator.of(context).popAndPushNamed("/main");
              },
            ),
          ],
        );
      },
    );
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
          Text("Seu evento tem datas de inscrições?",
              style: TextStyle(fontSize: 16, color: Colors.black54)),
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
          Text("Seu evento é na UFPR?",
              style: TextStyle(fontSize: 16, color: Colors.black54)),
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

  BoxDecoration containerDecorationCategory() {
    return BoxDecoration(
        borderRadius: BorderRadius.circular(4.5),
        border: Border.all(
          color: Colors.white,
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

  Column eventHourEndOutput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 10, 180, 0),
          child: new Text(
            "Horário de fim: ",
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
                "$showHrEnd",
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
            ],
          ),
        )
      ],
    );
  }

  Column eventHourStartOutput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 10, 180, 0),
          child: new Text(
            "Horário do início: ",
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
                "$showHrStart",
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

  Future<DateTime> _selectedDate(BuildContext context, DateTime date) =>
      showDatePicker(
          context: context,
          initialDate: date,
          firstDate: DateTime(1900),
          lastDate: DateTime(2100));

  Future<TimeOfDay> _selectedTime(BuildContext context, DateTime date) {
    final now = date;
    return showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: now.hour, minute: now.minute),
    );
  }



}
