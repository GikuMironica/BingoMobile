import 'package:flutter/widgets.dart';
import 'package:hopaut/config/injection.dart';
import 'package:hopaut/controllers/providers/page_states/base_form_status.dart';
import 'package:hopaut/data/repositories/authentication_repository.dart';
import 'package:hopaut/services/authentication_service.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class ChangePasswordProvider extends ChangeNotifier {

  /// Validators
  static final RegExp _pwdRule =
  RegExp(r"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d]{8,}$");

  /// State properties
  String oldPassword;
  String newPassword;
  bool passwordObscureText;
  bool newPasswordObscureText;
  BaseFormStatus formStatus;
  bool isOldPasswordValid;
  bool isNewPasswordValid;
  bool get isFormValid => isOldPasswordValid && isNewPasswordValid
      && oldPassword.isNotEmpty && newPassword.isNotEmpty;

  /// Services, repositories and models
  AuthenticationRepository _authenticationRepository;
  AuthenticationService _authenticationService;

  ChangePasswordProvider(){
    formStatus = Idle();
    oldPassword = "";
    newPassword = "";
    isOldPasswordValid = true;
    isNewPasswordValid = true;
    passwordObscureText = true;
    newPasswordObscureText = true;

    _authenticationRepository = getIt<AuthenticationRepository>();
    _authenticationService = getIt<AuthenticationService>();
  }

  /// State validating methods
  void toggleObscurePassword(){
    passwordObscureText = !passwordObscureText;
    notifyListeners();
  }

  void toggleObscureNewPassword() {
    newPasswordObscureText = !newPasswordObscureText;
    notifyListeners();
  }

  void validateOldPassword(String value) {
    oldPassword = value;
    isOldPasswordValid = oldPassword.isNotEmpty;
    notifyListeners();
  }

  void validateNewPassword(String value) {
    newPassword = value;
    isNewPasswordValid = newPassword.isNotEmpty && _pwdRule.hasMatch(newPassword);
    notifyListeners();
  }

  /// Updates
  void updatePassword(BuildContext context) async {
    bool passChangeRes = await _authenticationRepository.changePassword(
        email: _authenticationService.user.email,
        oldPassword: oldPassword,
        newPassword: newPassword);

    if (!passChangeRes){
      formStatus = Failed();
    }else{
      formStatus = Success();
    }
    notifyListeners();
  }
}