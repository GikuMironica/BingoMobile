import 'package:flutter/material.dart';
import 'gradient_box_decoration.dart';

Widget persistButton({
  required String label,
  required BuildContext context,
  required bool isStateValid,
  required void Function() onPressed,
}) {
  return Card(
    elevation: 5,
    child: Container(
        width: MediaQuery.of(context).size.width,
        height: 50.0,
        decoration: gradientBoxDecoration(),
        child: MaterialButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          onPressed: onPressed,
          child: Text(label,
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
              )),
        )),
  );
}
