

import 'package:flutter/material.dart';

class telaConfig extends StatefulWidget {
  @override
  _telaConfigState createState() => _telaConfigState();
}

class _telaConfigState extends State<telaConfig> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Configurações"),),
      body: new Center(
        child: Text("Aqui estarão as configurações"),
      ),
    );
  }
}
