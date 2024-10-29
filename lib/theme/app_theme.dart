import 'package:flutter/material.dart';

class AppTheme {
  Color selectedColor;

  AppTheme({this.selectedColor = const Color(0xFFFF0000)});

  ThemeData getTheme() =>
      ThemeData(useMaterial3: true, colorSchemeSeed: selectedColor, appBarTheme: const AppBarTheme(
        centerTitle: false,
      ));
}


