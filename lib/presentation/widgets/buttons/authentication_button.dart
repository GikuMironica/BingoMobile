import 'package:flutter/material.dart';
import 'gradient_box_decoration.dart';

/// Authentication Button
///
/// Returns a [StreamBuilder<bool>] for Registration Page, Login Page
/// and Forgot Password Page
StreamBuilder<bool> authentication_button({
  bloc,
  Function onPressedSuccess,
  Function onPressedError,
  String label,
}) {
  return StreamBuilder<bool>(
    stream: bloc.dataValid,
    builder: (ctx, snapshot) => Container(
        width: 200,
        height: 50.0,
        decoration: gradientBoxDecoration(),
        child: MaterialButton(
            onPressed: snapshot.hasData ? onPressedSuccess : onPressedError,
            elevation: 100,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(80),
            ),
            padding: EdgeInsets.all(0),
            child: Ink(
              child: Container(
                alignment: Alignment.center,
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
              ),
            ))),
  );
}
