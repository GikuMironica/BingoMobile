import 'package:hopaut/controllers/blocs/login/login_state.dart';
import 'package:hopaut/controllers/blocs/base_state.dart';

abstract class BaseEvent {
  Stream<LoginState> handleEvent(BaseState state);
}