import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:ufpr_convida_2/app/screens/alter_profile_screen/alter_profile_widget.dart';
import 'package:ufpr_convida_2/app/screens/events_screen/events_widget.dart';
import 'package:ufpr_convida_2/app/screens/favorites_screen/favorites_widget.dart';
import 'package:ufpr_convida_2/app/screens/map_screen/map_widget.dart';
import 'package:ufpr_convida_2/app/screens/my_events_screen/my_events_widget.dart';
import 'package:ufpr_convida_2/app/shared/globals/globals.dart' as globals;
import 'package:ufpr_convida_2/app/shared/models/user.dart';

class MainWidget extends StatefulWidget {
  @override
  _MainWidgetState createState() => _MainWidgetState();
}

class _MainWidgetState extends State<MainWidget> {
  int _indexAtual = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  User user;
  String _url = globals.URL;

  Widget _switchScreen(int index) {
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

      case 2:
        return FavoritesWidget();
        break;

      case 3:
        return MyEventsWidget();
        break;

      default:
        return MapWidget();
    }
  }

  FloatingActionButton getDrawer() {
    return FloatingActionButton(
      backgroundColor: Color(0xFF295492),
      mini: true,
      onPressed: () async {
        if (globals.token != "") String success = await getUserProfile();
        _scaffoldKey.currentState.openDrawer();
      },
      child: Icon(Icons.format_list_bulleted),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      //Ends the app
      onWillPop: () {
        Navigator.of(context).popAndPushNamed("/login");
        return null;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        key: _scaffoldKey,
        drawer: globals.token == ''
            //Drawer without user:
            ? drawerNoUser()
            //Drawer of the user:
            : drawerUser(context),
        body: _switchScreen(_indexAtual),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _indexAtual,
          type: BottomNavigationBarType.fixed,
          onTap: (value) {
            setState(() {
              _indexAtual = value;
            });
          },
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.map), title: Text("Mapa")),
            BottomNavigationBarItem(
                icon: Icon(Icons.list), title: Text("Eventos")),
            BottomNavigationBarItem(
                icon: Icon(Icons.star), title: Text("Favoritos")),
            BottomNavigationBarItem(
                icon: Icon(Icons.event_note), title: Text("Meus Eventos"))
          ],
        ),
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
      child: ListView(
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text("${globals.name} ${globals.lastName}"),
            accountEmail: Text("${globals.email}"),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Text("${globals.name[0].toUpperCase()}"),
            ),
          ),

          ListTile(
            title: Text("Perfil"),
            trailing: Icon(Icons.person),
            onTap: () async{
              if (globals.token != "") String success = await getUserProfile();
              //Pop Drawer:
              Navigator.of(context).pop();
              //Pop Map Screen and push Profile
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AlterProfileWidget(
                      user: user,
                    ),
                  ));
            },
          ),
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

  Future<String> getUserProfile() async {
    Map<String, String> mapHeaders = {
      "Accept": "application/json",
      "Content-Type": "application/json",
      HttpHeaders.authorizationHeader: "Bearer ${globals.token}"
    };
    String id = globals.userName;
    user = await http
        .get("$_url/users/$id", headers: mapHeaders)
        .then((http.Response response) {
      final int statusCode = response.statusCode;
      if ((statusCode == 200) || (statusCode == 201)) {
        print("Success loading user profile!");
        return User.fromJson(jsonDecode(response.body));
      } else {
        throw new Exception(
            "Error while fetching data, status code: $statusCode");
      }
    });

    return "Success";
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
          globals.email = "";
          globals.name  = "";
          globals.lastName = "";
          globals.userName = "";

          Navigator.of(context).pop();
          //Pop Map Screen and push Login
          Navigator.of(context).popAndPushNamed("/login");
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
        //Pop Map Screen and push Settings
        Navigator.of(context).popAndPushNamed("/settings");
      },
    );
  }
}
