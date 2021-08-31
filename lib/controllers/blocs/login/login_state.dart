
import 'package:email_validator/email_validator.dart';
import 'package:hopaut/controllers/blocs/base_state.dart';
import 'package:hopaut/controllers/blocs/login/login_page_status.dart';

class LoginState extends BaseState{
  final RegExp _pwdRule = RegExp(r"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d]{8,}$");

  //validators
  bool get isValidEmail => EmailValidator.validate(username.trim());

  final String username;
  final String password;
  final bool obscureText;
  final LoginPageStatus formStatus;

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
  }){
    return LoginState(
      username: username ?? this.username,
      password: password ?? this.password,
      obscureText: obscureText ?? this.obscureText,
      formStatus: formStatus ?? this.formStatus,
    );
  }
}