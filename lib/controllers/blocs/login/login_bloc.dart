import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hopaut/controllers/blocs/login/login_state.dart';
import 'package:hopaut/controllers/blocs/base_event.dart';

class LoginBloc extends Bloc<BaseEvent, LoginState>{
  LoginBloc() : super(LoginState());

  @override
  Stream<LoginState> mapEventToState(BaseEvent event) async*{
    yield* event.handleEvent(state);
  }

}