import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:hopaut/controllers/blocs/login/login_state.dart';
import 'package:hopaut/controllers/blocs/login/login_page_status.dart';
import 'package:hopaut/services/auth_service/auth_service.dart';
import 'login_event.dart';
import 'package:hopaut/controllers/blocs/base_event.dart';

class LoginBloc extends Bloc<BaseEvent, LoginState>{
  LoginBloc() : super(LoginState());


  // Map the events with the states
  @override
  Stream<LoginState> mapEventToState(BaseEvent event) async*{

    // User input something in username field
    //if (event is LoginUsernameChanged){
    //  yield state.copyWith(username: event.username);
    //}
    yield event.handleEvent(state);

    // User input something in password field
   // if (event is LoginPasswordChanged){
   //   yield state.copyWith(password: event.password);
   // }

    // Login form was submission
    //else if (event is LoginBtnClicked){
    //  yield state.copyWith(formStatus: FormSubmitting());

    //  bool isSuccess = await authService.loginWithUserCredentials(state.username, state.password);
     // if(!isSuccess) yield state.copyWith(formStatus: SubmissionFailed(Exception('Invalid Credentials')));
    //  yield state.copyWith(formStatus: SubmissionSuccess());
    //}

    // Facebook login was clicked
    // TODO

    // Sign up was clicked
    // TODO

    // Forgot password was clicked
    // TODO
  }

}