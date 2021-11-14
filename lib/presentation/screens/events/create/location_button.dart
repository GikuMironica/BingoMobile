import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hopaut/config/constants/theme.dart';
import 'package:hopaut/config/routes/application.dart';
import 'package:hopaut/config/routes/routes.dart';
import 'package:hopaut/data/models/post.dart';

class LocationButton extends StatelessWidget {
  final Post post;

  LocationButton({this.post});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Application.router.navigateTo(context, Routes.searchByMap,
          replace: false, transition: TransitionType.fadeIn),
      child: Card(
        color: Colors.transparent,
        elevation: HATheme.WIDGET_ELEVATION,
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(12.0),
          height: 48,
          decoration: BoxDecoration(
            color: HATheme.BASIC_INPUT_COLOR,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(post.location?.entityName ?? post.location?.address ?? ''),
        ),
      ),
    );
  }
}
