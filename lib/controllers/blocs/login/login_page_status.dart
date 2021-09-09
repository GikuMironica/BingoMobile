abstract class LoginPageStatus {
  const LoginPageStatus();
}

class Idle extends LoginPageStatus{
  const Idle();
}

class LoginSubmitted extends LoginPageStatus {}

class SubmissionSuccess extends LoginPageStatus {}

class SubmissionFailed extends LoginPageStatus {
  final String exception;
  SubmissionFailed(this.exception);
}
