import 'package:flutter/material.dart';
import 'package:hopaut/providers/event_provider.dart';
import 'package:provider/provider.dart';

class EntrancePricePrompt extends StatefulWidget {
  @override
  _EntrancePricePromptState createState() => _EntrancePricePromptState();
}

class _EntrancePricePromptState extends State<EntrancePricePrompt> {
  @override
  Widget build(BuildContext context) => Consumer<EventProvider>(
        builder: (_, controller, __) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [],
        ),
      );
}
