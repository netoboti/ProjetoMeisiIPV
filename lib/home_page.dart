import 'package:ProjetoMeisiIPV/loc_screen.dart';
import 'package:ProjetoMeisiIPV/mapa.dart';
import 'package:ProjetoMeisiIPV/models/user_loc.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import 'utilities/user_loc_db.dart' as user_loc_db;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> itensMenu = ["Histórico","Localização Atual", "Mapa"];
  Position _currentPosition;
  // Storing Location
  final database = user_loc_db.openDB();

  void queryScores() async {
    final database = user_loc_db.openDB();
    var queryResult = await user_loc_db.locations(database);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) {
          return LocScreen(query: queryResult);
        },
      ),
    );
  }

  void mapa()  {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) {
          return Mapa();
        },
      ),
    );
  }

  _escolhaMenuItem(String escolha) {
    switch (escolha) {
      case "Histórico":
        queryScores();
        break;
      case "Mapa":
        mapa();
        break;
      case "Localização Atual":
       _getCurrentLocation();
    break;
    }
  }

  _deslogarUsuario() {}

  void storeLocation() {
    UserLocation location = UserLocation(
        id: 1,
        locDateTime: DateTime.now().toString(),
        userLat: _currentPosition.latitude,
        userLon: _currentPosition.longitude);
    user_loc_db.manipulateDatabase(location, database);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffe5c100),
        foregroundColor: Color(0xffffffff),
        title: Text("ParkingM IPV"),
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: _escolhaMenuItem,
            itemBuilder: (context) {
              return itensMenu.map((String item) {
                return PopupMenuItem<String>(
                  value: item,
                  child: Text(item),
                );
              }).toList();
            },
          )
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(

            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,

            children: <Widget>[
              if (_currentPosition != null)
                Text(
                    "LAT: ${_currentPosition.latitude}, LNG: ${_currentPosition.longitude}"),
              Padding(
                padding: EdgeInsets.only(bottom: 32),
                child: Image.asset(
                  "lib/imagens/logo.png",
                  width: 200,
                  height: 150,
                ),
              ),
              FlatButton(
                child: Text("Capturar a localização atual"),
                onPressed: () {
                  _getCurrentLocation();
                },
              ),
              FlatButton(
                child: Text("Mostrar a localização"),
                onPressed: () {
                  queryScores();
                },
              ),

            ],
          ),
        ),
      ),
    );
  }

  _getCurrentLocation() async {
    final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;

    await geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      setState(() {
        _currentPosition = position;

        storeLocation();
      });
    }).catchError((e) {
      print(e);
    });
  }
}
