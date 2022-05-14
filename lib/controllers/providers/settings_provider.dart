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
import 'package:hopaut/services/notifications_service.dart';
import 'package:injectable/injectable.dart';
import 'package:package_info/package_info.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:hopaut/generated/locale_keys.g.dart';

@singleton
class SettingsProvider with ChangeNotifier {
  PackageInfo? packageInfo;
  SharedPreferences? preferences;
  UserRepository userRepository = getIt<UserRepository>();
  OneSignalNotificationService oneSignalNotificationService =
      getIt<OneSignalNotificationService>();

  BaseFormStatus deleteFormStatus = Idle();
  String deleteAccountEmail = "";
  bool? pushNotifications;

  bool get isDeleteAccountEmailValid =>
      EmailValidator.validate(deleteAccountEmail.trim());
  String get appVersion => packageInfo!.version;

  SettingsProvider() {
    getPackageInfo();
    initializeSharedPreferences();
  }

  Future<void> initializeSharedPreferences() async {
    preferences = await SharedPreferences.getInstance();
    pushNotifications = preferences!.getBool('HA_PUSH_NOTIFICATIONS')!;
  }

  void getPackageInfo() async {
    packageInfo = await PackageInfo.fromPlatform();
  }

  Future<void> togglePushNotificationsPreference(bool value) async {
    pushNotifications = value;
    await preferences!.setBool('HA_PUSH_NOTIFICATIONS', pushNotifications!);
    notifyListeners();
  }

  Future<void> togglePushNotifications(bool value) async {
    await togglePushNotificationsPreference(value);
    value
        ? await oneSignalNotificationService.initializeNotificationService()
        : await oneSignalNotificationService
            .unsubscribeFromNotificationsServer();
  }

  void emailChange(String value) {
    deleteAccountEmail = value;
    notifyListeners();
  }

  Future<void> deleteAccount(BuildContext context) async {
    var authService = getIt<AuthenticationService>();
    if (deleteAccountEmail != authService.user.email) {
      showNewErrorSnackbar(
          LocaleKeys.Others_Providers_Settings_inputurEmail.tr());
      return;
    }

    deleteFormStatus = Submitted();
    notifyListeners();

    bool deleteRes = await userRepository
        .delete(getIt<AuthenticationService>().currentIdentity.id);

    deleteFormStatus = Idle();

    if (deleteRes) {
      Application.router.navigateTo(context, Routes.login,
          replace: true, transition: TransitionType.fadeIn);
      showNewErrorSnackbar(
          LocaleKeys.Others_Providers_Settings_accountDeleted.tr());

      await authService.logout();
    } else {
      showNewErrorSnackbar(
          LocaleKeys.Others_Providers_Settings_failedAccountDelete.tr());
    }
  }

  void resetProvider() {
    deleteAccountEmail = "";
  }
}
