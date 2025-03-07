import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

String fontFamily = "Mulish";
Color lightColor = CupertinoColors.black;
Color darkColor = CupertinoColors.white;
Color darkBackground = const Color(0xFF1A1B1E);
Color lightBackground = const Color(0xFFf2f2f7);
final ThemeData lightTheme = ThemeData(
  iconTheme: IconThemeData(color: Colors.black),
  fontFamily: fontFamily,
  brightness: Brightness.light,
  primaryColor: Colors.black,
  colorScheme: ColorScheme.light().copyWith(
    primary: Colors.black,
    secondary: const Color.fromARGB(255, 114, 114, 114),
    primaryContainer: lightBackground,
    secondaryContainer: Colors.grey[700],
  ),
  // Define additional light theme properties here
);
final ThemeData darkTheme = ThemeData(
  iconTheme: IconThemeData(color: Colors.white),
  fontFamily: fontFamily,
  brightness: Brightness.dark,
  primaryColor: Colors.white,
  textTheme: TextTheme(),
  colorScheme: ColorScheme.dark().copyWith(
    primary: Colors.white,
    secondary: const Color.fromARGB(255, 114, 114, 114),
    primaryContainer: darkBackground,
    secondaryContainer: Colors.grey[700],
  ),
  // Define additional dark theme properties here
);
