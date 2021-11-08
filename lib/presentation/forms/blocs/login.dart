import 'package:hopaut/presentation/forms/blocs/base_bloc.dart';
import 'package:hopaut/presentation/forms/common_validators.dart';
import 'dart:async';
import 'package:rxdart/rxdart.dart';

class LoginBloc extends Object with Validator implements BaseBloc {
  final _emailController = BehaviorSubject<String>();
  final _passwordController = BehaviorSubject<String>();

  Function(String) get emailChanged => _emailController.sink.add;
  Function(String) get passwordChanged => _passwordController.sink.add;

  String get email => _emailController.value;
  String get password => _passwordController.value;

  Stream<String> get emailValid => _emailController.stream
      .transform(emailValidator);

  Stream<String> get passwordValid => _passwordController.stream
      .transform(StreamTransformer<String, String>.fromHandlers(
    handleData: (password, sink) => password.length > 0
        ? sink.add(password) : sink.addError("Password field is empty")
  ));

  Stream<bool> get dataValid =>
      Rx.combineLatest2(emailValid, passwordValid, (a, b) => true);





  @override
  void dispose() {
    _emailController?.close();
    _passwordController?.close();
  }
}