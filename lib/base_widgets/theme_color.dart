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

class ColorUtil {
  static Color darkenColor(Color c, [double percent = 0.1]) {
    // Returns a darker shade of the color argument by a given percent

    assert(0 <= percent && percent <= 1);
    var f = 1 - percent;
    return Color.fromARGB(
      c.alpha,
      (c.red * f).round(),
      (c.green * f).round(),
      (c.blue * f).round(),
    );
  }

  static Color lightenColor(Color c, [double percent = 0.1]) {
    // Returns a lighter shade of the color argument by a given percent

    assert(0 <= percent && percent <= 1);
    var p = percent;
    return Color.fromARGB(
      c.alpha,
      c.red + ((255 - c.red) * p).round(),
      c.green + ((255 - c.green) * p).round(),
      c.blue + ((255 - c.blue) * p).round(),
    );
  }
}
