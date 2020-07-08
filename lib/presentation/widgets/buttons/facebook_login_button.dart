import 'package:flutter/material.dart';
import 'stretchable_button.dart';

class FacebookButton extends StatelessWidget {
  final String text;
  final TextStyle textStyle;
  final VoidCallback onPressed;
  final double borderRadius;
  final Color splashColor;

  /// Creates a new button. The default button text is 'Continue with Facebook',
  /// which apparently results in higher conversion. 'Login with Facebook' is
  /// another suggestion.
  FacebookButton({
    this.onPressed,
    this.borderRadius = defaultBorderRadius,
    this.text = 'Facebook',
    this.textStyle,
    this.splashColor,
    Key key,
  })  : assert(text != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return StretchableButton(
      buttonColor: Color(0xFF1877F2),
      borderRadius: borderRadius,
      splashColor: splashColor,
      onPressed: onPressed,
      buttonPadding: 8.0,
      children: <Widget>[
        // Facebook doesn't provide strict sizes, so this is a good
        // estimate of their examples within documentation.
        SizedBox(width: 5,),
        Image(
          image: AssetImage(
            "assets/facebook/f_logo_RGB-White_100.png",
          ),
          height: 24.0,
          width: 24.0,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 14.0, right: 10.0),
          child: Text(
            text,
            style: textStyle ?? TextStyle(
              // default to the application font-style
              fontSize: 20.0,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}