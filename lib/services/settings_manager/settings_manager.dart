import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsManager with ChangeNotifier {
  static SettingsManager _settingsManager;
  PackageInfo _packageInfo;
  SharedPreferences _preferences;

  String get appVersion => _packageInfo.version;

  bool pushNotifications = true;

  factory SettingsManager(){
    return _settingsManager ??= SettingsManager._();
  }

  SettingsManager._(){
    getPackageInfo();
    getSharedPreferences();
  }

  void getSharedPreferences() async {
    _preferences = await SharedPreferences.getInstance();
    pushNotifications = _preferences.getBool('HA_PUSH_NOTIFICATIONS') ?? pushNotifications;
  }

  void getPackageInfo() async {
    _packageInfo = await PackageInfo.fromPlatform();
  }

  void togglePushNotifications() {
    pushNotifications = !pushNotifications;
    _preferences.setBool('HA_PUSH_NOTIFICATIONS', pushNotifications);
    notifyListeners();
  }
}