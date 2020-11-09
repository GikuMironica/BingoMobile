import 'package:flutter/material.dart';
import 'package:hopaut/config/constants.dart';
import 'package:hopaut/config/routes/application.dart';

class SimpleAppBar extends AppBar {
  final String text;
  final bool centerText;
  final BuildContext context;

  SimpleAppBar(
      {@required this.text, this.centerText = false, @required this.context});

  @override
  Widget get flexibleSpace => Container(
        decoration: HATheme.GRADIENT_DECORATION,
      );

  @override
  Widget get title => Text(text);

  @override
  bool get centerTitle => centerText;

  @override
  Widget get leading => IconButton(
        icon: HATheme.backButton,
        onPressed: () => Application.router.pop(context),
      );
}
