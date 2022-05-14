import 'package:flutter/widgets.dart';
import 'package:hopaut/config/injection.dart';
import 'package:hopaut/config/routes/application.dart';
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
  String oldPassword = "";
  String newPassword = "";
  bool passwordObscureText = true;
  bool newPasswordObscureText = true;
  BaseFormStatus formStatus = Idle();

  /// Services, repositories and models
  AuthenticationRepository authenticationRepository =
      getIt<AuthenticationRepository>();
  AuthenticationService authenticationService = getIt<AuthenticationService>();

  /// State validating methods
  void toggleObscurePassword() {
    passwordObscureText = !passwordObscureText;
    notifyListeners();
  }

  void toggleObscureNewPassword() {
    newPasswordObscureText = !newPasswordObscureText;
    notifyListeners();
  }

  bool validateOldPassword() {
    return oldPassword.isNotEmpty;
  }

  bool validateNewPassword() {
    return newPassword.isNotEmpty && _pwdRule.hasMatch(newPassword);
  }

  void oldPasswordChange(String value) {
    oldPassword = value;
    notifyListeners();
  }

  void newPasswordChange(String value) {
    newPassword = value;
    notifyListeners();
  }

  /// Updates
  Future<void> updatePassword(BuildContext context) async {
    formStatus = Submitted();
    notifyListeners();
    bool passChangeRes = await authenticationRepository.changePassword(
        email: authenticationService.user.email!,
        oldPassword: oldPassword,
        newPassword: newPassword);

    if (!passChangeRes) {
      formStatus = Failed(errorMessage: '');
    } else {
      formStatus = Success();
      Future.delayed(Duration(seconds: 4), () async {
        Application.router.pop(context);
      });
    }
    notifyListeners();
    oldPassword = "";
    newPassword = "";
  }

  void resetProvider() {
    formStatus = Idle();
    oldPassword = "";
    newPassword = "";
    passwordObscureText = true;
    newPasswordObscureText = true;
  }
}
