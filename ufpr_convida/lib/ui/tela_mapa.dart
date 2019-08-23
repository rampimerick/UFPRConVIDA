
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class telaMapa extends StatefulWidget {


  @override
  _telaMapaState createState() => _telaMapaState();
}

class _telaMapaState extends State<telaMapa> {
  Completer<GoogleMapController> _controller = Completer();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        _googleMaps(context),
      ],
    );
  }

  Widget _googleMaps(BuildContext context) {
    return Container(
      height: MediaQuery
          .of(context)
          .size
          .height,
      width: MediaQuery
          .of(context)
          .size
          .width,
      child: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition:
        CameraPosition(target: LatLng(-25.4560508, -49.2371759), zoom: 12),
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        markers: {politecnicoMarker},
      ),
    );
  }
}

  Marker politecnicoMarker = Marker(
      markerId: MarkerId("politecnico1"),
      position: LatLng(-25.4555137, -49.2361375),
      infoWindow: InfoWindow(title: "UFPR Centro Politecnico"),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure));

