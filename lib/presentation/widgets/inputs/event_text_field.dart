import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EventTextField extends StatefulWidget {
  final String textHint;
  final double height;
  final bool expand;
  final TextInputType textInputType;
  final List<TextInputFormatter> inputFormatter;
  final Function onChanged;
  final int maxChars;

  EventTextField({
    @required this.textHint,
    this.maxChars,
    this.onChanged,
    this.height = 48.0,
    this.expand = false,
    this.textInputType = TextInputType.text,
    this.inputFormatter = const [],
  });

  @override
  _EventTextFieldState createState() => _EventTextFieldState();
}

class _EventTextFieldState extends State<EventTextField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      margin: EdgeInsets.only(bottom: 24.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextField(
        maxLines: widget.expand ? 6 : 1,
        onChanged: widget.onChanged,
        keyboardType: widget.textInputType,
        inputFormatters: widget.inputFormatter,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(12.0),
          border: InputBorder.none,
          hintText: widget.textHint,
        ),
      ),
    );
  }
}
