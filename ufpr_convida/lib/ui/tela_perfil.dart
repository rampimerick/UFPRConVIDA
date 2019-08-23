
import 'package:flutter/material.dart';

class telaPerfil extends StatefulWidget {
  @override
  _telaPerfilState createState() => _telaPerfilState();
}

class _telaPerfilState extends State<telaPerfil> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Seu Perfil")),
      body: Center (
        child: Text("Aqui estarão as informaçoes do seu perfil"),
      ),

    );
  }
}
