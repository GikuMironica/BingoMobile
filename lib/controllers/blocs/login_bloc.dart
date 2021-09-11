import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:hopaut/controllers/blocs/states/login_state.dart';
import 'package:hopaut/controllers/statuses/login_form_submission_status.dart';
import 'package:hopaut/services/authentication_service.dart';

import 'events/login_event.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState>{
  AuthenticationService authService = GetIt.I.get<AuthenticationService>();

  LoginBloc({this.authService}) : super(LoginState());


  // Map the events with the states
  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async*{

    // User input something in username field
    if (event is LoginUsernameChanged){
      yield state.copyWith(username: event.username);
    }
    // User input something in password field
    else if (event is LoginPasswordChanged){
      yield state.copyWith(password: event.password);
    }
    // Login form was submission
    else if (event is LoginBtnClicked){
      yield state.copyWith(formStatus: FormSubmitting());

      try {
        bool isSuccess = await authService.loginWithEmail(state.username, state.password);
        yield state.copyWith(formStatus: SubmissionSuccess());
      } catch (e){
        yield state.copyWith(formStatus: SubmissionFailed(e));
      }
    }
  }

}