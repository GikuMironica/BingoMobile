import 'package:flutter/material.dart';
import 'package:hopaut/presentation/widgets/text/subtitle.dart';

class FieldTitle extends StatelessWidget {
  final String title;

  FieldTitle({@required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(8.0), child: Subtitle(label: title));
  }
}
