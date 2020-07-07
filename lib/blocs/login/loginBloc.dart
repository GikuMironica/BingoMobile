import 'dart:async';
import 'package:HopAutapp/blocs/login/validator.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

class LoginBloc extends Object with Validator implements BaseBloc {
  final StreamController<String> _emailController = BehaviorSubject();
  final StreamController<String> _passwordController = BehaviorSubject();

  Function(String) get emailChanged => _emailController.sink.add;
  Function(String) get passwordChanged => _passwordController.sink.add;

  Stream<String> get email =>
      _emailController.stream.transform(emailValidator);

  Stream<String> get password =>
      _passwordController.stream.transform(passwordValidator);

  Stream<bool> get submitCheck =>
      Rx.combineLatest2(email, password, (e, p) => true);

  @override
  void dispose() {
    _emailController?.close();
    _passwordController?.close();
  }
}

abstract class BaseBloc {
  void dispose();
}