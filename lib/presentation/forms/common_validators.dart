import 'dart:async';
import 'package:email_validator/email_validator.dart';

final RegExp _PWRule = RegExp(r"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d]{8,}$");

mixin Validator {
  StreamTransformer emailValidator = StreamTransformer<String, String>
      .fromHandlers(
    handleData: (email, sink) => EmailValidator.validate(email.trimRight())
        ? sink.add(email)
        : sink.addError(("Email is not valid."))
  );

  StreamTransformer passwordValidator = StreamTransformer<String, String>
      .fromHandlers(
    handleData: (password, sink) => _PWRule.hasMatch(password) 
        ? sink.add(password) 
        : sink.addError("Passwords must be 8 characters long, be alpha-numeric, "
        "and contain at least 1 uppercase letter.")
  );
    
}