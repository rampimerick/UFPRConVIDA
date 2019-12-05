import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ufpr_convida_2/app/shared/globals/globals.dart' as globals;

class NewEventWidget extends StatefulWidget {
  @override
  _NewEventWidgetState createState() => _NewEventWidgetState();
}

class _NewEventWidgetState extends State<NewEventWidget> {
  String _url = globals.URL;
  final _formKey = GlobalKey<FormState>();

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

  //Switch:
  bool isSwitchedOne = false;
  bool isSwitchedTwo = false;

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
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: _eventNameController,
                decoration: InputDecoration(
                    hintText: "Nome do evento: ",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4.5)),
                    icon: Icon(Icons.event_note)),
                //Validations:
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Favor entre com o nome do Evento';
                  }
                  return null;
                },
              ),
            ),

            //Event Target
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: _eventTargetController,
                decoration: InputDecoration(
                    hintText: "Público alvo: ",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4.5)),
                    icon: Icon(Icons.person_pin_circle)),
                //Validations:
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Não obrigatório';
                  }
                  return null;
                },
              ),
            ),

            //Event Description
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: _eventDescController,
                maxLines: 3,
                decoration: InputDecoration(
                    hintText: "Descrição: ",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4.5)),
                    icon: Icon(Icons.note)),
                //Validations:
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Favor coloque uma descrição';
                  }
                  return null;
                },
              ),
            ),

            //Event Date Start:
            Padding(
                padding: const EdgeInsets.fromLTRB(47, 8, 8, 8),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4.5),
                      border: Border.all(
                        color: Colors.grey,
                        width: 1.0,
                      )),
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
                    child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 10, 180, 0),
                          child: new Text(
                            "Inicio do Evento: ",
                            style:
                                TextStyle(fontSize: 16, color: Colors.black54),
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
                                style: TextStyle(
                                    fontSize: 16, color: Colors.black54),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                )),

            //Date End Event:
            Padding(
                padding: const EdgeInsets.fromLTRB(47, 8, 8, 8),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4.5),
                      border: Border.all(
                        color: Colors.grey,
                        width: 1.0,
                      )),
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
                    child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 10, 180, 0),
                          child: new Text(
                            "Fim do Evento: ",
                            style:
                                TextStyle(fontSize: 16, color: Colors.black54),
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
                                style: TextStyle(
                                    fontSize: 16, color: Colors.black54),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                )),

            //Event Link or Email:
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: _eventLinkController,

                decoration: InputDecoration(
                    hintText: "Link ou Email: ",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4.5)),
                    icon: Icon(Icons.link)),
                //Validations:
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Favor coloque um link ou email';
                  }
                  return null;
                },
              ),
            ),

            //Event Category

            //Event Sector and Block
            Padding(
              padding: const EdgeInsets.fromLTRB(47,8.0,8.0,8.0),
              child: Row(
                children: <Widget>[
                  Text("Seu evento é na UFPR?"),
                  Switch(
                      value: isSwitchedOne,
                      onChanged: (value) {
                        setState(() {
                          print("Executou um setState");
                          isSwitchedOne = value;
                        });
                      }),
                ],
              ),
            ),
            Container(
                child: isSwitchedOne == true
                    ? Container(
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                controller: _eventSectorController,

                                decoration: InputDecoration(
                                    hintText: "Informe o Setor:",
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(4.5)),
                                    icon: Icon(Icons.import_contacts)),
                                //Validations:
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Não Obrigatório';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            //Event Block:
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                controller: _eventBlocController,

                                decoration: InputDecoration(
                                    hintText: "Informe o Bloco: ",
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(4.5)),
                                    icon: Icon(Icons.account_balance)),
                                //Validations:
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Não obrigatório';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                      )
                    :  Container(
                  child: SizedBox(width: 0),
                )),

            //Subscriptions:

            Padding(
              padding: const EdgeInsets.fromLTRB(47,8.0,8.0,8.0),
              child: Row(
                children: <Widget>[
                  Text("Seu evento tem datas de inscrições?"),
                  Switch(
                      value: isSwitchedTwo,
                      onChanged: (value) {
                        setState(() {
                          print("Executou um setState");
                          isSwitchedTwo = value;
                        });
                      }),
                ],
              ),
            ),

            Container(
                child: isSwitchedTwo == true
                    ? Container(
                  child: Column(
                    children: <Widget>[
                      Padding(
                          padding: const EdgeInsets.fromLTRB(47, 8, 8, 8),
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4.5),
                                border: Border.all(
                                  color: Colors.grey,
                                  width: 1.0,
                                )),
                            child: InkWell(
                              onTap: () async {
                                final selectedDate = await _selectedDate(context);
                                if (selectedDate == null) return 0;

                                final selectedTime = await _selectedTime(context);
                                if (selectedDate == null) return 0;

                                setState(() {
                                  this.selectedSubEventStart = DateTime(
                                      selectedDate.year,
                                      selectedDate.month,
                                      selectedDate.day,
                                      selectedTime.hour,
                                      selectedTime.minute);
                                  //Format's:
                                  postSubEventStart =
                                      dateFormat.format(selectedSubEventStart);
                                  showSubStart = formatter.format(selectedSubEventStart);
                                  print("Formato data post: $postSubEventStart");
                                });
                                return 0;
                              },
                              child: new Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(0, 10, 180, 0),
                                    child: new Text(
                                      "Inicio das Inscrições: ",
                                      style:
                                      TextStyle(fontSize: 16, color: Colors.black54),
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
                                          style: TextStyle(
                                              fontSize: 16, color: Colors.black54),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          )),

                      //END
                      Padding(
                          padding: const EdgeInsets.fromLTRB(47, 8, 8, 8),
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4.5),
                                border: Border.all(
                                  color: Colors.grey,
                                  width: 1.0,
                                )),
                            child: InkWell(
                              onTap: () async {
                                final selectedDate = await _selectedDate(context);
                                if (selectedDate == null) return 0;

                                final selectedTime = await _selectedTime(context);
                                if (selectedDate == null) return 0;

                                setState(() {
                                  this.selectedSubEventEnd = DateTime(
                                      selectedDate.year,
                                      selectedDate.month,
                                      selectedDate.day,
                                      selectedTime.hour,
                                      selectedTime.minute);
                                  //Format's:
                                  postSubEventEnd =
                                      dateFormat.format(selectedSubEventEnd);
                                  showSubEnd = formatter.format(selectedSubEventEnd);
                                  print("Formato data post: $postSubEventEnd");
                                });
                                return 0;
                              },
                              child: new Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(0, 10, 180, 0),
                                    child: new Text(
                                      "Fim das inscrições: ",
                                      style:
                                      TextStyle(fontSize: 16, color: Colors.black54),
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
                                          style: TextStyle(
                                              fontSize: 16, color: Colors.black54),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          )),


                    ],
                  ),
                )
                    :  Container(
                  child: SizedBox(width: 0),
                )),

            //Buttons:
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,

                children: <Widget>[
                  RaisedButton(
                    shape:RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),

                    ),
                    padding: EdgeInsets.all(12),
                    onPressed: () => null,
                    color: Color(0xFF295492),
                    child: Text(
                      "Cancelar",
                      style:
                      TextStyle(color: Colors.white, fontSize: 17.0),
                    ),
                  ),
                  SizedBox(width: 30),
                  RaisedButton(

                    shape:RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),

                    ),
                    padding: EdgeInsets.all(12),
                    onPressed: () => null,
                    color: Color(0xFF8A275D),
                    child: Text(
                      "Criar",
                      style:
                      TextStyle(color: Colors.white, fontSize: 17.0),
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

  Future<DateTime> _selectedDate(BuildContext context) => showDatePicker(
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
