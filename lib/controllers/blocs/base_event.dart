import 'base_state.dart';

abstract class BaseEvent {
  Stream<BaseState> handleEvent(BaseState state);
}
