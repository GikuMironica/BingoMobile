import 'package:flutter/cupertino.dart';
import 'package:hopaut/config/injection.dart';
import 'package:hopaut/config/routes/application.dart';
import 'package:hopaut/controllers/providers/BaseFormStatus.dart';
import 'package:hopaut/data/models/user.dart';
import 'package:hopaut/data/repositories/user_repository.dart';
import 'package:hopaut/services/authentication_service.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class AccountProvider extends ChangeNotifier {
  // validation rules
  static final RegExp _regExp = RegExp(r"^[\p{L} ,.'-]*$",
      caseSensitive: false, unicode: true, dotAll: true);
  bool firstNameIsValid;
  bool lastNameIsValid;

  // State related
  String firstName = '';
  String lastName = '';
  BaseFormStatus formStatus;

  // Services, repositories and models
  AuthenticationService _authenticationService;
  UserRepository _userRepository;
  User get currentIdentity => _authenticationService.user;

  AccountProvider() {
    _authenticationService = getIt<AuthenticationService>();
    _userRepository = getIt<UserRepository>();
    firstName = currentIdentity.firstName;
    lastName = currentIdentity.lastName;
    firstNameIsValid = _regExp.hasMatch(firstName) && firstName.isNotEmpty;
    lastNameIsValid = _regExp.hasMatch(lastName) && lastName.isNotEmpty;
    formStatus = Idle();
  }

  Future<void> updateUserNameAsync(
      String firstName, String lastName, BuildContext context) async {
    bool firstNameChanged = currentIdentity.firstName != firstName;
    bool lastNameChanged = currentIdentity.lastName != lastName;

    if (!(firstNameChanged && lastNameChanged)) {
      Application.router.pop(context);
    } else {
      User tempUser = User(firstName: firstName, lastName: lastName);
      User updatedUser =
          await _userRepository.update(currentIdentity.id, tempUser);
      _authenticationService.setUser(updatedUser);
      Application.router.pop(context);
    }
  }

  void validateFirstNameChange(String value) {
    firstNameIsValid = _regExp.hasMatch(value) && value.isNotEmpty;
    notifyListeners();
  }

  void validateLastNameChange(String value) {
    lastNameIsValid = _regExp.hasMatch(value) && value.isNotEmpty;
    notifyListeners();
  }
}
