import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:package_info/package_info.dart';
import 'package:shared_preferences/shared_preferences.dart';

@singleton
class SettingsProvider with ChangeNotifier {
  PackageInfo _packageInfo;
  SharedPreferences _preferences;

  String get appVersion => _packageInfo.version;

  bool pushNotifications = true;

  SettingsProvider() {
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
}
