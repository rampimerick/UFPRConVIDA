import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as prefix0;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ufpr_convida/ui/tela_configuracoes.dart';
import 'package:ufpr_convida/ui/tela_eventos.dart';
import 'package:ufpr_convida/ui/tela_mapa.dart';

int _indexItem = 0;

class telaPrincipal extends StatefulWidget {
  @override
  _telaPrincipalState createState() => _telaPrincipalState();
}

class _telaPrincipalState extends State<telaPrincipal> {
  Completer<GoogleMapController> _controller = Completer();
  int _indexAtual = 0;

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
