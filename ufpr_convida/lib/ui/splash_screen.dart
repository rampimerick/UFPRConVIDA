import 'dart:async';

import 'package:flutter/material.dart';
import 'home.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(Duration(seconds: 2), () => _abrirTela(context));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(color: Colors.white,
//                gradient: LinearGradient(
//                  colors: [Color(0xFF295492), Color(0xFF8A275D)],
//                  begin: Alignment.centerRight,
//                  end: Alignment.centerLeft,
//                )

            ),

          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image.asset(
                        //Imagem LOGO da UFPR
                        "assets/logo-ufprconvida-sembordas.png",
                        width: 400.0,
                        height: 400.0,
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.only(top: 10.0),
                      ),
                      //Text("UFPR ConVIDA",style: TextStyle(color: Colors.white, fontSize: 24.0,fontWeight: FontWeight.bold),)
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CircularProgressIndicator(),
                    Padding(padding: EdgeInsetsDirectional.only(top: 20.0),),
                    Text("Carregando", style: TextStyle(
                        color: Color(0xFF295492),
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold),)
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}

Future _abrirTela(BuildContext context) async {
  Map result = await Navigator.of(context)
      .push(new MaterialPageRoute<Map>(builder: (BuildContext context) {
    return new Home();
  }));
}