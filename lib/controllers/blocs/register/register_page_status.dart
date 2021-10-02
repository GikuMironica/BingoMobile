abstract class RegisterPageStatus {
  const RegisterPageStatus();
}

class Idle extends RegisterPageStatus {
  const Idle();
}

class EmailChanged extends RegisterPageStatus {}

class PasswordChanged extends RegisterPageStatus {}

class RepeatPasswordChanged extends RegisterPageStatus {}

class RegisterSubmitted extends RegisterPageStatus {}

class SubmissionSuccess extends RegisterPageStatus {}

class SubmissionFailed extends RegisterPageStatus {
  final String exception;

  SubmissionFailed(this.exception);
}
