import 'package:flutter/material.dart';

MaterialColor createMaterialColor(Color color) {
  // Returns a custom MaterialColor based on the color argument

  var strengths = <double>[.05];
  var swatch = <int, Color>{};
  final r = color.red, g = color.green, b = color.blue;

  for (var i = 1; i < 10; i++) {
    strengths.add(i * 0.1);
  }

  for (var strength in strengths) {
    // create the color shades from 50 to 900
    final ds = 0.5 - strength;
    swatch[(strength * 1000).round()] = Color.fromRGBO(
      r + ((ds < 0 ? r : (255 - r)) * ds).round(),
      g + ((ds < 0 ? g : (255 - g)) * ds).round(),
      b + ((ds < 0 ? b : (255 - b)) * ds).round(),
      1,
    );
  }

  return MaterialColor(color.value, swatch);
}
