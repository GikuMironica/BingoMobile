import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hopaut/config/injection.dart';
import 'package:hopaut/config/routes/application.dart';
import 'package:hopaut/controllers/providers/page_states/base_form_status.dart';
import 'package:hopaut/data/repositories/user_repository.dart';
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
  bool get isDeleteAccountEmailValid => EmailValidator.validate(deleteAccountEmail.trim());
  UserRepository _userRepository;
  String get appVersion => _packageInfo.version;

  bool pushNotifications;

  SettingsProvider() {
    pushNotifications = true;
    deleteAccountEmail = "";
    _userRepository = getIt<UserRepository>();
    deleteFormStatus = Idle();
    getPackageInfo();
    getSharedPreferences();
  }

  void getSharedPreferences() async {
    _preferences = await SharedPreferences.getInstance();
    pushNotifications =
        _preferences.getBool('HA_PUSH_NOTIFICATIONS') ?? pushNotifications;
  }

  void getPackageInfo() async {
    _packageInfo = await PackageInfo.fromPlatform();
  }

  void togglePushNotifications(bool value) {
    pushNotifications = value;
    _preferences.setBool('HA_PUSH_NOTIFICATIONS', pushNotifications);
    notifyListeners();
  }

  void emailChange(String value){
    deleteAccountEmail = value;
    notifyListeners();
  }

  Future<void> deleteAccount(BuildContext context) async{
    var authService = getIt<AuthenticationService>();
    if(deleteAccountEmail!=authService.user.email){
      Fluttertoast.showToast(
        // TODO translation
          backgroundColor: Color(0xFFed2f65),
          textColor: Colors.white,
          toastLength: Toast.LENGTH_LONG,
          msg: "Input your account email"
      );
      return;
    }

    deleteFormStatus = Submitted();
    notifyListeners();

    bool deleteRes = await _userRepository.delete(
        getIt<AuthenticationService>()
            .currentIdentity
            .id);

    deleteFormStatus = Idle();

    if (deleteRes) {
      Application.router.navigateTo(
          context, '/login',
          clearStack: true);

      Fluttertoast.showToast(
          backgroundColor: Color(0xFFed2f65),
          textColor: Colors.white,
          toastLength: Toast.LENGTH_LONG,
          // TODO translation
          msg: 'Account deleted');
      await authService.logout();
    } else {
      Fluttertoast.showToast(
      // TODO translation
        backgroundColor: Color(0xFFed2f65),
        textColor: Colors.white,
        toastLength: Toast.LENGTH_LONG,
        msg: "Unable to delete account"
      );
    }
  }

  void resetProvider(){
    deleteAccountEmail = "";
  }
}
