import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';

class HATheme {
  static const Color HOPAUT_ORANGE = Color(0xFFFFBE6A);
  static const Color HOPAUT_PINK = Color(0xFFED2F65);
  static const Color HOPAUT_SECONDARY = Color(0xFF21CB8C);
  static const Color HOPAUT_GREEN = Color(0xFF0f8063);
  static const Color HOPAUT_GREY = Color(0xFFc3bfbf);

  static Icon backButton =
      Platform.isIOS ? Icon(Icons.arrow_back_ios) : Icon(Icons.arrow_back);

  static const double PAGE_TITLE_SIZE = 18;

  static ThemeData themeData = ThemeData(
    primaryColor: HOPAUT_PINK,
    fontFamily: 'Poppins',
    primarySwatch: Colors.pink,
    accentColor: HOPAUT_PINK,
    accentColorBrightness: Brightness.light,
  );

  static const LinearGradient HOPAUT_GRADIENT = LinearGradient(
    colors: [
      HOPAUT_ORANGE,
      HOPAUT_PINK,
    ],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const LinearGradient APP_GRADIENT = LinearGradient(colors: [
    const Color(0xFFff9e6f), // yellow sun
    const Color(0xFFf2326d), // blue sky
  ], begin: Alignment.centerLeft, end: Alignment.centerRight);

  static const BoxDecoration GRADIENT_DECORATION =
      BoxDecoration(gradient: APP_GRADIENT);

  static Color BASIC_INPUT_COLOR = Colors.grey[100];
  static const double WIDGET_ELEVATION = 5;

  static TextStyle FIELD_HINT_STYLE = TextStyle(
    color: const Color(0xFF818181).withOpacity(0.69),
    fontSize: 14.0,
    fontWeight: FontWeight.w400,
  );

  static TextStyle LABEL_HEADER_STYLE =
      TextStyle(fontSize: 20, fontWeight: FontWeight.w500);
}
