import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hopaut/config/routes/application.dart';
import 'package:hopaut/presentation/screens/home_page.dart';
import 'package:hopaut/services/authentication_service.dart';
import 'package:provider/provider.dart';

import 'data/models/user.dart';

class Initialization extends StatefulWidget {
  final String route;

  Initialization({this.route});

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
          Duration(milliseconds: 500),
          () => Application.router.navigateTo(context, '/login',
              replace: true,
              transition: TransitionType.fadeIn,
              transitionDuration: Duration(milliseconds: 500)));
    } else {
      widget.route == null
          ? Future.delayed(
              Duration(milliseconds: 500),
              () => Application.router.navigateTo(context, '/home',
                  replace: true,
                  transition: TransitionType.fadeIn,
                  transitionDuration: Duration(milliseconds: 0)))
          : HomePage(route: widget.route);
    }

    return Stack(children: [
      Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Colors.white,
        child: Center(
          child: Image.asset(
            'assets/logo/logo_no_bg.png',
            fit: BoxFit.contain,
            width: MediaQuery.of(context).size.width * 0.7,
          ),
        ),
      ),
      Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.2),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: CupertinoActivityIndicator(),
        ),
      )
    ]);
  }
}
