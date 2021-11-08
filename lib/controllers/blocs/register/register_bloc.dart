import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hopaut/controllers/blocs/base_event.dart';
import 'package:hopaut/controllers/blocs/register/register_state.dart';

class RegisterBloc extends Bloc<BaseEvent, RegisterState>{
  RegisterBloc() : super(RegisterState());

  @override
  Stream<RegisterState> mapEventToState(BaseEvent event) async*{
    yield* event.handleEvent(state);
  }

}