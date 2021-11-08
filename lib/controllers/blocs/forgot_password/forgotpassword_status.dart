abstract class ForgotPasswordStatus {
  const ForgotPasswordStatus();
}

class Idle extends ForgotPasswordStatus {
  const Idle();
}

class RequestSubmitted extends ForgotPasswordStatus {}

class SubmissionSuccess extends ForgotPasswordStatus {}

class SubmissionFailed extends ForgotPasswordStatus {
  final String exception;

  SubmissionFailed(this.exception);
}
