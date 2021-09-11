abstract class LoginEvent {}

// Event 1
class LoginUsernameChanged extends LoginEvent {
  final String username;

  LoginUsernameChanged({this.username});
}

// Event 2
class LoginPasswordChanged extends LoginEvent {
  final String password;

  LoginPasswordChanged({this.password});
}

// Event 3
class LoginBtnClicked extends LoginEvent {}

// Event 4
class FacebookLoginBtnClicked extends LoginEvent {}

// Event 5
class ForgotPasswordLabelClicked extends LoginEvent {}

// Event 6
class SignUpLabelClicked extends LoginEvent {}