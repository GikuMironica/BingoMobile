import 'package:flutter/material.dart';
import 'package:hopaut/presentation/widgets/hopaut_background.dart';

class HopAutAppBar extends StatelessWidget {
  final List<Widget> actions;
  final String title;
  final Widget bottom;

  HopAutAppBar({this.title, this.actions, this.bottom});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: Colors.transparent,
      expandedHeight: 120.0,
        floating: true,
      pinned: true,
      bottom: bottom,
      snap: true,
      elevation: 0.0,
      actions: actions,
      flexibleSpace: Stack(
        children: <Widget>[
          Positioned.fill(child: HopAutBackgroundContainer()),
          FlexibleSpaceBar(
            title: Text(title),
            centerTitle: true,
          )
        ],
      )
    );
  }
}
