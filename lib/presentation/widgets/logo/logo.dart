import 'package:flutter/material.dart';

class HopautLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 50, 0 ,0),
      height: MediaQuery.of(context).size.height / 7,
      decoration: const BoxDecoration(
          image: DecorationImage(
        image: AssetImage('assets/logo/icon_tr.png'),
      )),
    );
  }
}
