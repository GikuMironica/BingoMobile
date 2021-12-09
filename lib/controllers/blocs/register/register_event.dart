import 'package:get_it/get_it.dart';
import 'package:hopaut/controllers/blocs/base_state.dart';
import 'package:hopaut/controllers/blocs/register/register_page_status.dart';
import 'package:hopaut/controllers/blocs/register/register_state.dart';
import 'package:hopaut/data/domain/login_result.dart';
import 'package:hopaut/services/authentication_service.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:hopaut/generated/locale_keys.g.dart';
import '../base_event.dart';

abstract class RegisterEvent extends BaseEvent {
  AuthenticationService authService = GetIt.I.get<AuthenticationService>();
}

class RegisterUsernameChanged extends RegisterEvent {
  final String username;

  RegisterUsernameChanged({this.username});

  @override
  Stream<RegisterState> handleEvent(BaseState state) async* {
    // Dart style down-casting...
    RegisterState registerState = state;
    yield registerState.copyWith(username: username);
  }
}

class RegisterPasswordChanged extends RegisterEvent {
  final String password;

  RegisterPasswordChanged({this.password});

  @override
  Stream<RegisterState> handleEvent(BaseState state) async* {
    RegisterState registerState = state;
    yield registerState.copyWith(password: password);
  }
}

class RegisterConfirmPasswordChanged extends RegisterEvent {
  final String confirmPassword;

  RegisterConfirmPasswordChanged({this.confirmPassword});

  @override
  Stream<RegisterState> handleEvent(BaseState state) async* {
    RegisterState registerState = state;
    yield registerState.copyWith(confirmPassword: confirmPassword);
  }
}

class UnobscurePasswordClicked extends RegisterEvent {
  final bool passwordObscureText;

  UnobscurePasswordClicked({this.passwordObscureText});

  @override
  Stream<RegisterState> handleEvent(BaseState state) async* {
    RegisterState registerState = state;
    yield registerState.copyWith(passwordObscureText: !passwordObscureText);
  }
}

class UnobscureConfirmPasswordClicked extends RegisterEvent {
  final bool confirmPasswordObscureText;

  UnobscureConfirmPasswordClicked({this.confirmPasswordObscureText});

  @override
  Stream<RegisterState> handleEvent(BaseState state) async* {
    RegisterState registerState = state;
    yield registerState.copyWith(
        confirmPasswordObscureText: !confirmPasswordObscureText);
  }
}

class RegisterClicked extends RegisterEvent {
  @override
  Stream<RegisterState> handleEvent(BaseState state) async* {
    RegisterState registerState = state;
    AuthResult result;
    yield registerState.copyWith(formStatus: RegisterSubmitted());
    try {
      result = await authService.register(
          registerState.username.trim(), registerState.password.trim());
      yield result.isSuccessful
          ? registerState.copyWith(formStatus: SubmissionSuccess())
          : registerState.copyWith(
              formStatus: SubmissionFailed(result.data["Error"]));
    } catch (e) {
      yield registerState.copyWith(
          formStatus: SubmissionFailed(
              LocaleKeys.Authentication_Register_toasts_internalError.tr()));
    }
  }
}
