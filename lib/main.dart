import 'package:flutter/material.dart';
import 'marcadores.dart';
import 'home_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ParkingM IPV',
      home: MapsDemo(),
    );
  }
}
