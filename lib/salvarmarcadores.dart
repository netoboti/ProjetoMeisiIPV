import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class StoreMap extends StatefulWidget {
  StoreMap({
    Key key,
    @required this.documents,
    @required this.initialPosition,
  }) : super(key: key);

  final List<DocumentSnapshot> documents;
  final LatLng initialPosition;
  static final CameraPosition _initialPosition = CameraPosition(
    target: LatLng(45.791789, 24.150390),
    zoom: 16,
  );


  @override
  _StoreMapState createState() => _StoreMapState();
}

class _StoreMapState extends State<StoreMap> {
  final Completer<GoogleMapController> _controller = Completer();


  List<Marker> markers = [];
  Future<List<Marker>> _createMarkersForLotsAndParkings() async{
    List<Marker> markersList = [];
    int markerId = 0;
    for (DocumentSnapshot document in widget.documents){
      // ignore: deprecated_member_use
      String documentId = document.documentID;
      DocumentReference parkingDocReference =
      // ignore: deprecated_member_use
      Firestore.instance.collection("Parkings").document(documentId);
      DocumentSnapshot parkingDocRef = await parkingDocReference.get();
      markersList.add(Marker(
          markerId: MarkerId(markerId.toString()),
          position: LatLng(parkingDocRef.get('location').latitude,
              parkingDocRef.get('location').longitude),
          onTap: () => _changeMap(LatLng(
              parkingDocRef.get('location').latitude,
              parkingDocRef.get('location').longitude)),
          infoWindow: InfoWindow(
              title: document.get('name'),
              snippet: document.get('numberOfLots')),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow)),
      );
      markerId++;
      QuerySnapshot subDocuments = await parkingDocReference.collection("lots").get();
      // ignore: deprecated_member_use
      // ignore: deprecated_member_use
      List<DocumentSnapshot> subDocumentsSnapshots = subDocuments.documents;
      for (DocumentSnapshot subDoc in subDocumentsSnapshots){
        // ignore: deprecated_member_use
        String subDocId = subDoc.documentID;
        DocumentSnapshot snapshot = await parkingDocReference.collection("lots")
        // ignore: deprecated_member_use
            .document(subDocId).get();
        print(snapshot.get('location').latitude);

        markersList.add(
          Marker(
              markerId:MarkerId(markerId.toString()),
              position: LatLng(snapshot.get('location').latitude,
                  snapshot.get('location').longitude),
              onTap: () => _changeMap(LatLng(
                  snapshot.get('location').latitude,
                  snapshot.get('location').longitude)),
              infoWindow: InfoWindow(
                  title: document.get('name'),
                  snippet: document.get('numberOfLots')),
              icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet)),
        );
        markerId++;

      }

    }
    return Future.value(markersList);

  }

  @override
  void initState() {
    super.initState();
    _createMarkersForLotsAndParkings().then((List<Marker> lotsMarkers){
      setState((){
        markers = lotsMarkers;
      });

    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        zoomGesturesEnabled: true,
        mapType: MapType.hybrid,
        initialCameraPosition: StoreMap._initialPosition,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        myLocationEnabled: true,
        markers: markers.toSet(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _currentLocation,
        child: Icon(Icons.location_searching),
        backgroundColor: Colors.deepPurple[400],
      ),
    );
  }

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

  _changeMap(LatLng position) async {
    final GoogleMapController controller = await _controller.future;

    controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        bearing: 0,
        target: LatLng(position.latitude, position.longitude),
        zoom: 19.4,
      ),
    ));
  }
}
