import 'package:flutter/material.dart';
import 'package:notes_app/utils/colors.dart';

class MyThemes {
  static final darkTheme = ThemeData(
      // textTheme: GoogleFonts.rubikTextTheme(Theme.of(context).textTheme),
      // primarySwatch: white,
      primaryColor: Colors.white,
      iconTheme: const IconThemeData(color: white),
      scaffoldBackgroundColor: bgColor,
      colorScheme: const ColorScheme.dark());
  static final lightTheme = ThemeData(
      scaffoldBackgroundColor: white, colorScheme: const ColorScheme.light());
}
