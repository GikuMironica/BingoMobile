
import 'package:hopaut/controllers/statuses/login_form_submission_status.dart';

class LoginState{
  //validators
  bool get isValidUsername => username.length >3;
  bool get isValidPassword => password.length >6;

  final String username;
  final String password;
  final FormSubmissionStatus formStatus;

  LoginState({
    this.username = '',
    this.password = '',
    this.formStatus = const InitialFormStatus(),
  });

  LoginState copyWith({
    String username,
    String password,
    FormSubmissionStatus formStatus,
  }){
    return LoginState(
      username: username ?? this.username,
      password: password ?? this.password,
      formStatus: formStatus ?? this.formStatus,
    );
  }
}