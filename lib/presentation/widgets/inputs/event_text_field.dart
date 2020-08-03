import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EventTextField extends StatelessWidget {
  final String textHint;
  final double height;
  final Function onSaved;
  final Function validator;
  final bool expand;
  final TextInputType textInputType;
  final List<TextInputFormatter> inputFormatter;
  final Function onChanged;

  EventTextField({
    @required this.textHint,
    @required this.onSaved,
    @required this.validator,
    this.onChanged,
    this.height = 48.0,
    this.expand = false,
    this.textInputType = TextInputType.text,
    this.inputFormatter = const [],
  });


  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      margin: EdgeInsets.only(bottom: 24.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextFormField(
        onChanged: onChanged,
        onSaved: onSaved,
        validator: validator,
        maxLines: expand ? null : 3,
        keyboardType: textInputType,
        inputFormatters: inputFormatter,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(16.0),
          border: InputBorder.none,
          hintText: textHint,
        ),
      ),
    );
  }
}
