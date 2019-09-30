import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as prefix0;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ufpr_convida/ui/tela_configuracoes.dart';
import 'package:ufpr_convida/ui/tela_eventos.dart';
import 'package:ufpr_convida/ui/tela_mapa.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

int _indexItem = 0;



class telaPrincipal extends StatefulWidget {
  @override
  _telaPrincipalState createState() => _telaPrincipalState();
}

class _telaPrincipalState extends State<telaPrincipal> {
  Completer<GoogleMapController> _controller = Completer();
  int _indexAtual = 0;
  //AQUI
  //final editKey = new GlobalKey<FormState>();

  Future<List> getUser() async {
    String apiUrl = "http://192.168.0.103:8080/users/20190000";
    http.Response response = await http.get(apiUrl);
    print("StatusCode:${response.statusCode}");

    if ((response.statusCode != 200) && (response.statusCode != 201)) {
      apiUrl = "http://10.0.2.2:8080/users/20190000";
      print("Tentando com $apiUrl");
      response = await http.get(apiUrl);
    }
    //Caso vir código 200, OK!
    var jsonData;
    if ((response.statusCode == 200) || (response.statusCode == 201)) {
      jsonData = json.decode(response.body);
    } else {
      throw Exception("Falhou!");
    }
    //Printa o usuario que voltou
    print(jsonData);
  }

  @override
  //Switch para trocar as telas, é chamado nos métodos que estão abaixo do código principal
  Widget _chamaPagina(int index) {

    switch (index) {
      case 0:
        return telaMapa();
        break;

      case 1:
        List l;
        return telaEventos();
        break;

      default:
        return telaMapa();
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //No título terá o nome do Usurio que ele poderá definir
        title: Text("Bem vindo 'Fulano de Tal'"),
        //Estou usando Theme por isso não precisa declarar cores
        //Theme esta na Main.dart
        //backgroundColor: Colors.blueAccent,
      ),
      //Drawer é a barra de ferramentas que aparece ao lado
      drawer: new Drawer(
        //Cada filho é uma opação que ao ser clicado puxará outra tela
        child: ListView(
          children: <Widget>[
            new UserAccountsDrawerHeader(
              accountName: Text("Fulano de Tal"),
              accountEmail: Text("taldefulano@gmail.com"),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Text("F"),
              ),
            ),
            new ListTile(
              title: Text("Pefil"),
              trailing: Icon(Icons.person),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushNamed("/perfil");
              },
            ),
            new ListTile(
              title: Text("Configurações"),
              trailing: Icon(Icons.settings),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushNamed("/config");
              },
            ),
            new ListTile(
              title: Text("Logout"),
              trailing: Icon(Icons.chevron_left),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushNamed("/login");
              }
            ),
            new Divider(),
            //O Fechar somente fecha a barra de ferramentas
            new ListTile(
              title: Text("Fechar"),
              trailing: Icon(Icons.close),
              onTap: () => Navigator.of(context).pop(),
            )
          ],
        ),
      ),

      //Chama a pagina com o body do MAPA
      body: _chamaPagina(_indexAtual),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _indexAtual,
        onTap: (value) {
          _indexAtual = value;
          setState(() {});
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.map), title: Text("Mapa")),
          BottomNavigationBarItem(
              icon: Icon(Icons.list), title: Text("Eventos"))
        ],
      ),
    );
  }
}

