import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as prefix0;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MapWidget extends StatefulWidget {
  @override
  _MapWidgetState createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  MapType _mapType;
  Completer<GoogleMapController> _controller = Completer();

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
          //markers = await getMarkers(context);
          _controller.complete(controller);
        },

        onLongPress: (latlang) {
          //_addMarkerLongPressed(latlang);
          Navigator.pop(context);
          Navigator.pushNamed(context, "/new-event");
        },
        //markers: Set<Marker>.of(markers.values),
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
    print(locData.latitude);
    print(locData.longitude);
    return locData;
  }
}
