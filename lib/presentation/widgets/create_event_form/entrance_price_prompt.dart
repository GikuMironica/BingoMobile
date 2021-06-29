import 'package:flutter/material.dart';
import 'package:hopaut/controllers/event/create_event.dart';
import 'package:provider/provider.dart';

class EntrancePricePrompt extends StatefulWidget {
  @override
  _EntrancePricePromptState createState() => _EntrancePricePromptState();
}

class _EntrancePricePromptState extends State<EntrancePricePrompt> {
  @override
  Widget build(BuildContext context) => Consumer<CreateEventController>(
    builder: (_, controller, __) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

      ],
    ),
  );
}
