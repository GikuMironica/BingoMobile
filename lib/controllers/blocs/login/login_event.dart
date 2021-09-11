import 'package:hopaut/controllers/blocs/base_event.dart';
import 'package:hopaut/controllers/blocs/base_state.dart';
import 'package:hopaut/controllers/blocs/login/login_state.dart';
import 'package:hopaut/services/authentication_service.dart';
import 'package:get_it/get_it.dart';
import 'package:hopaut/controllers/blocs/login/login_page_status.dart';

abstract class LoginEvent extends BaseEvent{

  AuthenticationService authService = GetIt.I.get<AuthenticationService>();
}

// Event 1
class LoginUsernameChanged extends LoginEvent {
  final String username;

  LoginUsernameChanged({this.username});

  @override
  Stream<LoginState> handleEvent(BaseState state) async*{
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
  Stream<LoginState> handleEvent(BaseState state) async*{
    LoginState loginState = state;
    yield loginState.copyWith(password: password);
  }
}

// Event 3
class ShowPasswordClicked extends LoginEvent{
  final bool obscureText;

  ShowPasswordClicked({this.obscureText});

  @override
  Stream<LoginState> handleEvent(BaseState state) async*{
    LoginState loginState = state;
    yield loginState.copyWith(obscureText: !obscureText);
  }

}

// Event 4
class LoginClicked extends LoginEvent {
  @override
  Stream<LoginState> handleEvent(BaseState state) async*{
    LoginState loginState = state;

    yield loginState.copyWith(formStatus: LoginSubmitted());
    try{
      bool result =
        await authService.loginWithEmail(loginState.username.trim(), loginState.password.trim());
      if(result)
        yield loginState.copyWith(formStatus: SubmissionSuccess());
      else
        // TODO - Translations
        yield loginState.copyWith(formStatus: SubmissionFailed("Invalid Credentials"));
    } catch(e){
      yield loginState.copyWith(formStatus: SubmissionFailed(e));
    }
  }
}

// Event 5
class FacebookLoginClicked extends LoginEvent {
  @override
  Stream<LoginState> handleEvent(BaseState state) async*{
    LoginState loginState = state;

    yield loginState.copyWith(formStatus: LoginSubmitted());
    try{
      bool result = await authService.loginWithFb();
      if(result)
        yield loginState.copyWith(formStatus: SubmissionSuccess());
      else
        // TODO - Translations
        yield loginState.copyWith(formStatus: SubmissionFailed("Error, something went wrong"));
    } catch(e){
      yield loginState.copyWith(formStatus: SubmissionFailed(e));
    }
  }
}

// Event 6
class ForgotPasswordLabelClicked extends LoginEvent {
  @override
  Stream<LoginState> handleEvent(BaseState state) async*{
    throw UnimplementedError();
  }
}

// Event 7
class SignUpLabelClicked extends LoginEvent {
  @override
  Stream<LoginState> handleEvent(BaseState state) async*{
    throw UnimplementedError();
  }
}