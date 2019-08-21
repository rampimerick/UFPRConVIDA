import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

int _indexItem= 0;

class telaPrincipal extends StatefulWidget {
  @override
  _telaPrincipalState createState() => _telaPrincipalState();
}

class _telaPrincipalState extends State<telaPrincipal> {
  Completer <GoogleMapController> _controller = Completer();

  @override
  void _itemClicado(int index){
    setState(() {
      _indexItem = index;
      debugPrint("Item Index: $_indexItem");
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Bem vindo 'Fulano de Tal'"),
        backgroundColor: Colors.blueAccent,

      ),
      body: Stack(

        children: <Widget>[
          _googleMaps(context),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(items: [
        BottomNavigationBarItem(icon: Icon(Icons.map),
            title: Text("Mapa")),
        BottomNavigationBarItem(icon: Icon(Icons.list),
            title: Text("Eventos")
        )
      ],
          onTap: _itemClicado
      ),
    );
  }

  Widget _googleMaps(BuildContext context){
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: CameraPosition(target: LatLng(-25.4560508,-49.2371759), zoom: 12),
        onMapCreated: (GoogleMapController controller){
          _controller.complete(controller);
        },
        markers: {
          politecnicoMarker
        },
      ),

    );
  }
}



Marker politecnicoMarker=Marker(
  markerId: MarkerId("politecnico1"),
  position: LatLng(-25.4555137,-49.2361375),
  infoWindow: InfoWindow(title: "UFPR Centro Politecnico"),
  icon: BitmapDescriptor.defaultMarkerWithHue(
    BitmapDescriptor.hueAzure
  )
);

