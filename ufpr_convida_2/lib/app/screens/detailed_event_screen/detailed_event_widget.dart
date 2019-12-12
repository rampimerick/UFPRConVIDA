import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';
import 'dart:io';
import 'package:ufpr_convida_2/app/shared/globals/globals.dart' as globals;
import 'package:ufpr_convida_2/app/shared/models/bfav.dart';
import 'package:ufpr_convida_2/app/shared/models/event.dart';
import 'package:ufpr_convida_2/app/shared/models/user.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailedEventWidget extends StatefulWidget {
  @override
  _DetailedEventWidgetState createState() => _DetailedEventWidgetState();
}

class _DetailedEventWidgetState extends State<DetailedEventWidget> {
  String _url = globals.URL;
  final DateFormat formatter = new DateFormat.yMd("pt_BR").add_Hm();
  final DateFormat hour = new DateFormat.Hm();
  final DateFormat date = new DateFormat("EEE, d MMM", "pt_BR");
  final DateFormat test = new DateFormat.MMMM("pt_BR");
  String address =
      "R. Dr. Alcides Vieira Arcoverde, 1225 - Jardim das Américas, Curitiba - PR, 81520-260";

  bool fav = false;
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
      future: getEvent(eventId),
      builder: (BuildContext context, AsyncSnapshot<Event> snapshot) {
        if (snapshot.data == null) {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else {
          DateTime dateStart = DateTime.parse(snapshot.data.dateStart);
          DateTime dateEnd = DateTime.parse(snapshot.data.dateEnd);
          DateTime hourStart = DateTime.parse(snapshot.data.hrStart);
          DateTime hourEnd = DateTime.parse(snapshot.data.hrEnd);
          DateTime subStart;
          DateTime subEnd;
          if(snapshot.data.startSub != null){
             subStart = DateTime.parse(snapshot.data.startSub);
             subEnd = DateTime.parse(snapshot.data.endSub);
          }

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
            backgroundColor: Colors.white70,
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
                                padding: const EdgeInsets.fromLTRB(8, 3, 8, 3),
                                child: Text("${snapshot.data.name}",
                                    style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold)),
                              ),
                              //SizedBox(height: 6),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                                child: Row(
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          3, 10, 3, 3),
                                      child: Icon(Icons.access_time, size: 24),
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
                                padding: const EdgeInsets.fromLTRB(42, 0, 0, 0),
                                child: Text(
                                    "${hour.format(hourStart)} - ${hour.format(hourEnd)}",
                                    style: TextStyle(fontSize: 14)),
                              ),

                              //Endereço:
                              snapshot.data.bloc == ''
                                  ? Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(8, 8, 0, 0),
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
                                      padding:
                                          const EdgeInsets.fromLTRB(8, 8, 0, 0),
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
                                padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                                child: Text("Descrição do evento",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold)),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                                child: SizedBox(
                                    width: 360,
                                    child: Text("${snapshot.data.desc}", style: TextStyle(
                                      fontSize: 15
                                    ),)),
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
                                      fontSize: 20,
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
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold)),
                              ),
                              SizedBox(
                                height: 2,
                              ),
                              Padding(
                                  padding: const EdgeInsets.fromLTRB(14,4,4,4),
                                  child: Row(
                                    children: <Widget>[
                                      Text(
                                        "Tipo de Evento: ",
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text("${snapshot.data.type}", style: TextStyle(
                                        fontSize: 16
                                      ),),
                                    ],
                                  )),

                              SizedBox(height: 4),
                              Padding(
                                  padding: const EdgeInsets.fromLTRB(14,4,4,4),
                                  child: Row(
                                    children: <Widget>[
                                      Text(
                                        "Público alvo: ",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                      ),
                                      Text("${snapshot.data.target}" ,style: TextStyle(fontSize: 16))
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(8, 8, 8, 0),
                                      child: Text("Inscrições:",
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold)),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Padding(
                                        padding: const EdgeInsets.fromLTRB(14,4,4,4),
                                        child: Row(
                                          children: <Widget>[
                                            Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(3, 3, 3, 3),
                                              child: Icon(Icons.timer,size: 24),
                                            ),
                                            SizedBox(width: 3),
                                            Text("Início: ", style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold)),
                                            SizedBox(width: 3),
                                            Text(
                                                "${date.format(subStart)} - ${hour.format(subStart)}",
                                                style:
                                                    TextStyle(fontSize: 16.0)),
                                          ],
                                        )),
                                    Padding(
                                        padding: const EdgeInsets.fromLTRB(14,4,4,4),
                                        child: Row(
                                          children: <Widget>[
                                            Padding(
                                              padding:
                                              const EdgeInsets.fromLTRB(3, 3, 3, 3),
                                              child: Icon(Icons.timer_off,size: 24),
                                            ),
                                            SizedBox(width: 3),
                                            Text("Fim: ", style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold)),
                                            SizedBox(width: 3),
                                            SizedBox(
                                              width: 360,
                                              child: Text(
                                                  "${date.format(subEnd)} - ${hour.format(subEnd)}",
                                                  style:
                                                  TextStyle(fontSize: 16.0)),
                                            ),
                                          ],
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(8, 8, 8, 0),
                                      child: Text("Não há inscrições",
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold)),
                                    ),
                                    Center(
                                      child: SizedBox(
                                        width: 360,
                                        child: Padding(
                                          padding: const EdgeInsets.fromLTRB(14,14,4,4),
                                          child: Text(
                                            "Infelizmente o organizador não informou datas de inscrições",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.grey
                                                  )
                                          ),
                                        ),
                                      ),
                                    )
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
                        onTap: () async {
                          openLink(snapshot.data.link);
                        },
                        child: SizedBox(
                            width: 90,
                            height: 50,
                            child: Column(
                              children: <Widget>[
                                Icon(
                                  Icons.link,
                                  size: 28,
                                ),
                                Text("Link")
                              ],
                            )),
                      ),
                      InkWell(
                        onTap: () {
                          if (fav == true)
                            _deleteEventFav(snapshot.data.id);
                          else
                            _putEventFav(snapshot.data.id);
                        },
                        child: SizedBox(
                            width: 90,
                            height: 50,
                            child: Column(
                              children: <Widget>[
                                fav == true
                                    ? Icon(
                                        Icons.star,
                                        size: 28,
                                        color: Colors.amberAccent,
                                      )
                                    : Icon(Icons.star_border, size: 28),
                                Text("Favoritar")
                              ],
                            )),
                      ),
                      SizedBox(
                          width: 90,
                          height: 50,
                          child: Column(
                            children: <Widget>[
                              Icon(Icons.share, size: 28),
                              Text("Compartilhar")
                            ],
                          ))
                    ]),
              ),
            ),
          );
        }
      },
    );
  }

  Future<Event> getEvent(String eventId) async {
    http.Response response = await http.get("$_url/events/$eventId");
    print(response.statusCode);
    var jsonEvent;
    if ((response.statusCode == 200) || (response.statusCode == 201)) {
      jsonEvent = json.decode(response.body);
      Event e = Event.fromJson(jsonEvent);
      //address = await getPlaceAddress(e.lat,e.lng);
      //print("Local: $address");

      var idEvent = e.id;
      String idUser = globals.userName;

      Bfav fv = new Bfav(grr: idUser, id: idEvent);

      String body = json.encode(fv.toJson());

      var r =
          await http.post("$_url/users/isfav", body: body, headers: mapHeaders);
//      print("Status code POST is FAV:${r.statusCode}");
      if (r.statusCode == 200)
        fav = true;
      else
        fav = false;

      return e;
    } else {
      throw Exception("Falhou!");
    }
  }

  Future<String> getPlaceAddress(double lat, double lng) async {
    final url =
        "https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=AIzaSyDExnKlMmmFCZMh1okr26-JFz1anYRr9HE";
    final response = await http.get(url);

    print("Geocoding: ${response.statusCode}");
    print("Body: ${jsonDecode(response.body)}");
    return jsonDecode(response.body)['result'][0]['formatterd_address'];
  }

  openLink(String link) async {
    String url = 'http://$link';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future _putEventFav(String eventId) async {
    Map<String, String> mapHeaders = {
      "Accept": "application/json",
      "Content-Type": "application/json",
      HttpHeaders.authorizationHeader: "Bearer ${globals.token}"
    };

    Event e = await http
        .get("$_url/events/$eventId", headers: mapHeaders)
        .then((http.Response response) {
      final int statusCodeEvent = response.statusCode;
      if (statusCodeEvent == 200 || statusCodeEvent == 201) {
        print("Event Success!");
        return Event.fromJson(jsonDecode(response.body));
      } else {
        throw new Exception(
            "Error while fetching data, status code: $statusCodeEvent");
      }
    });

    var idEvent = e.id;
    String idUser = globals.userName;

    Bfav fv = new Bfav(grr: idUser, id: idEvent);

    String body = json.encode(fv.toJson());
    print(body);

    var r = await http.post("$_url/users/fav", body: body, headers: mapHeaders);
    print("Status code POST:${r.statusCode}");
    if (r.statusCode == 204)
      setState(() {
        fav = true;
      });
  }

  Future _deleteEventFav(String eventId) async {
    Event e = await http
        .get("$_url/events/$eventId", headers: mapHeaders)
        .then((http.Response response) {
      final int statusCodeEvent = response.statusCode;
      if (statusCodeEvent == 200 || statusCodeEvent == 201) {
        print("Event Success!");
        return Event.fromJson(jsonDecode(response.body));
      } else {
        throw new Exception(
            "Error while fetching data, status code: $statusCodeEvent");
      }
    });

    var idEvent = e.id;
    String idUser = globals.userName;

    Bfav fv = new Bfav(grr: idUser, id: idEvent);

    String body = json.encode(fv.toJson());
    print(body);
    var r =
        await http.post("$_url/users/rfav", body: body, headers: mapHeaders);
    print("Status code DELETE:${r.statusCode}");
    if (r.statusCode == 204)
      setState(() {
        fav = false;
      });
  }
}
