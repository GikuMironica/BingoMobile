import 'package:hopaut/services/authentication_service.dart';
import 'package:get_it/get_it.dart';
import 'package:hopaut/controllers/blocs/login/login_page_status.dart';
import 'package:hopaut/data/domain/login_result.dart';

import '../base_event.dart';
import '../base_state.dart';
import 'login_state.dart';

abstract class LoginEvent extends BaseEvent {
  AuthenticationService authService = GetIt.I.get<AuthenticationService>();
}

// Event 1
class LoginUsernameChanged extends LoginEvent {
  final String username;

  LoginUsernameChanged({this.username});

  @override
  Stream<LoginState> handleEvent(BaseState state) async* {
    // Dart style down-casting...
    LoginState loginState = state;
    yield loginState.copyWith(username: username);
  }
}

// Event 2
class LoginPasswordChanged extends LoginEvent {
  final String password;

  LoginPasswordChanged({this.password});

  @override
  Stream<LoginState> handleEvent(BaseState state) async* {
    LoginState loginState = state;
    yield loginState.copyWith(password: password);
  }
}

// Event 3
class ShowPasswordClicked extends LoginEvent {
  final bool obscureText;

  ShowPasswordClicked({this.obscureText});

  @override
  Stream<LoginState> handleEvent(BaseState state) async* {
    LoginState loginState = state;
    yield loginState.copyWith(obscureText: !obscureText);
  }
}

// Event 4
class LoginClicked extends LoginEvent {
  @override
  Stream<LoginState> handleEvent(BaseState state) async* {
    LoginState loginState = state;
    AuthResult result;
    yield loginState.copyWith(formStatus: LoginSubmitted());
    try {
      result = await authService.loginWithEmail(
          loginState.username.trim(), loginState.password.trim());
      yield result.isSuccessful
          ? loginState.copyWith(formStatus: SubmissionSuccess())
          // TODO- Translation
          : loginState.copyWith(
              formStatus: SubmissionFailed(result.data["Error"]));
    } catch (e) {
      // TODO - translations
      yield loginState.copyWith(formStatus: SubmissionFailed("Internal error"));
    }
  }
}

// Event 5
class FacebookLoginClicked extends LoginEvent {
  @override
  Stream<LoginState> handleEvent(BaseState state) async* {
    LoginState loginState = state;
    yield loginState.copyWith(formStatus: LoginSubmitted());
    try {
      bool result = await authService.loginWithFb();
      yield result
          ? loginState.copyWith(formStatus: SubmissionSuccess())
          // TODO - Translations
          : loginState.copyWith(
              formStatus: SubmissionFailed("Error, something went wrong"));
    } catch (e) {
      yield loginState.copyWith(formStatus: SubmissionFailed(e));
    }
  }
}

// Event 6
class ForgotPasswordLabelClicked extends LoginEvent {
  @override
  Stream<LoginState> handleEvent(BaseState state) async* {
    throw UnimplementedError();
  }
}

// Event 7
class SignUpLabelClicked extends LoginEvent {
  @override
  Stream<LoginState> handleEvent(BaseState state) async* {
    throw UnimplementedError();
  }
}
