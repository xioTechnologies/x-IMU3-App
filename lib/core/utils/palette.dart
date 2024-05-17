import 'package:flutter/material.dart';

class Palette {
  ///Selected tab icons, enabled state
  static const white = Color(0xFFE4E4E4);

  ///Unselected tab icons, disabled state, textfield placeholder
  static const unselected = Color(0xFF787878);

  ///Background color
  static const backgroundLight = Color(0xFF2D2D30);

  ///Background dark (e.g. connection tile)
  static const backgroundDark = Color(0xFF252526);

  ///Background darkest
  static const backgroundDarkest = Color(0xFF1E1E1E);

  ///Background lightest (e.g. action pane)
  static const backgroundLightest = Color(0xFF3E3E42);

  ///Record buttons
  static const red = Color(0xFFEF5350);

  static const darkButtonColor = Color(0xFF414144);

  ///Graph colors
  static const graphX = Color(0xFFDF3332);
  static const graphY = Color(0xFF72C228);
  static const graphZ = Color(0xFF43B9D4);

  static const graphChannel1 = Color(0xFFFFFF00);
  static const graphChannel2 = Color(0xFFFE6ABC);
  static const graphChannel3 = Color(0xFFD7FFD9);
  static const graphChannel4 = Color(0xFF8481FF);
  static const graphChannel5 = Color(0xFF02FFFF);
  static const graphChannel6 = Color(0xFF02C100);
  static const graphChannel7 = Color(0xFFFE0000);
  static const graphChannel8 = Color(0xFFFF8000);

  static const MaterialColor materialWhite = MaterialColor(
    0xFFE4E4E4,
    <int, Color>{
      50: white, // Lightest
      100: white,
      200: white,
      300: white,
      400: white,
      500: white, // Default (primary value)
      600: white,
      700: white,
      800: white,
      900: white, // Darkest
    },
  );
}
