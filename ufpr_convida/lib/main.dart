
import 'package:flutter/material.dart';
import 'package:ufpr_convida/ui/home.dart';
import 'package:ufpr_convida/ui/splash_screen.dart';
import 'package:ufpr_convida/ui/tela_configuracoes.dart';
import 'package:ufpr_convida/ui/tela_perfil.dart';

void main() {

  //Cores:  #8a275d
  //        #295492

  Map<int, Color> color =
  {
    50:Color.fromRGBO(41, 84, 146, .1),
    100:Color.fromRGBO(41, 84, 146, .2),
    200:Color.fromRGBO(41, 84, 146, .3),
    300:Color.fromRGBO(41, 84, 146, .4),
    400:Color.fromRGBO(41, 84, 146, .5),
    500:Color.fromRGBO(41, 84, 146, .6),
    600:Color.fromRGBO(41, 84, 146, .7),
    700:Color.fromRGBO(41, 84, 146, .8),
    800:Color.fromRGBO(41, 84, 146, .9),
    900:Color.fromRGBO(41, 84, 146, 1),
  };

  final testCor = new MaterialColor(0xFF295492, color);
  runApp(
      new MaterialApp(

        //Chama a Home que está no UI
        theme: new ThemeData(primarySwatch: testCor),
        //Chama a tela home que esta em UI/home.dart
        home: new SplashScreen(),
        //Define rotas para depois poder cominhar entrar as telas de forma facilitada
        routes: <String, WidgetBuilder>{
          "/perfil" : (BuildContext context) => new telaPerfil(),
          "/config" : (BuildContext context) => new telaConfig()
        } ,
      )
  );
}
