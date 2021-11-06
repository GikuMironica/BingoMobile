import 'package:flutter/material.dart';

import 'gradient_box_decoration.dart';

Container BasicButton({String label, void Function() onPressed}) {
  return Container(
      width: 200,
      height: 50.0,
      decoration: gradientBoxDecoration(),
      child: MaterialButton(
          onPressed: onPressed,
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
          )));
}
