import 'package:flutter/material.dart';

class HopAutBackgroundContainer extends StatelessWidget {
  final Widget child;
  final double height;

  HopAutBackgroundContainer({
    this.child,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: decorationGradient(),
      child: child ?? null,
      height: height ?? 200,
    );
  }
}

BoxDecoration decorationGradient() {
  return BoxDecoration(
      gradient: LinearGradient(colors: [
        const Color(0xFFff9e6f), // yellow sun
        const Color(0xFFf2326d), // blue sky
      ], begin: Alignment.centerLeft, end: Alignment.centerRight));
}