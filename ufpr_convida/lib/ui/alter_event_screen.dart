import 'package:flutter/material.dart';
import 'package:ufpr_convida/modelos/evento.dart';

class alterEvent extends StatefulWidget {
  Event event;

  alterEvent({Key key, @required this.event}) : super(key: key);

  @override
  _alterEventState createState() => _alterEventState(event);
}

class _alterEventState extends State<alterEvent> {
  Event event;

  _alterEventState(this.event);

  @override
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
  final TextEditingController _eventBlockController =
      new TextEditingController();
  //Tratar as datas:

  Widget build(BuildContext context) {
    name();
    //Target
    _eventTargetController.value = _eventTargetController.value.copyWith(
        text: event.target,
        selection: TextSelection(
            baseOffset: event.target.length, extentOffset: event.target.length),
        composing: TextRange.empty);
    //Desc
    _eventDescController.value = _eventDescController.value.copyWith(
        text: event.desc,
        selection: TextSelection(
            baseOffset: event.desc.length, extentOffset: event.desc.length),
        composing: TextRange.empty);
    //Link
    _eventLinkController.value = _eventLinkController.value.copyWith(
        text: event.link,
        selection: TextSelection(
            baseOffset: event.link.length, extentOffset: event.link.length),
        composing: TextRange.empty);
    //Type
    _eventTypeController.value = _eventTypeController.value.copyWith(
        text: event.type,
        selection: TextSelection(
            baseOffset: event.type.length, extentOffset: event.type.length),
        composing: TextRange.empty);
    //Sector
    //Block
    //Data
    //Init
    //End

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

            //Tipo:
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
                  controller: _eventBlockController,
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
                        onPressed: () {},
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
                      child: new AlterButton(),
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
}

class AlterButton extends StatelessWidget {
  const AlterButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      onPressed: () async {},
      color: Color(0xFF8A275D),
      shape:RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),

      ),
      padding: EdgeInsets.fromLTRB(30, 12, 30, 12),
      child: Text(
        "Alterar",
        style: TextStyle(color: Colors.white, fontSize: 17.0),
      ),
    );
  }
}
