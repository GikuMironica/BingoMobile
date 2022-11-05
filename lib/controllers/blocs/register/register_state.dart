import 'package:email_validator/email_validator.dart';
import 'package:hopaut/controllers/blocs/base_state.dart';
import 'package:hopaut/controllers/blocs/register/register_page_status.dart';

class RegisterState extends BaseState {
  static final RegExp _pwdRule = RegExp(r"^(.{0,7}|[^0-9]*|[A-Za-z]*)$");

  //validators
  bool get isEmailValid => EmailValidator.validate(username.trim());
  bool get isPasswordValid =>
      password.isNotEmpty && !_pwdRule.hasMatch(password);
  bool get isConfirmPasswordValid =>
      confirmPassword.isNotEmpty && passwordsMatch;
  bool get passwordsMatch => password == confirmPassword;

  final String username;
  final String password;
  final String confirmPassword;
  final bool passwordObscureText;
  final bool confirmPasswordObscureText;
  RegisterPageStatus formStatus;

  RegisterState({
    this.username = '',
    this.password = '',
    this.confirmPassword = '',
    this.passwordObscureText = true,
    this.confirmPasswordObscureText = true,
    this.formStatus = const Idle(),
  });

  RegisterState copyWith({
    String username,
    String password,
    String confirmPassword,
    bool passwordObscureText,
    bool confirmPasswordObscureText,
    RegisterPageStatus formStatus,
  }) {
    return RegisterState(
      username: username ?? this.username,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      passwordObscureText: passwordObscureText ?? this.passwordObscureText,
      confirmPasswordObscureText:
          confirmPasswordObscureText ?? this.confirmPasswordObscureText,
      formStatus: formStatus ?? this.formStatus,
    );
  }
}
