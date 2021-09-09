import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:hopaut/controllers/blocs/login/login_state.dart';
import 'package:hopaut/controllers/blocs/login/login_page_status.dart';
import 'package:hopaut/services/auth_service/auth_service.dart';
import 'login_event.dart';
import 'package:hopaut/controllers/blocs/base_event.dart';

class LoginBloc extends Bloc<BaseEvent, LoginState>{
  LoginBloc() : super(LoginState());

  @override
  Stream<LoginState> mapEventToState(BaseEvent event) async*{
    yield* event.handleEvent(state);
  }

}