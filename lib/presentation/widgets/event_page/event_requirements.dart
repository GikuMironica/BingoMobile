import 'package:flutter/material.dart';
import '../text/subtitle.dart';

class EventRequirements extends StatelessWidget {
  final String text;

  EventRequirements(this.text);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Subtitle(label: 'Requirements'),
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
