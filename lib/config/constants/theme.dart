import 'dart:ui';
import 'package:flutter/material.dart';

class HATheme {
  static const Color HOPAUT_ORANGE = Color(0xFFFFBE6A);
  static const Color HOPAUT_PINK = Color(0xFFED2F65);


  static const Icon BACK_BUTTON_IOS = Icon(Icons.arrow_back_ios, color: Colors.white,);

  static const LinearGradient HOPAUT_GRADIENT = LinearGradient(
    colors: [
      HOPAUT_ORANGE,
      HOPAUT_PINK,
    ],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );
}