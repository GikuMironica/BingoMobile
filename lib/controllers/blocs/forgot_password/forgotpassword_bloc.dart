import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hopaut/controllers/blocs/forgot_password/forgotpassword_event.dart';

import '../base_event.dart';
import 'forgotpassword_state.dart';

class ForgotPasswordBloc extends Bloc<BaseEvent, ForgotPasswordState> {
  ForgotPasswordBloc() : super(ForgotPasswordState());

  @override
  Stream<ForgotPasswordState> mapEventToState(BaseEvent event) async* {
    yield* (event as ForgotPasswordEvent).handleEvent(state);
  }
}
