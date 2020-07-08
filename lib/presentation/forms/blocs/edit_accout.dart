import 'dart:async';

import 'package:hopaut/presentation/forms/blocs/base_bloc.dart';
import 'package:rxdart/rxdart.dart';

class EditAccountBloc extends Object implements BaseBloc {
  final _firstNameController = BehaviorSubject<String>();
  final _lastNameController = BehaviorSubject<String>();

  void setFirstNameField(String string){
    _firstNameController.add(string);
  }

  void setLastNameField(String string){
    _lastNameController.add(string);
  }


  Function(String) get fnChanged => _firstNameController.sink.add;
  Function(String) get lnChanged => _lastNameController.sink.add;

  Stream<String> get fnValid => _firstNameController.stream.transform(
      StreamTransformer.fromHandlers(
          handleData: (name, sink) => name.trim().length > 1
              ? sink.add(name) : sink.addError("First name is too short")
      )
  );

  String get firstName => _firstNameController.value.trim();
  String get lastName => _lastNameController.value.trim();

  Stream<String> get lnValid => _lastNameController.stream.transform(
      StreamTransformer.fromHandlers(
          handleData: (name, sink) => name.trim().length > 1
              ? sink.add(name) : sink.addError("Last name is too short")
      )
  );

  Stream<bool> get dataValid => Rx.combineLatest2(fnValid, lnValid, (a, b) => true);

  @override
  void dispose() {
    // TODO: implement dispose
    _firstNameController?.close();
    _lastNameController?.close();
  }
}