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
  final DateFormat formatter = new DateFormat.yMMMMd("pt_BR");
  final DateFormat dateFormat = new DateFormat("yyyy-MM-ddTHH:mm:ss");
  String showDateUser = "";
  String dateUser;

  DateTime selectedDateEvent = DateTime.now();
  DateTime selectedDateInit = DateTime.now();
  DateTime selectedDateEnd = DateTime.now();

  //Controllers:
  final TextEditingController _eventNameController =
  new TextEditingController();
  final TextEditingController _eventTargetController =
  new TextEditingController();
  final TextEditingController _eventDescController =
  new TextEditingController();
  final TextEditingController _eventDateInitController =
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
                    icon: Icon(Icons.event_note)),
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
                controller: _eventTargetController,
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

            //Event Date
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
                        this.selectedDateEvent = DateTime(
                            selectedDate.year,
                            selectedDate.month,
                            selectedDate.day,
                            selectedTime.hour,
                            selectedTime.minute
                        );
                        dateUser = dateFormat.format(selectedDateEvent);
                        showDateUser = formatter.format(selectedDateEvent);
                        print("Formato data post: $dateUser");
                      });
                      return 0;
                    },
                    child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 10, 180, 0),
                          child: new Text("Data de Nascimento: ", style: TextStyle(
                              fontSize: 16,
                              color: Colors.black54
                          ),),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: new Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              //Dia
                              Text("$showDateUser", style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black54
                              ),),

                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                )),

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
