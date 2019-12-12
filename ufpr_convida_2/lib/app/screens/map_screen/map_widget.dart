import 'dart:async';
import 'dart:convert';

import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as prefix0;
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
  //GoogleMapController mapController;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  String _url = globals.URL;
  var randID = Uuid();

  void initState() {
    super.initState();
    _mapType = MapType.normal;
    //print("Building Map");
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
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 34, 11, 0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          width: 400,
                          height: 52,
                          child: RaisedButton(
                            child: Text(
                              "Pesquisar Endereço",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20.0,
                                fontWeight: FontWeight.w500
                              ),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                              Navigator.pushNamed(context, '/search');
                            },
                            color: Color(0xFF295492),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
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

        onLongPress: (latlng) async{

          GoogleMapController mapController = await _controller.future;
          mapController?.animateCamera(
              CameraUpdate.newCameraPosition(
                  CameraPosition(
                      target: LatLng(
                          latlng.latitude,
                          latlng.longitude
                      ),
                      zoom: 18.0
                  )
              )
          );
          print(latlng);
          //String id = _markerConfirm(latlng);
          String id = "";
          _confirmEvent(latlng, id,context);
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
      onPressed: _getLocation,
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

  Future<LocationData> _getLocation() async {
    final locData = await Location().getLocation();
    GoogleMapController mapController = await _controller.future;
    mapController?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(
            locData.latitude,
            locData.longitude
          ),
          zoom: 16.0
        )
      )
    );
    return locData;
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

    print("-------------------------------------------------------");
    print("Request on: $_url/events");
    print("Status Code: ${response.statusCode}");
    print("Loading Event's Markers...");
    print("-------------------------------------------------------");

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
        onTap: () {
          _showSnackBar(e["name"], e["id"], context);
        });

      markers[markerId] = marker;

    }
    return markers;
  }
  String _markerConfirm(LatLng latLng){
    MarkerId markerId;

    var id = randID.v1();
    markerId = MarkerId("$id");

    Marker marker = Marker(
        markerId: markerId,
        draggable: false,
        position: latLng,
    );

    setState(() {
      markers[markerId] = marker;
    });

    return id;
  }
  void _showSnackBar(String eventName, String eventId, BuildContext context) {
    print("Context:$context");
    Flushbar(
      flushbarPosition: FlushbarPosition.TOP,
      margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
      borderRadius: 8,
      backgroundColor: Colors.white,

      boxShadows: [
        BoxShadow(
            color: Colors.black45,
            offset: Offset(3,3),
            blurRadius: 3
        )
      ],
      dismissDirection: FlushbarDismissDirection.HORIZONTAL,
      messageText: Text("Evento: $eventName", style: TextStyle(color:Color(0xFF295492),fontSize: 18,fontWeight: FontWeight.bold)),
      //message: "E",
      mainButton: FlatButton(
        child: Text("Visualizar"),
        onPressed: () {
          Navigator.pushNamed(context, '/event', arguments: {
            'id' : eventId
          });
        },
      ),
      duration: Duration(seconds: 5),
    )..show(context);
  }

  void _confirmEvent (LatLng latLng ,String id,BuildContext context) {
    print("Context:$context");
    Flushbar(
      flushbarPosition: FlushbarPosition.TOP,
      margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
      borderRadius: 8,
      backgroundColor: Colors.white,

      boxShadows: [
        BoxShadow(
            color: Colors.black45,
            offset: Offset(3,3),
            blurRadius: 3
        )
      ],
      dismissDirection: FlushbarDismissDirection.HORIZONTAL,
      messageText: Text("Deseja criar um evento aqui?", style: TextStyle(color:Color(0xFF295492),fontSize: 18,fontWeight: FontWeight.bold)),
      //message: "E",
      mainButton: FlatButton(
        child: Text("Sim"),
        onPressed: () {
          Navigator.pop(context);
          Navigator.pop(context);
          Navigator.pushNamed(context, "/new-event", arguments: latLng);
          //print("Removendo marker: $id");
          //markers.remove(id);
        },
      ),
      duration: Duration(seconds: 8),
    )..show(context);

  }

}
