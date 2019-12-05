import 'package:flutter/material.dart';
import 'package:ufpr_convida_2/app/shared/theme/blue_theme.dart' as prefix0;

class DetailedEventWidget extends StatefulWidget {
  @override
  _DetailedEventWidgetState createState() => _DetailedEventWidgetState();
}

class _DetailedEventWidgetState extends State<DetailedEventWidget> {

  String inscricoes = "Não existe inscrições!";
  //---------Manipular dados---------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white70,
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
              centerTitle: true,
              title: Text("Evento"),
              pinned: true,
              floating: true),
          SliverFixedExtentList(
            itemExtent: 150.0,
            delegate: SliverChildListDelegate(
              [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 6),
                  child: Container(
                    alignment: Alignment.topLeft,
                    color: Colors.white,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("Eventos tals",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                        ),
                        //SizedBox(height: 6),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                          child: Row(
                            children: <Widget>[
                              Icon(Icons.access_time, size: 28),
                              SizedBox(width: 5),
                              Text("Sáb, 25 jan - Dom, 26 jan"),
                            ],
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.only(left: 42),
                          child:
                              Text("12h - 00h", style: TextStyle(fontSize: 12)),
                        ),

                        Padding(
                          padding: const EdgeInsets.fromLTRB(8, 8, 0, 0),
                          child: Row(
                            children: <Widget>[
                              Icon(Icons.location_on, size: 28),
                              SizedBox(width: 5),
                              Text("SEPT - UFPR")
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 42),
                          child: Text("Rua tal tal tal tsl stal",
                              style: TextStyle(fontSize: 12)),
                        ),
                      ],
                    ),
                  ),
                ),

                //Description
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 6),
                  child: Container(
                    alignment: Alignment.topLeft,
                    color: Colors.white,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("Descrição do evento",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                              "Tals talsTals talsTals talsTals talsTals tals Tals talsTals talsTals talsTals talsTals tals Tals talsTals talsTals ls talsTals tals Tals Tals talsTals talsTals talsTals talsTals tals sTals talsTals talsTals talsTals talsTals tals"),
                        ),
                      ],
                    ),
                  ),
                ),

                Container(
                  padding: const EdgeInsets.fromLTRB(0, 6, 0, 6),
                  alignment: Alignment.topLeft,
                  color: Colors.white,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("Sobre o organizador",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                            "Tals talsTals talsTals talsTals talsTals tals"),
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 6, 0, 6),
                  child: Container(
                    alignment: Alignment.topLeft,
                    color: Colors.white,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("Mais informaçoes",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                        ),
                        SizedBox(
                          height: 2,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Text("Link: www...."),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Text("Categoria: Festa"),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: IconButton(icon: Icon(Icons.my_location), onPressed: () => null),
                        ),
                      ],
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 6),
                  child: Container(
                    alignment: Alignment.topLeft,
                    color: Colors.white,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("Inscrições:",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container (child: Text("$inscricoes"))


                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
              //crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                RaisedButton(
                  color: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, '/main');
                  },
                  padding: EdgeInsets.fromLTRB(60, 12, 60, 12),
                  child: Text('Favoritar',
                      style: TextStyle(color: Colors.white, fontSize: 18)),
                ),
              ]),
        ),
      ),
    );
  }
}
