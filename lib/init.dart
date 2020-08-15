import 'package:hopaut/presentation/screens/home_page.dart';
import 'package:hopaut/presentation/screens/login/_login.dart';
import 'package:hopaut/services/auth_service/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';

import 'data/models/user.dart';

class Initialization extends StatefulWidget {
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
    _user = Provider.of<AuthService>(context).user;
    if(_user == null){
      return LoginPage();
    }else{

      return HomePage();
    }
  }
}
