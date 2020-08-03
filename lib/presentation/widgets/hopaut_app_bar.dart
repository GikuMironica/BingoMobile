import 'package:flutter/material.dart';
import 'package:hopaut/presentation/widgets/hopaut_background.dart';

class HopAutAppBar extends StatelessWidget {
  final List<Widget> actions;
  final String title;

  HopAutAppBar({this.title, this.actions});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 120.0,
      floating: true,
      pinned: true,
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
