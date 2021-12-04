import 'package:ProjetoMeisiIPV/home_page.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';


//class MyHomePage extends StatefulWidget {
  //@override
  //_MyHomePageState createState() => _MyHomePageState();
//}

class Mapa extends StatefulWidget {
  @override
  _MapaState createState() => _MapaState();
}

class _MapaState extends State<Mapa> {

  LatLng _initialcameraposition = LatLng(20.5937, 78.9629);
  GoogleMapController _controller;
  Location _location = Location();

  //MARCADORES
  GoogleMapController mapController; //contrller for Google map
  final Set<Marker> markers = new Set(); //markers for google map
  static const LatLng showLocation = const LatLng(40.63913, -7.927002); //location to show in map

  void _onMapCreated(GoogleMapController _cntlr)
  {
    _controller = _cntlr;
    _location.onLocationChanged.listen((l) {
      _controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: LatLng(l.latitude, l.longitude),zoom: 15),
        ),
      );
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: [
            GoogleMap(
              //initialCameraPosition: CameraPosition(target: _initialcameraposition),
              mapType: MapType.normal,
              //onMapCreated: _onMapCreated,
              myLocationEnabled: true,
              zoomGesturesEnabled: true, //enable Zoom in, out on map
              initialCameraPosition: CameraPosition( //innital position in map
               target: showLocation, //initial position
               zoom: 18.0, //initial zoom level
          ),
              markers: getmarkers(), //markers to show on map
              onMapCreated: (controller) { //method called when map is created
                setState(() {
                  mapController = controller;
                });
              }
             ),
          ],
        ),
      ),
    );
  }

  Set<Marker> getmarkers() { //markers to place on map
    setState(() {
      markers.add(Marker( //add first marker
        markerId: MarkerId(showLocation.toString()),
        position: showLocation, //position of marker
        infoWindow: InfoWindow( //popup info
          title: 'Park Area ',
          snippet: 'Park Area',
        ),
        icon: BitmapDescriptor.defaultMarker, //Icon for Marker
      ));

      markers.add(Marker( //add second marker
        markerId: MarkerId(showLocation.toString()),
        position: LatLng(40.638139, -7.927002), //position of marker
        infoWindow: InfoWindow( //popup info
          title: 'Park Area ',
          snippet: 'Park Area',
        ),
        icon: BitmapDescriptor.defaultMarker, //Icon for Marker
      ));

      markers.add(Marker( //add third marker
        markerId: MarkerId(showLocation.toString()),
        position: LatLng(40.638556, -7.926862), //position of marker
        infoWindow: InfoWindow( //popup info
          title: 'Park Area ',
          snippet: 'Park Area',
        ),
        icon: BitmapDescriptor.defaultMarker, //Icon for Marker
      ));

      markers.add(Marker( //add third marker
        markerId: MarkerId(showLocation.toString()),
        position: LatLng(40.63865, -7.92712), //position of marker
        infoWindow: InfoWindow( //popup info
          title: 'Park Area ',
          snippet: 'Park Area',
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
