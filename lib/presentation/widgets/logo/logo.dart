import 'package:flutter/material.dart';

class HopautLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 5,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/logo/icon_tr.png'),
        )
      ),
    );
  }
}
