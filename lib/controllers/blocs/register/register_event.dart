import 'package:get_it/get_it.dart';
import 'package:hopaut/services/authentication_service.dart';

import '../base_event.dart';

abstract class RegisterEvent extends BaseEvent {
  AuthenticationService authService = GetIt.I.get<AuthenticationService>();
}

