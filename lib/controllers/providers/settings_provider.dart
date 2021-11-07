import 'package:email_validator/email_validator.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:hopaut/config/injection.dart';
import 'package:hopaut/config/routes/application.dart';
import 'package:hopaut/config/routes/routes.dart';
import 'package:hopaut/controllers/providers/page_states/base_form_status.dart';
import 'package:hopaut/data/repositories/user_repository.dart';
import 'package:hopaut/presentation/widgets/widgets.dart';
import 'package:hopaut/services/authentication_service.dart';
import 'package:injectable/injectable.dart';
import 'package:package_info/package_info.dart';
import 'package:shared_preferences/shared_preferences.dart';

@singleton
class SettingsProvider with ChangeNotifier {
  PackageInfo _packageInfo;
  SharedPreferences _preferences;
  BaseFormStatus deleteFormStatus;
  String deleteAccountEmail;
  bool get isDeleteAccountEmailValid =>
      EmailValidator.validate(deleteAccountEmail.trim());
  UserRepository _userRepository;
  String get appVersion => _packageInfo.version;

  bool pushNotifications;

  SettingsProvider() {
    deleteAccountEmail = "";
    _userRepository = getIt<UserRepository>();
    deleteFormStatus = Idle();
    getPackageInfo();
    initializeSharedPreferences();
  }

  Future<void> initializeSharedPreferences() async {
    _preferences = await SharedPreferences.getInstance();
    pushNotifications = _preferences.getBool('HA_PUSH_NOTIFICATIONS');
  }

  void getPackageInfo() async {
    _packageInfo = await PackageInfo.fromPlatform();
  }

  void togglePushNotifications(bool value) {
    pushNotifications = value;
    _preferences.setBool('HA_PUSH_NOTIFICATIONS', pushNotifications);
    notifyListeners();
  }

  void emailChange(String value) {
    deleteAccountEmail = value;
    notifyListeners();
  }

  Future<void> deleteAccount(BuildContext context) async {
    var authService = getIt<AuthenticationService>();
    if (deleteAccountEmail != authService.user.email) {
      // TODO translate
      showNewErrorSnackbar('Input your account email');
      return;
    }

    deleteFormStatus = Submitted();
    notifyListeners();

    bool deleteRes = await _userRepository
        .delete(getIt<AuthenticationService>().currentIdentity.id);

    deleteFormStatus = Idle();

    if (deleteRes) {
      Application.router.navigateTo(context, Routes.login,
          replace: true, transition: TransitionType.fadeIn);
      //  TODO translate
      showNewErrorSnackbar('Account deleted');

      await authService.logout();
    } else {
      showNewErrorSnackbar('Unable to delete account');
    }
  }

  void resetProvider() {
    deleteAccountEmail = "";
  }
}
