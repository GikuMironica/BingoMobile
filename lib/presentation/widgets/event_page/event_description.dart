import 'package:flutter/material.dart';
import '../text/subtitle.dart';

class EventDescription extends StatelessWidget {
  final String text;

  EventDescription(this.text);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Subtitle(label: 'Description'),
        SizedBox(
          height: 8,
        ),
        Text(
          text,
          style: TextStyle(
            fontSize: 14,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}
