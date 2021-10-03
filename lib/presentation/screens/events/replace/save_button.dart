import 'package:flutter/material.dart';

class SaveButton extends StatelessWidget {
  final Function onPressed;

  SaveButton({this.onPressed});

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onPressed,
      child: Ink(child: Container(child: Text('Save'))),
    );
  }
}
