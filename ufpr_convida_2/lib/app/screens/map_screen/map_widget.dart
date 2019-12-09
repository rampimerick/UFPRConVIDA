import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ufpr_convida_2/app/shared/globals/globals.dart' as globals;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:uuid/uuid.dart';


class MapWidget extends StatefulWidget {
  @override
  _MapWidgetState createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {

  MapType _mapType;
  Completer<GoogleMapController> _controller = Completer();
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  String _url = globals.URL;
  var randID = Uuid();

  void initState() {
    super.initState();
    _mapType = MapType.normal;
    print("Construindo Mapa");
  }

  @override
  Widget build(BuildContext context) {
    //setState(() {});
    return FutureBuilder(
      future: _getCurrentUserLocation(),
      builder:(BuildContext context, AsyncSnapshot<LocationData> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
              final _userLocation = snapshot.data;
              return Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  //Google's Map:
                  _googleMap(context, _userLocation.latitude, _userLocation.longitude),

                  //Right Buttons in Map:
                  Padding(
                    padding: const EdgeInsets.fromLTRB(360, 95, 0, 8),
                    child: Column(
                      children: <Widget>[
                        //_switchMapStyle(),
                        _getMyPosition(),
                      ],
                    ),
                  ),

                  //Search Text Field:
//                  Padding(
//                    padding: const EdgeInsets.fromLTRB(5, 32, 5, 0),
//                    child: Column(
//                      mainAxisAlignment: MainAxisAlignment.start,
//                      children: <Widget>[
//                        Container(
//                          color: Colors.white,
//                          child: TextField(
//                            decoration: InputDecoration(
//                              hintText: "Endereço: ",
//                              border: OutlineInputBorder(
//                                  borderRadius: BorderRadius.circular(4.5)),
//                            ),
//                          ),
//                        )
//                      ],
//                    ),
//                  ),
                ],
              );
        } else
          return CircularProgressIndicator();
      }
    );
  }

  Widget _googleMap(BuildContext context, double lat, double lng) {
    return Container(
      //height: MediaQuery.of(context).size.height,
      //width: MediaQuery.of(context).size.width,
      child: GoogleMap(
        mapType: _mapType,
        myLocationEnabled: true,
        myLocationButtonEnabled: false,
        compassEnabled: true,
        initialCameraPosition:
            CameraPosition(target: LatLng(lat,lng), zoom: 12),

        onMapCreated: (GoogleMapController controller) async {
          //FutureBuilder maybe..:
          //markers = await getMarkers(context);
          //print(markers);
          _controller.complete(controller);
        },

        onLongPress: (latlang) {
          //_addMarkerLongPressed(latlang);
          print(latlang);
          Navigator.pop(context);
          Navigator.pushNamed(context, "/new-event", arguments: latlang);
        },
        markers: Set<Marker>.of(markers.values),
        //onLongPress: ,
      ),
    );
  }

  FloatingActionButton _getMyPosition() {
    return FloatingActionButton(
      heroTag: "positionButton",
      backgroundColor: Color(0xFF295492),
      mini: true,
      onPressed: _getCurrentUserLocation,
      child: Icon(Icons.my_location),
    );
  }

  FloatingActionButton _switchMapStyle() {
    return FloatingActionButton(
      heroTag: "switchButton",
      backgroundColor: Color(0xFF295492),
      mini: true,
      onPressed: () {
        setState(() {
          if(_mapType == MapType.normal)
            _mapType = MapType.hybrid;
          else
            _mapType = MapType.normal;
          });
        },
      child: Icon(Icons.map),
    );
  }

  Future<LocationData> _getCurrentUserLocation() async{
    final locData = await Location().getLocation();
    markers = await getMarkers(context);

    print(locData.latitude);
    print(locData.longitude);
    //await Future.delayed(Duration(: 2));
    return locData;
  }

  Future <Map<MarkerId, Marker>> getMarkers(BuildContext context) async {

    http.Response response = await http.get("$_url/events");
    print("StatusCode:${response.statusCode}");
    //Caso vir código 200, OK!
    var jsonEvents;
    if ((response.statusCode == 200) || (response.statusCode == 201)) {
      jsonEvents = json.decode(response.body);
    } else {
      throw Exception("Falhou!");
    }

    Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
    MarkerId markerId;
    LatLng location;

    for (var e in jsonEvents){

      print("Criando markers..");
      var id = randID.v1();
      markerId = MarkerId("$id");
      location = LatLng(e["lat"], e["lng"]);
      double color;
      String type = e["type"];
      //Marker color:
      if (type == "Reunião"){
        color = 120.0;
      } else if (type == "Festa"){
        color = 60.0;
      } else if (type == "Indefinido"){
        color = 210.0;
      } else {
        color = 0.0;
      }

      Marker marker = Marker(
        markerId: markerId,
        draggable: false,
        position: location,
        infoWindow: InfoWindow(title: e["name"], snippet: e["link"]),
        icon: BitmapDescriptor.defaultMarkerWithHue(color),
        onTap: () => null
      );

      markers[markerId] = marker;

    }
    return markers;
  }


}
