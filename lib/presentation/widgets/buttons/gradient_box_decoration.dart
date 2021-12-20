import 'package:flutter/material.dart';

BoxDecoration gradientBoxDecoration() {
  return BoxDecoration(
    // borderRadius: BorderRadius.circular(20.0),
    borderRadius: BorderRadius.circular(4.0),
    gradient: RadialGradient(
      center: const Alignment(-0.6, -4), // near the top right
      radius: 3.5,
      colors: [
        const Color(0xFFffbe6a), // yellow sun
        const Color(0xFFed2f65), // blue sky
      ],
      stops: [0.3, 1.0],
    ),
    boxShadow: [
      BoxShadow(
        color: Colors.grey.withOpacity(0.4),
        offset: Offset(3, 7),
        blurRadius: 7,
      ),
    ],
  );
}
