import 'package:flutter/cupertino.dart';
import 'package:hopaut/config/injection.dart';
import 'package:hopaut/config/routes/application.dart';
import 'package:hopaut/controllers/providers/page_states/base_form_status.dart';
import 'package:hopaut/data/models/user.dart';
import 'package:hopaut/data/repositories/user_repository.dart';
import 'package:hopaut/presentation/widgets/widgets.dart';
import 'package:hopaut/services/authentication_service.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class AccountProvider extends ChangeNotifier {
  // validation rules
  static final RegExp _regExp = RegExp(r"^[\p{L} ,.'-]*$",
      caseSensitive: false, unicode: true, dotAll: true);

  // state
  bool firstNameIsValid = true;
  bool lastNameIsValid = true;
  BaseFormStatus formStatus;

  // Services, repositories and models
  AuthenticationService _authenticationService;
  UserRepository _userRepository;
  User get currentIdentity => _authenticationService.user;

  AccountProvider() {
    _authenticationService = getIt<AuthenticationService>();
    _userRepository = getIt<UserRepository>();
    formStatus = Idle();
  }

  Future<void> updateUserNameAsync(
      String firstName, String lastName, BuildContext context) async {
    bool firstNameChanged =
        currentIdentity.firstName != firstName;
    bool lastNameChanged = currentIdentity.lastName != lastName;

    if ((!firstNameChanged && !lastNameChanged) || (firstName=="")&&(lastName=="")) {
      Application.router.pop(context);
    } else {
      formStatus = Submitted();
      notifyListeners();
      User tempUser = User(firstName: firstName, lastName: lastName);
      User updatedUser =
          await _userRepository.update(currentIdentity.id, tempUser);
      if(updatedUser==null){
        formStatus = new Failed();
        notifyListeners();
      }else{
        formStatus = Idle();
        _authenticationService.setUser(updatedUser);
        // TODO translate
        showSuccessSnackBar(context: context, message: "Profile updated");
        Application.router.pop(context);
      }
    }
  }

  void validateFirstNameChange(
      String value, TextEditingController controller, int maxLength) {
    firstNameIsValid = _regExp.hasMatch(value) && value.isNotEmpty;
    controller.text = value.length < maxLength ? value : controller.text;
    notifyListeners();
  }

  void validateLastNameChange(
      String value, TextEditingController controller, int maxLength) {
    lastNameIsValid = _regExp.hasMatch(value) && value.isNotEmpty;
    controller.text = value.length < maxLength ? value : controller.text;
    notifyListeners();
  }
}
