import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as prefix0;

class ProfileWidget extends StatefulWidget {
  @override
  _ProfileWidgetState createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends State<ProfileWidget> {
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
        appBar: AppBar(title: Text("Perfil")),
        body: Center(
          child: Text("Seu Perfil"),
        ),
      ),
    );
  }
}
