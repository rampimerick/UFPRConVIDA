
import 'package:flutter/material.dart';
import 'package:ufpr_convida/ui/home.dart';
import 'package:ufpr_convida/ui/tela_configuracoes.dart';
import 'package:ufpr_convida/ui/tela_perfil.dart';

void main() => runApp(

    new MaterialApp(
      //Chama a Home que está no UI
        theme: new ThemeData(primarySwatch: Colors.blue),
        home: new Home(),
        routes: <String, WidgetBuilder>{
          "/perfil" : (BuildContext context) => new telaPerfil(),
          "/config" : (BuildContext context) => new telaConfig()
        } ,
    )
);
