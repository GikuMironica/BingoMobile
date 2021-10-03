import 'package:email_validator/email_validator.dart';

import '../base_state.dart';
import 'forgotpassword_status.dart';

class ForgotPasswordState extends BaseState {
  //validators
  bool get isValidEmail => EmailValidator.validate(username.trim());

  final String username;
  ForgotPasswordStatus formStatus;

  ForgotPasswordState({this.username = '', this.formStatus = const Idle()});

  ForgotPasswordState copyWith({
    String username,
    ForgotPasswordStatus formStatus,
  }) {
    return ForgotPasswordState(
      username: username ?? this.username,
      formStatus: formStatus ?? this.formStatus,
    );
  }
}
