import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

String fontFamily = "Mulish";
Color lightColor = CupertinoColors.black;
Color darkColor = CupertinoColors.white;

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: Colors.blue,
  // Define additional light theme properties here
);
final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: Colors.grey[900],
  colorScheme: ColorScheme.dark().copyWith(
    primary: Colors.grey[900],
    secondary: Colors.grey[800],
    primaryContainer: const Color.fromARGB(255, 204, 154, 255),
    secondaryContainer: Colors.grey[700],
  ),
  // Define additional dark theme properties here
);
