import 'package:flutter/cupertino.dart';
import 'package:hopaut/config/injection.dart';
import 'package:hopaut/data/models/user.dart';
import 'package:hopaut/services/authentication_service.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class AccountProvider extends ChangeNotifier {
  AuthenticationService _authenticationService;

  AccountProvider() : _authenticationService = getIt<AuthenticationService>();

  User get currentIdentity => _authenticationService.user;
}
