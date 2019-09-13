import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';


class telaEventos extends StatefulWidget {
  @override
  _telaEventosState createState() => _telaEventosState();
}

class _telaEventosState extends State<telaEventos> {
  final TextEditingController _controlNome = new TextEditingController();
  final TextEditingController _controlLocal = new TextEditingController();
  final _controlData = new MaskedTextController(mask: '00/00/0000');

  @override

  //Tela onde terá a lista de todos os eventos que o usuario decidir criar/participar
  //Os eventos que nao estão listados podem ser vistos no mapa e ao clicar tem a opção de participar
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          materialTapTargetSize: MaterialTapTargetSize.padded,
          backgroundColor: Color(0xFF8A275D),
          child: Icon(Icons.add, size: 36.0),
          onPressed: _criarEvento,
          ),

        );

  }

  void _criarEvento() {

    //Cria um alerta para a criação de um novo EVENTO
    var alert = AlertDialog(
      contentPadding: EdgeInsets.all(2.5),
      content: Container(
        width: double.infinity,

        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(5.5),
              child: Text(
                "Criar Evento",
                style: TextStyle(
                    fontSize: 19.5,
                    fontWeight: FontWeight.w600,
                    color: Colors.blueAccent),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(5.5),
              child: TextField(
                controller: _controlNome,
                autofocus: true,
                decoration: InputDecoration(
                    labelText: "Nome do Evento",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4.5)),
                    icon: Icon(Icons.note_add)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(2.5),
              child: TextField(
                controller: _controlData,
                autofocus: true,
                keyboardType: TextInputType.datetime,
                decoration: InputDecoration(
                    labelText: "Data",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4.5)),
                    icon: Icon(Icons.calendar_today)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(2.5),
              child: TextField(
                controller: _controlLocal,
                autofocus: true,
                keyboardType: TextInputType.datetime,
                decoration: InputDecoration(

                    labelText: "Local",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4.5)),
                    icon: Icon(Icons.map)),
              ),
            )
          ],
        ),
      ),
      actions: <Widget>[
        FlatButton(
          onPressed: () {
            //_lidarComTexto(_control.text);
            _controlNome.clear();
            _controlData.clear();
            _controlLocal.clear();


            Navigator.pop(context);
          },
          child: Text("Criar", style: TextStyle(fontSize: 15.0),),
        )
      ],
    );
    showDialog(
        context: context,
        builder: (_) {
          return alert;
        });
  }
}
