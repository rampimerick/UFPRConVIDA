import 'dart:async';
import 'dart:async' as prefix0;
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';


class Post {

  //final String Id;
  final String name;
  final String target;
  final String date_event;
  final String desc;
  final String init;
  final String end;
  final String link;
  final String type;
  final String setor;
  final String bloco;

  Post({this.name, this.target, this.date_event, this.desc, this.init, this.end, this.link, this.type, this.setor,this.bloco});

  factory Post.fromJson(Map<String, dynamic> json){
    return Post(
        //Id: json['Id'],
        name: json['name'],
        target: json['target'],
        date_event: json['date_event'],
        desc: json['desc'],
        init: json['init'],
        end: json['end'],
        link: json['link'],
        type: json['type'],
        setor: json['setor'],
        bloco: json['bloco']
    );
  }



  Map toMap(){
    var map = new Map<String, dynamic> ();
    //map["Id"] = Id;
    map["name"] = name;
    map["target"] = target;
    map["date_event"] = date_event;
    map["desc"] = desc;
    map["init"] = init;
    map["end"] = end;
    map["link"] = link;
    map["type"] = type;
    map["setor"] = setor;
    map["bloco"] = bloco;
    return map;
  }
}

Future <Post> createPost (String url, {String body}/*Aqui tem que ter HEADERS?*/) async {
  Map<String, String> mapHeaders = {"Accept": "application/json", "Content-Type": "application/json"};

  return http.post(url, body: body, headers: mapHeaders).then((http.Response response){

    final int statusCode = response.statusCode;
    print(statusCode);

    if ((statusCode == 200)||(statusCode == 201)){
      return null;//Post.fromJson(json.decode(response.body));
    }

    else {
      throw new Exception("Error while fetching data");
    }

  });

}
//
//Future<List<dynamic>> getEvent() async {
//  String apiUrl = "";
//  var response = await http.post(
//      Uri.encodeFull("http://10.0.2.2:8080/events"),
//      headers: {"Accept": "application/json"}
//  );
//
//  if (response.statusCode == 200) {
//    var print1 = json.decode(response.body);
//    print(print1);
//  } else {
//    throw Exception("Falhou!");
//  }
//}
//
//



class telaNovoEvento extends StatefulWidget {
  @override
  _telaNovoEventoState createState() => _telaNovoEventoState();
}

class _telaNovoEventoState extends State<telaNovoEvento> {


  @override
  //Controles:
  final TextEditingController _eventNameController =
      new TextEditingController();
  final TextEditingController _eventTargetController =
      new TextEditingController();
  final _eventDataController = new MaskedTextController(mask: '00/00/0000');
  final TextEditingController _eventController = new TextEditingController();
  final TextEditingController _eventDescController =
      new TextEditingController();
  final _eventDataInitController = new MaskedTextController(mask: '00/00/0000');
  final _eventDataEndController = new MaskedTextController(mask: '00/00/0000');
  final TextEditingController _eventLinkController =
      new TextEditingController();
  final TextEditingController _eventTypeController =
      new TextEditingController();

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Seu novo Evento"),
        ),
        body: Container(
          child:
          //-----------------------
              ListView(
              //Talvez uma Row com "Dados:"

            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(10),
                child: Container(
                  alignment: Alignment.center,
                  child: Text(
                    "Informe os Dados",
                    style: TextStyle(
                        color: Color(0xFF295492), //Color(0xFF8A275D),
                        fontSize: 32.0,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: TextField(
                    controller: _eventNameController,
                    decoration: InputDecoration(
                      hintText: "Nome do seu Evento:",
                      //border: OutlineInputBorder(
                      //  borderRadius:,
                      //),
                      icon: Icon(Icons.event_note),
                    )),
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: TextField(
                    controller: _eventTargetController,
                    decoration: InputDecoration(
                      hintText: "Público Alvo:",
                      //border: OutlineInputBorder(
                      //  borderRadius:,
                      //),
                      icon: Icon(Icons.person_pin_circle),
                    )),
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: TextField(
                    controller: _eventDataController,
                    decoration: InputDecoration(
                      hintText: "Data o seu Evento:",
                      //border: OutlineInputBorder(
                      //  borderRadius:,
                      //),
                      icon: Icon(Icons.event),
                    )),
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: TextField(
                    controller: _eventDescController,
                    decoration: InputDecoration(
                      hintText: "Descrição:",
                      //border: OutlineInputBorder(
                      //  borderRadius:,
                      //),
                      icon: Icon(Icons.note),
                    )),
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: TextField(
                    controller: _eventDataInitController,
                    decoration: InputDecoration(
                      hintText: "Data Início Inscrições:",
                      //border: OutlineInputBorder(//  borderRadius:,
                      //),
                      icon: Icon(Icons.event_available),
                    )),
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: TextField(
                    controller: _eventDataEndController,
                    decoration: InputDecoration(
                      hintText: "Data Fim Inscrições:",
                      //border: OutlineInputBorder(
                      //  borderRadius:,
                      //),
                      icon: Icon(Icons.event_busy),
                    )),
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: TextField(
                    controller: _eventLinkController,
                    decoration: InputDecoration(
                      hintText: "Link do seu Evento:",
                      //border: OutlineInputBorder(
                      //  borderRadius:,
                      //),
                      icon: Icon(Icons.link),
                    )),
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: TextField(
                    controller: _eventTypeController,
                    decoration: InputDecoration(
                      hintText: "Tipo do seu Evento:",
                      //border: OutlineInputBorder(
                      //  borderRadius:,
                      //),
                      icon: Icon(Icons.assignment),
                    )),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0,0,10,0),
                        child: FlatButton(
                          onPressed: () => print("Cancelar!"),
                          color: Color(0xFF295492),
                          child: Text(
                            "Cancelar",
                            style: TextStyle(color: Colors.white, fontSize: 17.0),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10,0,0,0),
                        child: FlatButton(
                          onPressed: () async {
                            String test = _eventDataEndController.text;
                            test = test.replaceAll("/","-");
                            print(test);

                            _eventDataEndController.text = _eventDataEndController.text.replaceAll("/", "-");
                            _eventDataEndController.text = _eventDataEndController.text.replaceAll("/", "-");
                            _eventDataEndController.text = _eventDataEndController.text.replaceAll("/", "-");
                            Post newPost = new Post(
                              //Id: "123",
                              name: _eventNameController.text,
                              target: _eventTargetController.text,
                              date_event: "2019-12-12",
                              desc: _eventDescController.text,
                              init: "2019-12-12",
                              end: "2019-12-12",
                              link: _eventLinkController.text,
                              type: _eventTypeController.text,
                              setor: "SEPT",
                              bloco: "A"
                            );

                            String post1 = json.encode(newPost.toMap());
                            print(post1);
                            Post p = await createPost("http://10.0.2.2:8080/events", body: post1);
                            //print(p);
                            },
                          color: Color(0xFF8A275D),
                          child: Text(
                            "Criar",
                            style: TextStyle(color: Colors.white, fontSize: 17.0),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
          // ------------------------
        ));
  }
}