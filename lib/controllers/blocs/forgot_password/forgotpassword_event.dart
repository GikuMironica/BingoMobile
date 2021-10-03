import 'package:get_it/get_it.dart';
import 'package:hopaut/data/repositories/authentication_repository.dart';

import '../base_event.dart';
import '../base_state.dart';
import 'forgotpassword_state.dart';
import 'forgotpassword_status.dart';

abstract class ForgotPasswordEvent extends BaseEvent {
  AuthenticationRepository authService =
      GetIt.I.get<AuthenticationRepository>();
}

// Event 1
class UsernameChanged extends ForgotPasswordEvent {
  final String username;

  UsernameChanged({this.username});

  @override
  Stream<ForgotPasswordState> handleEvent(BaseState state) async* {
    // Dart style down-casting...
    ForgotPasswordState forgotPasswordState = state;
    yield forgotPasswordState.copyWith(username: username);
  }
}

// Event 4
class RequestClicked extends ForgotPasswordEvent {
  @override
  Stream<ForgotPasswordState> handleEvent(BaseState state) async* {
    ForgotPasswordState forgotPasswordState = state;
    bool result;
    yield forgotPasswordState.copyWith(formStatus: RequestSubmitted());
    try {
      result =
          await authService.forgotPassword(forgotPasswordState.username.trim());
      yield result
          ? forgotPasswordState.copyWith(formStatus: SubmissionSuccess())
          // TODO- Translation
          : forgotPasswordState.copyWith(
              formStatus: SubmissionFailed("Internal Error"));
    } catch (e) {
      // TODO - translations
      yield forgotPasswordState.copyWith(
          formStatus: SubmissionFailed("Internal error"));
    }
  }
}

class SignUpLabelClicked extends ForgotPasswordEvent {
  @override
  Stream<ForgotPasswordState> handleEvent(BaseState state) async* {
    throw UnimplementedError();
  }
}
