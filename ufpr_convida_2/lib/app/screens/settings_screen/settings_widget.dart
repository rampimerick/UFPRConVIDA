import 'package:flutter/material.dart';

class SettingsWidget extends StatefulWidget {
  @override
  _SettingsWidgetState createState() => _SettingsWidgetState();
}

class _SettingsWidgetState extends State<SettingsWidget> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        // ignore: missing_return
        onWillPop: () {
          //Fix it:
          print("Pop");
          Navigator.pushNamed(context, '/main');
        },
        child: Scaffold(
          appBar: AppBar(title: Text("Configurações")),
          body: Center(
            child: Text("Configurações"),
          ),
        ));
  }
}
