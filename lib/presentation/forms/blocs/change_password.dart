import 'dart:async';

import 'package:hopaut/presentation/forms/blocs/base_bloc.dart';
import 'package:hopaut/presentation/forms/common_validators.dart';
import 'package:rxdart/rxdart.dart';

class ChangePasswordBloc with Validator implements BaseBloc {
  final _passwordController = BehaviorSubject<String>();
  final _confirmPassController = BehaviorSubject<String>();

  Function(String) get passwordChanged => _passwordController.sink.add;
  Function(String) get confirmPassChanged =>
      _confirmPassController.sink.add;

  String get password => _passwordController.value;

  Stream<String> get passwordValid => _passwordController.stream.transform(passwordValidator);
  Stream<String> get confirmPassValid => _confirmPassController.stream.transform(StreamTransformer<String, String>
      .fromHandlers(
      handleData: (_password, sink) =>
      0 == _passwordController.value.compareTo(_password)
          ? sink.add(_password) : sink.addError("Passwords do not match")
  )
  );

  Stream<bool> get passwordsAreValid =>
      Rx.combineLatest2(passwordValid, confirmPassValid, (a, b) => true);

  @override
  void dispose() {
    // TODO: implement dispose
    _passwordController?.close();
    _confirmPassController?.close();
  }
}