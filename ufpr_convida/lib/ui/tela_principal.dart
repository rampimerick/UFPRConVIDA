import 'dart:async';

import 'package:flutter/material.dart';
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
  Widget _chamaPagina(int index) {
    switch (index) {
      case 0:
        return telaMapa();
        break;

      case 1:
        return telaEventos();
        break;

      default:
        return telaMapa();
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Bem vindo 'Fulano de Tal'"),
        //Estou usando Theme por isso não precisa declarar cores
        //Theme esta na Main.dart
        //backgroundColor: Colors.blueAccent,
      ),
      drawer: new Drawer(
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
              trailing: Icon(Icons.filter_vintage),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushNamed("/config");
              },
            ),
            new ListTile(
              title: Text("Logout"),
              trailing: Icon(Icons.chevron_left),
              onTap: () => Navigator.of(context).pop(),
            ),
            new Divider(),
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
