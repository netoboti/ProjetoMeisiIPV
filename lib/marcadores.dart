import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

GoogleMapController mapController;

class MapsDemo extends StatefulWidget {
  MapsDemo() : super();



  @override
  MapsDemoState createState() => MapsDemoState();
}

class MapsDemoState extends State<MapsDemo> {
  //

  Completer<GoogleMapController> _controller = Completer();
  static const LatLng _center = const LatLng(38.82082, -9.09043);
  final Set<Marker> _markers = {};
  LatLng _lastMapPosition = _center;
  MapType _currentMapType = MapType.normal;


  void _currentLocation() async {
    final GoogleMapController controller = await _controller.future;
    LocationData currentLocation;
    var location = new Location();
    try {
      currentLocation = await location.getLocation();
    } on Exception {
      currentLocation = null;
    }

    controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        bearing: 0,
        target: LatLng(currentLocation.latitude, currentLocation.longitude),
        zoom: 18.0,
      ),
    ));
  }

  _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  _onCameraMove(CameraPosition position) {
    _lastMapPosition = position.target;
  }

  _onMapTypeButtonPressed() {
    setState(() {
      _currentMapType = _currentMapType == MapType.normal
          ? MapType.hybrid
          : MapType.normal;
    });
  }

  _onAddMarkerButtonPressed() {
    _currentLocation();
    setState(() {
      _markers.add(
          Marker(
              markerId: MarkerId(_lastMapPosition.toString()),
              position: _lastMapPosition,
              infoWindow: InfoWindow(
                  title: "Parking",
                  snippet: "Há Vagas Disponíveis",
                  onTap: (){
                  }
              ),
              onTap: (){
              },
              icon: BitmapDescriptor.defaultMarker));
    });
  }

  _onAddMarkerButtonPressedSem() {
    _currentLocation();
    setState(() {
      _markers.add(
          Marker(
              markerId: MarkerId(_lastMapPosition.toString()),
              position: _lastMapPosition,
              infoWindow: InfoWindow(
                  title: "Parking",
                  snippet: "Sem vagas Disponíveis",
                  onTap: (){
                  }
              ),
              onTap: (){
              },
              icon: BitmapDescriptor.defaultMarker));
    });
  }

  Widget button(Function function, IconData icon) {
    return FloatingActionButton(
      onPressed: function,
      materialTapTargetSize: MaterialTapTargetSize.padded,
      backgroundColor: Color(0xffe5c100),
      child: Icon(
        icon,
        size: 36.0,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      debugShowCheckedModeBanner: false,
      home: Scaffold(

        appBar: PreferredSize(
          preferredSize: Size.fromHeight(40),

          child: AppBar(
            automaticallyImplyLeading: false,
            centerTitle: true,
            title:  Column(
              children: <Widget>[
                const Text("Mapa - ParkingM", style: TextStyle(fontSize: 30.0),textAlign: TextAlign.center,),
                const Text("", style: TextStyle(fontSize: 13.0),textAlign: TextAlign.center,),
              ],
            ),
            flexibleSpace: Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: <Color>[
                      Color(0xffe5c100),
                      Color(0xffa39322),
                      ])
              ),

            ),
          ),
        ),
        body:
        Stack(

          children: <Widget>[

            GoogleMap(
              padding: new EdgeInsets.all(3.0),
              onMapCreated: _onMapCreated,

              initialCameraPosition: CameraPosition(
                target: _center,
                zoom: 6.0,
              ),
              mapType: _currentMapType,
              markers: _markers,
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              onCameraMove: _onCameraMove,
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Align(
                alignment: Alignment.topRight,
                child: Column(
                  children: <Widget>[
                    button(_onMapTypeButtonPressed, Icons.map),
                    SizedBox(
                      height: 18.0,
                      child: new Text('Vista Cidade',
                        style: new TextStyle(fontSize: 11.0,
                        ),
                      ),
                    ),
                    button(_onAddMarkerButtonPressed, Icons.add_location),
                    SizedBox(
                      height: 18.0,
                      child: new Text('Vagas livres',
                        style: new TextStyle(fontSize: 11.0,
                        ),
                      ),
                    ),
                    button(_onAddMarkerButtonPressedSem, Icons.location_off_rounded
                    ),
                    SizedBox(
                      height: 18.0,
                      child: new Text('Sem vagas',
                        style: new TextStyle(fontSize: 11.0,
                      ),
                      ),
                      ),
                    button(_currentLocation, Icons.location_searching),
                    SizedBox(
                      height: 18.0,
                      child: new Text('Minha localização',
                        style: new TextStyle(fontSize: 11.0,
                      ),
                      ),
                    ),

                  ],
                ),
              ),
            ),
          ],
        ),
        drawer: Drawer(
          child: ListView(
            padding: new EdgeInsets.all(0.0),
            children: <Widget>[
              DrawerHeader(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(colors: <Color>[
                        Colors.blue,
                        Colors.lightBlueAccent
                      ])
                  ),
                  child: Container(
                    child: Column(
                      children: <Widget>[
                        Material(
                          borderRadius: BorderRadius.all(Radius.circular(40.0)),
                          elevation: 10,
                          child: Padding(padding: EdgeInsets.all(8.0),
                            child: Image.asset('images/a.png',width: 80,height: 80,),
                          ),
                        ),
                        Padding(padding: EdgeInsets.all(2.0), child: Text ('Viewist', style: TextStyle(color: Colors.white, fontSize: 30.0,),
                        )
                        )],
                    ),
                  )),
              CustomListTile(Icons.person, 'Profile', ()=>{}),
              CustomListTile(Icons.notifications, 'Notification', ()=>{}),
              CustomListTile(Icons.settings, 'Settings', ()=>{}),
              CustomListTile(Icons.lock, 'Log Out', ()=>{}),
            ],
          ),
        ),

      ),

    );
  }
}

class CustomListTile extends StatelessWidget {
  IconData icon;
  String text;
  Function onTap;

  CustomListTile(this.icon,this.text,this.onTap);

  @override
  Widget build(BuildContext context) {
    // TODO: implement createState
    return Padding(
      padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
      child: Container(
        decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.grey.shade400))
        ),
        child: InkWell(
          splashColor: Colors.lightBlueAccent,
          onTap: onTap,
          child: Container(
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Icon(icon),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(text, style: TextStyle(
                          fontSize: 16.0
                      ),),
                    ),
                  ],
                ),
                Icon(Icons.arrow_right)
              ],
            ),
          ),
        ),
      ),
    );

  }


}