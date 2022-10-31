import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hopaut/config/constants/theme.dart';
import 'package:hopaut/presentation/widgets/fields/field_title.dart';

class EventTextField extends StatefulWidget {
  final String title;
  final String? textHint;
  final double height;
  final bool expand;
  final TextInputType textInputType;
  final List<TextInputFormatter> inputFormatter;
  final Function(String)? onChanged;
  final int? maxChars;
  final FormFieldSetter<String>? onSaved;
  final String? initialValue;

  EventTextField(
      {required this.title,
      this.textHint,
      this.maxChars,
      this.onChanged,
      this.height = 48.0,
      this.expand = false,
      this.textInputType = TextInputType.text,
      this.inputFormatter = const [],
      this.onSaved,
      this.initialValue});

  @override
  _EventTextFieldState createState() => _EventTextFieldState();
}

class _EventTextFieldState extends State<EventTextField> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        widget.title != null ? FieldTitle(title: widget.title) : Container(),
        Card(
          elevation: HATheme.WIDGET_ELEVATION,
          color: Colors.transparent,
          child: Container(
            height: widget.height,
            decoration: BoxDecoration(
              color: HATheme.BASIC_INPUT_COLOR,
              borderRadius: BorderRadius.circular(8),
            ),
            child: TextFormField(
              initialValue: widget.initialValue,
              maxLines: widget.expand ? 6 : 1,
              onChanged: widget.onChanged,
              onSaved: widget.onSaved,
              keyboardType: widget.textInputType,
              inputFormatters: widget.inputFormatter,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(12.0),
                border: InputBorder.none,
                hintText: widget.textHint,
              ),
            ),
          ),
        )
      ],
    );
  }
}
