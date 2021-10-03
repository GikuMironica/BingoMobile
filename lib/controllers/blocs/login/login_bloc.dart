import 'package:flutter_bloc/flutter_bloc.dart';

import '../base_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<BaseEvent, LoginState> {
  LoginBloc() : super(LoginState());

  @override
  Stream<LoginState> mapEventToState(BaseEvent event) async* {
    yield* event.handleEvent(state);
  }
}
