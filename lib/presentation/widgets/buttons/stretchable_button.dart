import 'package:flutter/material.dart';

const double defaultBorderRadius = 4;

class StretchableButton extends StatelessWidget {
  final VoidCallback onPressed;
  final double borderRadius;
  final double buttonPadding;
  final Color buttonColor, splashColor;
  final Color buttonBorderColor;
  final List<Widget> children;

  StretchableButton({
    @required this.buttonColor,
    @required this.borderRadius,
    @required this.children,
    this.splashColor,
    this.buttonBorderColor,
    this.onPressed,
    this.buttonPadding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(buttonPadding),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: ButtonTheme(
        minWidth: 200,
        height: 50.0,
        child: RaisedButton(
          elevation: 10,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          onPressed: onPressed,
          color: buttonColor,
          splashColor: splashColor,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: this.children,
          ),
        ),
      ),
    );
  }
}
