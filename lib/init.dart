import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hopaut/config/routes/application.dart';
import 'package:hopaut/services/authentication_service.dart';
import 'package:provider/provider.dart';
import 'data/models/user.dart';
import 'package:firebase_core/firebase_core.dart';

class Initialization extends StatefulWidget {
  Initialization();

  @override
  _InitializationState createState() => _InitializationState();
}

class _InitializationState extends State<Initialization> {
  User _user;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _user = Provider.of<AuthenticationService>(context).user;
    if (_user == null) {
      Future.delayed(
          Duration(milliseconds: 1),
          () => Application.router.navigateTo(context, '/login',
              replace: true,
              transition: TransitionType.fadeIn,
              transitionDuration: Duration(milliseconds: 200)));
    } else {
      Future.delayed(
          Duration(milliseconds: 1),
          () => Application.router.navigateTo(context, '/home',
              replace: true,
              transition: TransitionType.fadeIn,
              transitionDuration: Duration(milliseconds: 200)));
    }
    return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Colors.white,
        child: Container());
  }
}
