import 'package:flutter/material.dart';
import 'package:uber/telas/Home.dart';
import 'Rotas.dart';

final ThemeData temaPadrao = ThemeData(
    primaryColor: Color(0xff37474f),
    accentColor: Color(0xff546e7a),
    appBarTheme: AppBarTheme(
        backgroundColor: Color(0xffe5c100),
        foregroundColor: Color(0xffffffff)
                            )
);

void main() => runApp(MaterialApp(
  title: "Uber",
  home: Home(),
  theme: temaPadrao,
  initialRoute: "/",
  onGenerateRoute: Rotas.gerarRotas,
  debugShowCheckedModeBanner: false,
));
