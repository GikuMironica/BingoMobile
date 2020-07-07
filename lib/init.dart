import 'package:hopaut/data/repositories/user_repository.dart';
import 'package:hopaut/presentation/screens/account/account.dart';
import 'package:hopaut/presentation/screens/login/login.dart';
import 'package:hopaut/services/auth_service/auth_service.dart';
import 'package:hopaut/services/secure_service/secure_service.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

import 'data/models/user.dart';

class Initialization extends StatefulWidget {
  @override
  _InitializationState createState() => _InitializationState();
}

class _InitializationState extends State<Initialization> {
  User user;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<AuthService>(context).user;
    if (user == null){
      return LoginPage();
    }else{
      return Account();
    }
  }
}
