import 'package:flutter/material.dart';
import 'package:hopaut/config/constants/theme.dart';

void showSnackBar(BuildContext context, String message) {
  Scaffold.of(context).showSnackBar(
      SnackBar(
          content:
          Text(
            message,
            textAlign: TextAlign.center,
          ),
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 2),
          backgroundColor: HATheme.HOPAUT_PINK
      )
  );
}