import 'dart:async';

import 'package:hopaut/presentation/forms/blocs/base_bloc.dart';
import 'package:rxdart/rxdart.dart';

class DeleteAccountBloc extends Object implements BaseBloc {
  final _emailController = BehaviorSubject<String>();

  final String userEmail;
  DeleteAccountBloc(this.userEmail);

  Function(String) get emailChanged => _emailController.sink.add;

  Stream<String> get emailValid => _emailController.stream.transform(
    StreamTransformer.fromHandlers(
      handleData: (email, sink) => 0 != email.compareTo(userEmail)
          ? sink.addError('') : sink.add(email)
    )
  );

  Stream<bool> get dataValid => Rx.combineLatest([emailValid,], (values) => true);

  @override
  void dispose() {
    _emailController?.close();
  }
}