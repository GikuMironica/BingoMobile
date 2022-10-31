import 'package:flutter/material.dart';
import 'package:hopaut/config/constants/theme.dart';
import 'package:hopaut/presentation/widgets/hopaut_background.dart';

class HopAutAppBar extends StatelessWidget {
  final List<Widget> actions;
  final String title;
  final Widget bottom;

  HopAutAppBar(
      {required this.title, required this.actions, required this.bottom});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
        backgroundColor: Colors.transparent,
        expandedHeight: 120.0,
        floating: true,
        pinned: true,
        bottom: bottom as PreferredSizeWidget,
        snap: true,
        elevation: 0.0,
        actions: actions,
        flexibleSpace: Stack(
          children: <Widget>[
            Positioned.fill(child: HopAutBackgroundContainer()),
            FlexibleSpaceBar(
              title: Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: HATheme.PAGE_TITLE_SIZE),
              ),
              centerTitle: true,
            )
          ],
        ));
  }
}
