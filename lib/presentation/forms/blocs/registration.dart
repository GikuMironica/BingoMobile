import 'package:hopaut/presentation/forms/blocs/base_bloc.dart';
import 'package:hopaut/presentation/forms/common_validators.dart';
import 'dart:async';
import 'package:rxdart/rxdart.dart';

class RegistrationBloc extends Object with Validator implements BaseBloc {
  final _emailController = BehaviorSubject<String>();
  final _passwordController = BehaviorSubject<String>();
  final _confirmPassController = BehaviorSubject<String>();

  Function(String) get emailChanged => _emailController.sink.add;
  Function(String) get passwordChanged => _passwordController.sink.add;
  Function(String) get confirmPassChanged =>
      _confirmPassController.sink.add;

  String get email => _emailController.value;
  String get password => _passwordController.value;

  Stream<String> get emailValid => _emailController.stream
      .transform(emailValidator);

  Stream<String> get passwordValid => _passwordController.stream
      .transform(passwordValidator);

  Stream<String> get confirmPassValid =>
      _confirmPassController.stream.transform(StreamTransformer<String, String>
          .fromHandlers(
        handleData: (_password, sink) =>
            0 == _passwordController.value.compareTo(_password)
            ? sink.add(_password) : sink.addError("Passwords do not match")
          )
      );

  Stream<bool> get dataValid =>
      Rx.combineLatest3(emailValid, passwordValid, confirmPassValid, (a, b, c) => true);





  @override
  void dispose() {
    _emailController?.close();
    _passwordController?.close();
    _confirmPassController?.close();
  }
}