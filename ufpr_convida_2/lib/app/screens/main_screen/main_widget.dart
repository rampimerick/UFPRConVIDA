import 'package:flutter/material.dart';
import 'package:ufpr_convida_2/app/screens/events_screen/events_widget.dart';
import 'package:ufpr_convida_2/app/screens/map_screen/map_widget.dart';
import 'package:ufpr_convida_2/app/shared/globals/globals.dart' as globals;

class MainWidget extends StatefulWidget {
  @override
  _MainWidgetState createState() => _MainWidgetState();
}

class _MainWidgetState extends State<MainWidget> {
  int _indexAtual = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  Widget _switchSreen(int index) {
    switch (index) {
      case 0:
        return new Stack(
          alignment: Alignment.center,
          children: <Widget>[
            //Google's Map:
            MapWidget(),

            //Drawer:
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 95, 360, 8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  getDrawer(),
                ],
              ),
            ),
          ],
        );
        break;

      case 1:
        return EventsWidget();
        break;

      default:
        return MapWidget();
    }
  }

  FloatingActionButton getDrawer() {
    return FloatingActionButton(
      backgroundColor: Color(0xFF295492),
      mini: true,
      onPressed: () => _scaffoldKey.currentState.openDrawer(),
      child: Icon(Icons.format_list_bulleted),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //Drawer é a barra de ferramentas que aparece ao lado
      key: _scaffoldKey,
      drawer: globals.token == ''
          //Drawer without user:
          ? drawerNoUser()
          //Drawer of the user:
          : drawerUser(context),
      body: _switchSreen(_indexAtual),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _indexAtual,
        onTap: (value) {
          _indexAtual = value;
          setState(() {});
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.map), title: Text("Mapa")),
          BottomNavigationBarItem(
              icon: Icon(Icons.list), title: Text("Eventos")),
//          BottomNavigationBarItem(
//              icon: Icon(Icons.event_note), title: Text("Meus Eventos")),
        ],
      ),
    );
  }

  Drawer drawerNoUser() {
    return Drawer(
      child: ListView(
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text("UFPR ConVIDA"),
            accountEmail: Text("Favor fazer Login!"),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Text("UFPR"),
            ),
          ),
          drawerLogin(),
          drawerSignup(),
          Divider(),

          //O Fechar somente fecha a barra de ferramentas
          ListTile(
            title: Text("Fechar"),
            trailing: Icon(Icons.close),
            onTap: () => Navigator.of(context).pop(),
          )
        ],
      ),
    );
  }

  Drawer drawerUser(BuildContext context) {
    return new Drawer(
      //Cada filho é uma opação que ao ser clicado puxará outra tela
      child: ListView(
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text("${globals.userName}"),
            accountEmail: Text("${globals.userName}@mail.com"),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Text("${globals.userName[0].toUpperCase()}"),
            ),
          ),

          new DrawerProfile(),
          new DrawerSettings(),
          new DrawerLogout(),
          new Divider(),

          //O Fechar somente fecha a barra de ferramentas
          new ListTile(
            title: Text("Fechar"),
            trailing: Icon(Icons.close),
            onTap: () => Navigator.of(context).pop(),
          )
        ],
      ),
    );
  }

  ListTile drawerLogin() {
    return ListTile(
        title: Text("Login"),
        trailing: Icon(Icons.person),
        onTap: () {
          globals.token = "";
          //Pop Drawer:
          Navigator.of(context).pop();
          //Pop Map Screen:
          Navigator.of(context).pop();
          //Push Login Screen:
          Navigator.of(context).pushNamed("/login");
        });
  }

  ListTile drawerSignup() {
    return ListTile(
        title: Text("Cadastro"),
        trailing: Icon(Icons.arrow_forward_ios),
        onTap: () {
          //Pop Drawer:
          Navigator.of(context).pop();
          //Pop Map Screen:
          Navigator.of(context).pop();
          //Push SignUp Screen:
          Navigator.of(context).pushNamed("/signup");
        });
  }
}

class DrawerLogout extends StatelessWidget {
  const DrawerLogout({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new ListTile(
        title: Text("Logout"),
        trailing: Icon(Icons.chevron_left),
        onTap: () {
          globals.token = "";
          Navigator.of(context).pop();
          Navigator.of(context).pushNamed("/login");
        });
  }
}

class DrawerSettings extends StatelessWidget {
  const DrawerSettings({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new ListTile(
      title: Text("Configurações"),
      trailing: Icon(Icons.settings),
      onTap: () {
        Navigator.of(context).pop();
        Navigator.of(context).pushNamed("/settings");
      },
    );
  }
}

class DrawerProfile extends StatelessWidget {
  const DrawerProfile({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text("Perfil"),
      trailing: Icon(Icons.person),
      onTap: () {
        Navigator.of(context).pop();
        Navigator.of(context).pushNamed("/profile");
      },
    );
  }
}
