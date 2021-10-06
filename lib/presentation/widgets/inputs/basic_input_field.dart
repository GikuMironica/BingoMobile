import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hopaut/presentation/widgets/fields/field_title.dart';

class BasicInputField extends StatefulWidget {
  final TextEditingController controller;
  final bool Function(String) isValid;
  final String validationMessage;
  final String initialValue;
  final void Function(String) onChanged;
  final int maxLength;
  final String title;
  final String hintText;

  BasicInputField(
      {this.controller,
      @required this.isValid,
      @required this.validationMessage,
      @required this.initialValue,
      @required this.onChanged,
      @required this.maxLength,
      this.title,
      this.hintText});

  @override
  _BasicInputFieldState createState() => _BasicInputFieldState();
}

class _BasicInputFieldState extends State<BasicInputField> {
  bool isStateValid = true;

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      widget.title != null ? FieldTitle(title: widget.title) : Container(),
      Stack(
        children: [
          Container(
              height: 48.0,
              margin: EdgeInsets.only(bottom: 5.0),
              decoration: BoxDecoration(
                border: Border.all(
                    color:
                        !isStateValid ? Colors.red[100] : Colors.transparent),
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              )),
          TextFormField(
            inputFormatters: [
              LengthLimitingTextInputFormatter(widget.maxLength),
            ],
            initialValue: widget.initialValue ?? "",
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (v) => isStateValid ? null : widget.validationMessage,
            onChanged: (v) {
              setState(() {
                isStateValid = widget.isValid(v);
                widget.onChanged(v);
              });
            },
            maxLines: 1,
            maxLengthEnforced: true,
            maxLength: widget.maxLength,
            decoration: InputDecoration(
              hintText: widget.hintText,
              counterText: "",
              isDense: true,
              errorMaxLines: 3,
              contentPadding: EdgeInsets.all(12.0),
              border: InputBorder.none,
            ),
          ),
        ],
      )
    ]);
  }
}
