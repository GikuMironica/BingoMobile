import 'package:flutter/material.dart';
import 'package:hopaut/config/constants.dart';
import 'package:hopaut/config/routes/application.dart';

class SimpleAppBar extends AppBar {
  final String text;
  final bool centerText;
  final BuildContext context;
  final List<Widget>? actionButtons;

  SimpleAppBar(
      {required this.text,
      this.centerText = false,
      required this.context,
      this.actionButtons});

  @override
  Widget get flexibleSpace => Container(
        decoration: HATheme.GRADIENT_DECORATION,
      );

  @override
  Widget get title =>
      Text(text, style: TextStyle(fontSize: HATheme.PAGE_TITLE_SIZE));

  @override
  bool get centerTitle => centerText;

  @override
  Widget get leading => IconButton(
        icon: HATheme.backButton,
        onPressed: () => Application.router.pop(context),
      );

  @override
  List<Widget>? get actions => actionButtons;
}
