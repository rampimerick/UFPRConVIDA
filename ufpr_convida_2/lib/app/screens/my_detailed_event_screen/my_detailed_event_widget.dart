import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as prefix0;
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:ufpr_convida_2/app/screens/alter_event_screen/alter_event_widget.dart';
import 'dart:convert';
import 'dart:io';
import 'package:ufpr_convida_2/app/shared/globals/globals.dart' as globals;
import 'package:ufpr_convida_2/app/shared/models/bfav.dart';
import 'package:ufpr_convida_2/app/shared/models/event.dart';
import 'package:ufpr_convida_2/app/shared/models/user.dart';
import 'package:url_launcher/url_launcher.dart';

class MyDetailedEventWidget extends StatefulWidget {
  @override
  _MyDetailedEventWidgetState createState() => _MyDetailedEventWidgetState();
}

class _MyDetailedEventWidgetState extends State<MyDetailedEventWidget> {
  String _url = globals.URL;
  final DateFormat formatter = new DateFormat.yMd("pt_BR").add_Hm();
  final DateFormat hour = new DateFormat.Hm();
  final DateFormat date = new DateFormat("EEE, d MMM", "pt_BR");
  final DateFormat test = new DateFormat.MMMM("pt_BR");
  String address =
      "R. Dr. Alcides Vieira Arcoverde, 1225 - Jardim das Américas, Curitiba - PR, 81520-260";

  Map<String, String> mapHeaders = {
    "Accept": "application/json",
    "Content-Type": "application/json",
    HttpHeaders.authorizationHeader: "Bearer ${globals.token}"
  };

  @override
  Widget build(BuildContext context) {
    final routeArgs =
        ModalRoute.of(context).settings.arguments as Map<String, String>;
    final eventId = routeArgs['id'];

    return FutureBuilder(
        future: getMyEvent(eventId),
        builder: (BuildContext context, AsyncSnapshot<Event> snapshot) {
          if (snapshot.data == null) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            DateTime dateStart = DateTime.parse(snapshot.data.dateStart);
            DateTime dateEnd = DateTime.parse(snapshot.data.dateEnd);
            DateTime hourStart = DateTime.parse(snapshot.data.hrStart);
            DateTime hourEnd = DateTime.parse(snapshot.data.hrEnd);

            String _imageAsset = "";

            if(snapshot.data.type == 'Saúde'){
              _imageAsset = 'type-health.png';
            }else if (snapshot.data.type == 'Esporte e Lazer'){
              _imageAsset = 'type-sport.png';
            }else if (snapshot.data.type == 'Festas e Comemorações'){
              _imageAsset = 'type-party.png';
            }else if (snapshot.data.type == 'Cultura'){
              _imageAsset = 'type-art.png';
            }else if (snapshot.data.type == 'Acadêmico'){
              _imageAsset = 'type-graduation.png';
            }else {
              _imageAsset = 'type-others.png';
            }
            
            return Scaffold(
              body: CustomScrollView(
                slivers: <Widget>[
                  SliverAppBar(
                      centerTitle: true,
                      title: Text("${snapshot.data.name}"),
                      pinned: true,
                      floating: true),
                  SliverFixedExtentList(
                    itemExtent: 150.0,
                    delegate: SliverChildListDelegate(
                      [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                          child: Container(
                              alignment: Alignment.center,
                              color: Colors.white,
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Image.asset("assets/$_imageAsset"),
                              )),
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
                                  padding:
                                      const EdgeInsets.fromLTRB(8, 3, 8, 3),
                                  child: Text("${snapshot.data.name}",
                                      style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold)),
                                ),
                                //SizedBox(height: 6),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(8, 0, 0, 0),
                                  child: Row(
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            3, 10, 3, 3),
                                        child:
                                            Icon(Icons.access_time, size: 24),
                                      ),
                                      SizedBox(width: 3),
                                      Text(
                                        "${date.format(dateStart)} - ${date.format(dateEnd)}",
                                        style: TextStyle(fontSize: 16.0),
                                      ),
                                    ],
                                  ),
                                ),

                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(42, 0, 0, 0),
                                  child: Text(
                                      "${hour.format(hourStart)} - ${hour.format(hourEnd)}",
                                      style: TextStyle(fontSize: 14)),
                                ),

                                //Endereço:
                                snapshot.data.bloc == ''
                                    ? Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            8, 8, 0, 0),
                                        child: Row(
                                          children: <Widget>[
                                            Icon(Icons.location_on, size: 28),
                                            SizedBox(width: 5),
                                            SizedBox(
                                              width: 360,
                                              child: Text("$address"),
                                            )
                                          ],
                                        ),
                                      )
                                    : Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            8, 8, 0, 0),
                                        child: Row(
                                          children: <Widget>[
                                            Icon(Icons.location_on, size: 28),
                                            SizedBox(width: 5),
                                            Text(
                                                "${snapshot.data.sector} - ${snapshot.data.bloc}")
                                          ],
                                        ),
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
                                  padding:
                                      const EdgeInsets.fromLTRB(8, 8, 8, 0),
                                  child: Text("Descrição do evento",
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold)),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(10, 0, 0, 0),
                                  child: SizedBox(
                                      width: 360,
                                      child: Text(
                                          "${snapshot.data.desc}  tals als tals ")),
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
                                padding: const EdgeInsets.fromLTRB(8, 8, 8, 4),
                                child: Text("Sobre o organizador",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold)),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                                child: Row(
                                  children: <Widget>[
                                    Icon(Icons.person, size: 28),
                                    SizedBox(width: 7),
                                    Text(
                                        "${snapshot.data.author.name} ${snapshot.data.author.lastName}",
                                        style: TextStyle(fontSize: 15))
                                  ],
                                ),
                              ),
                              SizedBox(height: 10),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                                child: Row(
                                  children: <Widget>[
                                    Icon(Icons.email, size: 28),
                                    SizedBox(width: 7),
                                    Text(
                                      "${snapshot.data.author.email}",
                                      style: TextStyle(fontSize: 15),
                                    )
                                  ],
                                ),
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
                                  child: Text("Mais informações",
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold)),
                                ),
                                SizedBox(
                                  height: 2,
                                ),
//                              Padding(
//                                padding: const EdgeInsets.all(2.0),
//                                child: InkWell(
//                                  child: Text("Link: ${snapshot.data.link}"),
//                                  onTap: () async {
//                                    openLink(snapshot.data.link);
//                                  },
//                                ),
//                              ),
                                Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(8.0, 5, 0, 0),
                                    child: Row(
                                      children: <Widget>[
                                        Text(
                                          "Tipo de Evento: ",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text("${snapshot.data.type}"),
                                      ],
                                    )),

                                SizedBox(height: 10),
                                Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(8.0, 0, 0, 0),
                                    child: Row(
                                      children: <Widget>[
                                        Text(
                                          "Público alvo: ",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text("${snapshot.data.target}"),
                                      ],
                                    )),
                                SizedBox(height: 10),
                              ],
                            ),
                          ),
                        ),

                        snapshot.data.startSub != null
                            ? Padding(
                                padding: const EdgeInsets.fromLTRB(0, 0, 0, 6),
                                child: Container(
                                  alignment: Alignment.topLeft,
                                  color: Colors.white,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            8, 8, 8, 0),
                                        child: Text("Inscrições:",
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold)),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            children: <Widget>[],
                                          )),
                                    ],
                                  ),
                                ),
                              )
                            : Padding(
                                padding: const EdgeInsets.fromLTRB(0, 0, 0, 6),
                                child: Container(
                                  alignment: Alignment.topLeft,
                                  color: Colors.white,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            8, 8, 8, 0),
                                        child: Text("Não há inscrições",
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold)),
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
                  padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        InkWell(
                          onTap: () {
                            //Test:
                           Navigator.pop(context);
                           //print("TEST");

                           Navigator.push(
                               context,
                               MaterialPageRoute(
                                 builder: (context) => AlterEventWidget(
                                   event: snapshot.data,
                                 ),
                               ));
                          },
                          child: SizedBox(
                              width: 90,
                              height: 50,
                              child: Column(
                                children: <Widget>[
                                  Icon(Icons.event_note,size: 28),
                                  Text("Alterar")
                                ],
                              )),
                        ),
                        InkWell(
                          onTap: () async {
                            int delete = _confirmDelete(snapshot.data.id, snapshot.data.name);
                            if (delete == 1){
                               int status = await deleteMyEvent(snapshot.data.id);
                               if (status == 200){
                                 Navigator.popAndPushNamed(context,'/main');
                               }
                               else
                                 _showWarning();
                            }
                          },
                          child: SizedBox(
                              width: 90,
                              height: 50,
                              child: Column(
                                children: <Widget>[
                                  Icon(Icons.delete_forever, size: 28),
                                  Text("Deletar")
                                ],
                              )),
                        ),
                      ]),
                ),
              ),
            );
          }
        });
  }

  Future <Event> getMyEvent(eventId) async {
    http.Response response = await http.get("$_url/events/$eventId");
    print(response.statusCode);
    var jsonEvent;
    if ((response.statusCode == 200) || (response.statusCode == 201)) {
      jsonEvent = json.decode(response.body);
      Event e = Event.fromJson(jsonEvent);
      //address = await getPlaceAddress(e.lat,e.lng);
      //print("Local: $address");

      return e;
    } else {
      throw Exception("Falhou!");
    }
  }

  Future<int> deleteMyEvent(eventId) async{

    Response response = await http.delete("$_url/events/$eventId", headers: mapHeaders);
    print("Deletando: $_url/events/$eventId");
    int statusCode = response.statusCode;
    print("StatusCode DEL:$statusCode");
    return response.statusCode;
  }
  int _confirmDelete(String eventId, String eventName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Deletar Evento"),
          content: new Text("Deseja realmente deletear o evento \"$eventName\"?"),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Sim"),
              onPressed: () async {
                int status = await deleteMyEvent(eventId);
                if (status == 200){
                  Navigator.popAndPushNamed(context,'/main');
                }
                else
                  _showWarning();
              },
            ),
          ],
        );
      },
    );
    return 0;
  }

  void _showWarning() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Erro ao deletar Evento"),
          content: new Text("Não foi possível deletar esse evento, por favor, tente mais tarde."),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Ok"),
              onPressed: () {
                Navigator.popAndPushNamed(context,"/main");
              },
            ),
          ],
        );
      },
    );
  }

}
