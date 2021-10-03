import 'package:email_validator/email_validator.dart';

import '../base_state.dart';
import 'login_page_status.dart';

class LoginState extends BaseState {
  //validators
  bool get isValidEmail => EmailValidator.validate(username.trim());
  bool get isValidPassword => password.isNotEmpty;

  final String username;
  final String password;
  final bool obscureText;
  LoginPageStatus formStatus;

  LoginState({
    this.username = '',
    this.password = '',
    this.obscureText = true,
    this.formStatus = const Idle(),
  });

  LoginState copyWith({
    String username,
    String password,
    bool obscureText,
    LoginPageStatus formStatus,
  }) {
    return LoginState(
      username: username ?? this.username,
      password: password ?? this.password,
      obscureText: obscureText ?? this.obscureText,
      formStatus: formStatus ?? this.formStatus,
    );
  }
}
