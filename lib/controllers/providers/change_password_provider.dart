import 'package:flutter/widgets.dart';
import 'package:hopaut/config/injection.dart';
import 'package:hopaut/controllers/providers/page_states/base_form_status.dart';
import 'package:hopaut/data/repositories/authentication_repository.dart';
import 'package:hopaut/services/authentication_service.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class ChangePasswordProvider extends ChangeNotifier {

  static final RegExp _pwdRule =
  RegExp(r"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d]{8,}$");

  bool get isOldPasswordValid =>
      oldPassword.isNotEmpty;
  bool get isNewPasswordValid =>
      newPassword.isNotEmpty && _pwdRule.hasMatch(newPassword);

  // State
  String oldPassword;
  String newPassword;
  bool passwordObscureText;
  BaseFormStatus formStatus;

  // Services, repositories and models
  AuthenticationService _authenticationService;

  ChangePasswordProvider(){
    formStatus = Idle();
    oldPassword = "";
    newPassword = "";
    passwordObscureText = true;
  }

  void toggleObscurePassword(){
    passwordObscureText = !passwordObscureText;
    notifyListeners();
  }

  void validateOldPassword(
      String value) {
    oldPassword = value;
    notifyListeners();
  }

  void doPasswordChange(String currentPassword, String newPassword) async {
    bool passChangeRes = await getIt<AuthenticationRepository>().changePassword(
        email: getIt<AuthenticationService>().user.email,
        oldPassword: currentPassword,
        newPassword: newPassword);

  }
}