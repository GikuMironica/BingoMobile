import 'package:hopaut/providers/blocs/login/login_state.dart';
import 'package:hopaut/providers/blocs/base_state.dart';

abstract class BaseEvent {
  Stream<LoginState> handleEvent(BaseState state);
}
