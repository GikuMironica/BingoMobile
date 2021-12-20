import 'package:flutter/material.dart';
import '../text/subtitle.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:hopaut/generated/locale_keys.g.dart';

class EventRequirements extends StatelessWidget {
  final String text;

  EventRequirements(this.text);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Subtitle(label: LocaleKeys.Event_labels_requirements.tr()),
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
