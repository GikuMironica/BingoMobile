import 'package:hopaut/controllers/blocs/base_event.dart';
import 'package:hopaut/controllers/blocs/base_state.dart';
import 'package:hopaut/controllers/blocs/login/login_state.dart';
import 'package:hopaut/services/auth_service/auth_service.dart';
import 'package:get_it/get_it.dart';

abstract class LoginEvent extends BaseEvent{

  AuthService authService = GetIt.I.get<AuthService>();
}

// Event 1
class LoginUsernameChanged extends LoginEvent {
  final String username;

  LoginUsernameChanged({this.username});

  @override
  LoginState handleEvent(BaseState state) {
    // Dart style down-casting...
    LoginState loginState = state;
    return loginState.copyWith(username: username);
  }
}

// Event 2
class LoginPasswordChanged extends BaseEvent {
  final String password;

  LoginPasswordChanged({this.password});

  @override
  LoginState handleEvent(BaseState state) {
    throw UnimplementedError();
  }
}

// Event 3
class LoginBtnClicked extends BaseEvent {
  @override
  LoginState handleEvent(BaseState state) {
    throw UnimplementedError();
  }
}

// Event 4
class FacebookLoginBtnClicked extends BaseEvent {
  @override
  LoginState handleEvent(BaseState state) {
    throw UnimplementedError();
  }
}

// Event 5
class ForgotPasswordLabelClicked extends BaseEvent {
  @override
  LoginState handleEvent(BaseState state) {
    throw UnimplementedError();
  }
}

// Event 6
class SignUpLabelClicked extends BaseEvent {
  @override
  LoginState handleEvent(BaseState state) {
    throw UnimplementedError();
  }
}