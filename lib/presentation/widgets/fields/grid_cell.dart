import 'package:flutter/material.dart';
import '../text/subtitle.dart';

Widget gridCell(
    {required String title, required String data, required IconData icon}) {
  final textColor = Colors.black87;
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Subtitle(label: title),
      SizedBox(
        height: 8,
      ),
      Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Icon(
            icon,
            size: 18,
            color: textColor,
          ),
          SizedBox(
            width: 8,
          ),
          Text(
            data,
            style: TextStyle(color: textColor),
          )
        ],
      )
    ],
  );
}
