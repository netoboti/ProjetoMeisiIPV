import 'package:ProjetoMeisiIPV/home_page.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


class Marcadores extends StatefulWidget{
  @override
  _MarcadoresState createState() => _MarcadoresState();
}

class _MarcadoresState extends State<Marcadores> {

  GoogleMapController mapController; //contrller for Google map
  final Set<Marker> markers = new Set(); //markers for google map
  static const LatLng showLocation = const LatLng(40.63913, -7.925455); //location to show in map

  @override
  Widget build(BuildContext context) {

    return  Scaffold(
      appBar: AppBar(
        title: Text("Área p/ Parking"),
        backgroundColor: Color(0xffe5c100),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
            onPressed: () {
            Navigator.pushReplacement(
            context,
            MaterialPageRoute(
            builder: (context) {
            return HomePage();
        },
        ),
        );
        },
        ),
      ),

    body: GoogleMap( //Map widget from google_maps_flutter package
        zoomGesturesEnabled: true, //enable Zoom in, out on map
        initialCameraPosition: CameraPosition( //innital position in map
          target: showLocation, //initial position
          zoom: 15.0, //initial zoom level
        ),
        markers: getmarkers(), //markers to show on map
        mapType: MapType.normal, //map type
        onMapCreated: (controller) { //method called when map is created
          setState(() {
            mapController = controller;
          });
        },
      ),

    );
  }

  Set<Marker> getmarkers() { //markers to place on map
    setState(() {
      markers.add(Marker( //add first marker
        markerId: MarkerId(showLocation.toString()),
        position: showLocation, //position of marker
        infoWindow: InfoWindow( //popup info
          title: 'Park Area 1',
          snippet: 'Sem vagas disponíveis',
        ),
      onTap: (){},
        icon: BitmapDescriptor.defaultMarker, //Icon for Marker
      ));

      markers.add(Marker( //add second marker
        markerId: MarkerId(showLocation.toString()),
        position: LatLng(40.638139, -7.927001), //position of marker
        infoWindow: InfoWindow( //popup info
          title: 'Park Area',
          snippet: 'Sem vagas disponíveis',
        ),
        icon: BitmapDescriptor.defaultMarker, //Icon for Marker
      ));

      markers.add(Marker( //add third marker
        markerId: MarkerId(showLocation.toString()),
        position: LatLng(40.638556, -7.926862), //position of marker
        infoWindow: InfoWindow( //popup info
          title: 'Park Area',
          snippet: 'Vagas disponíveis',
        ),
        icon: BitmapDescriptor.defaultMarker, //Icon for Marker
      ));

      markers.add(Marker( //add third marker
        markerId: MarkerId(showLocation.toString()),
        position: LatLng(40.63865, -7.92712), //position of marker
        infoWindow: InfoWindow( //popup info
          title: 'Park Area',
          snippet: 'Sem vagas disponíveis',
        ),
        icon: BitmapDescriptor.defaultMarker, //Icon for Marker
      ));

      markers.add(Marker( //add third marker
        markerId: MarkerId(showLocation.toString()),
        position: LatLng(40.637785, -7.927415), //position of marker
        infoWindow: InfoWindow( //popup info
          title: 'Park Area ',
          snippet: 'Park Area',
        ),
        icon: BitmapDescriptor.defaultMarker, //Icon for Marker
      ));
      //add more markers here

    });

    return markers;
  }
}