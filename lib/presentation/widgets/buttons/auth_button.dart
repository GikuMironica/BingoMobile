import 'package:flutter/material.dart';
import 'gradient_box_decoration.dart';
import 'package:hopaut/config/routes/application.dart';
import 'package:fluro/fluro.dart';


Widget authButton({
  @required String label,
  @required BuildContext context,
  @required bool isStateValid,
  @required void Function() onPressed,
}) {
    return Container(
        width: MediaQuery.of(context).size.width,
        height: 50.0,
        decoration: gradientBoxDecoration(),
        child: MaterialButton(
          elevation: 100,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          onPressed: onPressed,
          // TODO - Translation
          child: Text(
            label,
            style: TextStyle(
              fontSize: 20,
              color: Colors.white,
            )
          ),
        )
    );
}

