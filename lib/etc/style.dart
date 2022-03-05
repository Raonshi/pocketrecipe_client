import 'package:flutter/material.dart';

AppBarTheme _appBarTheme = AppBarTheme(
  backgroundColor: Colors.white,
  elevation: 0,
  centerTitle: true,
  titleTextStyle: TextStyle(
    fontSize: 30,
    color: Colors.black,
    fontWeight: FontWeight.bold,
  ),
  iconTheme: IconThemeData(color: Colors.black, size: 30),
);

ThemeData mainTheme = ThemeData(
  focusColor: Colors.lightGreen,
  appBarTheme: _appBarTheme,
);

OutlineInputBorder outLineInputBorder = OutlineInputBorder(
  borderSide: BorderSide(color: Colors.lightGreen),
  borderRadius: BorderRadius.all(Radius.circular(20)),
);
