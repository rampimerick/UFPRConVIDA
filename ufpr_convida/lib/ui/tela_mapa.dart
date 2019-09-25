import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ufpr_convida/ui/tela_configuracoes.dart';
import 'package:http/http.dart' as http;
import 'package:ufpr_convida/ui/tela_eventos.dart';
import 'package:ufpr_convida/ui/tela_novo_evento.dart';
import 'package:uuid/uuid.dart';


Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
var randID = Uuid();

class telaMapa extends StatefulWidget {
  @override
  _telaMapaState createState() => _telaMapaState();
}

class _telaMapaState extends State<telaMapa> {
  //Implementa a API do google, ao final do codigo temos um marker da UFPR

  Completer<GoogleMapController> _controller = Completer();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        _googleMaps(context),
      ],
    );
  }

  final TextEditingController _pesquisaController = new TextEditingController();

  Widget _googleMaps(BuildContext context) {
    return Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        //Configurações do mapa que será mostrado na tela ao carregar:
        child: Stack(
          children: <Widget>[
            GoogleMap(
              mapType: MapType.normal,
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              compassEnabled: true,
              initialCameraPosition: CameraPosition(target: LatLng(-25.4560508, -49.2371759), zoom: 12),
              onMapCreated: (GoogleMapController controller) {

                _controller.complete(controller);

                },
              onLongPress: (latlang) {
                _addMarkerLongPressed(latlang);
              },
              markers: Set<Marker>.of(markers.values)
              //onLongPress: ,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Align(
                alignment: Alignment.bottomRight,
                child: Container(
                  child: addButton(context,Icons.add),
                ),
              ),
            ),
            Container(

              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: TextField(
                  controller: _pesquisaController,
                  decoration: InputDecoration(
                      hintText: "Local: ",
                      //border: OutlineInputBorder(
                      //    borderRadius: BorderRadius.circular(4.5)),
                      icon: Padding(
                        padding: const EdgeInsets.fromLTRB(8.0, 0.0, 0.0, 0.0),
                        child: Icon(Icons.search),
                      )),
                ),
              ),
            ),
          ],
        ));
  }

Future _addMarkerLongPressed(latlang) async {
    _abrirTela(context);
    setState(() {
      var id = randID.v1();
      //print(id);
      final MarkerId markerId = MarkerId("$id");
      Marker marker = Marker(
        markerId: markerId,
        draggable: true,
        position: latlang,
        infoWindow: InfoWindow(
          title: "Novo Marker",
          snippet: "Seu marker foi criado!"),
        icon: BitmapDescriptor.defaultMarker
        );
        markers[markerId] = marker;
    });

    GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newLatLngZoom(latlang, 20.0));
  }
}
//Marker do politecnico baseado no MAPS, Lat/Long foram pegas na "mão"
//Pesquisando no proprio maps a localização do Politecnico

Marker politecnicoMarker = Marker(

  markerId: MarkerId("politecnico1"),
  position: LatLng(-25.4555137, -49.2361375),
  infoWindow: InfoWindow(title: "UFPR Centro Politecnico"),
  icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueMagenta),
);
//Usar outras cores depois talvez.
//http://chart.googleapis.com/chart?chst=d_map_pin_letter&chld=xxx|9550FC|846098&.png
Widget addButton(BuildContext context,IconData icon) {
  return FloatingActionButton(
    onPressed:() => _abrirTela(context),//getEvent(),
    materialTapTargetSize: MaterialTapTargetSize.padded,
    backgroundColor: Color(0xFF8A275D),
    child: Icon(icon, size: 36.0),
  );
}
Future _abrirTela(BuildContext context) async {
  Map resultado = await Navigator.of(context)
      .push(new MaterialPageRoute<Map>(builder: (BuildContext context) {
    return new telaNovoEvento();
  }));
}

